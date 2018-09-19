//
//  CallSMSPopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 27/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "CallSMSPopupViewController.h"

@interface CallSMSPopupViewController ()<MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *vwPopup;

@end

@implementation CallSMSPopupViewController
@synthesize number,vwPopup;

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
                         vwPopup.hidden    = NO;
                     }
                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Event Method
- (IBAction)btnCallTap:(id)sender
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)btnSMSTap:(id)sender
{
    if (![MFMessageComposeViewController canSendText])
    {
        NSLog(@"Message services are not available.");
    }
    else
    {
        MFMessageComposeViewController* composeVC = [[MFMessageComposeViewController alloc] init];
        
        composeVC.messageComposeDelegate = self;
        composeVC.recipients             = @[number];
        
        [self presentViewController:composeVC animated:YES completion:nil];
    }
}
- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - MFMessageComposeViewController delegate method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    // Check the result or perform other tasks.
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
