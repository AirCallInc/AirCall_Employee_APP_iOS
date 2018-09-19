//
//  ChooseQtyPopupViewController.h
//  AircallEmployee
//
//  Created by Manali on 01/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseQty <NSObject>

-(void)ChooseQuantity:(NSString *)qty;

@end

@interface ChooseQtyPopupViewController : ACEViewController

@property (weak) id<ChooseQty> delegate;

@end
