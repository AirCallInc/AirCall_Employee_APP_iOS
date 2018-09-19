//
//  AddUnitClientInfoViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 19/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//



#import "AddUnitClientInfoViewController.h"

@interface AddUnitClientInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SelectedUser,ZWTTextboxToolbarHandlerDelegate,UnMatchedPopup,SelectDatePopupViewControllerdelegate,AddAddressViewControllerDelegate,MonthYearPickerViewControllerdelegate>

@property (weak, nonatomic) IBOutlet UILabel        *lblHeading         ;
@property (weak, nonatomic) IBOutlet UITextField    *txtfClientName     ;
@property (weak, nonatomic) IBOutlet UITextField    *txtfNameOfUnit     ;
@property (weak, nonatomic) IBOutlet UIView         *vwAddress          ;
@property (weak, nonatomic) IBOutlet UITableView    *tblvAddress        ;
@property (weak, nonatomic) IBOutlet UIView         *vwClientDetail     ;

@property (strong, nonatomic) IBOutlet ACETextField *txtModelNo         ;
@property (strong, nonatomic) IBOutlet ACETextField *txtSerialNo        ;
@property (strong, nonatomic) IBOutlet ACETextField *txtSplitModelNo    ;
@property (strong, nonatomic) IBOutlet ACETextField *txtSplitSerialNo   ;


@property (weak, nonatomic) IBOutlet UIView *vwBelowAddress             ;
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

@property (strong, nonatomic) IBOutlet ACETextField *txtManufactureDate ;
@property (strong, nonatomic) IBOutlet ACETextField *txtSplitManufactureDate;

@property NSMutableArray *arrAddress    ;
@property NSMutableArray *arrPlanTypes  ;
@property NSString       *unitType      ;
@property NSString       *unitTypeId    ;
@property NSString       *planId        ;

@property ACESelectionCell         *cell            ;
@property ZWTTextboxToolbarHandler *textboxHandler  ;

@property NSInteger selectedAddressIndex        ;
@property NSInteger selectedPlanIndex           ;

@property NSMutableArray *arrtextBoxes          ;
@property NSMutableArray *arrUnitDetail         ;
@property NSMutableArray *arrUnitInfo           ;

@property UITextField *selectedTextField        ;
@property NSMutableDictionary *dictClientInfo   ;
@property NSDate   *selectedDate;

@end

@implementation AddUnitClientInfoViewController

@synthesize txtfClientName,txtfNameOfUnit,vwAddress,tblvAddress,vwBelowAddress,vwTypeOfPlan,vwClientDetail,vwBelowTypeOfPlan,vwModelNSerial,btnSubmit,lblForHeating,scrlvbg,vwModelNSerialSplit,unitType,lblHeading,btnPackaged,btnSplit,btnHeating,tblvPlans,arrtextBoxes,textboxHandler,txtModelNo,txtSerialNo,txtSplitModelNo,txtSplitSerialNo,selectedClientId,arrUnitDetail,arrUnitInfo,txtManufactureDate,txtSplitManufactureDate,selectedTextField,btnClientSearch;

@synthesize arrAddress,arrPlanTypes,unitTypeId,cell,selectedAddressIndex,selectedPlanIndex,planId,addressId,dictClientInfo,isAddAnother,clientName,selectedDate;

#pragma mark - ACEViewController Method
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
//    if(![self isValidAddress:arrAddress])
//    {
//        [self showAlertWithMessage:ACEInactiveZipcode];
//        return NO;
//    }
    if(planId == nil)
    {
        [self showAlertWithMessage:ACENoPlanSelected];
        return NO;
    }
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
    
    result = [txtManufactureDate validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankManufactureDate belowView:txtManufactureDate];
        return NO;
    }

    if (vwModelNSerialSplit.hidden == NO)
    {
        result = [txtSplitModelNo validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
        
        if (result == ZWTValidationResultBlank)
        {
            [self showErrorMessage:ACEBlankModelNumber belowView:txtSplitModelNo];
            return NO;
        }
        
//        result = [txtSplitSerialNo validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
//        
//        if (result == ZWTValidationResultBlank)
//        {
//            [self showErrorMessage:ACEBlankSerialNumber belowView:txtSplitSerialNo];
//            return NO;
//        }
        
        result = [txtSplitManufactureDate validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
        
        if (result == ZWTValidationResultBlank)
        {
            [self showErrorMessage:ACEBlankManufactureDate belowView:txtSplitManufactureDate];
            return NO;
        }
        
        txtModelNo.text         = [self trimmWhiteSpaceFrom:txtModelNo.text];
        txtSplitModelNo.text    = [self trimmWhiteSpaceFrom:txtSplitModelNo.text];
        txtSerialNo.text        = [self trimmWhiteSpaceFrom:txtSerialNo.text];
        txtSplitSerialNo.text   = [self trimmWhiteSpaceFrom:txtSplitSerialNo.text];
                           
        if([txtModelNo.text isEqualToString:txtSplitModelNo.text])
        {
            [self showAlertWithMessage:ACESameModelNumber];
            return NO;
        }
        
        if(![txtSplitSerialNo.text isEqualToString:@""] && ![txtSerialNo.text isEqualToString:@""])
        {
            if([txtSerialNo.text isEqualToString:txtSplitSerialNo.text])
            {
                [self showAlertWithMessage:ACEBlankSerialNumber];
                return NO;
            }
            if([txtModelNo.text isEqualToString:txtSplitModelNo.text] && [txtSerialNo.text isEqualToString:txtSplitSerialNo.text])
            {
                [self showAlertWithMessage:ACESameModelSerialNumber];
                return NO;
            }
        }
        
    }
    return YES;
}
-(BOOL)isValidAddress:(NSMutableArray *)addressList
{
    BOOL isActive = NO;
    for (int i = 0; i < addressList.count; i++)
    {
        ACEAddress *address = addressList[i];
        
        if ([addressId isEqualToString:address.addressId])
        {
            if (address.isShowAddress)
            {
                isActive = YES;
            }
        }
    }
    return isActive;
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
    //tblvAddress.userInteractionEnabled    = NO;
    
    [self getAddressListFromClient:selectedClientId];
    
}
-(void)setFramesWithmMessage:(NSString *)message
{
   // [tblvPlans reloadData];
   // [tblvAddress reloadData];
    
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
        
        arrtextBoxes = [[NSMutableArray alloc]initWithObjects:txtfNameOfUnit,txtModelNo,txtSerialNo,txtSplitModelNo,txtSplitSerialNo,nil];
    }
    else
    {
        if (arrtextBoxes!= nil)
        {
            arrtextBoxes= nil;
        }
        
        vwBelowTypeOfPlan.frame = CGRectMake(vwBelowTypeOfPlan.x,vwTypeOfPlan.y + vwTypeOfPlan.height + 20, vwBelowTypeOfPlan.width, vwModelNSerial.y + vwModelNSerial.height);
        
        arrtextBoxes = [[NSMutableArray alloc]initWithObjects:txtfNameOfUnit,txtModelNo,txtSerialNo,nil];
    }
    
    scrlvbg.contentSize = CGSizeMake(scrlvbg.width,vwBelowTypeOfPlan.y + vwBelowTypeOfPlan.height+20);
    
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
-(void)openDetailViewController:(int)isMatch andShouldCallWebService:(BOOL)ans
{
    AddUnitACHeatingViewController *auavc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddUnitACHeatingViewController"];
   
    auavc.isMatched             = isMatch     ;
    auavc.shouldCallWebservice  = ans         ;
    
    auavc.unitType       = unitType           ;
    auavc.arrModelSerial = arrUnitDetail      ;
    auavc.headingTitle   = ACEAddUnitTitle    ;
    auavc.arrUnitInfo    = arrUnitInfo        ;
    auavc.dictClientInfo = dictClientInfo     ;
    auavc.paymentOption  = _paymnetOption     ;
    [self.navigationController pushViewController:auavc animated:YES];
}
-(void)openPopUpViewcontroller
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
                               ACKeyTypeOfUnit      : GUnitTypeHeating,
                               ACKeyMnumber         : txtModelNo.text,
                               ACKeySerialNumber    : txtSerialNo.text,
                               ACKeyMdate           : txtManufactureDate.placeholder
                               };
      
        NSDictionary *dict1 = @{
                                ACKeyTypeOfUnit      : GUnitTypeCooling,
                                ACKeyMnumber         : txtSplitModelNo.text,
                                ACKeySerialNumber    : txtSplitSerialNo.text,
                                ACKeyMdate           : txtSplitManufactureDate.placeholder
                                };
        
        [arrUnitDetail addObject:dict];
        [arrUnitDetail addObject:dict1];
    }
    else
    {
        NSDictionary *dict = @{
                               ACKeyTypeOfUnit      : unitType,
                               ACKeyMnumber         : txtModelNo.text,
                               ACKeySerialNumber    : txtSerialNo.text,
                               ACKeyMdate           : txtManufactureDate.placeholder
                               };
        [arrUnitDetail addObject:dict];
        
    }
    
    NSDictionary *parameterDict =@{
                                   PKeyParts : arrUnitDetail,
                                   UKeyEmployeeID : ACEGlobalObject.user.userID
                                   };
    
    [ACEWebServiceAPI checkUnitMatchDetails:parameterDict completionHandler:^(ACEAPIResponse *response,NSMutableArray *arrunit)
     {
         [SVProgressHUD dismiss];
         
         if(response.code == RCodeSuccess)
         {
             arrUnitInfo = arrunit;
             [self openDetailViewController:1 andShouldCallWebService:NO];
         }
         else if (response.code == RCodeUnitPartialMatch)
         {
             arrUnitInfo = arrunit;
             [self openDetailViewController:2 andShouldCallWebService:NO];
         }
         else if(response.code == RCodeNoData)
         {
             [self openPopUpViewcontroller];
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
#pragma mark - SelectDatePopupViewControllerdelegate Method
-(void)selectedDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    selectedTextField.text = stringFromDate;
    selectedTextField.placeholder = [NSString stringWithFormat:@"%@",date];
}

#pragma mark - MonthYearPickerViewControllerdelegate Method
-(void)selectedDateFromMonthPicker:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM, yyyy"];
    
    NSString *stringFromDate      = [formatter stringFromDate:date];
    selectedTextField.text        = stringFromDate;
    selectedTextField.placeholder = [NSString stringWithFormat:@"%@",date];
    
    NSCalendar * calendar         = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components  = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
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
    AddAddressViewController *aavc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    aavc.delegate = self;
    [self presentViewController:aavc animated:YES completion:nil];
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
    
    selectedDate = [formatter dateFromString:selectedTextField.placeholder];
    
   // [textboxHandler btnDoneTap];
    
    [self.view endEditing:YES];
    
    scrlvbg.contentSize = CGSizeMake(scrlvbg.width,vwBelowTypeOfPlan.y + vwBelowTypeOfPlan.height);
    
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
        
        [self setFramesWithmMessage:@""];
        
    }
    else if (sender == btnSplit)
    {
        [self.view endEditing:YES];
        
        vwModelNSerialSplit.hidden = false;
        unitTypeId = @"2";
        unitType = @"Split";
        lblForHeating.text = [NSString stringWithFormat:@"For %@",GUnitTypeHeating];
        btnPackaged.selected    = NO;
        btnSplit.selected       = YES;
        btnHeating.selected     = NO;
        
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
        
//        if (arrtextBoxes!= nil)
//        {
//            arrtextBoxes= nil;
//        }
//        
//        arrtextBoxes = [[NSMutableArray alloc]initWithObjects:txtfNameOfUnit,txtModelNo,txtSerialNo, nil];
        
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
        
        cell  = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvTick.image  = [UIImage imageNamed:@"radiobutton-selected"];
        ACEAddress *address  = arrAddress[indexPath.row];
        addressId            = address.addressId;
        selectedAddressIndex = indexPath.row;
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
    //scrlvbg.contentSize = CGSizeMake(scrlvbg.width,vwBelowTypeOfPlan.y + vwBelowTypeOfPlan.height);
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
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
/* SelectDatePopupViewController *viewController = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectDatePopupViewController"];
 
 ACEGlobalObject.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
 ACEGlobalObject.navigationController.navigationBar.hidden = YES;
 
 ACEGlobalObject.navigationController.providesPresentationContextTransitionStyle = YES;
 ACEGlobalObject.navigationController.definesPresentationContext = YES;
 [ACEGlobalObject.navigationController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
 
 viewController.delegate       = self  ;
 viewController.isMinimumDate  = NO    ;
 viewController.isMaximumDate  = YES   ;
 
 
 [self presentViewController:ACEGlobalObject.navigationController animated:NO completion:nil];*/
@end
