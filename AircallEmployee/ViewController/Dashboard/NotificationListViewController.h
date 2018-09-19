//
//  NotificationListViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 27/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface NotificationListViewController : ACEViewController

@property (strong, nonatomic) IBOutlet UITableView *tblvNotification;
@property (strong, nonatomic) NSMutableArray *arrNotification;

@end
