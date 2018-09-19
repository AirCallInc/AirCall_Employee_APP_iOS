//
//  AddunitReceiptViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 17/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AddunitReceiptViewController.h"

@interface AddunitReceiptViewController ()<UITableViewDelegate,UITableViewDataSource>


@property NSMutableArray *arrUnits;
@property int unitCount;
@property float totalAmount;

@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPackage;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;

@property (strong, nonatomic) IBOutlet UIButton *btndashboard;
@property (strong, nonatomic) IBOutlet UIButton *btnRetry;

@property (strong, nonatomic) IBOutlet UITableView *tblvReceipt;

@end

@implementation AddunitReceiptViewController

@synthesize lblEmail,lblClientName,lblTotalAmount,lblTotalPackage,btnRetry,btndashboard,tblvReceipt;
@synthesize arrUnits,unitCount,totalAmount,unitInfo;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

#pragma maek - Helper Method
-(void)prepareView
{
    unitCount = 0;
    totalAmount = 0.0;
    tblvReceipt.alwaysBounceVertical = NO;
    tblvReceipt.separatorColor = [UIColor clearColor];
    btnRetry.hidden = YES;
    btndashboard.userInteractionEnabled = false;
    arrUnits = [[NSMutableArray alloc]init];
    
    NSArray *arr = unitInfo[AKeyUnits];
    
    for(int i =0 ; i< arr.count;i++)
    {
        NSMutableDictionary *dict = [arr[i]mutableCopy];
        //unit.paymentStatus = @"Processing";
        [dict setValue:@"Processing" forKey:GPaymentStatus];
        [arrUnits addObject:dict];
        totalAmount += [dict[GPrice]floatValue];
        
    }
    
    [self setReceiptData];
    
    if([_paymentOption isEqualToString:CHKeyCC])
    {
        [self getPaymentStatus];
        unitCount = 0;
        totalAmount = 0.0;
    }
    else
    {
        lblTotalAmount.text = [NSString stringWithFormat:@"$%0.2f",totalAmount];
        btndashboard.userInteractionEnabled = true;
    }
}
-(void)setReceiptData
{
    lblClientName.text = [NSString stringWithFormat:@"%@ %@",unitInfo[ACKeyClientFirstName],unitInfo[ACKeyClientLastName]];
    lblEmail.text = unitInfo[UKeyEmail];
    lblTotalPackage.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)arrUnits.count];
}

#pragma mark - WebService Methods
-(void)getFailedPaymentUnits
{
    NSDictionary *clientInfo = @{
                                 UKeyEmployeeID : ACEGlobalObject.user.userID,
                                 CKeyID         : unitInfo[CKeyID]
                                 };
    
    [SVProgressHUD show];
    
    [ACEWebServiceAPI getFailedPaymentUnits:clientInfo completionHandler:^(ACEAPIResponse *response, NSDictionary *dictUnitInfo)
     {
          [SVProgressHUD dismiss];
         
         if(response.code == RCodeSuccess)
         {
             UnitSummaryViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"UnitSummaryViewController"];
             vc.dictUnitInfo   = dictUnitInfo   ;
             vc.dictClientInfo = clientInfo     ;
             vc.paymentOption  = _paymentOption ;
             
             [self.navigationController pushViewController:vc animated:YES];
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
             [self showAlertWithMessage:ACEUnknownError];
         }
         
     }];
}

-(void)getPaymentStatus
{
    if (unitCount < arrUnits.count)
    {
        NSMutableDictionary *unitDict = [arrUnits[unitCount]mutableCopy];
        
        NSDictionary *dict = @{
                                CKeyID : unitInfo[CKeyID],
                                ACKeyID : unitDict[GKeyId],
                                UKeyEmployeeID : ACEGlobalObject.user.userID
                                //CKeyStripeCardID : stripeCardId
                               };
        
        [ACEWebServiceAPI getPaymentStatus:dict completionHandler:^(ACEAPIResponse *response, NSDictionary *dictStatus)
         {
             if (response.code == RCodeSuccess)
             {
                 [unitDict setValue:dictStatus[GPaymentStatus] forKey:GPaymentStatus];
                 [unitDict setValue:dictStatus[GPaymentError] forKey:GPaymentError];
                 //unit.paymentStatus = statusData[UKeyStatus];
                 //unit.paymentError = statusData[CKeyStripeError];
                 
                 [arrUnits replaceObjectAtIndex:unitCount withObject:unitDict];
                 
                 if (![unitDict[GPaymentStatus] isEqualToString:@"Processing"])
                 {
                     if ([unitDict[GPaymentStatus] isEqualToString:@"Received"])
                     {
                         totalAmount += [unitDict[GPrice]floatValue];
                         lblTotalAmount.text = [NSString stringWithFormat:@"$%0.2f",totalAmount];
                     }
                     else
                     {
                         btnRetry.hidden = NO;
                         btnRetry.userInteractionEnabled = false;
                         btndashboard.userInteractionEnabled = false;
                     }
                     
                     unitCount++;
                     [tblvReceipt reloadData];
                 }
                 
                 [self performSelector:@selector(getPaymentStatus) withObject:nil afterDelay:0.20];
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
                 [self showAlertWithMessage:ACEUnknownError];
             }
         }];
    }
    else
    {
        btnRetry.userInteractionEnabled = true;
        btndashboard.userInteractionEnabled = true;
    }
}

#pragma mark - Event Methods
- (IBAction)btnDashboardTap:(id)sender
{
    if(ACEGlobalObject.user.isSalesPerson)
    {
        SPNotificationListViewController *viewController = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"SPNotificationListViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        ScheduleListViewController *viewController = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ScheduleListViewController"];
    
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)btnRetryTap:(id)sender
{
    if ([ACEUtil reachable])
    {
        [self getFailedPaymentUnits];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrUnits.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACEReceiptCell *receiptCell = [tableView dequeueReusableCellWithIdentifier:@"receiptCell"];
    receiptCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if([_paymentOption isEqualToString:CHKeyCC])
        [receiptCell setCellData:arrUnits[indexPath.row]];
    else
        [receiptCell setCellDataForCheckNPO:arrUnits[indexPath.row]];
    //ACCUnit *unit = arrUnits[indexPath.item];
    //[receiptCell setCellData:unit];
    return receiptCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_paymentOption isEqualToString:CHKeyCC])
    {
        return 133.0f;
    }
    else
    {
        return 95.0f;
    }
}
@end
