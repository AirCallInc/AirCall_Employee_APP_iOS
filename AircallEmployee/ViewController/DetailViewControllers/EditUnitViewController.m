//
//  EditUnitViewController.m
//  AircallEmployee
//
//  Created by Manali on 06/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "EditUnitViewController.h"

@interface EditUnitViewController ()<UITextFieldDelegate,ZWTTextboxToolbarHandlerDelegate,UnMatchedPopup,SelectDatePopupViewControllerdelegate,MonthYearPickerViewControllerdelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrlv;
@property (weak, nonatomic) IBOutlet UIView *vwClientInfo;
@property (weak, nonatomic) IBOutlet UIView *vwUnitType;
@property (weak, nonatomic) IBOutlet ACELabel *lblClientName;
@property (weak, nonatomic) IBOutlet ACELabel *lblUnitName;
@property (weak, nonatomic) IBOutlet ACELabel *lblAddress;
@property (weak, nonatomic) IBOutlet ACELabel *lblPlanType;
@property (weak, nonatomic) IBOutlet UIButton *btnPackaged;
@property (weak, nonatomic) IBOutlet UIButton *btnSplit;
@property (weak, nonatomic) IBOutlet UIButton *btnHeating;
@property (weak, nonatomic) IBOutlet UIView *vwModelNSerial;
@property (weak, nonatomic) IBOutlet ACETextField *txtModelNo;
@property (weak, nonatomic) IBOutlet ACETextField *txtSerialNo;
@property (weak, nonatomic) IBOutlet UIView *vwModelNSerialSplit;
@property (strong, nonatomic) IBOutlet ACETextField *txtMfgDate;
@property (strong, nonatomic) IBOutlet UIButton *btnMfgDate;
@property (weak, nonatomic) IBOutlet UIButton *btnEditModel;

@property (weak, nonatomic) IBOutlet ACETextField *txtModelNoSplit;
@property (weak, nonatomic) IBOutlet ACETextField *txtSerialNoSplit;
@property (strong, nonatomic) IBOutlet ACETextField *txtMfgDateSplit;
@property (strong, nonatomic) IBOutlet UIButton *btnMfgDateSplit;
@property (weak, nonatomic) IBOutlet UIButton *btnEditModelSplit;


@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *lblForUnitType;
@property (strong, nonatomic) NSMutableArray *arrunitDetail;
@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;

@property NSDate         *  dateMfg           ;
@property NSDate         *  dateMfgSplit      ;

@property NSMutableArray *  arrTextFields      ;
@property NSString       *  selectedUnitType   ;
@property NSMutableArray *  arrMatchedUnitInfo ;
@property BOOL              isSplitMfg         ;

@end


@implementation EditUnitViewController

@synthesize scrlv,lblClientName,lblUnitName,lblAddress,lblPlanType,vwModelNSerial,txtModelNo,txtSerialNo,vwModelNSerialSplit,txtModelNoSplit,txtSerialNoSplit,vwClientInfo,vwUnitType,btnSubmit,btnPackaged,btnSplit,btnHeating,selectedUnitType,btnMfgDate,btnMfgDateSplit,txtMfgDate,txtMfgDateSplit;

@synthesize arrTextFields,textboxHandler,lblForUnitType,unitDetail,arrMatchedUnitInfo,arrunitDetail,isSplitMfg,dateMfg,dateMfgSplit;

@synthesize btnEditModel,btnEditModelSplit;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    arrTextFields = [[NSMutableArray alloc]initWithArray:@[txtModelNo,txtSerialNo]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextFields andScroll:scrlv];
    
    textboxHandler.delegate = self;
    [self prepareLabels];
    [self setViews];
}
-(void)prepareLabels
{
    lblClientName.text = unitDetail.clientName  ;
    lblUnitName.text   = unitDetail.unitName    ;
    lblAddress.text    = unitDetail.address     ;
    lblPlanType.text   = unitDetail.plan        ;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM, yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    if([unitDetail.unitType isEqualToString:GUnitTypeSplit])
    {
        if(unitDetail.arrModelSerial.count > 0)
        {
            NSDictionary *dict      = unitDetail.arrModelSerial[0];
            
            NSDate       *date      = [formatter dateFromString:dict[ACKeyMfgDate]];
                                       
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
            
            NSInteger year = components.year;
            
            if([dict[ACKeyUnitType] isEqualToString:GUnitTypeHeating])
            {
                txtModelNo.text         = dict[ACKeyMnumber]          ;
                txtSerialNo.text        = dict[ACKeySerialNumber]     ;
                txtMfgDate.text         = dict[ACKeyMfgDate]          ;
                dateMfg                 = [formatter dateFromString:dict[ACKeyMfgDate]];
                
                if(year >= 10)
                {
                    txtMfgDate.textColor = [UIColor redColor];
                }
                else
                {
                    txtMfgDate.textColor = [UIColor blackColor];
                }
            }
            else if ([dict[ACKeyUnitType] isEqualToString:GUnitTypeCooling])
            {
                txtModelNoSplit.text    = dict[ACKeyMnumber]          ;
                txtSerialNoSplit.text   = dict[ACKeySerialNumber]     ;
                txtMfgDateSplit.text    = dict[ACKeyMfgDate]          ;
                dateMfgSplit            = [formatter dateFromString:dict[ACKeyMfgDate]];
                
                if(year >= 10)
                {
                    txtMfgDateSplit.textColor = [UIColor redColor];
                }
                else
                {
                    txtMfgDateSplit.textColor = [UIColor blackColor];
                }
            }
        }
        if(unitDetail.arrModelSerial.count > 1)
        {
            NSDictionary *dict      = unitDetail.arrModelSerial[1];
            
            NSDate *date            = [formatter dateFromString:dict[ACKeyMfgDate]];
            
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
            
            NSInteger year = components.year;
            
            if([dict[ACKeyUnitType] isEqualToString:GUnitTypeHeating])
            {
                txtModelNo.text         = dict[ACKeyMnumber]          ;
                txtSerialNo.text        = dict[ACKeySerialNumber]     ;
                txtMfgDate.text         = dict[ACKeyMfgDate];
                dateMfg                 = [formatter dateFromString:dict[ACKeyMfgDate]];
                if(year >= 10)
                {
                    txtMfgDate.textColor = [UIColor redColor];
                }
                else
                {
                    txtMfgDate.textColor = [UIColor blackColor];
                }
            }
            else if ([dict[ACKeyUnitType] isEqualToString:GUnitTypeCooling])
            {
                txtModelNoSplit.text    = dict[ACKeyMnumber]          ;
                txtSerialNoSplit.text   = dict[ACKeySerialNumber]     ;
                txtMfgDateSplit.text    = dict[ACKeyMfgDate]          ;
                dateMfgSplit            = [formatter dateFromString:dict[ACKeyMfgDate]];
                if(year >= 10)
                {
                    txtMfgDateSplit.textColor = [UIColor redColor];
                }
                else
                {
                    txtMfgDateSplit.textColor = [UIColor blackColor];
                }
            }
        }
    }
    else if([unitDetail.unitType isEqualToString:GUnitTypePackaged] || [unitDetail.unitType isEqualToString:GUnitTypeHeating])
    {
        if(unitDetail.arrModelSerial.count > 0)
        {
            NSDictionary *dict      = unitDetail.arrModelSerial[0]    ;
            
            NSDate       *date      = [formatter dateFromString:dict[ACKeyMfgDate]];
            
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
            
            NSInteger year = components.year;
            
            txtModelNo.text         = dict[ACKeyMnumber]              ;
            txtSerialNo.text        = dict[ACKeySerialNumber]         ;
            txtMfgDate.text         = dict[ACKeyMfgDate]              ;
            dateMfg                 = [formatter dateFromString:dict[ACKeyMfgDate]];
            
            if(year >= 10)
            {
                txtMfgDate.textColor = [UIColor redColor];
            }
            else
            {
                txtMfgDate.textColor = [UIColor blackColor];
            }
        }
    }
    
}
-(void)setViews
{
    if (unitDetail.isMatched)
    {
        //[self setNotEditableView];
        txtModelNo.userInteractionEnabled = false;
        txtModelNoSplit.userInteractionEnabled = false;
    }
    else
    {
        //[self setEditableView];
        btnEditModelSplit.hidden = true;
        btnEditModel.hidden = true;
    }
    
    [self setEditableView];
    [self setViewByUnitType];
}
-(void)setViewByUnitType
{
    if([selectedUnitType isEqualToString:GUnitTypeSplit])
    {
        lblForUnitType.text = @"For Heating";
        [arrTextFields addObjectsFromArray:[NSArray arrayWithObjects:(txtModelNoSplit),(txtSerialNoSplit), nil]];
        vwModelNSerialSplit.hidden = NO;
        [scrlv setContentSize:CGSizeMake(scrlv.width, vwClientInfo.height + vwUnitType.height)];
    }
    else
    {
        lblForUnitType.text = [NSString stringWithFormat:@"For %@",selectedUnitType];
        vwModelNSerialSplit.hidden = YES;
        [arrTextFields removeObjectsInArray:[NSArray arrayWithObjects:(txtModelNoSplit),(txtSerialNoSplit),nil]];
        [scrlv setContentSize:CGSizeMake(scrlv.width, vwClientInfo.height + vwUnitType.height - vwModelNSerialSplit.height)];
    }
    
    [textboxHandler setScroll:scrlv withTextBoxes:arrTextFields];
}
-(void)setNotEditableView
{
    if ([unitDetail.unitType isEqualToString:GUnitTypePackaged])
    {
        [self btnUnitTypeTap:btnPackaged];
    }
    else if ([unitDetail.unitType isEqualToString:GUnitTypeSplit])
    {
        [self btnUnitTypeTap:btnSplit];
    }
    else
    {
        [self btnUnitTypeTap:btnHeating];
    }
    
    btnPackaged.userInteractionEnabled      = NO;
    btnSplit.userInteractionEnabled         = NO;
    btnHeating.userInteractionEnabled       = NO;
    btnMfgDateSplit.userInteractionEnabled  = NO;
    btnMfgDate.userInteractionEnabled       = NO;
    
    [btnSubmit setTitle:@"Next" forState:UIControlStateNormal];
    
    for (int i = 1; i <= 5 ; i++)
    {
        UITextField *tf = (UITextField *)[self.view viewWithTag:i];
        tf.userInteractionEnabled = false;
    }

}
-(void)setEditableView
{
    if ([unitDetail.unitType isEqualToString:GUnitTypePackaged])
    {
        [self btnUnitTypeTap:btnPackaged];
    }
    else if ([unitDetail.unitType isEqualToString:GUnitTypeSplit])
    {
        [self btnUnitTypeTap:btnSplit];
    }
    else if([unitDetail.unitType isEqualToString:GUnitTypeHeating])
    {
        [self btnUnitTypeTap:btnHeating];
    }
    else
    {
        [self btnUnitTypeTap:btnPackaged];
    }
    
    [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
}

#pragma mark - Validation method
-(BOOL)isValidDetail
{
    ZWTValidationResult result;
    
    result = [txtModelNo validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankModelNumber belowView:txtModelNo];
        return NO;
    }
    
//    result = [txtSerialNo validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
//    
//    if (result == ZWTValidationResultBlank)
//    {
//        [self showErrorMessage:ACEBlankSerialNumber belowView:txtSerialNo];
//        return NO;
//    }
    result = [txtMfgDate validate:ZWTValidationTypeBlank showRedRect:YES getFocus:NO];
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankManufactureDate belowView:txtMfgDate];
        return NO;
    }
    if([selectedUnitType isEqualToString:GUnitTypeSplit])
    {
        result = [txtModelNoSplit validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
        
        if (result == ZWTValidationResultBlank)
        {
            [self showErrorMessage:ACEBlankModelNumber belowView:txtModelNoSplit];
            return NO;
        }
        
//        result = [txtSerialNoSplit validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
//        
//        if (result == ZWTValidationResultBlank)
//        {
//            [self showErrorMessage:ACEBlankSerialNumber belowView:txtSerialNoSplit];
//            return NO;
//        }
        result = [txtMfgDateSplit validate:ZWTValidationTypeBlank showRedRect:YES getFocus:NO];
        if (result == ZWTValidationResultBlank)
        {
            [self showErrorMessage:ACEBlankManufactureDate belowView:txtMfgDateSplit];
            return NO;
        }
        
        if([txtModelNo.text isEqualToString:txtModelNoSplit.text] && [txtSerialNo.text isEqualToString:txtSerialNoSplit.text])
        {
            [self showAlertWithMessage:ACESameModelNumber];
            return NO;

        }
//        if([txtSerialNo.text isEqualToString:txtSerialNoSplit.text])
//        {
//            [self showErrorMessage:ACESameSerialNumber belowView:txtSerialNoSplit];
//            return NO;
//            
//        }
    }
    return YES;
}
-(void)openDetailViewController:(int)isMatch andShouldCallWebService:(BOOL)ans
{
    AddUnitACHeatingViewController *auavc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddUnitACHeatingViewController"];
    //auavc.unitStatus   = unitStatus;
    auavc.isMatched             = isMatch     ;
    auavc.shouldCallWebservice  =   ans       ;
    
    auavc.unitId         = unitDetail.unitId  ;
    auavc.unitType       = selectedUnitType   ;
    auavc.arrModelSerial = arrunitDetail      ;
    auavc.headingTitle   = ACEEditUnitTitle   ;
    auavc.arrUnitInfo    = arrMatchedUnitInfo ;
    
    [self.navigationController pushViewController:auavc animated:YES];
}
-(void)openPopupViewController
{
    UnitUnMatchedPopupViewController *unMatchedPopup  = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"UnitUnMatchedPopupViewController"];
    
    ACEGlobalObject.navigationController = [[UINavigationController alloc] initWithRootViewController:unMatchedPopup];
    ACEGlobalObject.navigationController.navigationBar.hidden = YES;
    
    ACEGlobalObject.navigationController.providesPresentationContextTransitionStyle = YES;
    ACEGlobalObject.navigationController.definesPresentationContext = YES;
    [ACEGlobalObject.navigationController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    unMatchedPopup.delegate = self;
    
    [self presentViewController:ACEGlobalObject.navigationController animated:NO completion:nil];

}
-(void)openDatePopupViewController
{
    NSDate *selectedDate;
    
    if(isSplitMfg)
        selectedDate = dateMfgSplit;
    else
        selectedDate = dateMfg;

    MonthYearPickerViewController *controller = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"MonthYearPickerViewController"];
    
    controller.delegate = self;
    controller.showDate = selectedDate;
    
    ACEGlobalObject.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    ACEGlobalObject.navigationController.navigationBar.hidden = YES;
    ACEGlobalObject.navigationController.providesPresentationContextTransitionStyle = YES;
    ACEGlobalObject.navigationController.definesPresentationContext = YES;
    [ACEGlobalObject.navigationController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:ACEGlobalObject.navigationController animated:NO completion:nil];
 
}
#pragma mark - ZWTTextboxToolbarHandler Delegate Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
    return YES;
}

-(void)doneTap
{
    //[self setViewByUnitType];
}

#pragma mark - Event Methods
- (IBAction)btnSubmitTap:(id)sender
{
//    if(unitDetail.isMatched)
//    {
//        [self openDetailViewController:unitDetail.isMatched andShouldCallWebService:YES];
//    }
//    else
//    {
        if([self isValidDetail])
        {
            [self callWebserviceToSendUnitData];
        }
    //}
}

- (IBAction)btnUnitTypeTap:(UIButton *)sender
{
    if (sender == btnPackaged)
    {
        selectedUnitType     = GUnitTypePackaged;
        btnPackaged.selected = YES          ;
        btnSplit.selected    = NO           ;
        btnHeating.selected  = NO           ;
    }
    else if (sender == btnSplit)
    {
        selectedUnitType     = GUnitTypeSplit;
        btnPackaged.selected = NO            ;
        btnSplit.selected    = YES           ;
        btnHeating.selected  = NO            ;
    }
    else if (sender == btnHeating)
    {
        selectedUnitType     = GUnitTypeHeating;
        btnPackaged.selected = NO              ;
        btnSplit.selected    = NO              ;
        btnHeating.selected  = YES             ;
    }

    [self setViewByUnitType];
}


- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnMfgDateTap:(UIButton *)sender
{
    //[self.view endEditing:YES];
    
    if(sender == btnMfgDate)
    {
        isSplitMfg = NO;
        [self removeErrorMessageBelowView:txtMfgDate];
        txtMfgDate.layer.borderColor = [UIColor separatorColor].CGColor;
    }
    else if (sender == btnMfgDateSplit)
    {
        isSplitMfg = YES;
        [self removeErrorMessageBelowView:txtMfgDateSplit];
        txtMfgDateSplit.layer.borderColor = [UIColor separatorColor].CGColor;
    }
    
    [self openDatePopupViewController];
}

- (IBAction)btnEditModelTap:(UIButton *)sender
{
    txtModelNo.userInteractionEnabled = true;
    [txtModelNo becomeFirstResponder];
}

- (IBAction)btnEditModelSplitTap:(UIButton *)sender
{
    txtModelNoSplit.userInteractionEnabled = true;
    [txtModelNoSplit becomeFirstResponder];
}

#pragma mark - Webservice Method
-(void)callWebserviceToSendUnitData
{
    if([ACEUtil reachable])
    {
        [self sendUnitData];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)sendUnitData
{
    [SVProgressHUD show];
    
    arrunitDetail = [[NSMutableArray alloc]init];
    
    if([selectedUnitType isEqualToString:GUnitTypeSplit])
    {
        NSDictionary *dict = @{
                               ACKeyTypeOfUnit      : GUnitTypeHeating,
                               ACKeyMnumber         : txtModelNo.text,
                               ACKeySerialNumber    : txtSerialNo.text,
                               ACKeyMdate           : [NSString stringWithFormat:@"%@",dateMfg]
                               };
        NSDictionary *dict1 = @{
                               ACKeyTypeOfUnit      : GUnitTypeCooling,
                               ACKeyMnumber         : txtModelNoSplit.text,
                               ACKeySerialNumber    : txtSerialNoSplit.text,
                               ACKeyMdate           : [NSString stringWithFormat:@"%@",dateMfgSplit]
                               };
        
        [arrunitDetail addObject:dict];
        [arrunitDetail addObject:dict1];
    }
    else
    {
        NSDictionary *dict = @{
                               ACKeyTypeOfUnit      : selectedUnitType,
                               ACKeyMnumber         : txtModelNo.text,
                               ACKeySerialNumber    : txtSerialNo.text,
                               ACKeyMdate           : [NSString stringWithFormat:@"%@",dateMfg]
                               };
        
        [arrunitDetail addObject:dict];
    }
    
    NSDictionary *parameterDict = @{
                                    PKeyParts : arrunitDetail,
                                    UKeyEmployeeID : ACEGlobalObject.user.userID,
                                    ACKeyID        : unitDetail.unitId
                                   };
    
    [ACEWebServiceAPI checkUnitMatchDetails:parameterDict completionHandler:^(ACEAPIResponse *response,NSMutableArray *arrunit)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
            arrMatchedUnitInfo = arrunit;
            // Fully match Found - tag 1
            [self openDetailViewController:1 andShouldCallWebService:NO];
        }
        else if (response.code == RCodeUnitPartialMatch)
        {
            arrMatchedUnitInfo = arrunit;
            // partial match found - tag 2 (for split type of unit)
            [self openDetailViewController:2 andShouldCallWebService:NO];
        }
        else if(response.code == RCodeNoData)
        {
            // match not found - tag 3
            [self openPopupViewController];
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
            //[self showAlertWithMessage:response.error.localizedDescription];
            [self showAlertWithMessage:ACEUnknownError];
        }
    }];
}

#pragma mark - UnMatched Popup Delegate
-(void)openAddUnitACHeating:(int)isMatched
{
    AddUnitACHeatingViewController *auahvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddUnitACHeatingViewController"];
    
    auahvc.isMatched      =  isMatched          ;
    auahvc.headingTitle   = ACEEditUnitTitle    ;
    auahvc.unitType       = selectedUnitType    ;
    auahvc.unitId         = unitDetail.unitId   ;
    auahvc.arrModelSerial = arrunitDetail       ;
    auahvc.shouldCallWebservice = NO            ;
    
    [self.navigationController pushViewController:auahvc animated:YES];
}

#pragma mark - SelectDatePopupViewControllerdelegate Method
-(void)selectedDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    
    if(isSplitMfg)
    {
        dateMfgSplit           = date;
        txtMfgDateSplit.text   = [formatter stringFromDate:date];
    }
    else
    {
        dateMfg             =   date;
        txtMfgDate.text     =  [formatter stringFromDate:date];
    }

}
#pragma mark - MonthYearPickerViewControllerdelegate Method
-(void)selectedDateFromMonthPicker:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM, yyyy"];
    
    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
    NSInteger year = components.year;
    
    if(isSplitMfg)
    {
        dateMfgSplit           = date;
        txtMfgDateSplit.text   = [formatter stringFromDate:date];
        
        if(year >= 10)
            txtMfgDateSplit.textColor = [UIColor redColor];
        else
            txtMfgDateSplit.textColor = [UIColor blackColor];
    }
    else
    {
        dateMfg             =   date;
        txtMfgDate.text     =  [formatter stringFromDate:date];
        
        if(year >= 10)
            txtMfgDate.textColor = [UIColor redColor];
        else
            txtMfgDate.textColor = [UIColor blackColor];
    }
    
    /* if(year >= 10)
     {
         selectedTextField.textColor = [UIColor redColor];
     }
     else
     {
         selectedTextField.textColor = [UIColor blackColor];
     }*/

}
/* SelectDatePopupViewController *datePopup = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectDatePopupViewController"];
 datePopup.isMinimumDate     = NO    ;
 datePopup.isMaximumDate     = YES   ;
 datePopup.delegate          = self  ;
 
 
 self.providesPresentationContextTransitionStyle = YES;
 self.definesPresentationContext = YES;
 
 [datePopup setModalPresentationStyle:UIModalPresentationOverFullScreen];
 
 [self setModalPresentationStyle:UIModalPresentationCurrentContext];
 [self presentViewController:datePopup animated:NO completion:nil];*/
@end
