//
//  SPAddUnitPopupViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 12/01/17.
//  Copyright © 2017 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol SPAddUnitPopupViewControllerDelegate <NSObject>

-(void)selectedPaymentOption:(NSString *)selectedOption;

@end

@interface SPAddUnitPopupViewController : ACEViewController

@property id<SPAddUnitPopupViewControllerDelegate> delegate;

@end
