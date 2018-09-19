//
//  SPAddunitViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 12/01/17.
//  Copyright © 2017 com.zwt. All rights reserved.
//

#import "SPAddunitViewController.h"

@interface SPAddunitViewController ()<ZWTTextboxToolbarHandlerDelegate,MonthYearPickerViewControllerdelegate,SelectedUser,UnMatchedPopup>

@property (weak, nonatomic) IBOutlet UILabel        *lblHeading         ;
@property (weak, nonatomic) IBOutlet UILabel        *lblUnitSizeTitle   ;

@property (weak, nonatomic) IBOutlet UITextField    *txtfClientName     ;
@property (weak, nonatomic) IBOutlet UITextField    *txtfNameOfUnit     ;
@property (weak, nonatomic) IBOutlet UIView         *vwAddress          ;
@property (weak, nonatomic) IBOutlet UITableView    *tblvAddress        ;
@property (weak, nonatomic) IBOutlet UIView         *vwClientDetail     ;

@property (weak, nonatomic) IBOutlet ACETextField   *txtModelNo         ;
@property (weak, nonatomic) IBOutlet ACETextField   *txtSerialNo        ;
@property (weak, nonatomic) IBOutlet ACETextField   *txtUnitTon         ;

@property (weak, nonatomic) IBOutlet ACETextField   *txtSplitModelNo    ;
@property (weak, nonatomic) IBOutlet ACETextField   *txtSplitSerialNo   ;
@property (weak, nonatomic) IBOutlet ACETextField   *txtSplitUnitTon    ;
@property (weak, nonatomic) IBOutlet ACETextField   *txtQty             ;

@property (weak, nonatomic) IBOutlet UIView *vwTypeOfPlan               ;
@property (weak, nonatomic) IBOutlet UITableView *tblvPlans             ;

@property (weak, nonatomic) IBOutlet UIButton *btnPackaged              ;
@property (weak, nonatomic) IBOutlet UIButton *btnSplit                 ;
@property (weak, nonatomic) IBOutlet UIButton *btnHeating               ;
@property (weak, nonatomic) IBOutlet UIButton *btnClientSearch          ;

@property (weak, nonatomic) IBOutlet UIView *vwBelowTypeOfPlan          ;
@property (weak, nonatomic) IBOutlet UIView *vwModelNSerial             ;
@property (weak, nonatomic) IBOutlet UIView *vwModelNSerialSplit        ;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit                ;
@property (weak, nonatomic) IBOutlet UILabel *lblForHeating             ;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlvbg              ;

@property (weak, nonatomic) IBOutlet UILabel *lblSpecialOffer   ;
@property (weak, nonatomic) IBOutlet UILabel *lblPerMnthPrice   ;
@property (weak, nonatomic) IBOutlet UILabel *lblForAllMnths    ;

@property (weak, nonatomic) IBOutlet UIView   *vwPlanPrice        ;
@property (weak, nonatomic) IBOutlet UIView   *vwPlanDetail       ;
@property (weak, nonatomic) IBOutlet UIView   *vwPlanInfo         ;
@property (weak, nonatomic) IBOutlet UIView   *vwSpOffer          ;

@property (weak, nonatomic) IBOutlet UILabel  *lblForMnthPrice    ;

@property (weak, nonatomic) IBOutlet UIButton *btnAutoRenew;
@property (weak, nonatomic) IBOutlet UIButton *btnSpecialOffer;

@property (weak, nonatomic) IBOutlet ACETextField *txtManufactureDate ;
@property (weak, nonatomic) IBOutlet ACETextField *txtSplitManufactureDate;

@property NSMutableArray *arrAddress    ;
@property NSMutableArray *arrPlanTypes  ;
@property NSString       *unitType      ;
@property NSString       *unitTypeId    ;
@property NSString       *planId        ;

@property ACESelectionCell         *cell            ;
@property ZWTTextboxToolbarHandler *textboxHandler  ;

@property NSInteger selectedAddressIndex        ;
@property NSInteger selectedPlanIndex           ;

@property BOOL isSpecialOffer                   ;

@property NSMutableArray *arrtextBoxes          ;
@property NSMutableArray *arrUnitDetail         ;
@property NSMutableArray *arrUnitInfo           ;

@property UITextField *selectedTextField        ;
@property NSMutableDictionary *dictClientInfo   ;
@property float perMnth;
@property float discountPrice;
@property float specialPrice;


@end

@implementation SPAddunitViewController

@synthesize txtfClientName,txtfNameOfUnit,vwAddress,tblvAddress,vwTypeOfPlan,vwClientDetail,vwBelowTypeOfPlan,vwModelNSerial,btnSubmit,lblForHeating,scrlvbg,vwModelNSerialSplit,unitType,lblHeading,btnPackaged,btnSplit,btnHeating,tblvPlans,arrtextBoxes,textboxHandler,txtModelNo,txtSerialNo,txtSplitModelNo,txtSplitSerialNo,selectedClientId,arrUnitDetail,arrUnitInfo,txtManufactureDate,txtSplitManufactureDate,selectedTextField,btnClientSearch,txtUnitTon,txtSplitUnitTon,txtQty;

@synthesize lblSpecialOffer,lblPerMnthPrice,lblForAllMnths,vwPlanPrice,vwPlanDetail,vwPlanInfo,vwSpOffer,lblForMnthPrice,btnAutoRenew,btnSpecialOffer,isSpecialOffer,lblUnitSizeTitle;

@synthesize arrAddress,arrPlanTypes,unitTypeId,cell,selectedAddressIndex,selectedPlanIndex,planId,addressId,dictClientInfo,isAddAnother,clientName,perMnth,discountPrice,specialPrice;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(isAddAnother)
    {
        [self prepareviewForAddAnotherUnit];
    }
    else
    {
        [self prepareView];
    }
}

#pragma mark - Helper Method
-(BOOL)isDetailValid
{
    ZWTValidationResult result;
    
    result = [txtfClientName validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankClientName belowView:txtfClientName];
        [scrlvbg setContentOffset:CGPointMake(0, 0)];
        return NO;
    }
    if ([addressId isEqualToString:@""])
    {
        [self showAlertWithMessage:ACESelectAddress];
        return NO;
    }
    if(planId == nil)
    {
        [self showAlertWithMessage:ACENoPlanSelected];
        return NO;
    }
    int qty = [txtQty.text intValue];
    
    if(qty <= 0)
    {
        [self showAlertWithMessage:ACEInvalidQty];
        return NO;
    }
    /*if(qty > 50)
    {
        
    }*/
    
    return YES;
}
-(void)prepareView
{
    [self getPlanTypes]   ;
    [tblvPlans reloadData];
    
    arrUnitInfo     = [[NSMutableArray alloc]init]      ;
    dictClientInfo  = [[NSMutableDictionary alloc]init] ;
    
    vwModelNSerialSplit.hidden = YES    ;
    //selectedPlanIndex          = 0      ;
    selectedAddressIndex       = 0      ;
    addressId                  = @""    ;
    [self btnUnitTypeTap:btnPackaged]   ;
    
    // [self setFrames];
}
-(void)prepareviewForAddAnotherUnit
{
    [self getPlanTypes];
    
    [tblvPlans reloadData];
    arrUnitInfo     = [[NSMutableArray alloc]init];
    dictClientInfo  = [[NSMutableDictionary alloc]init];
    
    vwModelNSerialSplit.hidden = YES;
    // selectedPlanIndex = 0;
    selectedAddressIndex = 0;
    [self btnUnitTypeTap:btnPackaged];
    
    txtfClientName.text = clientName;
    btnClientSearch.userInteractionEnabled = NO;
    //tblvAddress.userInteractionEnabled     = NO;
    
    [self getAddressListFromClient:selectedClientId];
    
}
-(void)setFramesWithmMessage:(NSString *)message
{
    
    if (arrAddress.count > 0)
    {
        tblvAddress.frame = CGRectMake(tblvAddress.x, tblvAddress.y, tblvAddress.width, tblvAddress.contentSize.height);
        vwAddress.frame = CGRectMake(vwAddress.x, vwAddress.y, vwAddress.width,tblvAddress.contentSize.height + 50);
    }
    else
    {
        tblvAddress.backgroundView = [ACEUtil viewNoDataWithMessage:message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
        
        tblvAddress.frame = CGRectMake(tblvAddress.x, tblvAddress.y, tblvAddress.width, tblvAddress.height);
        vwAddress.frame = CGRectMake(vwAddress.x, vwAddress.y, vwAddress.width, tblvAddress.height + 50);
    }
    
    tblvPlans.frame = CGRectMake(tblvPlans.x, tblvPlans.y, tblvPlans.width, tblvPlans.contentSize.height);
    
    vwTypeOfPlan.frame = CGRectMake(vwTypeOfPlan.x, vwAddress.y + vwAddress.height, vwTypeOfPlan.width,tblvPlans.contentSize.height + 50);
    
    if (vwModelNSerialSplit.hidden == NO)
    {
        if (arrtextBoxes!= nil)
        {
            arrtextBoxes= nil;
        }
        
        vwBelowTypeOfPlan.frame = CGRectMake(vwBelowTypeOfPlan.x,vwTypeOfPlan.y + vwTypeOfPlan.height + 20, vwBelowTypeOfPlan.width, vwModelNSerialSplit.y + vwModelNSerialSplit.height);
        
        arrtextBoxes = [[NSMutableArray alloc]initWithObjects:txtfNameOfUnit,txtModelNo,txtSerialNo,txtUnitTon,txtSplitModelNo,txtSplitSerialNo,txtSplitUnitTon,txtQty,nil];
    }
    else
    {
        if (arrtextBoxes!= nil)
        {
            arrtextBoxes= nil;
        }
        
        vwBelowTypeOfPlan.frame = CGRectMake(vwBelowTypeOfPlan.x,vwTypeOfPlan.y + vwTypeOfPlan.height + 20, vwBelowTypeOfPlan.width, vwModelNSerial.y + vwModelNSerial.height);
        
        arrtextBoxes = [[NSMutableArray alloc]initWithObjects:txtfNameOfUnit,txtModelNo,txtSerialNo,txtUnitTon,txtQty,nil];
    }
    
    vwPlanInfo.y = vwBelowTypeOfPlan.y + vwBelowTypeOfPlan.height + 10;
    
    scrlvbg.contentSize = CGSizeMake(scrlvbg.width,vwPlanInfo.y + vwPlanInfo.height + 30);
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrtextBoxes andScroll:scrlvbg];
    
    textboxHandler.delegate = self;
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


-(void)openUserSearch
{
    SearchUserViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SearchUserViewController"];
    
    vc.delegate         = self;
    vc.isWorkAreaClient = NO;
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
-(void)getPlanInfo
{
    if([ACEUtil reachable])
    {
        [self callwebserviceTogetPlanInfo];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)setPaymentInfoView:(NSDictionary *)paymentInfo
{
    perMnth = [paymentInfo[GPricePerMonth]floatValue];
    discountPrice = [paymentInfo[GDiscountPrice]floatValue];
    float forMnth = [paymentInfo[GPrice]floatValue];
    
    vwPlanDetail.height  = vwSpOffer.y + vwSpOffer.height;
    vwPlanDetail.hidden  = NO;
    
    float price = [txtQty.text intValue] * perMnth;
    
    lblPerMnthPrice.text = [NSString stringWithFormat:@"$%0.2f",
                            price];
    
    lblForMnthPrice.text = [NSString stringWithFormat:@"For %@ Months",paymentInfo[GPlanDuration]];
    
    lblForAllMnths.text  = [NSString stringWithFormat:@"$%0.2f",forMnth];
    
    lblSpecialOffer.text = paymentInfo[GSpecialText];
    
    specialPrice = [paymentInfo[GSpecialPrice] floatValue];
    
    lblSpecialOffer.text = [NSString stringWithFormat:@"Save $%0.2f and Pay only $%0.2f now!",[txtQty.text intValue] * specialPrice,[txtQty.text intValue] * discountPrice];
    
    bool shouldDisplay   = [paymentInfo[GShouldDisplay]boolValue];
    
    bool isAutoRenewal   = [paymentInfo[GShowAutoRenewal]boolValue];
    
    if(!shouldDisplay && isAutoRenewal) // Display Only Auto Renewal
    {
        vwSpOffer.hidden      = YES     ;
        btnAutoRenew.hidden   = NO      ;
        vwPlanDetail.height   = vwPlanDetail.height - vwSpOffer.height;
    }
    else if (!isAutoRenewal && shouldDisplay) //Display Only Special Offer
    {
        btnAutoRenew.hidden   = YES                 ;
        vwSpOffer.hidden      = NO                  ;
        vwSpOffer.y           = btnAutoRenew.y      ;
        vwPlanDetail.height   = vwSpOffer.height    ;
    }
    else if(!isAutoRenewal && !shouldDisplay) // Hide options
    {
        vwPlanDetail.hidden   = YES;
        vwPlanDetail.height   = 0  ;
    }
    else if (isAutoRenewal && shouldDisplay) // Display both options
    {
        vwSpOffer.hidden      = NO      ;
        btnAutoRenew.hidden   = NO      ;
        vwPlanDetail.hidden   = NO      ;
        vwSpOffer.y           = btnAutoRenew.y + btnAutoRenew.height;
        vwPlanDetail.height   = vwSpOffer.y + vwSpOffer.height;
    }
    
    vwPlanInfo.height       = vwPlanDetail.y + vwPlanDetail.height;
    
    scrlvbg.contentSize = CGSizeMake(scrlvbg.width,vwPlanInfo.y + vwPlanInfo.height + 30);
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrtextBoxes andScroll:scrlvbg];
    
    textboxHandler.delegate   = self;
    
}
#pragma mark - WebService Methods
-(void)getPlanTypes
{
    if ([ACEUtil reachable])
    {
        [SVProgressHUD show];
        [ACEWebServiceAPI getPlanTypeWithcompletionHandler:^(ACEAPIResponse *response, NSMutableArray *planType)
         {
             [SVProgressHUD dismiss];
             if (response.code == RCodeSuccess)
             {
                 arrPlanTypes = planType;
                 //planId = [arrPlanTypes[selectedPlanIndex]valueForKey:GKeyId];
                 [tblvPlans reloadData];
                 [self setFramesWithmMessage:ACEBlankClientName];
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
             
         }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

-(void)getAddressListFromClient:(NSString *)clientID
{
    [SVProgressHUD show];
    
    [ACEWebServiceAPI getAddressListForClient:clientID completionHandler:^(ACEAPIResponse *response, NSMutableArray *addressArray)
     {
         if (response.code == RCodeSuccess)
         {
             tblvAddress.backgroundView = nil;
             arrAddress = [self getValidAddresses:addressArray].mutableCopy;
             [tblvAddress reloadData];
         }
         else if(response.code == RCodeNoData)
         {
             arrAddress = nil;
             [tblvAddress reloadData];
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
         }
         else
         {
             arrAddress = nil;
             tblvAddress.backgroundView = [ACEUtil viewNoDataWithMessage:ACEUnknownError andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
             [tblvAddress reloadData];
             
             
         }
         
         [self setFramesWithmMessage:ACENoAddressFound];
         
         [SVProgressHUD dismiss];
     }];
}
-(void)sendUnitData
{
    [SVProgressHUD show];
    arrUnitDetail = [[NSMutableArray alloc]init];
    
    if([unitType isEqualToString:GUnitTypeSplit])
    {
        NSDictionary *dict = @{
                               ACKeySplitType      : GUnitTypeHeating,
                               ACKeyMnumber         : txtModelNo.text,
                               ACKeySerialNumber    : txtSerialNo.text,
                               ACKeyMdate           : txtManufactureDate.placeholder ? txtManufactureDate.placeholder : @"",
                               ACKeyUnitTon         : txtUnitTon.text
                               };
        
        
        NSDictionary *dict1 = @{
                                ACKeySplitType      : GUnitTypeCooling,
                                ACKeyMnumber         : txtSplitModelNo.text,
                                ACKeySerialNumber    : txtSplitSerialNo.text,
                                ACKeyMdate           : txtSplitManufactureDate.placeholder ? txtSplitManufactureDate.placeholder : @"",
                                ACKeyUnitTon         : txtSplitUnitTon.text
                                };
        [arrUnitDetail addObject:dict];
        [arrUnitDetail addObject:dict1];
    }
    else
    {
        NSDictionary *dict = @{
                               ACKeySplitType       : unitType,
                               ACKeyMnumber         : txtModelNo.text,
                               ACKeySerialNumber    : txtSerialNo.text,
                               ACKeyMdate           : txtManufactureDate.placeholder ? txtManufactureDate.placeholder : @""
                               };
        [arrUnitDetail addObject:dict];
        
    }
    
    
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    
    [parameterDict setDictionary:dictClientInfo];
    
    [parameterDict setValue:@(btnAutoRenew.selected) forKey:GAutoRenewal];
    [parameterDict setValue:@(btnSpecialOffer.selected) forKey:GSpecialOffer];
    [parameterDict setValue:arrUnitDetail forKey:ACKeyOptionalInfo];
    [parameterDict setValue:_paymnetOption forKey:ACKeyPaymentOption];
    [parameterDict setValue:txtQty.text forKey:ACKeyQty];
    
    [parameterDict setValue:ACEGlobalObject.user.userID forKey:UKeyEmployeeID];
    
    [ACEWebServiceAPI spAddUnit:parameterDict completionHandler:^(ACEAPIResponse *response, NSDictionary *unitInfo)
     {
         [SVProgressHUD dismiss];
         
         if(response.code == RCodeSuccess)
         {
             //arrUnitInfo = arrunit;
             SPSummaryViewController *vc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"SPSummaryViewController"];
             
             vc.dictClientInfo = dictClientInfo;
             vc.dictUnitInfo   = unitInfo;
             vc.paymentOption  = _paymnetOption;
             
             [self.navigationController pushViewController:vc animated:YES];
             
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
-(void)callwebserviceTogetPlanInfo
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           GPlanTypeId : planId,
                           UKeyEmployeeID : ACEGlobalObject.user.userID
                           };
    
    [ACEWebServiceAPI getSpecialRateofPlan:dict completionHandler:^(ACEAPIResponse *response, NSDictionary *dictInfo)
     {
         [SVProgressHUD dismiss];
         
         if(response.code == RCodeSuccess)
         {
             [self setPaymentInfoView:dictInfo];
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

#pragma mark - searchuser delegate method
-(void)selectedUser:(ACEClient *)user
{
    txtfClientName.text = user.Name;
    selectedClientId = [NSString stringWithFormat:@"%@",user.ID];
    addressId         = @"";
    planId            = nil;
    // selectedPlanIndex = nil;
    [tblvPlans reloadData];
    [self getAddressListFromClient:selectedClientId];
}
#pragma mark - AddAddressViewControllerDelegate Method
-(void)addedAddress:(NSDictionary *)dict
{
    ACEAddress *address = [[ACEAddress alloc]initWithDictionary:dict];
    [arrAddress addObject:address];
    [tblvAddress reloadData];
    //[self setFrames];
}

#pragma mark - MonthYearPickerViewControllerdelegate Method
-(void)selectedDateFromMonthPicker:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM, yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    selectedTextField.text = stringFromDate;
    selectedTextField.placeholder = [NSString stringWithFormat:@"%@",date];
    
    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
    NSInteger year = components.year;
    
    if(year >= 10)
    {
        selectedTextField.textColor = [UIColor redColor];
    }
    else
    {
        selectedTextField.textColor = [UIColor blackColor];
    }
    
}
#pragma mark - Event Method
- (IBAction)btnAddTap:(id)sender
{
    /*AddAddressViewController *aavc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    aavc.delegate = self;
    [self presentViewController:aavc animated:YES completion:nil];*/
}

- (IBAction)btnSubmitTap:(id)sender
{
    if ([self isDetailValid])
    {
        [dictClientInfo setValue:selectedClientId forKey:CKeyID];
        [dictClientInfo setValue:txtfNameOfUnit.text forKey:ACKeyNameOfUnit];
        [dictClientInfo setValue:planId forKey:GPlanTypeId];
        [dictClientInfo setValue:addressId forKey:SCHKeyAddressId];
        [dictClientInfo setValue:txtfClientName.text forKey:
         ACKeyClientName];
        
        if ([ACEUtil reachable])
        {
            [self sendUnitData];
        }
        else
        {
            [self showAlertWithMessage:ACENoInternet];
        }
    }
    
    
}
- (IBAction)btnDateTap:(UIButton*)sender
{
    if (sender.tag == 1)
    {
        selectedTextField = txtSplitManufactureDate;
    }
    else
    {
        selectedTextField = txtManufactureDate;
    }
    
    selectedTextField.layer.borderColor = [UIColor separatorColor].CGColor;
    
    [self removeErrorMessageBelowView:selectedTextField];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSDate *selectedDate = [formatter dateFromString:selectedTextField.placeholder];
    
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

- (IBAction)btnUnitTypeTap:(UIButton *)sender
{
    if (sender == btnPackaged)
    {
        vwModelNSerialSplit.hidden = true;
        
        unitTypeId = @"1";
        unitType = @"Packaged";
        lblForHeating.text = [NSString stringWithFormat:@"For %@",GUnitTypePackaged];
        btnPackaged.selected    = YES;
        btnSplit.selected       = NO;
        btnHeating.selected     = NO;
        lblUnitSizeTitle.text   = @"Unit Size";
        [self setFramesWithmMessage:@""];
        
    }
    else if (sender == btnSplit)
    {
        [self.view endEditing:YES];
        
        vwModelNSerialSplit.hidden = false;
        unitTypeId = @"2";
        unitType = @"Split";
        lblForHeating.text = [NSString stringWithFormat:@"For %@",GUnitTypeHeating];
        btnPackaged.selected = NO;
        btnSplit.selected = YES;
        btnHeating.selected = NO;
        lblUnitSizeTitle.text   = @"BTU & % of Heat Loss";
        [self setFramesWithmMessage:@""];
        
    }
    else if (sender == btnHeating)
    {
        vwModelNSerialSplit.hidden = true;
        unitTypeId = @"3";
        unitType = @"Heating";
        lblForHeating.text = [NSString stringWithFormat:@"For %@",GUnitTypeHeating];
        btnPackaged.selected = NO;
        btnSplit.selected = NO;
        btnHeating.selected = YES;
        lblUnitSizeTitle.text   = @"BTU & % of Heat Loss";
        [self setFramesWithmMessage:@""];
    }
}

- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClientSearchTap:(id)sender
{
    [textboxHandler btnDoneTap];
    [self removeErrorMessageBelowView:txtfClientName];
    txtfClientName.layer.borderColor = [UIColor separatorColor].CGColor;
    [self openUserSearch];
}
- (IBAction)btnPaymentMethodTap:(UIButton *)sender
{
    if (sender == btnAutoRenew)
    {
        isSpecialOffer           = false;
        btnAutoRenew.selected    = !btnAutoRenew.selected;
        btnSpecialOffer.selected = NO;
        if(btnAutoRenew.selected)
        {
            vwSpOffer.hidden         = YES;
        }
        else
        {
            vwSpOffer.hidden         = NO;
        }
    }
    else if (sender == btnSpecialOffer)
    {
        isSpecialOffer           = true;
        btnAutoRenew.selected    = NO;
        btnSpecialOffer.selected = !btnSpecialOffer.selected ;
        
        if(btnSpecialOffer.selected)
        {
            btnAutoRenew.hidden         = YES;
        }
        else
        {
            btnAutoRenew.hidden         = NO;
        }
        
    }
}

#pragma mark - tableview delegate method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblvAddress)
    {
        return  arrAddress.count;
    }
    else if(tableView == tblvPlans)
    {
        return arrPlanTypes.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = NO;
    
    if (tableView == tblvAddress)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
        ACEAddress *address = arrAddress[indexPath.row];
        cell.lblName.text = address.fullAddress;
        
        if(addressId && isAddAnother)
        {
            if([address.addressId isEqualToString:addressId])
            {
                selectedAddressIndex = indexPath.row;
                cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
                addressId           = address.addressId;
            }
            else
            {
                cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
            }
        }
        else
        {
            
            if (address.isDefaultAddress && arrAddress.count == 1)
            {
                selectedAddressIndex = indexPath.row;
                cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
                addressId           = address.addressId;
            }
            else if (addressId && [address.addressId isEqualToString:addressId])
            {
                selectedAddressIndex = indexPath.row;
                cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
                addressId           = address.addressId;
            }
            else
            {
                cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
            }
        }
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"planCell"];
        cell.lblName.text = [arrPlanTypes[indexPath.row] valueForKey:GKeyName];
        cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
        
        if (selectedPlanIndex == indexPath.row && planId != nil)
        {
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSIndexPath *indexPathForFirstRow;
    
    if (tableView == tblvAddress)
    {
         if (selectedAddressIndex != indexPath.row)
         {
             NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedAddressIndex inSection:0];
             cell = [tableView cellForRowAtIndexPath:indexPathForFirstRow];
             cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
         }
        
        ACEAddress *address  = arrAddress[indexPath.row];
        addressId            = address.addressId;
        selectedAddressIndex = indexPath.row;
        
        cell  = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvTick.image  = [UIImage imageNamed:@"radiobutton-selected"];
        
    }
    else if(tableView == tblvPlans)
    {
        /* if (selectedPlanIndex != indexPath.row)
         {
         indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedPlanIndex inSection:0];
         cell = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
         cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
         }*/
        
        selectedPlanIndex = indexPath.row;
        planId = [arrPlanTypes[indexPath.item] valueForKey:GKeyId];
        
        cell   = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
        [self getPlanInfo];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblvAddress)
    {
        cell  = (ACESelectionCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
    }
    else if (tableView == tblvPlans)
    {
        cell = (ACESelectionCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
    }
}

#pragma mark - ZWTTextboxToolbarHandler Delegate
-(void)doneTap
{
//    float price = [txtQty.text intValue] * perMnth;
//    
//    lblPerMnthPrice.text = [NSString stringWithFormat:@"$%0.2f",
//                            price];
//    
//    lblSpecialOffer.text = [NSString stringWithFormat:@"Save $%0.2f and Pay only $%0.2f now!",[txtQty.text intValue] * specialPrice,[txtQty.text intValue] * discountPrice];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    [self removeErrorMessageBelowView:textField];
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
    
    if(textField == txtUnitTon || textField == txtSplitUnitTon)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        
        if (length > 20)
        {
            return NO;
        }
        return YES;

    }
    if(textField == txtQty)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        
        if (length > 2)
        {
            return NO;
        }
        float price = [currentString intValue] * perMnth;
        
        lblPerMnthPrice.text = [NSString stringWithFormat:@"$%0.2f",
                                price];
        
        lblSpecialOffer.text = [NSString stringWithFormat:@"Save $%0.2f and Pay only $%0.2f now!",[currentString intValue] * specialPrice,[currentString intValue] * discountPrice];
        return YES;
        
    }
    return YES;
}
#pragma mark - UnMatched Popup Delegate
-(void)openAddUnitACHeating:(int)isMatched
{
    AddUnitACHeatingViewController *auahvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddUnitACHeatingViewController"];
    
    auahvc.isMatched      = isMatched            ;
    auahvc.headingTitle   = ACEAddUnitTitle      ;
    auahvc.unitType       = unitType             ;
    auahvc.dictClientInfo = dictClientInfo       ;
    auahvc.arrModelSerial = arrUnitDetail        ;
    auahvc.paymentOption  = _paymnetOption       ;
    
    [self.navigationController pushViewController:auahvc animated:YES];
}


@end
