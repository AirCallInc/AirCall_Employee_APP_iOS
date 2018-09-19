//
//  SideBarViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "SideBarViewController.h"

@interface SideBarViewController ()

@property (strong, nonatomic) IBOutlet UIView *vwSideMenu;
@property (strong, nonatomic) IBOutlet UIImageView *imgvUser;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblVersionNumber;

@end

@implementation SideBarViewController
@synthesize vwSideMenu,imgvUser,lblUserName,lblVersionNumber;


- (void)viewDidLoad
{
    [super viewDidLoad];
    imgvUser.layer.cornerRadius = imgvUser.height / 2;
    imgvUser.layer.masksToBounds = YES;
    lblVersionNumber.text = [NSString stringWithFormat:@"Version: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (IBAction)btnScheduleTap:(id)sender
{
    ScheduleListViewController *controller  = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleListViewController"];
    
    [self displayController:controller forMenuItem:sender];
}

- (IBAction)btnServiceReportsTap:(id)sender
{
    ServiceReportListViewController *controller = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ServiceReportListViewController"];
    
    [self displayController:controller forMenuItem:sender];
    
    
}
- (IBAction)btnUnitListTap:(id)sender
{
    ACUnitListViewController *controller = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ACUnitListViewController"];
    
    [self displayController:controller forMenuItem:sender];
    
}
- (IBAction)btnOrdersTap:(id)sender
{
    OrderListViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"OrderListViewController"];
   [self displayController:vc forMenuItem:sender];
    
}
- (IBAction)btnPartsListTap:(id)sender
{
    PartsListViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"PartsListViewController"];
    
    [self displayController:vc forMenuItem:sender];
    
}
- (IBAction)btnRatingReviewTap:(id)sender
{
    RatingNReviewViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"RatingNReviewViewController"];
    
    [self displayController:vc forMenuItem:sender];

}
- (IBAction)btnSalesPersonVisit:(id)sender
{
    SalesPersonViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SalesPersonViewController"];
    
    [self displayController:vc forMenuItem:sender];
    
}
- (IBAction)btnAccountSettingTap:(id)sender
{
    AccountSettingViewController *vc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"AccountSettingViewController"];
    
    [self displayController:vc forMenuItem:sender];
}


- (IBAction)btnLogOutTap:(id)sender
{
//    [ACEGlobalObject.user logout];
    [ACEUtil logoutUser];
}

- (void) displayController:(UIViewController *)controller forMenuItem:(UIButton *)btnMenuItem
{
    
    //[ACEGlobalObject.drawer closeDrawerAnimated:YES completion:nil];
    
   // [ACEGlobalObject.rootNavigationController setViewControllers:@[controller] animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.view.superview bringSubviewToFront:self.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        vwSideMenu.x = -CGRectGetWidth(vwSideMenu.frame);
        self.view.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished)
     {
         self.view.x = -CGRectGetWidth([UIScreen mainScreen].bounds);
         
         [ACEGlobalObject.rootNavigationController setViewControllers:@[controller] animated:NO];
     }];

}
- (IBAction)btnCancelTap:(id)sender
{
    [self hideMenu];
}

#pragma mark - Helper Method
- (void)showMenu
{
    //    From Right
    //    self.view.backgroundColor = [UIColor clearColor];
    //    self.view.frame = [UIScreen mainScreen].bounds;
    //
    //    vwSideMenu.x = CGRectGetWidth(vwSideMenu.frame);
    //
    //    [self.view.superview bringSubviewToFront:self.view];
    //
    //    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^
    //     {
    //         vwSideMenu.x = self.view.width / 5.5;
    //
    //         self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
    //     }
    //                     completion:^(BOOL finished)
    //     {
    //     }];
    
    //  From Left
    
    //NSData *dataImage = [[NSUserDefaults standardUserDefaults] objectForKey:UKeyProfileImage];
    //UIImage *image = [UIImage imageWithData:dataImage];
    
//    if (dataImage == nil)
//    {
//        imgvUser.image = [UIImage imageNamed:@"userPlaceHolder"];
//    }
//    else
//    {
//        imgvUser.image = image;
   // }
    
   // lblUserName.text = [NSString stringWithFormat:@"%@ %@",ACCGlobalObject.user.firstName,ACCGlobalObject.user.lastName];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    NSData *dataImage = [[NSUserDefaults standardUserDefaults] objectForKey:UKeyImage];
    UIImage *image = [UIImage imageWithData:dataImage];
    
    if (dataImage == nil)
    {
        imgvUser.image = [UIImage imageNamed:@"Profileimage"];
    }
    else
    {
        imgvUser.image = image;
    }
    
    lblUserName.text = [NSString stringWithFormat:@"%@ %@",ACEGlobalObject.user.firstName,ACEGlobalObject.user.lastName];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = [UIScreen mainScreen].bounds;
    
    vwSideMenu.x = -CGRectGetWidth(vwSideMenu.frame);
    
    [self.view.superview bringSubviewToFront:self.view];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:0
                     animations:^
    {
                         
         vwSideMenu.x = 0;
         
         self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
     }
     completion:^(BOOL finished)
     {
         
     }];
    
}

-(void)hideMenu
{
    //    From Right
    //    [UIView animateWithDuration:0.3 animations:^
    //     {
    //         self.view.backgroundColor = [UIColor clearColor];
    //
    //         vwSideMenu.x = self.view.width;
    //     }
    //                     completion:^(BOOL finished)
    //     {
    //         self.view.x = CGRectGetWidth([UIScreen mainScreen].bounds);
    //     }];
    
    
    //    From Left
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIView animateWithDuration:0.3 animations:^
     {
         self.view.backgroundColor = [UIColor clearColor];
         
         vwSideMenu.x = -CGRectGetWidth(vwSideMenu.frame);
     }
     completion:^(BOOL finished)
     {
         self.view.x = -CGRectGetWidth([UIScreen mainScreen].bounds);
     }];
    
    
}

@end
