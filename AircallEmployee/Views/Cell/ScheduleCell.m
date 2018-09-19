//
//  ScheduleCell.m
//  AircallEmployee
//
//  Created by ZWT112 on 5/6/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ScheduleCell.h"

@implementation ScheduleCell

@synthesize lblClientName,lblEndTime,lblPurpose,lblStartTime;

-(void)setCellData:(ACESchedule *)scheduleInfo
{
    lblClientName.text  =   scheduleInfo.clientName ;
    lblStartTime.text   =   scheduleInfo.startTime  ;
    lblEndTime.text     =   scheduleInfo.endTime    ;
    lblPurpose.text     =   scheduleInfo.purpose    ;
    if([scheduleInfo.status isEqualToString:@"Scheduled"])
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundColor = [UIColor selectedBackgroundColor];
    }
}
@end
