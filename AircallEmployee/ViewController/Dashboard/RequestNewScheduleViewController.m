//
//  RequestNewScheduleViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 10/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "RequestNewScheduleViewController.h"

@interface RequestNewScheduleViewController ()<UITextFieldDelegate,SelectedUser,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ZWTTextboxToolbarHandlerDelegate,SelectDatePopupViewControllerdelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrlvbg;
@property (weak, nonatomic) IBOutlet UIView *vwAddress;
@property (weak, nonatomic) IBOutlet UIView *vwPlan;
@property (weak, nonatomic) IBOutlet UIView *vwUnit;
@property (weak, nonatomic) IBOutlet UIView *vwBelowUnit;
@property (weak, nonatomic) IBOutlet UIView *vwReason;
@property (weak, nonatomic) IBOutlet UIView *vwNotes;
@property (weak, nonatomic) IBOutlet UIView *vwDateTime;

@property (weak, nonatomic) IBOutlet UIButton *btnFirstHalf;
@property (weak, nonatomic) IBOutlet UIButton *btnSecondHalf;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet SAMTextView *txtvNotes;
@property (weak, nonatomic) IBOutlet UITextField *txtContact;

@property (weak, nonatomic) IBOutlet UILabel     *lblDate;
@property (weak, nonatomic) IBOutlet UITableView *tblvReason;
@property (weak, nonatomic) IBOutlet UITableView *tblvUnit;
@property (weak, nonatomic) IBOutlet UITableView *tblvAddress;
@property (weak, nonatomic) IBOutlet UITableView *tblvPlan;

@property NSMutableArray *arrReasons;
@property NSMutableArray *arrAddress;
@property NSMutableArray *arrUnit;
@property NSMutableArray *arrPlan;
@property NSMutableArray *arrSelectedUnit;
@property NSMutableArray *arrSelectedIndexPaths;

@property NSString *addressId;
@property NSString *planId;
@property NSString *selectedClientID;
@property NSString *selectedTimeSlot;
@property NSInteger selectedReasonId;
@property NSString *alertMsg;

@property NSDictionary *purposeDictionary;

@property NSInteger selectedAddressIndex;
@property NSInteger selectedReasonIndex;
@property NSInteger selectedPlanIndex;
@property NSDateFormatter *formatter;
@property ZWTTextboxToolbarHandler *handler;

@property int   unitLimit;
@property int   minEmergencyDateGap;
@property int   minMaintenanceGap;
@end

@implementation RequestNewScheduleViewController

@synthesize scrlvbg, vwAddress,vwUnit,vwBelowUnit,vwReason,vwNotes,txtvNotes,txtContact,tblvReason,tblvUnit,tblvAddress,btnFirstHalf,btnSecondHalf,lblDate,selectedAddressIndex,selectedReasonId,arrSelectedIndexPaths,addressId,selectedClientID,selectedTimeSlot,tblvPlan,vwPlan,minEmergencyDateGap,minMaintenanceGap,selectedReasonIndex;

@synthesize arrAddress,arrSelectedUnit,arrReasons,arrUnit,selectedPlanIndex,arrPlan,planId,vwDateTime,formatter,unitLimit,btnDate,purposeDictionary,alertMsg;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

#pragma mark - Helper Method
-(void)prepareView
{
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwBelowUnit.y+vwBelowUnit.height)];
    
    arrSelectedIndexPaths = nil;
    arrSelectedUnit       = nil;
    
    tblvUnit.alwaysBounceVertical       = NO;
    tblvReason.alwaysBounceVertical     = NO;
    tblvAddress.alwaysBounceVertical    = NO;
    
    arrSelectedIndexPaths = [[NSMutableArray alloc]init];
    arrSelectedUnit       = [[NSMutableArray alloc]init];
    
    selectedReasonId    = 0;
    selectedPlanIndex   = 0;
    btnDate.enabled     = NO;
    
    [self btnTimingsTap:btnFirstHalf];
    
    formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    
    arrReasons      = [[NSMutableArray alloc]init];
    arrUnit         = [[NSMutableArray alloc]init];
    arrAddress      = [[NSMutableArray alloc]init];
    arrPlan         = [[NSMutableArray alloc]init];
    
    [self showNoDataview];
}

-(void)showNoDataview
{
    tblvAddress.backgroundView = [ACEUtil viewNoDataWithMessage:ACEBlankClientName andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
    
    tblvPlan.backgroundView = [ACEUtil viewNoDataWithMessage:ACESelectAddress andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPlan.height];
    
    tblvUnit.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoPlanSelected andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnit.height];
    
    tblvReason.backgroundView = [ACEUtil viewNoDataWithMessage:ACEBlankClientName andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvReason.height];
    
    _handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:[NSMutableArray arrayWithObjects:(txtvNotes), nil] andScroll:scrlvbg];
    _handler.showNextPrevious = NO;
    _handler.delegate         = self;

}

-(void)openSearchUserViewController
{
    SearchUserViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SearchUserViewController"];
    vc.delegate         = self;
    vc.isWorkAreaClient = NO;
    
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)setFrames
{
    tblvReason.height  = tblvReason.contentSize.height;
    vwReason.height    = tblvReason.y + tblvReason.height+10;
    vwDateTime.y       = vwReason.y +vwReason.height;
    vwNotes.y          = vwDateTime.y + vwDateTime.height;
    vwBelowUnit.y      = vwUnit.y + vwUnit.height;
    vwBelowUnit.height = vwReason.height + vwNotes.height + vwDateTime.height;
    
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwBelowUnit.y+vwBelowUnit.height + 10)];
    
    _handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:[NSMutableArray arrayWithObjects:(txtvNotes), nil] andScroll:scrlvbg];
    _handler.showNextPrevious = NO;
    _handler.delegate = self;
}

-(void)setframeForAddressUnit
{
    if (arrAddress.count == 0)
    {
        tblvAddress.height = 120;
        tblvAddress.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoAddressFound andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
        vwAddress.height = tblvAddress.y + tblvAddress.height - 10;
        arrUnit = nil;
        [tblvUnit reloadData];
    }
    else
    {
        tblvAddress.height = tblvAddress.contentSize.height;
        vwAddress.height   = tblvAddress.y + tblvAddress.height + 10;
    }
    
    if(arrPlan.count == 0)
    {
        tblvPlan.height = 120;
        
        tblvPlan.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoPlanFound andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPlan.height];
        
        vwPlan.frame        = CGRectMake(vwPlan.x, vwAddress.y + vwAddress.height, vwPlan.width, tblvPlan.y + tblvPlan.height);
        
    }
    else
    {
        tblvPlan.height     = tblvPlan.contentSize.height;
        vwPlan.frame        = CGRectMake(vwPlan.x, vwAddress.y + vwAddress.height, vwPlan.width, tblvPlan.y + tblvPlan.height);
    }

    if (arrUnit.count == 0)
    {
        tblvUnit.height = 120;
        tblvUnit.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitsFound andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnit.height];
        vwUnit.frame = CGRectMake(vwUnit.x, vwPlan.y + vwPlan.height, vwUnit.width, tblvUnit.y + tblvUnit.height);
        
    }
    else
    {
        tblvUnit.height    = tblvUnit.contentSize.height;
        vwUnit.frame       = CGRectMake (vwUnit.x, vwPlan.y + vwPlan.height, vwUnit.width, tblvUnit.y + tblvUnit.height + 10);
    }
    vwReason.y      = vwReason.y;
    vwDateTime.y    = vwReason.y +vwReason.height;
    vwNotes.y       = vwDateTime.y + vwDateTime.height;
    vwBelowUnit.y   = vwUnit.y + vwUnit.height;
    vwBelowUnit.height = vwReason.height + vwNotes.height + vwDateTime.height;
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwBelowUnit.y + vwBelowUnit.height + 10)];
    
    _handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:[NSMutableArray arrayWithObjects:(txtvNotes), nil] andScroll:scrlvbg];
    _handler.showNextPrevious = NO;
    _handler.delegate         = self;
}

-(NSMutableArray *)getValidAddresses:(NSMutableArray *)addressList
{
    NSMutableArray *arrAddressList = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < addressList.count; i++)
    {
        ACEAddress *address = addressList[i];
        
        if (address.isShowAddress)
        {
            [arrAddressList addObject:address];
        }
    }
    
    return arrAddressList;
}
-(BOOL)isValidateData
{
    if (selectedClientID == nil)
    {
        [self showAlertWithMessage:ACEBlankClientName];
        return NO;
    }
    else if (addressId == nil)
    {
        [self showAlertWithMessage:ACESelectAddress];
        return NO;
    }
    else if (arrSelectedUnit.count == 0)
    {
        [self showAlertWithMessage:ACENoUnitsSelected];
        return NO;
    }
    
    txtvNotes.text = [self trimmWhiteSpaceFrom:txtvNotes.text];
    
    if ([txtvNotes.text isEqualToString:@""])
    {
        txtvNotes.layer.borderColor = [UIColor redColor].CGColor;
        txtvNotes.layer.borderWidth = 1.0;
        [self showErrorMessage:ACEBlankNotes belowView:txtvNotes];
        [txtvNotes becomeFirstResponder];
        return NO;
    }
    if(selectedReasonId == 0||selectedReasonId == 2||selectedReasonId == 3) //Repair, Maintenance & Continuing prev. work are not allowd to request on saturday and sunday
    {
        NSInteger weekday = [self getWeekdayOfselectedDate];
        
        if(weekday == 1 || weekday == 7) // sunday or saturday
        {
            [self showAlertWithMessage:ACEInvalidSelectedDate];
            return NO;
        }
    }
    return YES;
}
-(NSInteger)getWeekdayOfselectedDate
{
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSDate *date = [formatter dateFromString:lblDate.text];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    
     NSInteger weekday = [weekdayComponents weekday];
    
    return weekday;
}
-(void)setDateAccordingToReason
{
    if (selectedReasonId == 2||selectedReasonId == 0) // For Repair , Continuing Previous Work
    {
        lblDate.text = [formatter stringFromDate:[ACEUtil getDefaultDateWithoutWeekends:minEmergencyDateGap]];
    }
    else if (selectedReasonId == 1) // For emergency
    {
        lblDate.text = [formatter stringFromDate:[NSDate date]];
    }
    else // for maintenace service
    {
        lblDate.text = [formatter stringFromDate:[ACEUtil getDefaultDateWithoutWeekends:minMaintenanceGap]];
    }
    lblDate.textColor = [UIColor blackColor];
    
    [self setButtonTitles];
}
-(void)setButtonTitles
{
    NSInteger weekDay = [self getWeekdayOfselectedDate];
    
    if(selectedReasonId == 1 && weekDay > 1 && weekDay < 7) //emergency and working day so display different time 8 to 12 && 12 to 6
    {
        [btnFirstHalf setTitle:purposeDictionary[GTimeEmergencySlot1] forState:UIControlStateNormal];
        [btnSecondHalf setTitle:purposeDictionary[GTimeEmergencySloat2] forState:UIControlStateNormal];
    }
    else
    {
        [btnFirstHalf setTitle:purposeDictionary[GTimeSlot1] forState:UIControlStateNormal];
        [btnSecondHalf setTitle:purposeDictionary[GTimeSlot2] forState:UIControlStateNormal];
    }

}

-(void)prepareDateAndTimeAccordingToPurpose:(NSDictionary *)purposeInfo
{
    purposeDictionary = purposeInfo;
    
    [btnFirstHalf setTitle:purposeInfo[GTimeSlot1] forState:UIControlStateNormal];
    [btnSecondHalf setTitle:purposeInfo[GTimeSlot2] forState:UIControlStateNormal];
    arrReasons          = purposeInfo[GPurpose];
    selectedTimeSlot    = purposeInfo[GTimeSlot1];
    unitLimit           = [purposeInfo[GKeyUnitLimit] intValue];
    minMaintenanceGap   = [purposeInfo[GKeyMaintenanceDays]intValue];
    minEmergencyDateGap = [purposeInfo[GKeyEmergencyDays]intValue];
    [tblvReason reloadData];
    btnDate.enabled     = YES;
}
#pragma mark - WebService Methods
-(void)getPurposeAndTime
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               GPlanTypeId : planId,
                               UKeyEmployeeID :ACEGlobalObject.user.userID
                               };
        
        [ACEWebServiceAPI getScheduletimeByServiceId:dict completionHandler:^(ACEAPIResponse *response, NSDictionary *purposeInfo)
        {
        
             if (response.code == RCodeSuccess)
             {
                 [self prepareDateAndTimeAccordingToPurpose:purposeInfo];
                 [self setFrames];
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
             [SVProgressHUD dismiss];
         }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

-(void)sendScheduleRequest
{
    if ([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        NSString *reasonId = [NSString stringWithFormat:@"%ld",(long)selectedReasonId];
        
        NSDictionary *dict = @{
                               UKeyEmployeeID   : ACEGlobalObject.user.userID,
                               CKeyID           : selectedClientID,
                               SCHKeyAddressId  : addressId,
                               SCHKeyTimeSlot   : btnFirstHalf.selected?btnFirstHalf.titleLabel.text : btnSecondHalf.titleLabel.text,
                               SCHKeyPurpose    : reasonId,
                               SCHKeyUnitsId    : arrSelectedUnit,
                               ACKeyServiceDate : lblDate.text,
                               ACKeyNotes       : txtvNotes.text
                              };
        
         [ACEWebServiceAPI sendScheduleRequest:dict completionHandler:^(ACEAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                [self.navigationController popViewControllerAnimated:YES];
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
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

-(void)getAddressListFromClient:(NSString *)clientID
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACEWebServiceAPI getAddressListForClient:clientID completionHandler:^(ACEAPIResponse *response, NSMutableArray *addressArray)
         {
             if (response.code == RCodeSuccess)
             {
                 tblvAddress.backgroundView = nil;
                 //arrAddress = addressArray;
                 arrAddress = [self getValidAddresses:addressArray].mutableCopy;
                 [tblvAddress reloadData];
             }
             else if(response.code == RCodeNoData)
             {
                 arrAddress = nil;
                 [tblvAddress reloadData];
                 [tblvPlan    reloadData];
                 [tblvUnit    reloadData];
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
                 arrAddress = nil;
                 tblvAddress.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
                 [tblvAddress reloadData];
                 [tblvPlan    reloadData];
             }
             else
             {
                 arrAddress = nil;
                 tblvAddress.backgroundView = [ACEUtil viewNoDataWithMessage:ACEUnknownError andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
                 [tblvAddress reloadData];
                 [tblvPlan    reloadData];
             }
             [self setframeForAddressUnit];
             [SVProgressHUD dismiss];
         }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)getPlanType
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               SCHKeyAddressId : addressId
                               };
        [ACEWebServiceAPI getPlanTypes:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *arrPlanTypes)
         {
             if(response.code == RCodeSuccess)
             {
                 arrPlan = arrPlanTypes;
                 tblvPlan.backgroundView = nil;
                 [tblvPlan reloadData];
             }
             else if(response.code == RCodeNoData)
             {
                 arrPlan = nil;
                 arrUnit = nil;
                 [tblvPlan reloadData];
                 [tblvUnit reloadData];
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
                 arrPlan = nil;
                 tblvPlan.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPlan.height];
                 
                 [tblvPlan reloadData];
             }
             else
             {
                 arrPlan = nil;
                 tblvPlan.backgroundView = [ACEUtil viewNoDataWithMessage:ACEUnknownError andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPlan.height];
                 
                 [tblvPlan reloadData];
             }
             
             [self setframeForAddressUnit];
             [SVProgressHUD dismiss];
             
         }];
        
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
    
}

-(void)getUnitList
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        
        NSDictionary *dict = @{
                               CKeyID : selectedClientID,
                               SCHKeyAddressId : addressId,
                               GPlanTypeId : planId,
                               UKeyEmployeeID: ACEGlobalObject.user.userID
                               };
        
        [ACEWebServiceAPI getUnitListFromClientAndPlanType:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *unitsArray)
        {
        
             if (response.code == RCodeSuccess)
             {
                 tblvUnit.backgroundView = nil;
                 arrUnit = unitsArray;
                 [tblvUnit reloadData];
                 [self getPurposeAndTime];
             }
             else if (response.code == RCodeNoData)
             {
                 arrUnit = nil;
                 [tblvUnit reloadData];
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
                 arrUnit = nil;
                 tblvUnit.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnit.height];
                 [tblvUnit reloadData];
             }
             else
             {
                 
                 arrUnit = nil;
                 tblvUnit.backgroundView = [ACEUtil viewNoDataWithMessage:ACEUnknownError andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnit.height];
                 [tblvUnit reloadData];

             }
             
             [self setframeForAddressUnit];
             
             [SVProgressHUD dismiss];
         }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

#pragma mark - Event Method
- (IBAction)btnTimingsTap:(UIButton *)btn
{
    int selectedUnit = (int)arrSelectedUnit.count;
    if(btn == btnFirstHalf)
    {
        btnFirstHalf.selected = YES;
        btnSecondHalf.selected = NO;
        selectedTimeSlot = btnFirstHalf.titleLabel.text;
    }
    else if(btn == btnSecondHalf)
    {
        if(selectedUnit > unitLimit)
        {
            [self showAlertWithMessage:ACERequestUnitLimit];
            [self btnTimingsTap:btnFirstHalf];
        }
        else
        {
            btnSecondHalf.selected = YES;
            btnFirstHalf.selected  = NO;
            selectedTimeSlot = btnSecondHalf.titleLabel.text;
        }
    }
}
- (IBAction)btnCalenderTap:(id)sender
{
    SelectDatePopupViewController *svc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectDatePopupViewController"];
    
    svc.delegate        = self          ;
    svc.selectedDate    = lblDate.text  ;
    svc.isMinimum       = YES           ;
    svc.isFromScheduleNRequest = YES    ;
    if(selectedReasonId == 0 || selectedReasonId == 2)
    {
        svc.minimumDateGap  = minEmergencyDateGap ;
    }
    else if (selectedReasonId == 1)
    {
        svc.minimumDateGap = 0;
    }
    else
    {
        svc.minimumDateGap  = minMaintenanceGap ;
    }
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [svc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:svc animated:NO completion:nil];
}

- (IBAction)btnBackTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSubmitTap:(UIButton *)sender
{
    if ([self isValidateData])
    {
        if(selectedReasonId == 1)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:appName message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *agree = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                 [self sendScheduleRequest];
            }];
            UIAlertAction *donotAgree = [UIAlertAction actionWithTitle:@"Do not agree" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:donotAgree];
             [alert addAction:agree];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [ACEUtil showAlertFromControllerWithDoubleAction:self withMessage:alertMsg andHandler:^(UIAlertAction * _Nullable action)
             {
                [self sendScheduleRequest];
                 
             }andNoHandler:^(UIAlertAction * _Nullable action) {
                
             }];
        }
    }
}

#pragma mark - UITextField  & UITextView Delegate Method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == txtContact)
    {
        [self openSearchUserViewController];
        return NO;
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    txtvNotes.layer.borderColor = [UIColor separatorColor].CGColor;
    [self removeErrorMessageBelowView:txtvNotes];
    return YES;
}

-(void)doneTap
{
    
}

#pragma mark - SearchUser Delegate Method
-(void)selectedUser:(ACEClient *)user
{
    txtContact.text        = user.Name;
    selectedClientID       = [NSString stringWithFormat:@"%@",user.ID];
    arrSelectedIndexPaths  = [[NSMutableArray alloc]init];
    arrSelectedUnit        = [[NSMutableArray alloc]init];
    arrPlan                = [[NSMutableArray alloc]init];
    arrUnit                = [[NSMutableArray alloc]init];
    addressId              = nil;
    selectedPlanIndex      = 0;
    planId                 = nil;
    [self getAddressListFromClient:selectedClientID];
}

#pragma mark - SelectDatePopupViewControllerdelegate method
-(void)selectedDate:(NSDate *)date
{
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    
    lblDate.text        = [formatter stringFromDate:date];
    
    [self setButtonTitles];
}

#pragma mark - UITableview Delegate & DataSource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1) //tblv address
    {
        return arrAddress.count;
    }
    else if (tableView.tag == 2) //tblv unit
    {
        return arrUnit.count;
    }
    else if (tableView.tag == 3) //tblv reason
    {
        return arrReasons.count;
    }
    else if (tableView.tag == 4) //tblv plan
    {
        return arrPlan.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACESelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(tableView.tag == 1)// address
    {
        ACEAddress *address = arrAddress[indexPath.row];
        cell.lblName.text = address.fullAddress;
        
        if (address.isDefaultAddress)
        {
            selectedAddressIndex = indexPath.row;
            addressId            = address.addressId;
           
            [self getPlanType];
            //[self getUnitList:addressId];
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
        }
        else
        {
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
        }
    }
    else if (tableView.tag == 2) //unit
    {
        //ACEACUnit *unit     = arrUnit[indexPath.row];
        NSDictionary *dict  = arrUnit[indexPath.row];
        cell.lblName.text   = dict[ACKeyNameOfUnit];
        cell.imgvTick.image = [UIImage imageNamed:@"worknotdone"];
    }
    else if (tableView.tag == 3) //reason
    {
        NSDictionary *dict = arrReasons[indexPath.row];
        NSInteger     rId  = [dict[GKeyId]integerValue];
        cell.lblName.text  = dict[GKeyName];
        
        if (rId == selectedReasonId)
        {
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
            selectedReasonId    = [dict[GKeyId]integerValue];
            [self setDateAccordingToReason];
            selectedReasonIndex = indexPath.row;
            alertMsg            = dict[GKeyMessage];
        }
        else
        {
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
        }
    }
    else if (tableView.tag == 4) //plan
    {
        NSDictionary *dict = arrPlan[indexPath.row];
        cell.lblName.text = dict[PKeyName];
        if(indexPath.row == selectedPlanIndex)
        {
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
            planId = dict[ADKeyAddressId];
            [self getUnitList];
           // [self getPurposeAndTime];
        }
        else
        {
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
        }
        
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *indexPathForFirstRow;
    ACESelectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(tableView.tag == 1) //address
    {
        if (selectedAddressIndex != indexPath.row)
        {
            indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedAddressIndex inSection:0];
            cell = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        cell  = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        addressId                 = [arrAddress[indexPath.row] addressId];
        cell.imgvTick.image       = [UIImage imageNamed:@"radiobutton-selected"];
        arrSelectedIndexPaths     = [[NSMutableArray alloc]init];
        arrSelectedUnit           = [[NSMutableArray alloc]init];
        selectedPlanIndex         = 0;
        [self getPlanType];
    }
    else if(tableView.tag == 2) //unit
    {
        cell = (ACESelectionCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        //ACEACUnit *unit = arrUnit[indexPath.row];
         NSDictionary *dict   = arrUnit[indexPath.row];
        if (![arrSelectedIndexPaths containsObject:indexPath])
        {
            [arrSelectedUnit addObject:dict[ADKeyAddressId]];
            [arrSelectedIndexPaths addObject:indexPath];
            cell.imgvTick.image = [UIImage imageNamed:@"worknotdone-selected"];
        }
        else
        {
            [arrSelectedUnit removeObject:dict[ADKeyAddressId]];
            [arrSelectedIndexPaths removeObject:indexPath];
            cell.imgvTick.image = [UIImage imageNamed:@"worknotdone"];
        }
        int selectedUnit = (int)arrSelectedUnit.count;
        
        if(selectedUnit > unitLimit && btnSecondHalf.selected)
        {
            [self showAlertWithMessage:ACERequestUnitLimit];
            [self btnTimingsTap:btnFirstHalf];
            
            [btnSecondHalf setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
       else if(selectedUnit > unitLimit && btnFirstHalf.selected)
        {
          [btnSecondHalf setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        else if (selectedUnit <= unitLimit)
        {
           [btnSecondHalf setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    else if (tableView.tag == 3) //reason
    {
        NSDictionary *dict  = arrReasons[indexPath.row];
        NSInteger rid       = [dict[GKeyId]integerValue];
        if (selectedReasonId != rid)
        {
            indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedReasonIndex inSection:0];
            cell = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        cell  = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
        selectedReasonId    = rid;
        alertMsg            = dict[GKeyMessage];
        selectedReasonIndex = indexPath.row;
        [self setDateAccordingToReason];

    }
    else if (tableView.tag == 4) //plan
    {
        if (selectedPlanIndex != indexPath.row)
        {
            indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedPlanIndex inSection:0];
            cell = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
        }
        cell  = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
        selectedPlanIndex = indexPath.row;
        planId     = arrPlan[indexPath.row][ADKeyAddressId];
        arrSelectedIndexPaths     = [[NSMutableArray alloc]init];
        arrSelectedUnit           = [[NSMutableArray alloc]init];
        [self getUnitList];
        
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACESelectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(tableView.tag == 1 || tableView.tag == 3 || tableView.tag == 4)
    {
        cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
    }
   
//    else if (tableView.tag == 3) //reason
//    {
//         [cell.btnSelection setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
//    }
}
/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1)
    {
        NSString *str       = [_arrAddress objectAtIndex:indexPath.row];
        UIFont *font        = [UIFont systemFontOfSize:17.0f];
        CGSize constraint   = CGSizeMake(200 , FLT_MAX);
        CGSize size         = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font }context:nil].size;
        return size.height + 20;
    }
    
    return 50;
}*/
@end
