//
//  UnitUnMatchedPopupViewController.h
//  AircallEmployee
//
//  Created by Manali on 30/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UnMatchedPopup <NSObject>

-(void)openAddUnitACHeating:(int)isMatched;

@end

@interface UnitUnMatchedPopupViewController : ACEViewController

@property (weak, nonatomic) IBOutlet UIButton *btnCreateNewUnit;
@property (weak, nonatomic) IBOutlet UIButton *btnReEnterDetail;

@property (weak) id<UnMatchedPopup> delegate;

@end
