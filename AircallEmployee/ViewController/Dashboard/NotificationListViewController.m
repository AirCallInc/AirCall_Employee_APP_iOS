//
//  NotificationListViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 27/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "NotificationListViewController.h"

@interface NotificationListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
@property (strong, nonatomic) ACELoadMoreCell   *loadMoreCell;

@property NSString *pageNumber;
@end

@implementation NotificationListViewController

@synthesize tblvNotification,arrNotification,loadMoreCell,pageNumber,btnBack,btnLogout;

#pragma mark - ACEViewController Method

-(void)viewWillAppear:(BOOL)animated
{
    if(ACEGlobalObject.user.isSalesPerson)
    {
        btnBack.hidden = YES  ;
        btnLogout.hidden = NO ;
    }
    else
    {
        btnBack.hidden = NO  ;
        btnLogout.hidden = YES ;
    }
    pageNumber = @"1";
    arrNotification = [[NSMutableArray alloc]init];
    //[tblvNotification reloadData];
    [self getNotificationList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
    if([pageNumber isEqualToString:@"1"])
    {
        [SVProgressHUD show];
    }
    NSDictionary *dict = @{
                           UKeyEmployeeID : ACEGlobalObject.user.userID,
                           GKeyPageNumber : pageNumber
                           };
    
    [ACEWebServiceAPI getNotificationList:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *notificationList, NSString *pageNo, BOOL isPending)
    {
        [SVProgressHUD dismiss];
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
                    tblvNotification.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvNotification.height];
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
    }];
}

#pragma mark - Event method
- (IBAction)btnBacktap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
         NotificationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationListCell"];
        
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
            loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
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
        
        if ([notification.notificationType isEqualToString:@"10"]) // schedule Notification
        {
            ScheduleDetailViewController *sdvc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ScheduleDetailViewController"];
            
            sdvc.scheduleId     = notification.serviceID;
            sdvc.notificationId = notification.ID ;
            
            [self.navigationController pushViewController:sdvc animated:YES];
        }
        else if ([notification.notificationType isEqualToString:@"5"]) //Rating Notification
        {
            RatingDetailViewController *rdvc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"RatingDetailViewController"];
            
            rdvc.rateId = notification.serviceID;
            rdvc.notificationId = notification.ID;
            [self.navigationController pushViewController:rdvc animated:YES];
        }
        else if ([notification.notificationType isEqualToString:@"15"]) // sales person Notification
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

@end
