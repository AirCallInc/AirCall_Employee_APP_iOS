//
//  NotificationListCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 30/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblNotiMsg;
@property (strong, nonatomic) IBOutlet UILabel *lblDateTime;

-(void)setCellData:(ACENotification *)noti;

@end
