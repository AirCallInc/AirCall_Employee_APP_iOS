//
//  ACEViewController.m
//  AircallEmployee
//
//  Created by ZWT112 on 3/29/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface ACEViewController ()

@property (strong, nonatomic) ACEMessageBar *messageBar;
@property SideBarViewController *sideBarViewController;

@end

@implementation ACEViewController
@synthesize messageBar,sideBarViewController;

#pragma mark - UIViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
}
#pragma mark - Helper Method
- (void)zoomOutAnimation
{
    CATransition* transition = [CATransition animation];
    transition.duration      = 0.3;
    transition.type          = kCATransitionFade;
    transition.subtype       = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
}
-(NSString *)trimmWhiteSpaceFrom:(NSString *)string
{
    NSString *trimmedStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            
    return trimmedStr;
}

#pragma mark - AIRMessage Bar Methods
- (ACEMessageBar *)messageBar
{
    if(!messageBar)
    {
        messageBar = [[ACEMessageBar alloc] init];
    }
    
    return messageBar;
}

- (void)showErrorMessage:(NSString *)message belowView:(UIView *)viewDisplay
{
    CGRect messageBarFrame      = self.messageBar.frame;
    
    messageBarFrame.origin.x    = CGRectGetMinX(viewDisplay.frame);
    messageBarFrame.origin.y    = CGRectGetMaxY(viewDisplay.frame) + 5;
    messageBarFrame.size.width  = CGRectGetWidth(viewDisplay.frame);
    messageBarFrame.size.height = 0;
    
    self.messageBar.frame       = messageBarFrame;
    self.messageBar.message     = message;
    self.messageBar.relatedView = viewDisplay;
    
    [self.messageBar prepareForError];
    
    [viewDisplay.superview addSubview:self.messageBar];
    
    [UIView animateWithDuration:0.3 animations:^
     {
         self.messageBar.height = ACEValidationMsgHeight;
         
     }];
}

- (void)removeErrorMessageBelowView:(UIView *)viewDisplay
{
    
    if (self.messageBar.relatedView == viewDisplay)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             self.messageBar.height = 0;
         }
         completion:^(BOOL finished)
         {
             [self.messageBar removeFromSuperview];
         }];
    }
}

#pragma mark - Alert Methods
- (void)showAlertWithMessage:(NSString *)message
{
    [ACEUtil showAlertFromController:self withMessage:message];
}
- (void)showAlertFromWithMessageWithSingleAction:(NSString *__nullable)message andHandler:(void (^ __nullable)(UIAlertAction *__nullable action))handler
{
    [ACEUtil showAlertFromControllerWithSingleAction:self withMessage:message andHandler:handler];
}

#pragma mark- UIStoryboard Methods
-(UIStoryboard*)storyboardLogin
{
    return ACEGlobalObject.storyboardLogin;
}

-(void)openSideBar
{
    if(!sideBarViewController)
    {
        sideBarViewController = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SideBarViewController"];
        [self.view addSubview:sideBarViewController.view];
    }
    [sideBarViewController showMenu];
}
@end
