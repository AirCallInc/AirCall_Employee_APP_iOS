//
//  MonthYearPickerViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 14/10/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol MonthYearPickerViewControllerdelegate <NSObject>

-(void)selectedDateFromMonthPicker:(NSDate *)date;

@end

@interface MonthYearPickerViewController : ACEViewController

@property (strong) id <MonthYearPickerViewControllerdelegate> delegate;
@property NSDate *showDate ;


@end
