//
//  ScheduleCell.h
//  AircallEmployee
//
//  Created by ZWT112 on 5/6/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (strong, nonatomic) IBOutlet UILabel *lblPurpose;
@property (strong, nonatomic) IBOutlet UILabel *lblStartTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEndTime;

-(void)setCellData:(ACESchedule *)scheduleInfo;

@end
