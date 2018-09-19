//
//  SalesPersonViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "SalesPersonViewController.h"

@interface SalesPersonViewController ()<SalesPersonRequest>

@property (strong, nonatomic) ACELoadMoreCell *loadMoreCell;
@property NSString *pageNo;
@end

@implementation SalesPersonViewController

@synthesize arrSalesPerson,tblvSalesPersonData,loadMoreCell,pageNo;
#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self prepareview];
}
#pragma mark - Helper method
-(void)prepareview
{
    pageNo = @"1";
    arrSalesPerson = [[NSMutableArray alloc]init];
    tblvSalesPersonData.tableFooterView      = [[UIView alloc] initWithFrame:CGRectZero];
    tblvSalesPersonData.separatorColor       = [UIColor clearColor];
    tblvSalesPersonData.alwaysBounceVertical = NO;
    
    if ([ACEUtil reachable])
    {
        [self getData];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

#pragma mark - webservice Method
-(void)getData
{
   
    if([pageNo isEqualToString:@"1"])
    {
        [SVProgressHUD show];
    }
    
    NSDictionary *dict = @{
                           UKeyEmployeeID : ACEGlobalObject.user.userID,
                           GKeyPageNumber : pageNo
                           };
    [ACEWebServiceAPI getSalesPersonVisitList:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *salesPersonArray, NSString *pageNumber)
    {
        [SVProgressHUD dismiss];
        
        if (response.code == RCodeSuccess)
        {
            if(salesPersonArray.count == 0)
            {
                arrSalesPerson = salesPersonArray.mutableCopy;
            }
            else
            {
                [arrSalesPerson addObjectsFromArray:salesPersonArray];
            }

            [tblvSalesPersonData reloadData];
            
            loadMoreCell.hidden = YES;
            pageNo              = pageNumber;
            tblvSalesPersonData.backgroundView = nil;
        }
        else if (response.code == RCodeNoData)
        {
            if(arrSalesPerson.count == 0)
            {
                tblvSalesPersonData.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.size.height / 1.3];
            }
            else
            {
                loadMoreCell.indicator.hidden = YES;
                loadMoreCell.lblTitle.text = ACETextNoMoreData;
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
            loadMoreCell.hidden = YES;
            tblvSalesPersonData.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.size.height / 1.3];
        }
        else
        {
            loadMoreCell.hidden = YES;
            tblvSalesPersonData.backgroundView = [ACEUtil viewNoDataWithMessage:ACEUnknownError andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.size.height / 1.3];
        }
        
        [loadMoreCell.indicator stopAnimating];
    }];
}

#pragma mark - Event Method
- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}
- (IBAction)btnPlusTap:(id)sender
{
    SalesPersonRequestViewController *request = [self.storyboard instantiateViewControllerWithIdentifier:@"SalesPersonRequestViewController"];
    
    request.delegate = self;
    [self.navigationController pushViewController:request animated:YES];
}

#pragma mark - tableview delegate method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = arrSalesPerson.count;
    
    if(numberOfRows > 0)
    {
        numberOfRows = arrSalesPerson.count + 1;
    }
    
    return numberOfRows;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < arrSalesPerson.count)
    {
        ACESalesPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACESalesPersonCell"];
    
        [cell setCellData:arrSalesPerson[indexPath.row]];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
    }
    else
    {
        if(!loadMoreCell)
        {
            loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell" forIndexPath:indexPath];
        }
        loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return loadMoreCell;
    }
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell isKindOfClass:[ACELoadMoreCell class]])
    {
        loadMoreCell.lblTitle.text = ACETextLoading;
        
        loadMoreCell.hidden = NO;
        loadMoreCell.indicator.hidden = NO;
        
        [loadMoreCell.indicator startAnimating];
        
        [self performSelector:@selector(getData) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - delegate method
-(void)submitSalesPerson
{
   // NSLog(@"delegate Called");
}

@end
