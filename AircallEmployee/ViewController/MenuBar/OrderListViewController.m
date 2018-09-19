//
//  OrderListViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "OrderListViewController.h"

@interface OrderListViewController ()

@property NSMutableArray *arrOrderList;

@property (strong, nonatomic) IBOutlet UITableView *tblvOrderList;
@end

@implementation OrderListViewController
@synthesize arrOrderList,tblvOrderList;
#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    tblvOrderList.alwaysBounceVertical = NO;
    [self getOrderList];
}


#pragma mark - Helper Method
-(void)prepareView
{
    arrOrderList = [[NSMutableArray alloc]init];
}

#pragma mark - Event Methods
- (IBAction)btnPlusTap:(id)sender
{
    AddNewOrderViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewOrderViewController"];
    
    [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}
#pragma mark - TableView Delegate & Datasource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOrderList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACEOrderTableViewCell * cell = (ACEOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ACEOrderTableViewCell"];
    ACEOrder *order = arrOrderList[indexPath.item];
    
    [cell setCellData:order];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController *ODVC = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    
    ACEOrder *order = arrOrderList[indexPath.item];
    ODVC.orderId    =  order.Id;
    
    [self.navigationController pushViewController:ODVC animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.alpha = 0.0;
//    
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:(indexPath.row+1)/2];
//    cell.alpha = 1;
//    [UIView commitAnimations];
}
#pragma mark - WebService Method
-(void)getOrderList
{
    if ([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               
                               UKeyEmployeeID : ACEGlobalObject.user.userID
                               };
        
        [ACEWebServiceAPI getOrderList:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *arrOrders)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 arrOrderList = arrOrders;
                 [tblvOrderList reloadData];
                 [SVProgressHUD dismiss];
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
                 
                 arrOrderList  = arrOrders;
                 [tblvOrderList reloadData];
                 
                 tblvOrderList.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvOrderList.height];
             }
             else
             {
                 [SVProgressHUD dismiss];
                 //[self showAlertWithMessage:response.error.localizedDescription];
                 tblvOrderList.backgroundView = [ACEUtil viewNoDataWithMessage:ACEUnknownError andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvOrderList.height];
                 //[self showAlertWithMessage:ACEUnknownError];
             }
        }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
@end
