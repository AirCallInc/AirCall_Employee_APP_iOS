//
//  ACEViewController.h
//  AircallEmployee
//
//  Created by ZWT112 on 3/29/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACEViewController : UIViewController

@property (weak, nonatomic,nullable) UIStoryboard *storyboardLogin;

- (void)showErrorMessage:(NSString *_Nonnull)message belowView:(UIView *_Nonnull)viewDisplay;
- (void)removeErrorMessageBelowView:(UIView *_Nonnull)viewDisplay;
- (void)showAlertWithMessage:(NSString *__nullable)message;
- (void)showAlertFromWithMessageWithSingleAction:(NSString *__nullable)message andHandler:(void (^ __nullable)(UIAlertAction *__nullable action))handler;

- (void)openSideBar;
- (void)zoomOutAnimation;
- (NSString *_Nonnull)trimmWhiteSpaceFrom:(NSString *_Nonnull)string;

@end
