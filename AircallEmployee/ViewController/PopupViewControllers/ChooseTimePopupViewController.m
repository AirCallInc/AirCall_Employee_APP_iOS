//
//  ChooseTimePopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 14/02/17.
//  Copyright © 2017 com.zwt. All rights reserved.
//

#import "ChooseTimePopupViewController.h"

@interface ChooseTimePopupViewController ()

@property (strong, nonatomic) IBOutlet UIView *vwPopup;
@property (strong, nonatomic) IBOutlet UIDatePicker *dpTimePicker;

@end

@implementation ChooseTimePopupViewController

@synthesize vwPopup,dpTimePicker,delegate,displayDate;

#pragma mark - ViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [dpTimePicker setDate:displayDate];
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
#pragma mark - Event Method
- (IBAction)btnOkTap:(id)sender
{
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"hh:mm a"];
     [dateFormatter stringFromDate:dpTimePicker.date];
     [delegate selectedTime:[dateFormatter stringFromDate:dpTimePicker.date]];
     [self dismissViewControllerAnimated:NO completion:nil];

}
- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
