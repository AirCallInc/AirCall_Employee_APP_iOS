//
//  ChooseTimePopupViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 14/02/17.
//  Copyright © 2017 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol ChooseTimePopupViewControllerDelegate <NSObject>

-(void)selectedTime:(NSString *)selectedTime;


@end

@interface ChooseTimePopupViewController : ACEViewController

@property id<ChooseTimePopupViewControllerDelegate> delegate;

@property NSDate * displayDate;

@end
