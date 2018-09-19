//
//  SelectDatePopupViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 02/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol SelectDatePopupViewControllerdelegate <NSObject>

-(void)selectedDate:(NSDate *)date;

@end

@interface SelectDatePopupViewController : ACEViewController

@property (strong) id <SelectDatePopupViewControllerdelegate> delegate;

@property BOOL isFromScheduleNRequest;

@property int  minimumDateGap   ;

@property BOOL isMaximumDate    ;
@property BOOL isMinimum        ;

@property NSString *selectedDate;

@end
