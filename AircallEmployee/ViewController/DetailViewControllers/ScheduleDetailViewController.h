//
//  ScheduleDetailViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface ScheduleDetailViewController : ACEViewController

@property (strong, nonatomic) NSString *scheduleId;
@property (strong, nonatomic) NSDate   *selectedDate;
@property (strong, nonatomic) NSString *notificationId;

@end
