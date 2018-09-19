//
//  SelectDatePopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 02/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "SelectDatePopupViewController.h"

@interface SelectDatePopupViewController ()

@property (strong, nonatomic) IBOutlet UIDatePicker *dpDate;
@property (strong, nonatomic) IBOutlet UIView *vwPopup;

@end

@implementation SelectDatePopupViewController
@synthesize dpDate,delegate,vwPopup,minimumDateGap,isMaximumDate,selectedDate,isMinimum,isFromScheduleNRequest;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    vwPopup.hidden        = YES;
    dpDate.datePickerMode = UIDatePickerModeDate;
    //dpDate.subviews[0].subviews[0].subviews[1].hidden = true;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    
    if(isFromScheduleNRequest)
    {
        if(minimumDateGap > 0 && isMinimum)
        {
            [dpDate setMinimumDate:[ACEUtil getDefaultDateWithoutWeekends:minimumDateGap]];
        }
        if(minimumDateGap == 0)
        {
             [dpDate setMinimumDate:[NSDate date]];
        }
        if(selectedDate)
        {
            [dpDate setDate:[formatter dateFromString:selectedDate]];
        }
    }
    else
    {
        if(selectedDate && isMinimum)
        {
            [dpDate setMinimumDate:[formatter dateFromString:selectedDate]];
        }
        else if (selectedDate && isMaximumDate)
        {
            [dpDate setMaximumDate:[formatter dateFromString:selectedDate]];
        }
    }
    
   /*
    if(minimumDateGap >= 0 && isMinimum)
    {
        [dpDate setMinimumDate:[ACEUtil getDefaultDateWithoutWeekends:minimumDateGap]];
    }
    if(isMaximumDate)
    {
        [dpDate setMaximumDate:[NSDate date]];
    }*/
    
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
- (IBAction)btnPickerSubmitTap:(UIButton *)sender
{
    [delegate selectedDate:dpDate.date];
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)btnPickerCancelTap:(UIButton *)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)onDatePickerValueChanged:(UIDatePicker *)picker
{
    // Work out which day of the week is currently selected.
   
    NSCalendar* cal = [NSCalendar currentCalendar];
    
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:picker.date];
    
    int weekday = (int)[comp weekday];
    
    if (weekday == 1 || weekday == 7)
    {
        // Sunday or Saturday
        
        if (weekday == 1)
        {
            [dpDate  setDate: [dpDate.date dateByAddingTimeInterval:24 * 60  *60]animated:YES]; // Add 24 hours
        }
        else
        {
            [dpDate  setDate: [dpDate.date dateByAddingTimeInterval:2 * 24 * 60  *60]animated:YES]; // Add two daysc
        }
        
    }

}

/*-(void)showPickerView
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_vwDatePicker.bounds];
    
    _vwDatePicker.layer.masksToBounds = NO;
    _vwDatePicker.layer.shadowColor = [UIColor blackColor].CGColor;
    
    _vwDatePicker.layer.shadowOpacity = 0.5f;
    _vwDatePicker.layer.shadowPath = shadowPath.CGPath;
    
    [self.view addSubview:_vwDatePicker];
    
    _vwDatePicker.center = self.view.center;
    
   
    _vwDatePicker.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         _vwDatePicker.transform = CGAffineTransformIdentity;
     }
                     completion:nil];
    
}
-(void)hidePickerView
{
    _vwDatePicker.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         _vwDatePicker.transform = CGAffineTransformMakeScale(0.01, 0.01);
     }
                     completion:^(BOOL finished)
     {
         [_vwDatePicker removeFromSuperview];
        
     }];
}*/
@end
