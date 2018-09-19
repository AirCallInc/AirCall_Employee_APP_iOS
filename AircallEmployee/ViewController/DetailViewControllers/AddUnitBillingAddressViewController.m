//
//  AddUnitBillingAddressViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 17/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AddUnitBillingAddressViewController.h"

@interface AddUnitBillingAddressViewController ()<ZWTTextboxToolbarHandlerDelegate,SelectedStateCity,UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel      *lblAmount      ;
@property (weak, nonatomic) IBOutlet ACETextField *txtCompany     ;
@property (weak, nonatomic) IBOutlet ACETextField *txtfAddress    ;
@property (weak, nonatomic) IBOutlet ACETextField *txtState       ;
@property (weak, nonatomic) IBOutlet ACETextField *txtCity        ;
@property (weak, nonatomic) IBOutlet ACETextField *txtZip         ;
@property (weak, nonatomic) IBOutlet ACETextField *txtEmail       ;
@property (weak, nonatomic) IBOutlet ACETextField *txtCCEmailAddress;

@property (weak, nonatomic) IBOutlet UIButton *btnEmailToClient     ;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlvbg          ;

@property ZWTTextboxToolbarHandler *textboxHandler;
@property NSMutableArray *arrTextBoxes;

@property ACEAddress *defaultAddress    ;

@property NSString   *stateId           ;
@property NSString   *cityId            ;

@end

@implementation AddUnitBillingAddressViewController

@synthesize lblAmount,txtZip,txtCity,txtEmail,txtState,txtfAddress,txtCCEmailAddress,scrlvbg,btnEmailToClient,txtCompany;

@synthesize arrUnits,totalAmount,arrTextBoxes,textboxHandler,defaultAddress,stateId,cityId,clientId;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareview];
}
#pragma mark - Helper Method
-(void)prepareview
{
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width,txtCCEmailAddress.y + txtCCEmailAddress.height + 25)];
    
    arrTextBoxes = [[NSMutableArray alloc]initWithObjects:txtCompany,txtfAddress,txtZip,txtEmail,txtCCEmailAddress, nil];
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvbg];
    
    textboxHandler.delegate = self;
    
    lblAmount.text    = [NSString stringWithFormat:@"$%0.2f",fabsf(totalAmount)];
    [self getAddressOfClient];
}
-(void)setAddressDetail
{
    txtfAddress.text    = defaultAddress.addressName    ;
    txtCompany.text     = defaultAddress.company        ;
    txtState.text       = defaultAddress.stateName      ;
    txtCity.text        = defaultAddress.cityName       ;
    txtZip.text         = defaultAddress.zipcode        ;
    txtEmail.text       = defaultAddress.email          ;
    stateId             = defaultAddress.stateId        ;
    cityId              = defaultAddress.cityId         ;
    
    [SVProgressHUD dismiss];
}
-(void)updateAddressDetail
{
    defaultAddress.addressName  = txtfAddress.text    ;
    defaultAddress.company      = txtCompany.text     ;
    defaultAddress.stateName    = txtState.text       ;
    defaultAddress.cityName     = txtCity.text        ;
    defaultAddress.zipcode      = txtZip.text         ;
    defaultAddress.email        = txtEmail.text       ;
    defaultAddress.stateId      = stateId             ;
    defaultAddress.cityId       = cityId              ;
}
-(void)showStateCityViewController:(BOOL)isState andSelectedState:(NSString *)stateID andSelectedCity:(NSString *)cityID
{
    SelectStateCityViewController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectStateCityViewController"];
    
    vc.isState       = isState;
    vc.stateId       = stateID;
    vc.cityId        = cityID;
    vc.delegate      = self;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
-(BOOL)isValidInfo
{
    ZWTValidationResult result;

    txtfAddress.text = [self trimmWhiteSpaceFrom:txtfAddress.text];
    
    result = [txtfAddress validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankAddress belowView:txtfAddress];
        return NO;
    }
    
    else if ([cityId isEqualToString:@""])
    {
        [self showErrorMessage:ACEBlankCity belowView:txtCity];
        return NO;
    }
    
    result = [txtZip validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        
        [self showErrorMessage:ACEBlankZipCode belowView:txtZip];
        return NO;
    }
    if(txtZip.text.length != 5)
    {
        [self showErrorMessage:ACEShortZipcode belowView:txtZip];
        return NO;
    }
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

    if(![txtCCEmailAddress.text isEqualToString:@""])
    {
        result = [txtCCEmailAddress validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
        
        if (result == ZWTValidationResultInvalid)
        {
            [self showErrorMessage:ACEInvalidCCEmail belowView:txtCCEmailAddress];
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Event Method
- (IBAction)btnEmailToClientTap:(UIButton *)btn
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
}
- (IBAction)btnProceedToPaymentTap:(id)sender
{
    if([self isValidInfo])
    {
        [self validateBillingAddress];
    }
}
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - webservice Method
-(void)getAddressOfClient
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACEWebServiceAPI getDefaultAddress:clientId completionHandler:^(ACEAPIResponse *response, ACEAddress *Address)
         {
             if(response.code == RCodeSuccess)
             {
                 defaultAddress = Address;
                 [self setAddressDetail];
             }
             else if(response.code == RCodeUnauthorized)
             {
                 [SVProgressHUD dismiss];
                 [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                  {
                      [ACEUtil logoutUser];
                  }];
             }
             else if (response.code == RCodeSessionExpired)
             {
                 [SVProgressHUD dismiss];
                 [self showAlertFromWithMessageWithSingleAction:ACESessionExpired andHandler:^(UIAlertAction * _Nullable action)
                  {
                      [ACEUtil logoutUser];
                  }];
             }
             else if (response.message)
             {
                 [SVProgressHUD dismiss];
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
                                     CKeyID  : clientId,
                                     AdKeyAddress  : [txtfAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                     AdKeyStateId   : @(stateId.intValue),
                                     AdKeyCityId    : @(cityId.intValue),
                                     AdKeyZipcode   : txtZip.text
                                    };
    
    if ([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACEWebServiceAPI validateBillingAddress:billingAddress completionHandler:^(ACEAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 [self updateAddressDetail];
                 
                 AddUnitPaymentViewController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"AddUnitPaymentViewController"];
                 
                 vc.address          = defaultAddress;
                 vc.arrUnitInfo      = arrUnits      ;
                 vc.clientId         = clientId      ;
                 vc.totalAmount      = totalAmount   ;
                 vc.paymentOption    = _paymentOption;
                 vc.CCEmail          = txtCCEmailAddress.text;
                 
                 [self.navigationController pushViewController:vc animated:YES];
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //[textField resignFirstResponder];
    
    if(textField == txtState)
    {
        [self showStateCityViewController:YES andSelectedState:stateId andSelectedCity:nil];
    }
    else if(textField == txtCity)
    {
        [self showStateCityViewController:NO andSelectedState:stateId andSelectedCity:cityId];
    }
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
    [self removeErrorMessageBelowView:textField];
    
    if (textField == txtZip)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        
        if(length > 5)
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

#pragma mark - SelectedStateCity delegate method
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
    
}
#pragma mark - ZWTTextToolbarHandler delegate method
-(void)doneTap
{
    
}
@end
