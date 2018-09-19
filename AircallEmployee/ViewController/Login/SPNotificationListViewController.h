//
//  SPNotificationListViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 12/01/17.
//  Copyright © 2017 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPNotificationListViewController : ACEViewController

@property (weak, nonatomic) IBOutlet UITableView *tblvNotification;
@property (strong, nonatomic) NSMutableArray *arrNotification;

@end
