//
//  SaveReportDataPopupViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 05/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol SaveReportDataPopupViewControllerDelegate <NSObject>

-(void)selectedOption:(BOOL)option;

@end

@interface SaveReportDataPopupViewController : ACEViewController

@property (strong) id<SaveReportDataPopupViewControllerDelegate> delegate;

@end
