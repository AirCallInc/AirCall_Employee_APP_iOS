//
//  SaveReportDataPopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 05/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "SaveReportDataPopupViewController.h"

@interface SaveReportDataPopupViewController ()
@property (strong, nonatomic) IBOutlet UIView *vwPopup;

@end

@implementation SaveReportDataPopupViewController

@synthesize vwPopup;

- (void)viewDidLoad
{
    [super viewDidLoad];
    vwPopup.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    vwPopup.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwPopup.transform = CGAffineTransformIdentity;
                         vwPopup.hidden = NO;
                     }
                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Event Method
- (IBAction)btnYesTap:(id)sender
{
    [self.delegate selectedOption:YES];
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)btnNoTap:(id)sender
{
    [self.delegate selectedOption:NO];
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
