//
//  SPNotificationListViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 12/01/17.
//  Copyright © 2017 com.zwt. All rights reserved.
//

#import "SPNotificationListViewController.h"

@interface SPNotificationListViewController ()<SPAddUnitPopupViewControllerDelegate>

@property (strong, nonatomic) ACELoadMoreCell   *loadMoreCell;
@property NSString *pageNumber;
@property BOOL isPendingUnits;
@property UIRefreshControl *refreshController ;
@property BOOL isRefresh;
@end

@implementation SPNotificationListViewController

@synthesize arrNotification,pageNumber,tblvNotification,loadMoreCell,isPendingUnits,refreshController,isRefresh;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //pageNumber = @"1";
    //arrNotification = [[NSMutableArray alloc]init];
    //[tblvNotification reloadData];
    //[self getNotificationList];
     refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [tblvNotification addSubview:refreshController];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    pageNumber = @"1";
    arrNotification = [[NSMutableArray alloc]init];
    //[tblvNotification reloadData];
    isRefresh = NO;
    [self getNotificationList];
}
#pragma mark - Helper Method
-(void)handleRefresh : (id)sender
{
    pageNumber = @"1";
    isRefresh  = YES;
    [self getNotificationList];
}
-(void)openPaymentOption
{
    SPAddUnitPopupViewController *viewController  = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"SPAddUnitPopupViewController"];
    viewController.delegate = self;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [viewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:viewController animated:NO completion:nil];
}

#pragma mark - webservice method
-(void)getNotificationList
{
    if([ACEUtil reachable])
    {
        [self getNotifications];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
    
}
-(void)getNotifications
{
    if([pageNumber isEqualToString:@"1"] && !isRefresh)
    {
        [SVProgressHUD show];
    }
    NSDictionary *dict = @{
                           UKeyEmployeeID : ACEGlobalObject.user.userID,
                           GKeyPageNumber : pageNumber
                           };
    
    [ACEWebServiceAPI getNotificationList:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *notificationList, NSString *pageNo,BOOL isPending)
     {
         [SVProgressHUD dismiss];
          isPendingUnits = isPending;
         if(response.code == RCodeSuccess)
         {
             if([pageNumber isEqualToString:@"1"])
             {
                 arrNotification = notificationList.mutableCopy;
             }
             else if(notificationList.count == 0)
             {
                 arrNotification = notificationList.mutableCopy;
             }
             else
             {
                 [arrNotification addObjectsFromArray:notificationList];
             }
             
             [tblvNotification reloadData];
             loadMoreCell.hidden = YES;
             pageNumber = pageNo;
           
         }
         else if (response.code == RCodeNoData)
         {
             if([pageNumber isEqualToString:@"1"])
             {
                 arrNotification = notificationList;
                 
                 if(notificationList.count == 0)
                 {
                     tblvNotification.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.size.height / 1.9];
                 }
                 [tblvNotification reloadData];
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
             [self showAlertWithMessage:response.message];
         }
         else
         {
             //[self showAlertWithMessage:response.error.localizedDescription];
             [self showAlertWithMessage:ACEUnknownError];
         }
         [loadMoreCell.indicator stopAnimating];
         [refreshController endRefreshing];
     }];
}
-(void)callWebserviceToDeleteUnit
{
    if([ACEUtil reachable])
    {
        NSDictionary *dict = @{
                               UKeyEmployeeID :ACEGlobalObject.user.userID
                               };
        
        [ACEWebServiceAPI deletePendingUnits:dict CompletionHandler:^(ACEAPIResponse *response)
         {
             if(response.code == RCodeSuccess)
             {
                 isPendingUnits = NO;
                 [self openPaymentOption];
             }
             else
             {
                 [self showAlertWithMessage:ACEUnknownError];
             }
         }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
    
}
#pragma mark - Event method
- (IBAction)btnAddUnitTaptap:(id)sender
{
    if([ACEUtil reachable])
    {
        if(isPendingUnits)
        {
            [ACEUtil showAlertFromControllerWithDoubleAction:self withMessage:ACEPendingUnitMsg andHandler:^(UIAlertAction * _Nullable action)
             {
                 SPSummaryViewController *usvc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"SPSummaryViewController"];
                 
                 usvc.isPending     = isPendingUnits;
                 
                 [self.navigationController pushViewController:usvc animated:YES];
             }
                                                andNoHandler:^(UIAlertAction * _Nullable action)
             {
                 
                 [self callWebserviceToDeleteUnit];
                 
             }];
        }
        else
        {
            [self openPaymentOption];
        }
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }

}
- (IBAction)btnLogOutTap:(id)sender
{
    [ACEUtil logoutUser];
}

#pragma mark - tableview delegate and datasource method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = arrNotification.count;
    if(numOfRows > 0)
    {
        numOfRows += 1;
    }
    
    return numOfRows;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    tblvNotification.backgroundView = nil;
    
    if(indexPath.row < arrNotification.count)
    {
        NotificationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPNotificationListCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellData:arrNotification[indexPath.row]];
        
        if(indexPath.row != 0)
        {
            UIView* separatorLineView = [[UIView alloc] initWithFrame:
                                         CGRectMake(0, 0, self.view.width, 1)];
            
            separatorLineView.backgroundColor = [UIColor separatorColor];
            [cell.contentView addSubview:separatorLineView];
        }
        
        return cell;
        
    }
    else
    {
        if(!loadMoreCell)
        {
            loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"SPloadMoreCell"];
            loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView* separatorLineView = [[UIView alloc] initWithFrame:
                                         CGRectMake(0, 0, self.view.width, 1)];
            
            separatorLineView.backgroundColor = [UIColor separatorColor];
            [loadMoreCell.contentView addSubview:separatorLineView];
        }
        return loadMoreCell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrNotification.count > indexPath.row)
    {
        
        CGSize constraint;
        
        ACENotification *noti = arrNotification[indexPath.row];
        
        NSString *str = [NSString stringWithFormat:@"%@\n\n%@",noti.message,noti.dateTime];
        
        if(ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone6Plus)
        {
            constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.30 , FLT_MAX);
        }
        else if (ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone6)
        {
            constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.35 , FLT_MAX);
        }
        else
        {
            constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.45 , FLT_MAX);
        }
        //constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.45 , FLT_MAX);
        
        
        UIFont *font = [UIFont fontWithName:@"OpenSans" size:15];
        
        CGSize size = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font}context:nil].size;
        
        // NSLog(@"\n\nController :::: label height: %f\n label Width : %f\n\n",size.height + 20,size.width);
        
        return size.height + 20;
    }
    else if (indexPath.item == arrNotification.count)
    {
        return 50;
    }
    return 0;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell isKindOfClass:[ACELoadMoreCell class]])
    {
        loadMoreCell.lblTitle.text = ACETextLoading;
        loadMoreCell.hidden = NO;
        loadMoreCell.indicator.hidden = NO;
        
        [loadMoreCell.indicator startAnimating];
        
        [self performSelector:@selector(getNotificationList) withObject:nil afterDelay:0.5];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrNotification.count > indexPath.row)
    {
        ACENotification *notification = arrNotification[indexPath.row];
        
        if ([notification.notificationType isEqualToString:@"15"]) // sales person Notification
        {
            
            SalesPersonNotiDetailController *spvc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"SalesPersonNotiDetailController"];
            
            spvc.salesVisitId   = notification.serviceID;
            spvc.notificationId = notification.ID;
            
            [self.navigationController pushViewController:spvc animated:YES];
        }
        /* else if ([notification.notificationType isEqualToString:@""]) // Requested part status change notification
         {
         
         RequestPartViewController  *rpvc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"RequestPartViewController"];
         
         rpvc.empRequestId   = notification.serviceID;
         rpvc.isEditable     = YES;
         //rpvc.notificationId = notification.ID;
         
         [self.navigationController pushViewController:rpvc animated:YES];
         }*/
    }
}
#pragma mark - SPAddUnitPopupViewControllerDelegate method
-(void)selectedPaymentOption:(NSString *)selectedOption
{
    SPAddunitViewController *vc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"SPAddunitViewController"];
    
    vc.paymnetOption = selectedOption;
    vc.isAddAnother  = NO;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
