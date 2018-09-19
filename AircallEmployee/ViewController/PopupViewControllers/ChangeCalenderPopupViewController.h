//
//  ChangeCalenderPopupViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 23/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

extern NSString *const CalenderOptionMonth  ;
extern NSString *const CalenderOptionWeek   ;
extern NSString *const CalenderOptionToday    ;

@protocol ChangeCalenderPopupViewControllerProtocol <NSObject>

-(void)selectedOption:(NSString *)option;

@end

@interface ChangeCalenderPopupViewController : ACEViewController

@property (strong)id<ChangeCalenderPopupViewControllerProtocol> delegate;

@property (strong, nonatomic)NSString *selectedString;

@end
