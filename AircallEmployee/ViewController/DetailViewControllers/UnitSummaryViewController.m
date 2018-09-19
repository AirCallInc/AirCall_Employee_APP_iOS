//
//  UnitSummaryViewController.m
//  AircallEmployee
//
//  Created by Manali on 04/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "UnitSummaryViewController.h"

@interface UnitSummaryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblv;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmt;

@property NSMutableArray *arrDetail;
@property float totalAmt;
@end

@implementation UnitSummaryViewController
@synthesize tblv,lblTotalAmt,arrDetail,dictUnitInfo,dictClientInfo,totalAmt,isPending;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!isPending)
    {
        [self prepareView];
    }
    else
    {
        [self getPendingUnitList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Method
-(void)prepareView
{
    
    totalAmt = [dictUnitInfo[OKeyTotalAmt]floatValue];
    
    lblTotalAmt.text = [NSString stringWithFormat:@"$%0.2f",
                            totalAmt];
    
    arrDetail = [dictUnitInfo[AKeyUnits]mutableCopy];
    
    [tblv reloadData];
    
   // arrDetail = [[NSMutableArray alloc]initWithObjects:@"",@"", nil];
}

#pragma mark - UITableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrDetail.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitSummaryCell *cell    = [tableView dequeueReusableCellWithIdentifier:@"summaryCell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle      = UITableViewCellSelectionStyleNone;
    cell.llbNo.text          = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    
    NSDictionary *dict       =  arrDetail[indexPath.row];
    [cell setCellData:dict];
    if (indexPath.row > 0)
    {
        UIView *lineView         = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, self.view.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor separatorColor];
        [cell.contentView addSubview:lineView];
    }
    
    return cell;
}

#pragma mark - Event Methods
- (IBAction)btnAddTap:(id)sender
{
    if(arrDetail.count >= 5  && [_paymentOption isEqualToString:CHKeyCC])
    {
        [self showAlertWithMessage:ACEUnitLimit];
    }
    else
    {
        AddUnitClientInfoViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddUnitClientInfoViewController"];
        
        vc.addressId        = dictClientInfo[SCHKeyAddressId];
        vc.selectedClientId = dictClientInfo[CKeyID];
        vc.isAddAnother     = YES;
        vc.clientName       = dictClientInfo[ACKeyClientName];
        vc.paymnetOption    = _paymentOption;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnContinueTap:(id)sender
{
    AddUnitBillingAddressViewController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"AddUnitBillingAddressViewController"];
    
    vc.clientId         = dictClientInfo[CKeyID];
    vc.totalAmount      = totalAmt              ;
    vc.arrUnits         = arrDetail             ;
    vc.paymentOption    = _paymentOption        ;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnDeleteTap:(id)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tblv];
    NSIndexPath *indexPath = [tblv indexPathForRowAtPoint:touchPoint];
    
//    [ACEUtil showAlertFromControllerWithDoubleAction:self withMessage:ACEAskToDeleteUnit andHandler:^(UIAlertAction * _Nullable action)
//    {
//         [self deleteUnitFromSummary:arrDetail[indexPath.row]];
//    }];
    [ACEUtil showAlertFromControllerWithDoubleAction:self withMessage:ACEAskToDeleteUnit andHandler:^(UIAlertAction * _Nullable action)
    {
        [self deleteUnitFromSummary:arrDetail[indexPath.row]];
        
    } andNoHandler:^(UIAlertAction * _Nullable action)
    {
        
    }];
    // [tblv deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    // [tblv reloadData];
}

#pragma mark - Webservice Method
-(void)deleteUnitFromSummary:(NSDictionary *)dict
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dictInfo = @{
                                   CKeyID : dictClientInfo[CKeyID],
                                   ACKeyID : dict[ADKeyAddressId],
                                   UKeyEmployeeID : ACEGlobalObject.user.userID
                                   };
        [ACEWebServiceAPI deleteUnit:dictInfo completionHandler:^(ACEAPIResponse *response, NSDictionary *unitInfo)
        {
            [SVProgressHUD dismiss];
            
            if(response.code == RCodeSuccess)
            {
                dictUnitInfo = unitInfo;
                
                if(dictUnitInfo.count > 0)
                {
                    [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                    {
                         [self prepareView];
                    }];
                    
                }
                else
                {
                    [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                    {
                        ACUnitListViewController *aculv = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ACUnitListViewController"];
                        [self.navigationController pushViewController:aculv animated:YES];
                    }];
                    
                }
            }
            else if(response.code == RCodeUnauthorized)
            {
                [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [ACEUtil logoutUser];
                 }];
            }
            else if (response.code == RCodeSessionExpired)
            {
                [self showAlertFromWithMessageWithSingleAction:ACESessionExpired andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [ACEUtil logoutUser];
                 }];
            }
            else if(response.message)
            {
                [self showAlertWithMessage:response.message];
            }
            else
            {
               // [self showAlertWithMessage:response.error.localizedDescription];
                [self showAlertWithMessage:ACEUnknownError];
            }
        }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)getPendingUnitList
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyEmployeeID : ACEGlobalObject.user.userID
                               };
        
        [ACEWebServiceAPI getPendingUnitList:dict completionHandler:^(ACEAPIResponse *response, NSDictionary *dictUnit)
        {
             [SVProgressHUD dismiss];
            if(response.code == RCodeSuccess)
            {
                dictUnitInfo        = dictUnit;
                NSArray  *arr       = dictUnitInfo[AKeyUnits];
                NSDictionary *dict  = arr[0];
                dictClientInfo      = @{
                                        SCHKeyAddressId : [dict[SCHKeyAddressId]stringValue],
                                        CKeyID          : dict[CKeyID],
                                        ACKeyClientName : dict[ACKeyClientName]
                                        };
                _paymentOption      =  dictUnit[ACKeyPaymentOption];
                [self prepareView];
            }
            else if(response.code == RCodeUnauthorized)
            {
                [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [ACEUtil logoutUser];
                 }];
            }
            else if (response.code == RCodeSessionExpired)
            {
                [self showAlertFromWithMessageWithSingleAction:ACESessionExpired andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [ACEUtil logoutUser];
                 }];
            }
            else if(response.message)
            {
                [self showAlertWithMessage:response.message];
            }
            else
            {
                // [self showAlertWithMessage:response.error.localizedDescription];
                [self showAlertWithMessage:ACEUnknownError];
            }

        }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
@end
