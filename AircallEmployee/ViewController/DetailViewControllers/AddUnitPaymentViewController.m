//
//  AddUnitPaymentViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 17/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AddUnitPaymentViewController.h"

@interface AddUnitPaymentViewController ()<CardIOPaymentViewControllerDelegate,SignatureCaptured,ZWTTextboxToolbarHandlerDelegate,ExpYearMonthPopupViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *vwCheck;
@property (strong, nonatomic) IBOutlet ACETextField *txtCheckNum;
@property (strong, nonatomic) IBOutlet SAMTextView  *txtvNotes;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckFrontImage;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckBackImage;
@property (strong, nonatomic) IBOutlet UIButton *btnFrontDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnBackDelete;

@property (strong, nonatomic) IBOutlet UIView *vwCC;

@property (strong, nonatomic) IBOutlet ACETextField *txtNameOnCard;
@property (strong, nonatomic) IBOutlet ACETextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet ACETextField *txtCVV;
@property (strong, nonatomic) IBOutlet ACETextField *txtExpMonth;
@property (strong, nonatomic) IBOutlet ACETextField *txtExpYear;

@property (strong, nonatomic) IBOutlet UIButton *btnsignature;
@property (strong, nonatomic) IBOutlet UIButton *btnVisa;
@property (strong, nonatomic) IBOutlet UIButton *btnMasterCard;
@property (strong, nonatomic) IBOutlet UIButton *btndiscover;
@property (strong, nonatomic) IBOutlet UIButton *btnAmericanExp;

@property BOOL     isFrontOrBack;

@property (strong, nonatomic) IBOutlet UIView *vwPO;
@property (strong, nonatomic) IBOutlet ACETextField *txtPONum;
@property (strong, nonatomic) IBOutlet ACETextField *txtPCheckNum;
@property (strong, nonatomic) IBOutlet SAMTextView  *txtvPACNotes;

@property (strong, nonatomic) IBOutlet UIScrollView *scrlvbg;

@property NSMutableArray *arrTextboxes;
@property ZWTTextboxToolbarHandler *textboxHandler;

@property NSString *cardType;

@end

@implementation AddUnitPaymentViewController

@synthesize vwCC,txtCVV,txtExpYear,txtExpMonth,txtCardNumber,txtNameOnCard,btnVisa,btndiscover,btnsignature,btnMasterCard,btnAmericanExp,scrlvbg;

@synthesize vwCheck,txtCheckNum,txtvNotes,btnCheckFrontImage,btnCheckBackImage,btnFrontDelete,btnBackDelete,isFrontOrBack;

@synthesize vwPO,txtPONum,txtPCheckNum,txtvPACNotes;

@synthesize arrTextboxes,textboxHandler,address,arrUnitInfo,cardType,clientId,totalAmount,CCEmail;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CardIOUtilities preload];
}
#pragma mark - Helper Method
-(void)prepareView
{
    btnCheckFrontImage.layer.borderColor = [UIColor borderColor].CGColor;
    btnCheckFrontImage.layer.borderWidth = 1.0;
    btnCheckBackImage.layer.borderColor  = [UIColor borderColor].CGColor;
    btnCheckBackImage.layer.borderWidth  = 1.0;
    
    btnFrontDelete.hidden        = YES;
    btnBackDelete.hidden         = YES;
    
    if([_paymentOption isEqualToString:CHKeyCheque])
    {
        vwCheck.hidden = NO;
        vwPO.hidden    = YES;
        vwCC.hidden    = YES;
        
        arrTextboxes       = [[NSMutableArray alloc]initWithObjects:txtCheckNum,txtvNotes, nil];
        
        scrlvbg.contentSize = CGSizeMake(scrlvbg.width, vwCheck.y+ vwCheck.height + 20);
    }
    else if ([_paymentOption isEqualToString:CHKeyPO])
    {
        vwCheck.hidden = YES;
        vwPO.hidden    = NO;
        vwCC.hidden    = YES;
        
        arrTextboxes       = [[NSMutableArray alloc]initWithObjects:txtPONum,txtPCheckNum,txtvPACNotes, nil];
        
        scrlvbg.contentSize = CGSizeMake(scrlvbg.width, vwPO.y+ vwPO.height + 20);
    }
    else if ([_paymentOption isEqualToString:CHKeyCC])
    {
        vwCheck.hidden = YES;
        vwPO.hidden    = YES;
        vwCC.hidden    = NO;
        
        arrTextboxes       = [[NSMutableArray alloc]initWithObjects:txtNameOnCard,txtCardNumber,txtCVV, nil];
        
        scrlvbg.contentSize = CGSizeMake(scrlvbg.width, vwCC.y+ vwCC.height + 20);
        
        btnsignature.layer.borderColor  = [UIColor borderColor].CGColor;
        btnsignature.layer.borderWidth  = 1.0;
        cardType = ACECardVisa;
        //[self setDefaultExpireDetail];
        [self setSelectedCardType];
    }
    
    textboxHandler          = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextboxes andScroll:scrlvbg];
    
    textboxHandler.delegate = self;
    
    // txtNameOnCard.text  = address.nameOnCard ;
    //txtCardNumber.text  = address.cardNumber ;
   // txtExpYear.text     = address.expYear    ;
   // txtExpMonth.text    = address.expMonth   ;
  //  cardType            = address.cardType   ;
    
//    if(cardType.length > 0)
//    {
//       [self setSelectedCardType];
//    }
//    else
//    {
    
   // }
}
-(void)setSelectedButton:(UIButton *)btn anDeSelect:(UIButton*)btn1 and:(UIButton*)btn2 and:(UIButton*)btn3
{
    [btn setImage:[UIImage imageNamed:@"radiobutton-selected"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
}
-(void)openexpireDatePopUp:(NSString *)option
{
    ExpYearMonthPopupViewController *vc  = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ExpYearMonthPopupViewController"];
    
    vc.selectedOption = option;
    vc.delegate       = self;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:vc animated:NO completion:nil];
    
}
-(void)setDefaultExpireDetail
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    txtExpYear.text  = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"MM"];
    txtExpMonth.text =  [formatter stringFromDate:[NSDate date]];
    
}
-(void)setSelectedCardType
{
    if([cardType isEqualToString:ACECardVisa])
    {
        [self btnCardTypeTap:btnVisa];
    }
    else if ([cardType isEqualToString:ACECardMaseter])
    {
        [self btnCardTypeTap:btnMasterCard];
    }
    else if ([cardType isEqualToString:ACECardDiscover])
    {
        [self btnCardTypeTap:btndiscover];
    }
    else if ([cardType isEqualToString:ACECardAmericanExpress])
    {
        [self btnCardTypeTap:btnAmericanExp];
    }
    
}
-(void)setScannedDetail:(CardIOCreditCardInfo *)cardInfo
{
    txtCardNumber.text = cardInfo.cardNumber;
    txtNameOnCard.text = cardInfo.cardholderName;
    
    //txtExpMonth.text   = [NSString stringWithFormat:@"%lu",(unsigned long)cardInfo.expiryMonth];
    // txtExpYear.text    = [NSString stringWithFormat:@"%lu",(unsigned long)cardInfo.expiryYear];
    
    txtCVV.text        = cardInfo.cvv;
    
    cardType           = [CardIOCreditCardInfo displayStringForCardType:cardInfo.cardType usingLanguageOrLocale:@"en"];
    
    [self setSelectedCardType];
}

-(BOOL)isValidDetail
{
    ZWTValidationResult result;
    
    result = [txtNameOnCard validate:ZWTValidationTypeName showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankNameOnCard belowView:txtNameOnCard];
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEInvalidNameOnCard belowView:txtNameOnCard];
        return NO;
    }
    
    result = [txtCardNumber validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankCardNumber belowView:txtCardNumber];
        
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEInvalidCardNumber belowView:txtCardNumber];
        
        return NO;
    }
    else if([txtCardNumber.text length] > 16 || [txtCardNumber.text length] < 13)
    {
        txtCardNumber.layer.borderColor = [UIColor redColor].CGColor;
        txtCardNumber.layer.borderWidth = 1.0;
        [txtCardNumber becomeFirstResponder];
        [self showErrorMessage:ACEInvalidCardNumberLength belowView:txtCardNumber];
        
        return NO;
    }
    result = [txtExpMonth validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankExpMonth belowView:txtExpMonth];
        return NO;
    }
    result = [txtExpYear validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankExpYear belowView:txtExpYear];
        return NO;
    }

    NSDateComponents *components = [[NSCalendar currentCalendar] components:  NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger month = [components month];
    NSInteger year  = [components year];
    if([txtExpMonth.text intValue] < month && year == [txtExpYear.text intValue])
    {
        txtExpMonth.layer.borderColor = [UIColor redColor].CGColor;
        txtExpMonth.layer.borderWidth = 1.0;
        [txtExpMonth becomeFirstResponder];
        [self showErrorMessage:ACEInvalidExpDate belowView:txtExpMonth];
        return NO;
    }
    
    result = [txtCVV validate:ZWTValidationTypeNumber showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankCVV belowView:txtCVV];
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEInvalidCardNumber belowView:txtCVV];
        return NO;
    }
    else if (txtCVV.text.length < 3)
    {
        [self showErrorMessage:ACEInvalidCVV belowView:txtCVV];
        return NO;
    }
    return YES;
}
-(BOOL)isValidChequeDetail
{
    if (btnCheckFrontImage.currentBackgroundImage)
    {
        if(!btnCheckBackImage.currentBackgroundImage)
        {
            [self showAlertWithMessage:ACEBlankChequeBackImage];
            return NO;
        }
        return YES;
    }
    else if (btnCheckBackImage.currentBackgroundImage)
    {
        if(!btnCheckFrontImage.currentBackgroundImage)
        {
            [self showAlertWithMessage:ACEBlankChequeFrontImage];
            return NO;
        }
        return YES;
    }
    
    return YES;
}
-(BOOL)isValidPODetail
{
    ZWTValidationResult result;
    
//    result = [txtPONum validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (![txtPONum.text isEqualToString:@""])
    {
         result = [txtPONum validate:ZWTValidationTypeAlphaNumericWithspace showRedRect:YES getFocus:YES];
        
            if(result == ZWTValidationResultInvalid)
            {
                [self showErrorMessage:ACEInvalidPONumber belowView:txtPONum];
                return NO;
            }
    }
    
    return YES;
}
-(void)openReceiptController:(NSDictionary *)dict
{
    AddunitReceiptViewController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"AddunitReceiptViewController"];
    vc.unitInfo      = dict;
    vc.paymentOption = _paymentOption;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - Event Method
- (IBAction)btnScanCardTap:(id)sender
{
    CardIOPaymentViewController *cpvc = [[CardIOPaymentViewController alloc]initWithPaymentDelegate:self];
    
    //cpvc.detectionMode = cardiodete;
    cpvc.hideCardIOLogo             = YES;
    cpvc.suppressScanConfirmation   = YES;
    cpvc.collectCardholderName      = YES;
    cpvc.disableManualEntryButtons  = YES;
    cpvc.collectExpiry              = YES;
    //cpvc.collectCVV =YES;
    cpvc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:cpvc animated:YES completion:nil];
}

- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCardTypeTap:(UIButton *)btn
{
    if(btn == btnVisa)
    {
        cardType = ACECardVisa;
        [self setSelectedButton:btnVisa anDeSelect:btnMasterCard and:btndiscover and:btnAmericanExp];
    }
    else if (btn == btnMasterCard)
    {
        cardType = ACECardMaseter;
        [self setSelectedButton:btnMasterCard anDeSelect:btnVisa and:btndiscover and:btnAmericanExp];
    }
    else if (btn == btndiscover)
    {
        cardType = ACECardDiscover;
        [self setSelectedButton:btndiscover anDeSelect:btnVisa and:btnMasterCard and:btnAmericanExp];
    }
    else if (btn == btnAmericanExp)
    {
        cardType = ACECardAmericanExpress;
        [self setSelectedButton:btnAmericanExp anDeSelect:btnVisa and:btnMasterCard and:btndiscover];
    }
}
- (IBAction)btnExpMnthTap:(id)sender
{
    //txtExpMonth.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:txtExpMonth];
    txtExpMonth.layer.borderColor = [UIColor separatorColor].CGColor;
    
    [self openexpireDatePopUp:@"ExpMonth"];
}
- (IBAction)btnExpYearTap:(id)sender
{
    [self removeErrorMessageBelowView:txtExpMonth];
    txtExpMonth.layer.borderColor = [UIColor separatorColor].CGColor;
    
    [self openexpireDatePopUp:@"ExpYear"];
}
- (IBAction)btnSignatureTap:(id)sender
{
    [textboxHandler btnDoneTap];
    
    SignatureViewController *svc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SignatureViewController"];
    svc.delegate = self;
    
    [self presentViewController:svc animated:YES completion:nil];
}
- (IBAction)btnPaymentTap:(id)sender
{
    
   if([_paymentOption isEqualToString:CHKeyCC])
   {
       if([self isValidDetail])
       {
           if([ACEUtil reachable])
           {
               [self submitCardInfo];
           }
           else
           {
               [self showAlertWithMessage:ACENoInternet];
           }
       }
   }
   else if ([_paymentOption isEqualToString:CHKeyCheque])
   {
       if([self isValidChequeDetail])
       {
           if([ACEUtil reachable])
           {
               [self submitCardInfo];
           }
           else
           {
               [self showAlertWithMessage:ACENoInternet];
           }
       }
   }
   else
   {
       if([ACEUtil reachable])
       {
           if([self isValidPODetail])
           {
               [self submitCardInfo];
           }
       }
       else
       {
           [self showAlertWithMessage:ACENoInternet];
       }
   }
}
- (IBAction)btnCheckImageTap:(UIButton *)sender
{
    if(sender == btnCheckFrontImage)
    {
        isFrontOrBack = YES;
    }
    else if(sender == btnCheckBackImage)
    {
        isFrontOrBack = NO;
    }
    [self askImageSource];
}
- (IBAction)btnDeleteImageTap:(UIButton *)sender
{
    if(sender == btnFrontDelete)
    {
        [btnCheckFrontImage setTitle:@"Tap to take front image of Check" forState:UIControlStateNormal];
        [btnCheckFrontImage setBackgroundImage:nil forState:UIControlStateNormal];
        btnFrontDelete.hidden                     = YES;
        btnCheckFrontImage.userInteractionEnabled = YES;
    }
    else if (sender == btnBackDelete)
    {
         [btnCheckBackImage setTitle:@"Tap to take back image of Check" forState:UIControlStateNormal];
         [btnCheckBackImage setBackgroundImage:nil forState:UIControlStateNormal];
         btnBackDelete.hidden              = YES;
         btnCheckBackImage.userInteractionEnabled = YES;
    }
    
}
#pragma mark - SignatureCaptured delegate method
-(void)Signature:(UIImage *)signature
{
    [btnsignature setTitle:@"" forState:UIControlStateNormal];
    [btnsignature setBackgroundImage:signature forState:UIControlStateNormal];
}
#pragma mark - CardIOPaymentViewControllerDelegate methods
-(void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    // NSLog(@"Scan succeeded with info: %@", cardInfo);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setScannedDetail:cardInfo];
}
-(void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZWTTextboxToolbarHandler Delegate Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
    [self removeErrorMessageBelowView:textField];
    
    if(textField == txtCVV)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        if([cardType isEqualToString:ACECardAmericanExpress]&& length > 5)
        {
            return NO;
        }
        else if (length > 4)
        {
            return NO;
        }

        return YES;
        
    }
    else if (textField == txtCardNumber)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        if (length > 16)
        {
            return NO;
        }
        return YES;
    }
    return YES;
}

-(void)doneTap
{
    
}

#pragma mark - ExpYearMonthPopupViewControllerDelegate method
-(void)selectedValue:(NSString *)value forOption:(NSString *)option
{
    if([option isEqualToString:@"ExpYear"])
    {
        txtExpYear.text = value;
    }
    else if([option isEqualToString:@"ExpMonth"])
    {
        txtExpMonth.text = value;
    }
}

#pragma mark - Webservice Method
-(void)submitCardInfo
{
    [SVProgressHUD show];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:clientId forKey:CKeyID];
    [dict setValue:address.addressName forKey:ACKeyAddress];
    [dict setValue:address.cityId forKey:AdKeyCityId];
    [dict setValue:address.zipcode forKey:AdKeyZipcode];
    [dict setValue:address.company forKey:ADKeycompany];
    [dict setValue:address.stateId forKey:AdKeyStateId];
    [dict setValue:@(totalAmount) forKey:OKeyTotalAmt];
    [dict setValue:ACEGlobalObject.user.userID forKey:UKeyEmployeeID];
    [dict setValue:_paymentOption forKey:ACKeyPaymentMethod];
    [dict setValue:CCEmail forKey:OKeyCCEmail];
    
    if([_paymentOption isEqualToString:CHKeyCC])
    {
        [dict setValue:txtCVV.text forKey:GKeyCVV];
        [dict setValue:txtCardNumber.text forKey:GKeyCardNumber];
        [dict setValue:cardType forKey:GKeyCardType];
        [dict setValue:txtExpMonth.text forKey:GKeyExpiryMonth];
        [dict setValue:txtExpYear.text forKey:GKeyExpiryYear];
        [dict setValue:txtNameOnCard.text forKey:GKeyNameOnCard];
        [dict setValue:@"" forKey:GKeyStipeCardId];
    }
    else if ([_paymentOption isEqualToString:CHKeyCheque])
    {
        [dict setValue:txtvNotes.text forKey:GKeyAcocuntingNotes];
        [dict setValue:txtCheckNum.text forKey:GKeyChequeNo];
        
    }
    else if ([_paymentOption isEqualToString:CHKeyPO])
    {
        [dict setValue:txtvPACNotes.text forKey:GKeyAcocuntingNotes];
        [dict setValue:txtPONum.text forKey:ACKeyPoNum];
        [dict setValue:txtPCheckNum.text forKey:GKeyChequeNo];
    }
    NSDictionary *imageDict;
    
    UIImage *simage     = [[UIImage alloc]init];
    UIImage *frontImage = [[UIImage alloc]init];
    UIImage *backImage  = [[UIImage alloc]init];
    
    if(btnsignature.currentBackgroundImage)
    {
        simage = btnsignature.currentBackgroundImage;
    }
    if(btnCheckFrontImage.currentBackgroundImage)
    {
        frontImage = btnCheckFrontImage.currentBackgroundImage;
    }
    if(btnCheckBackImage.currentBackgroundImage)
    {
        backImage = btnCheckBackImage.currentBackgroundImage;
    }
    imageDict = @{
                  OKeySignature         : simage,
                  GKeyChequeFrontImage  : frontImage,
                  GKeyChequeBackImage   : backImage
                  };
    
    [ACEWebServiceAPI validateCardInfo:dict withImage:imageDict completionHandler:^(ACEAPIResponse *response, NSDictionary *dictUnitInfo)
    {
        [SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            [self openReceiptController:dictUnitInfo];
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
            //[self showAlertWithMessage:response.error.localizedDescription];
            [self showAlertWithMessage:ACEUnknownError];
        }
    }];
    
}
#pragma mark - UIImagePicker Method

-(void)askImageSource
{
    [self.view endEditing:YES];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:appName
                                                                         message:ACETextAskImageSource
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:ACETextFromCamera
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectCheckImageFrom:UIImagePickerControllerSourceTypeCamera];
                                }];
    
    UIAlertAction *fromAlbum = [UIAlertAction actionWithTitle:ACETextFromLibrary
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectCheckImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
                                }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:ACETextCancel
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                             {
                                 [actionSheet dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:fromAlbum];
    [actionSheet addAction:cancel];
    
    actionSheet.popoverPresentationController.sourceView = self.view;
    actionSheet.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    
    actionSheet.popoverPresentationController.sourceRect = CGRectMake(self.view.width/2, self.view.height/2 , 1.0, 1.0);
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)selectCheckImageFrom:(UIImagePickerControllerSourceType)sourceType
{
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
        
        BOOL isAuthorizedLibrary = NO;
        
        if (photoStatus == PHAuthorizationStatusAuthorized)
        {
            // Access has been granted.
            isAuthorizedLibrary = YES;
            [self openImagePicker:sourceType];
        }
        else if (photoStatus == PHAuthorizationStatusDenied)
        {
            // Access has been denied.
        }
        else if (photoStatus == PHAuthorizationStatusNotDetermined)
        {
            // Access has not been determined.
        }
        else if (photoStatus == PHAuthorizationStatusRestricted)
        {
            // Restricted access - normally won't happen.
        }
        
        if (isAuthorizedLibrary == NO)
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus Authstatus)
             {
                 if (Authstatus == PHAuthorizationStatusAuthorized)
                 {
                     [self openImagePicker:sourceType];
                 }
                 else
                 {
                     // [self showAlertWithMessage:ACEAllowAccessPhotoLibrary];
                     NSString *msg = [NSString stringWithFormat:@"%@ does not have access to your photos. To enable access, tap Settings and turn on Photos.",appName];
                     
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                     
                     [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
                     
                     [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                       }]];
                     
                     [self presentViewController:alert animated:YES completion:nil];
                 }
             }];
        }
        
    }
    else if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        
        BOOL isAuthorizedCamera = NO;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if(authStatus == AVAuthorizationStatusAuthorized)
        {
            isAuthorizedCamera = YES;
            [self openImagePicker:sourceType];
        }
        else if(authStatus == AVAuthorizationStatusDenied)
        {
            // denied
        }
        else if(authStatus == AVAuthorizationStatusRestricted)
        {
            // restricted, normally won't happen
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined)
        {
            // not determined?!
        }
        else
        {
            // impossible, unknown authorization status
        }
        
        if (isAuthorizedCamera == NO)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        [self openImagePicker:sourceType];
                                    });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        //[self showAlertWithMessage:ACEAllowAccessCamera];
                                        NSString *msg = [NSString stringWithFormat:@"%@ does not have access to your camera. To enable access, tap Settings and turn on Camera.",appName];
                                        
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
                                        
                                        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                                          {
                                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                          }]];
                                        [self presentViewController:alert animated:YES completion:nil];
                                    });
                 }
             }];
        }
    }
    else
    {
        NSAssert(NO, @"Permission type not found");
    }
}

-(void)openImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setAllowsEditing:YES];
    imagePicker.delegate      = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType    = sourceType;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
         if(isFrontOrBack == YES)
         {
             [btnCheckFrontImage setTitle:@"" forState:UIControlStateNormal];
             [btnCheckFrontImage setBackgroundImage:selectedImage forState:UIControlStateNormal];
             btnFrontDelete.hidden                     = NO;
             btnCheckFrontImage.userInteractionEnabled = NO;
         }
         else if(isFrontOrBack == NO)
         {
             [btnCheckBackImage setTitle:@"" forState:UIControlStateNormal];
             [btnCheckBackImage setBackgroundImage:selectedImage forState:UIControlStateNormal];
             
             btnBackDelete.hidden                     = NO;
             btnCheckBackImage.userInteractionEnabled = NO;
         }
     }];
}

@end
