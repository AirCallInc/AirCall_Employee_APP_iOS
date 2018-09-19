//
//  AddOrderClientInfoViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 07/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AddOrderClientInfoViewController.h"

@interface AddOrderClientInfoViewController ()<ZWTTextboxToolbarHandlerDelegate,SelectedStateCity,UITextViewDelegate,SelectedUser,ChargeByPopupViewControllerDelegate>

@property ZWTTextboxToolbarHandler *textboxHandler;
@property NSMutableArray *arrTextBoxes;

@property (strong, nonatomic) IBOutlet UIScrollView *scrlvbg    ;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount       ;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomer ;
@property (strong, nonatomic) IBOutlet UITextField *txtCompany  ;
@property (strong, nonatomic) IBOutlet UITextField *txtCity     ;
@property (strong, nonatomic) IBOutlet UITextField *txtState    ;

@property (strong, nonatomic) IBOutlet ACETextField *txtAddress;
@property (strong, nonatomic) IBOutlet ACETextField *txtZipCode ;
@property (strong, nonatomic) IBOutlet ACETextField *txtEmail   ;
@property (strong, nonatomic) IBOutlet ACETextField *txtccEmail ;
@property (strong, nonatomic) IBOutlet SAMTextView *txtvRecommendations;

@property (strong, nonatomic) IBOutlet ACETextField *txtChargeBy;
@property (strong, nonatomic) IBOutlet UIButton *btnEmailToClient;

@property (strong, nonatomic) IBOutlet UIButton *btnQuote;
@property (strong, nonatomic) IBOutlet UIButton *btnPayment;

@property ACEAddress *defaultAddress    ;
@property ACEClient  *selectedClient    ;
@property NSString   *stateId           ;
@property NSString   *cityId            ;
@property NSString   *selectedChargeBy  ;

@end

@implementation AddOrderClientInfoViewController

@synthesize scrlvbg,txtCustomer,lblAmount,txtCity,txtState,textboxHandler,arrTextBoxes,txtAddress,txtZipCode,txtEmail,txtccEmail,txtvRecommendations,stateId,cityId,totalAmount,selectedItem,defaultAddress,selectedClient,txtChargeBy,selectedChargeBy,btnEmailToClient,btnQuote,btnPayment,txtCompany;

#pragma mark - ACEViewcontroller Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}
-(void)prepareView
{
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width,btnQuote.y + btnQuote.height + 25)];
    
    arrTextBoxes = [[NSMutableArray alloc]initWithObjects:txtCompany,txtAddress,txtZipCode,txtEmail,txtccEmail,txtvRecommendations, nil];
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvbg];
    textboxHandler.delegate = self;
    
    lblAmount.text    = [NSString stringWithFormat:@"$%0.2f",fabsf(totalAmount)];
}
-(void)setAddressDetail
{
    txtCompany.text    = defaultAddress.company      ;
    
    txtAddress.text    = defaultAddress.addressName  ;
    [self removeErrorMessageBelowView:txtAddress]    ;
    txtAddress.layer.borderColor   = [UIColor separatorColor].CGColor;
    
    txtState.text       = defaultAddress.stateName   ;
    [self removeErrorMessageBelowView:txtState]      ;
    txtState.layer.borderColor   = [UIColor separatorColor].CGColor;
    
    txtCity.text        = defaultAddress.cityName   ;
    [self removeErrorMessageBelowView:txtCity]      ;
    txtCity.layer.borderColor   = [UIColor separatorColor].CGColor;
    
    txtZipCode.text     = defaultAddress.zipcode    ;
    [self removeErrorMessageBelowView:txtZipCode]   ;
    txtZipCode.layer.borderColor   = [UIColor separatorColor].CGColor;
    
    txtEmail.text       = defaultAddress.email       ;
    [self removeErrorMessageBelowView:txtEmail]      ;
    txtEmail.layer.borderColor   = [UIColor separatorColor].CGColor;
    
    stateId             = defaultAddress.stateId     ;
    cityId              = defaultAddress.cityId      ;
    txtChargeBy.text    = @"";
    
    [SVProgressHUD dismiss];
}
#pragma mark - EventMethod
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnEmailToclientTap:(UIButton *)btn
{
    if(btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"worknotdone"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"worknotdone-selected"] forState:UIControlStateNormal];
    }
    btnEmailToClient.selected = !btnEmailToClient.selected;
    
    [self removeErrorMessageBelowView:txtEmail];
    txtEmail.layer.borderColor = [UIColor separatorColor].CGColor;
}
- (IBAction)btnChargeByTap:(id)sender
{
    [self openChargeByController];
}
- (IBAction)btnSearchClientTap:(id)sender
{
    [textboxHandler btnDoneTap]    ;
    [self openSearchUserController];
}

- (IBAction)btnPaymentTap:(id)sender
{
    if ([self isValidInfo])
    {
        [self validateBillingAddress];
    }
}
- (IBAction)btnQuoteTap:(UIButton *)button
{
    
    if(button.selected)
    {
        [button setImage:[UIImage imageNamed:@"worknotdone-selected"] forState:UIControlStateNormal];
        [btnPayment setTitle:@"Send quote" forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"worknotdone"] forState:UIControlStateNormal];
        [btnPayment setTitle:@"Proceed to make a payment" forState:UIControlStateNormal];
    }
    button.selected = !button.selected;
}

#pragma mark - Helper Method
-(void)openPaymentMethod
{
    AddOrderPaymentViewController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"AddOrderPaymentViewController"];
    
    vc.arrSelectedParts         = selectedItem                      ;
    vc.address                  = defaultAddress                    ;
    vc.recomm                   = txtvRecommendations.text          ;
    vc.clientId                 = [selectedClient.ID stringValue]   ;
    vc.ccEmail                  = txtccEmail.text                   ;
    vc.selectedOption           = selectedChargeBy                  ;
    vc.isEmailToClient          = btnEmailToClient.isSelected       ;
    [self.navigationController pushViewController:vc animated:YES]  ;
}
-(void)sendQuote
{
    
    [SVProgressHUD show];
    
    NSDictionary * dict = @{
                            OKeyClientId    : [selectedClient.ID stringValue],
                            UKeyEmployeeID  : ACEGlobalObject.user.userID,
                            OKeyAddress     : defaultAddress.addressName,
                            OKeyCity        : defaultAddress.cityId,
                            OKeyState       : defaultAddress.stateId,
                            OKeyZip         : defaultAddress.zipcode,
                            OKeyEmail       : defaultAddress.email,
                            OKeyRecomm      : txtvRecommendations.text,
                            OKeyIteamList   : [self getPartList],
                            OKeyCCEmail     : txtccEmail.text
                            };
    
    
    [ACEWebServiceAPI submitOrderQuote:dict completionHandler:^(ACEAPIResponse *response)
    {
       
         [SVProgressHUD dismiss];
        
         if(response.code == RCodeSuccess)
         {
             [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
              {
                   OrderListViewController *vc = [ACEGlobalObject. storyboardMenuBar instantiateViewControllerWithIdentifier:@"OrderListViewController"];
                
                  [self.navigationController pushViewController:vc animated:YES];
              }];
             
         }
         else if(response.code == RCodePaymentFail)
         {
             [self showAlertWithMessage:response.message];
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
-(void)showStateCityViewController:(BOOL)isState andSelectedState:(NSString *)stateID andSelectedCity:(NSString *)cityID
{
    SelectStateCityViewController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectStateCityViewController"];
    
    vc.isState       = isState  ;
    vc.stateId       = stateID  ;
    vc.cityId        = cityID   ;
    vc.delegate      = self     ;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)openSearchUserController
{
    SearchUserViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SearchUserViewController"];
    vc.delegate          = self;
    vc.isWorkAreaClient  = NO;
    
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)openChargeByController
{
     //[self.view endEditing:YES];
    ChargeByPopupViewController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ChargeByPopupViewController"];
    
    [self.view endEditing:YES];
    vc.delegate = self;
    
    if(![defaultAddress.cardNumber isKindOfClass:[NSNull class]])
    {
        if([defaultAddress.cardNumber isEqualToString:@""])
        {
            vc.shouldHideCC = YES;
        }
    }
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
   
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:vc animated:NO completion:nil];
}
-(BOOL)isValidInfo
{
    ZWTValidationResult result;
    
    if([txtCustomer.text isEqualToString:@""])
    {
        //[txtCustomer becomeFirstResponder];
        [self showErrorMessage:ACEBlankClientName belowView:txtCustomer];
        [scrlvbg setContentOffset:CGPointMake(0, 0)];
        return NO;
    }
    result = [txtAddress validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankAddress belowView:txtAddress];
        return NO;
    }
    if ([stateId isEqualToString:@""] || stateId.length == 0 || [stateId isEqualToString:@"0"])
    {
        [self showErrorMessage:ACEBlankState belowView:txtState];
        [scrlvbg setContentOffset:CGPointMake(0, txtState.y - 50)];
        return NO;
    }
    
    if ([cityId isEqualToString:@""] || cityId.length == 0 || [cityId isEqualToString:@"0"])
    {
        [self showErrorMessage:ACEBlankCity belowView:txtCity];
        [scrlvbg setContentOffset:CGPointMake(0, txtCity.y - 50)];
        return NO;
    }
   
    result = [txtZipCode validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankZipCode belowView:txtZipCode];
        return NO;
    }
    result = [txtZipCode validate:ZWTValidationTypeNumber showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEInvalidZipcode belowView:txtZipCode];
        return NO;
    }
    if(txtZipCode.text.length != 5)
    {
        [self showErrorMessage:ACEShortZipcode belowView:txtZipCode];
        return NO;
    }
    if(btnEmailToClient.isSelected)
    {
        result = [txtEmail validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
    
        if (result == ZWTValidationResultBlank)
        {
            [self showErrorMessage:ACEBlankEmail belowView:txtEmail];
            return NO;
        }
        else if (result == ZWTValidationResultInvalid)
        {
            [self showErrorMessage:ACEInvalidEmail belowView:txtEmail];
            return NO;
        }
    }
    
    if([txtChargeBy.text isEqualToString:@""] && (btnQuote.selected))
    {
        [self showErrorMessage:ACEBlankChargeBy belowView:txtChargeBy];
        [scrlvbg setContentOffset:CGPointMake(0, txtChargeBy.y - 50)];
        return NO;
    }
    if(![txtccEmail.text isEqualToString:@""])
    {
        result = [txtccEmail validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
        if (result == ZWTValidationResultInvalid)
        {
            [self showErrorMessage:ACEInvalidCCEmail belowView:txtccEmail];
            return NO;
        }
    }

    /*if ([txtvRecommendations.text isEqualToString:@""])
    {
       // txtvRecommendations.layer.borderWidth = 1.0;
       // txtvRecommendations.layer.borderColor = [UIColor redColor].CGColor;
        [self showErrorMessage:ACERecommendation belowView:txtvRecommendations];
        [txtvRecommendations becomeFirstResponder];
        return NO;
    }*/
    if(!btnEmailToClient.isSelected && [txtccEmail.text isEqualToString:@""])
    {
        [self showAlertWithMessage:ACENoEmailSelected];
        return NO;
    }
    
    return YES;
}
-(NSString *)getPartList
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for(NSDictionary *dict in selectedItem)
    {
        ACEParts *part = dict[OIKeyPart];
        
        NSDictionary *pdict = @{
                                PKeyId           : part.ID,
                                OIKeyIteamQty    : dict[OIKeyQunty]
                                };
        [arr addObject:pdict];
        
    }
    NSString *partStr = [[NSString alloc]initWithJSONObject:arr];
    return partStr;
}
#pragma mark - webservice Method
-(void)getAddressOfClient
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACEWebServiceAPI getDefaultAddress:[selectedClient.ID stringValue] completionHandler:^(ACEAPIResponse *response, ACEAddress *Address)
        {
             [SVProgressHUD dismiss];
            if(response.code == RCodeSuccess)
            {
                defaultAddress = Address;
                [self setAddressDetail];
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
                defaultAddress = [[ACEAddress alloc]init];
                [self setAddressDetail];
                [self showAlertWithMessage:response.message];
            }
            else if (response.error.localizedDescription)
            {
                [SVProgressHUD dismiss];
                 defaultAddress = [[ACEAddress alloc]init];
                [self setAddressDetail];
                //[self showAlertWithMessage:response.error.localizedDescription];
                [self showAlertWithMessage:ACEUnknownError];
            }
            
        }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

-(void)validateBillingAddress
{
    NSDictionary *billingAddress = @{
                                     CKeyID  : [selectedClient.ID stringValue],
                                     AdKeyAddress  : [txtAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                     AdKeyStateId   : @(stateId.intValue),
                                     AdKeyCityId    : @(cityId.intValue),
                                     AdKeyZipcode   : txtZipCode.text
                                     };
    
    if ([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACEWebServiceAPI validateBillingAddress:billingAddress completionHandler:^(ACEAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 defaultAddress.addressName = txtAddress.text   ;
                 defaultAddress.zipcode     = txtZipCode.text   ;
                 defaultAddress.company     = txtCompany.text   ;
                 defaultAddress.email       = txtEmail.text     ;
                 defaultAddress.stateId     = stateId           ;
                 defaultAddress.cityId      = cityId            ;
                 
                 if(!btnQuote.selected)
                 {
                     [self sendQuote];
                 }
                 else
                 {
                     [self openPaymentMethod];
                 }

             }
             else if (response.code == RCodeSessionExpired)
             {
                 [self showAlertFromWithMessageWithSingleAction:ACESessionExpired andHandler:^(UIAlertAction * _Nullable action)
                  {
                      [ACEUtil logoutUser];
                  }];
             }
             else if (response.code == RCodeUnauthorized)
             {
                 [self showAlertWithMessage:response.message];
             }
             else
             {
                 [self showAlertWithMessage:response.message];
             }
         }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

#pragma mark - UItextField Delegate Method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //[textField resignFirstResponder];
    if(textField == txtCustomer)
    {
        [self openSearchUserController];
    }
    else if(textField == txtState)
    {
        [self removeErrorMessageBelowView:txtState];
        [txtState.layer setBorderColor:[UIColor separatorColor].CGColor];
        
        [self showStateCityViewController:YES andSelectedState:stateId andSelectedCity:nil];
    }
    else if(textField == txtCity)
    {
        if(stateId == NULL)
        {
            [self showAlertWithMessage:ACESelectState];
            [self resignFirstResponder];
        }
        [self removeErrorMessageBelowView:txtCity];
        [txtCity.layer setBorderColor:[UIColor separatorColor].CGColor];
        [self showStateCityViewController:NO andSelectedState:stateId andSelectedCity:cityId];
    }
    return NO;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
    [self removeErrorMessageBelowView:textField];
    if (textField == txtZipCode)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        
        if (length > 5)
        {
            return NO;
        }
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    textView.layer.borderColor = [UIColor separatorColor].CGColor;
    [self removeErrorMessageBelowView:textView];
    return YES;
}
-(void)selectedStatecity:(NSDictionary *)dict andIsstate:(BOOL)isSatate
{
    if (isSatate)
    {
        stateId = [dict[GKeyId] stringValue];
        txtState.text = dict[GKeyName];
    }
    else
    {
        cityId = [dict[GKeyId] stringValue];
        txtCity.text = dict[GKeyName];
    }
//    if(isSatate)
//        //txtState.text = name;
//    else
//       // txtCity.text  = name;
}

#pragma mark - ZWTTextToolbarHandler delegate method
-(void)doneTap
{
    
}
#pragma mark - searchUserViewController Method
-(void)selectedUser:(ACEClient *)user
{
    txtCustomer.text = user.Name;
    txtCustomer.layer.borderColor = [UIColor separatorColor].CGColor;
    [self removeErrorMessageBelowView:txtCustomer];
    selectedClient   = user;
    [self getAddressOfClient];
}
#pragma mark - ChargeByPopupViewControllerDelegate Method
-(void)selectedOption:(NSString *)option
{
    txtChargeBy.text  = option;
    txtChargeBy.layer.borderColor = [UIColor separatorColor].CGColor;
    [self removeErrorMessageBelowView:txtChargeBy];
    selectedChargeBy  = option;
}
@end
