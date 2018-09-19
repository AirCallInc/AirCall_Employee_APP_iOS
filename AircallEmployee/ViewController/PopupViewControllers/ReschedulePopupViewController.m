//
//  ReschedulePopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 28/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ReschedulePopupViewController.h"

@interface ReschedulePopupViewController ()<UITextFieldDelegate,ZWTTextboxToolbarHandlerDelegate,SelectDatePopupViewControllerdelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton     *btnFirstHalf;
@property (strong, nonatomic) IBOutlet UIButton     *btnSecondHalf;

@property (strong, nonatomic) IBOutlet ACETextField *txtDate;
@property (strong, nonatomic) IBOutlet SAMTextView  *txtvReason;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlv;

@property NSDictionary *dictPurposeInfo;

@property ZWTTextboxToolbarHandler *handler;

@property NSString *time;
@property NSDate   *prefdate;

@property int       unitLimit;
@property int       minEmergencyDateGap;
@property int       minMaintenanceGap;
@property NSDateFormatter *formatter;

@end

@implementation ReschedulePopupViewController

@synthesize btnFirstHalf,btnSecondHalf,time,scheduleId,txtDate,prefdate,handler,txtvReason,scrlv,clientId,selectedDate,unitLimit,totalUnits,purposeOfVisit,minEmergencyDateGap,minMaintenanceGap,purposeId,formatter,dictPurposeInfo;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    
    txtDate.userInteractionEnabled = NO;
    txtDate.text   = selectedDate;
    prefdate       = [formatter dateFromString:selectedDate];
    
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:[NSMutableArray arrayWithObjects:txtvReason, nil] andScroll:scrlv];
    handler.delegate = self;
    
    [self getTimeSlot];
    
    [self btnTimingsTap:btnFirstHalf];
//    if(totalUnits > unitLimit)
//    {
//        [btnSecondHalf setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [btnSecondHalf setTitleColor:[UIColor appGreenColor] forState:UIControlStateNormal];
//    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [self btnTimingsTap:btnFirstHalf];
//    if(totalUnits > unitLimit)
//    {
//        [btnSecondHalf setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [btnSecondHalf setTitleColor:[UIColor appGreenColor] forState:UIControlStateNormal];
//    }

}
#pragma mark - Helper Method
-(void)setButtonTitles
{
    NSInteger day = [self getWeekdayOfselectedDate];
    if(purposeId == 1 && (day > 1 && day < 7))
    {
        [btnFirstHalf setTitle:dictPurposeInfo[GTimeEmergencySlot1] forState:UIControlStateNormal];
        [btnSecondHalf setTitle:dictPurposeInfo[GTimeEmergencySloat2] forState:UIControlStateNormal];
    }
    else
    {
        [btnFirstHalf setTitle:dictPurposeInfo[GTimeSlot1] forState:UIControlStateNormal];
        [btnSecondHalf setTitle:dictPurposeInfo[GTimeSlot2] forState:UIControlStateNormal];
    }
    unitLimit           = [dictPurposeInfo[GKeyUnitLimit]intValue];
    minMaintenanceGap   = [dictPurposeInfo[GKeyMaintenanceDays]intValue];
    minEmergencyDateGap = [dictPurposeInfo[GKeyEmergencyDays]intValue];
}
-(NSInteger)getWeekdayOfselectedDate
{
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSDate *date = [formatter dateFromString:txtDate.text];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    
    NSInteger weekday = [weekdayComponents weekday];
    
    return weekday;
}
#pragma mark - Event Method
- (IBAction)btnTimingsTap:(UIButton *)btn
{
    if(btn == btnFirstHalf)
    {
        btnFirstHalf.userInteractionEnabled  = NO;
        btnSecondHalf.userInteractionEnabled = YES;
        btnFirstHalf.selected                = YES;
        btnSecondHalf.selected               = NO;
        
        btnFirstHalf.backgroundColor  = [UIColor appGreenColor];
        btnSecondHalf.backgroundColor = [UIColor colorWithRed:0.90 green:0.93 blue:0.95 alpha:1.0];
        time  = btnFirstHalf.titleLabel.text;
        [btnSecondHalf setTitleColor:[UIColor appGreenColor] forState:UIControlStateNormal];
        
        if (totalUnits > unitLimit)
        {
            [btnSecondHalf setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btnSecondHalf.backgroundColor = [UIColor colorWithRed:0.90 green:0.93 blue:0.95 alpha:1.0];
        }
        
    }
    else if(btn == btnSecondHalf)
    {
        if(totalUnits > unitLimit)
        {
            [self showAlertWithMessage:ACERequestUnitLimit];
            [self btnTimingsTap:btnFirstHalf];
             btnSecondHalf.backgroundColor = [UIColor colorWithRed:0.90 green:0.93 blue:0.95 alpha:1.0];
        }
        else
        {
            btnSecondHalf.userInteractionEnabled = NO   ;
            btnFirstHalf.userInteractionEnabled  = YES  ;
            btnSecondHalf.selected               = YES  ;
            btnFirstHalf.selected                = NO   ;
        
            btnFirstHalf.backgroundColor  = [UIColor colorWithRed:0.90 green:0.93 blue:0.95 alpha:1.0];
            btnSecondHalf.backgroundColor = [UIColor appGreenColor];
            time  = btnSecondHalf.titleLabel.text;
        }
    }
    
}
- (IBAction)btnSubmitTap:(UIButton *)sender
{
    NSInteger day = [self getWeekdayOfselectedDate];
    
    if(prefdate == nil)
    {
        [self showErrorMessage:ACEBlankDate belowView:txtDate];
    }
    txtvReason.text = [self trimmWhiteSpaceFrom:txtvReason.text];
    
    if([txtvReason.text isEqualToString:ACEInvalidSelectedDate]|| [txtvReason.text isEqualToString:@""])
    {
        [txtvReason becomeFirstResponder];
        [self showErrorMessage:ACEBlankReason belowView:txtvReason];
    }
    else if (purposeId != 1 && (day == 1 || day == 7))
    {
        [self showAlertWithMessage:@"Only emergency services can be scheduled on weekends. Either change this request to Emergency (fee will incur) or please request the service during regular business hours."];
    }
    else
    {
        [self sendUpdatedTime];
    }
    
}
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnDateTap:(id)sender
{
    SelectDatePopupViewController *SDPVC = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectDatePopupViewController"];
    
    SDPVC.delegate       = self         ;
    SDPVC.selectedDate   = txtDate.text ;
    SDPVC.isMinimum      = YES          ;
    SDPVC.isFromScheduleNRequest = YES  ;
    
    if([purposeOfVisit isEqualToString:@"Maintenance Services"])
    {
         SDPVC.minimumDateGap = minMaintenanceGap;
    }
    else if ([purposeOfVisit isEqualToString:@"Emergency"])
    {
        SDPVC.minimumDateGap = 0;
    }
    else
    {
         SDPVC.minimumDateGap = minEmergencyDateGap;
    }
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [SDPVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:SDPVC animated:NO completion:nil];
}


#pragma mark - WebService Method
-(void)getTimeSlot
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           GKeyserviceId : scheduleId,
                           UKeyEmployeeID:ACEGlobalObject.user.userID
                           };
    
    [ACEWebServiceAPI getScheduletimeByServiceId:dict completionHandler:^(ACEAPIResponse *response, NSDictionary *purposeInfo)
    {
        [SVProgressHUD dismiss];
        
        if (response.code == RCodeSuccess)
        {
            dictPurposeInfo = purposeInfo;
            [self setButtonTitles];
            [self btnTimingsTap:btnFirstHalf];
        }
        else if(response.code == RCodeUnauthorized)
        {
            [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
             {
                 [ACEUtil logoutUser];
             }];
        }
        else if (response.code == RCodeSessionExpired)
        {
            [self showAlertFromWithMessageWithSingleAction:ACESessionExpired andHandler:^(UIAlertAction * _Nullable action)
             {
                 [ACEUtil logoutUser];
             }];
        }
        else if (response.message)
        {
            [self showAlertWithMessage:response.message];
        }
        else
        {
            [self showAlertWithMessage:ACEUnknownError];
        }
    }];
}
-(void)sendUpdatedTime
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyEmployeeID : ACEGlobalObject.user.userID,
                           GScheduleId    : scheduleId,
                           CKeyID         : clientId  ,
                           GServiceRequestedTime : btnFirstHalf.selected?btnFirstHalf.titleLabel.text:btnSecondHalf.titleLabel.text,
                           GServiceRequestedOn : txtDate.text,
                           GRescheduleReason  : txtvReason.text
                           };
    
    [ACEWebServiceAPI rescheduleService:dict completionHandler:^(ACEAPIResponse *response)
    {
        [SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            if ([scheduleId isEqualToString:ACEGlobalObject.scheduleId])
            {
                [ACEGlobalObject clearAllData];
            }
        }
        else if(response.code == RCodeUnauthorized)
        {
            [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
             {
                 [ACEUtil logoutUser];
             }];
        }
        else if (response.code == RCodeSessionExpired)
        {
            [self showAlertFromWithMessageWithSingleAction:ACESessionExpired andHandler:^(UIAlertAction * _Nullable action)
             {
                 [ACEUtil logoutUser];
             }];
        }
        else if(response.message)
        {
            [self showAlertWithMessage:response.message];
        }
        else
        {
            [self showAlertWithMessage:ACEUnknownError];
        }
    }];
    
}
#pragma mark - UITTextfield delegate methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self removeErrorMessageBelowView:textView];
    textView.layer.borderColor = [UIColor separatorColor].CGColor;
    return YES;
}
#pragma Mark -ZWTTextToolbarHandler delegate method
-(void)doneTap
{
    
}
#pragma mark - SelectDatePopupViewControllerdelegate method
-(void)selectedDate:(NSDate *)sdate
{
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSString *str=[NSString stringWithFormat:@"%@",[formatter stringFromDate:sdate]];
    txtDate.text = str;
    prefdate     = sdate;
    
    [self setButtonTitles];
}

@end
