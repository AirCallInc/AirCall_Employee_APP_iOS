//
//  ChargeByPopupViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 20/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

extern NSString *const CHKeyCheque      ;
extern NSString *const CHKeyCCOnFile    ;
extern NSString *const CHKeyNewCC       ;
extern NSString *const CHKeyPO          ;
extern NSString *const CHKeyCC          ;

@protocol ChargeByPopupViewControllerDelegate <NSObject>

-(void)selectedOption:(NSString *)option;

@end

@interface ChargeByPopupViewController : ACEViewController

@property NSString *selectedOption ;
@property BOOL      shouldHideCC   ;

@property (weak)id<ChargeByPopupViewControllerDelegate> delegate;


@end
