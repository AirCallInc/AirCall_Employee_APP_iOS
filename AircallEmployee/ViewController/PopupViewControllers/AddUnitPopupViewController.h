//
//  AddUnitPopupViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 05/01/17.
//  Copyright © 2017 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddUnitPopupViewControllerDelegate <NSObject>

-(void)selectedPaymentOption:(NSString *)selectedOption;

@end

@interface AddUnitPopupViewController : ACEViewController

@property id<AddUnitPopupViewControllerDelegate> delegate;

@end
