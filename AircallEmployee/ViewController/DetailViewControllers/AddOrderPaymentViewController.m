//
//  AddOrderPaymentViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 08/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AddOrderPaymentViewController.h"

@interface AddOrderPaymentViewController ()<CardIOPaymentViewControllerDelegate,SignatureCaptured,ZWTTextboxToolbarHandlerDelegate,SelectDatePopupViewControllerdelegate,ExpYearMonthPopupViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property NSMutableArray *arrTextboxes;
@property ZWTTextboxToolbarHandler *textboxHandler;

@property (strong, nonatomic) IBOutlet UIScrollView *scrlvPayment;
@property (strong, nonatomic) IBOutlet ACETextField *txtNameOnCard;
@property (strong, nonatomic) IBOutlet ACETextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet ACETextField *txtExpMonth;
@property (strong, nonatomic) IBOutlet ACETextField *txtExpYear;
@property (strong, nonatomic) IBOutlet ACETextField *txtCVV;
@property (strong, nonatomic) IBOutlet ACETextField *txtCheckNum;
@property (strong, nonatomic) IBOutlet ACETextField *txtBankName;
@property (strong, nonatomic) IBOutlet ACETextField *txtPoNum;
@property (strong, nonatomic) IBOutlet SAMTextView  *txtvCheckNotes;
@property (strong, nonatomic) IBOutlet SAMTextView  *txtvPONotes;

@property (strong, nonatomic) IBOutlet UIImageView *imgCardType;

@property (strong, nonatomic) IBOutlet UIButton *btnScanCard;
@property (strong, nonatomic) IBOutlet UIButton *btnSignature;
@property (strong, nonatomic) IBOutlet UIButton *btnVisa;
@property (strong, nonatomic) IBOutlet UIButton *btnMasterCard;
@property (strong, nonatomic) IBOutlet UIButton *btnDiscover;
@property (strong, nonatomic) IBOutlet UIButton *btnAmericanExp;
@property (strong, nonatomic) IBOutlet UIButton *btnExpMnth;
@property (strong, nonatomic) IBOutlet UIButton *btnExpYear;
@property (strong, nonatomic) IBOutlet UIButton *btnFrontImage;
@property (strong, nonatomic) IBOutlet UIButton *btnBackImage;
@property (strong, nonatomic) IBOutlet UIButton *btnDelFrontCheck;
@property (strong, nonatomic) IBOutlet UIButton *btnDelBackCheck;

@property (strong, nonatomic) IBOutlet UIView *vwCheque;
@property (strong, nonatomic) IBOutlet UIView *vwCard;
@property (strong, nonatomic) IBOutlet UIView *vwPO;

@property (strong, nonatomic) IBOutlet ACELabel *lblChequeDate;

@property NSString          *cardType;
@property NSDate            *chequeDate;
@property NSDateFormatter   *formatter;
@property int               frontOrBack; //1 for front 2 for back

@end

@implementation AddOrderPaymentViewController

#pragma mark - ACEViewController Method

@synthesize imgCardType,txtCardNumber,txtExpYear,txtExpMonth,txtPoNum,txtNameOnCard,txtCVV,btnScanCard,btnSignature,btnExpMnth,btnExpYear,textboxHandler,arrTextboxes,scrlvPayment,cardType,frontOrBack;

@synthesize txtCheckNum,txtvCheckNotes,txtvPONotes,vwCard,vwCheque,vwPO,txtBankName,selectedOption,lblChequeDate,chequeDate;

@synthesize btnVisa,btnDiscover,btnMasterCard,btnAmericanExp,btnFrontImage,btnBackImage,btnDelFrontCheck,btnDelBackCheck;

@synthesize clientId,arrSelectedParts,recomm,address,ccEmail,formatter,isEmailToClient;

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
-(void)prepareView
{
    btnSignature.layer.borderColor  = [UIColor borderColor].CGColor;
    btnSignature.layer.borderWidth  = 1.0;
    
    btnFrontImage.layer.borderColor = [UIColor borderColor].CGColor;
    btnFrontImage.layer.borderWidth = 1.0;
    btnBackImage.layer.borderColor  = [UIColor borderColor].CGColor;
    btnBackImage.layer.borderWidth  = 1.0;
    
    btnDelFrontCheck.hidden        = YES;
    btnDelBackCheck.hidden         = YES;
    scrlvPayment.contentSize       = CGSizeMake(scrlvPayment.width, scrlvPayment.height);
    formatter                      = [[NSDateFormatter alloc]init];
    if([selectedOption isEqualToString:CHKeyCheque])
    {
        vwCheque.hidden = NO    ;
        vwCard.hidden   = YES   ;
        vwPO.hidden     = YES   ;
        
        //arrTextboxes    = [[NSMutableArray alloc]initWithObjects:txtCheckNum,txtBankName, nil];
        arrTextboxes    = [[NSMutableArray alloc]initWithObjects:txtCheckNum,txtvCheckNotes, nil];
        
        cardType        = @" ";
        
        scrlvPayment.contentSize = CGSizeMake(scrlvPayment.width, vwCheque.y+ vwCheque.height);
        [formatter setDateFormat:@"MMM dd, yyyy"];
        lblChequeDate.text = [formatter stringFromDate:[NSDate date]];
        chequeDate         = [NSDate date];
    }
    else if([selectedOption isEqualToString:CHKeyNewCC])
    {
        btnScanCard.enabled = YES  ;
        btnScanCard.alpha   = 1.0  ;
        vwCheque.hidden     = YES  ;
        vwCard.hidden       = NO   ;
        vwPO.hidden         = YES  ;
        arrTextboxes        = [[NSMutableArray alloc]initWithObjects:txtNameOnCard,txtCardNumber,txtCVV, nil];
        scrlvPayment.contentSize = CGSizeMake(scrlvPayment.width, vwCard.y+ vwCard.height);
        
        //[self setDefaultExpireDetail];
        [self btnCardtypeTap:btnVisa];
        
    }
    else if ([selectedOption isEqualToString:CHKeyCCOnFile])
    {
        scrlvPayment.contentSize = CGSizeMake(scrlvPayment.width, vwCard.y+ vwCard.height);
        
        arrTextboxes = [[NSMutableArray alloc]initWithObjects:txtNameOnCard,txtCardNumber,txtCVV, nil];
        
        btnScanCard.enabled = NO   ;
        btnScanCard.alpha   = 0.6  ;
        
        vwCheque.hidden     = YES  ;
        vwCard.hidden       = NO   ;
        vwPO.hidden         = YES  ;
        
        txtNameOnCard.text  = address.nameOnCard ;
        txtCardNumber.text  = address.cardNumber ;
        txtExpYear.text     = address.expYear    ;
        txtExpMonth.text    = address.expMonth   ;
        cardType            = address.cardType   ;
        
        txtNameOnCard.enabled  = NO ;
        txtCardNumber.enabled  = NO ;
        txtExpYear.enabled     = NO ;
        txtExpMonth.enabled    = NO ;
        
        btnMasterCard.userInteractionEnabled  = NO ;
        btnVisa.userInteractionEnabled        = NO ;
        btnDiscover.userInteractionEnabled    = NO ;
        btnAmericanExp.userInteractionEnabled = NO ;
        
        btnExpMnth.userInteractionEnabled     = NO ;
        btnExpYear.userInteractionEnabled     = NO ;
        
        [self setSelectedCardType];
    }
    else if([selectedOption isEqualToString:CHKeyPO])
    {
        vwCheque.hidden     = YES  ;
        vwCard.hidden       = YES  ;
        vwPO.hidden         = NO   ;
        
        scrlvPayment.contentSize = CGSizeMake(scrlvPayment.width, vwPO.y+ vwPO.height);
        
        arrTextboxes = [[NSMutableArray alloc]initWithObjects:txtPoNum,txtvPONotes, nil];
    }
    textboxHandler          = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextboxes andScroll:scrlvPayment];
    textboxHandler.delegate = self;
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
    [formatter setDateFormat:@"yyyy"];
    txtExpYear.text  = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"MM"];
    txtExpMonth.text =  [formatter stringFromDate:[NSDate date]];

}
-(void)setSelectedCardType
{
    if([cardType isEqualToString:ACECardVisa])
    {
        [self btnCardtypeTap:btnVisa];
    }
    else if ([cardType isEqualToString:ACECardMaseter])
    {
        [self btnCardtypeTap:btnMasterCard];
    }
    else if ([cardType isEqualToString:ACECardDiscover])
    {
        [self btnCardtypeTap:btnDiscover];
    }
    else if ([cardType isEqualToString:ACECardAmericanExpress])
    {
        [self btnCardtypeTap:btnAmericanExp];
    }

}
#pragma mark - Webservice Method
-(void)submitOrder
{
    [SVProgressHUD show];
    NSDictionary * dict = @{
                            OKeyClientId    : clientId,
                            UKeyEmployeeID  : ACEGlobalObject.user.userID,
                            OKeyAddress     : address.addressName,
                            OKeyCity        : address.cityId,
                            OKeyState       : address.stateId,
                            OKeyZip         : address.zipcode,
                            OKeyEmail       : address.email,
                            ADKeycompany    : address.company,
                            OKeyChargeBy    : selectedOption,
                            OKeyRecomm      : recomm,
                            OKeyCCEmail     : ccEmail,
                            GKeyCardNumber  : txtCardNumber.text,
                            GKeyCardType    : cardType,
                            GKeyNameOnCard  : txtNameOnCard.text,
                            GKeyExpiryMonth : txtExpMonth.text,
                            GKeyExpiryYear  : txtExpYear.text,
                            GKeyCVV         : txtCVV.text,
                            OKeyEmailToClient : @(YES),
                            OKeyIteamList   : [self getPartList],
                            GKeyChequeNo    : txtCheckNum.text,
                            GKeyAcocuntingNotes : txtvCheckNotes.text,
                            //GKeyBankName    : txtBankName.text,
                            GKeyChequeDate  : [NSString stringWithFormat:@"%@",chequeDate]
                            };
    
    NSDictionary *imageDict;
    
    UIImage *simage     = [[UIImage alloc]init];
    UIImage *frontImage = [[UIImage alloc]init];
    UIImage *backImage  = [[UIImage alloc]init];
    
    if(btnSignature.currentBackgroundImage)
    {
        simage = btnSignature.currentBackgroundImage;
    }
    if(btnFrontImage.currentBackgroundImage)
    {
        frontImage = btnFrontImage.currentBackgroundImage;
    }
    if(btnBackImage.currentBackgroundImage)
    {
        backImage = btnBackImage.currentBackgroundImage;
    }
    imageDict = @{
                  OKeySignature         : simage,
                  GKeyChequeFrontImage  : frontImage,
                  GKeyChequeBackImage   : backImage
                  };
    [ACEWebServiceAPI submitOrderPayment:dict withSignatureImage:imageDict completionHandler:^(ACEAPIResponse *response ,NSDictionary *dictParts)
    {
        [SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
             {
                 AddOrderReceiptViewController *vc = [ACEGlobalObject. storyboardDashboard instantiateViewControllerWithIdentifier:@"AddOrderReceiptViewController"];
                 
                 vc.dictReceiptData = dictParts;
                 
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
#pragma mark - Event Method

- (IBAction)btnCardtypeTap:(UIButton *)btn
{
    if(btn == btnVisa)
    {
        cardType = ACECardVisa;
        [self setSelectedButton:btnVisa anDeSelect:btnMasterCard and:btnDiscover and:btnAmericanExp];
    }
    else if (btn == btnMasterCard)
    {
        cardType = ACECardMaseter;
        [self setSelectedButton:btnMasterCard anDeSelect:btnVisa and:btnDiscover and:btnAmericanExp];
    }
    else if (btn == btnDiscover)
    {
        cardType = ACECardDiscover;
         [self setSelectedButton:btnDiscover anDeSelect:btnVisa and:btnMasterCard and:btnAmericanExp];
    }
    else if (btn == btnAmericanExp)
    {
        cardType = ACECardAmericanExpress;
        [self setSelectedButton:btnAmericanExp anDeSelect:btnVisa and:btnMasterCard and:btnDiscover];
    }
    
}
- (IBAction)btnExpYearTap:(id)sender
{
    [self removeErrorMessageBelowView:txtExpYear];
    
    txtExpYear.layer.borderColor = [UIColor separatorColor].CGColor;
    
    [self openexpireDatePopUp:@"ExpYear"];
}
- (IBAction)btnExpMonthTap:(id)sender
{
    [self removeErrorMessageBelowView:txtExpMonth];
    
    txtExpMonth.layer.borderColor = [UIColor separatorColor].CGColor;
    
    [self openexpireDatePopUp:@"ExpMonth"];
}

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

- (IBAction)btnSignatureTap:(id)sender
{
    [textboxHandler btnDoneTap];
    
    SignatureViewController *svc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SignatureViewController"];
    svc.delegate = self;
    
    [self presentViewController:svc animated:YES completion:nil];
}
- (IBAction)btnPaymentTap:(id)sender
{
    if([selectedOption isEqualToString:CHKeyCheque])
    {
        if([self isValidChequeDetail])
        {
            if([ACEUtil reachable])
            {
                [self submitOrder];
            }
            else
            {
                [self showAlertWithMessage:ACENoInternet];
            }
        }
    }
    else if ([selectedOption isEqualToString:CHKeyPO])
    {
        
    }
    else
    {
        if([self isValidDetail])
        {
            if([ACEUtil reachable])
            {
                [self submitOrder];
            }
            else
            {
                [self showAlertWithMessage:ACENoInternet];
            }
        }
    }
}
- (IBAction)btnChequeDateTap:(id)sender
{
    SelectDatePopupViewController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectDatePopupViewController"];
    
    vc.minimumDateGap   = 0;
    vc.delegate         = self;
    vc.isFromScheduleNRequest = NO;
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:vc animated:NO completion:nil];
}

- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnFrontImageTap:(id)sender
{
    frontOrBack = 1;
    [self askImageSource];
}
- (IBAction)btnBackImageTap:(id)sender
{
    frontOrBack = 2;
    [self askImageSource];
}
- (IBAction)btnFrontDelTap:(id)sender
{
    [btnFrontImage setTitle:@"Tap to take front image of Check" forState:UIControlStateNormal];
    [btnFrontImage setBackgroundImage:nil forState:UIControlStateNormal];
    btnDelFrontCheck.hidden              = YES;
    btnFrontImage.userInteractionEnabled = YES;
}
- (IBAction)btnBackDeltap:(id)sender
{
   // Tap to take back image of Check
    [btnBackImage setTitle:@"Tap to take back image of Check" forState:UIControlStateNormal];
    [btnBackImage setBackgroundImage:nil forState:UIControlStateNormal];
    btnDelBackCheck.hidden              = YES;
    btnBackImage.userInteractionEnabled = YES;
}

#pragma mark - Helper method
-(void)setScannedDetail:(CardIOCreditCardInfo *)cardInfo
{
    txtCardNumber.text = cardInfo.cardNumber;
    txtNameOnCard.text = cardInfo.cardholderName;
    
    //txtExpMonth.text   = [NSString stringWithFormat:@"%lu",(unsigned long)cardInfo.expiryMonth];
    //txtExpYear.text    = [NSString stringWithFormat:@"%lu",(unsigned long)cardInfo.expiryYear];
    
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
    ZWTValidationResult result;
    
    result = [txtCheckNum validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if(result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankChequeNumber belowView:txtCheckNum];
        return NO;
    }
    else if(!chequeDate)
    {
        [self showErrorMessage:ACEBlankChequeDate belowView:lblChequeDate];
        return NO;
    }
    else if (btnFrontImage.currentBackgroundImage)
    {
        if(!btnBackImage.currentBackgroundImage)
        {
            [self showAlertWithMessage:ACEBlankChequeBackImage];
            return NO;
        }
        return YES;
    }
    else if (btnBackImage.currentBackgroundImage)
    {
        if(!btnFrontImage.currentBackgroundImage)
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
    
    result = [txtPoNum validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    if(result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankPONumber belowView:txtPoNum];
        return NO;
    }
    
    return YES;
}
-(NSString *)getPartList
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for(NSDictionary *dict in arrSelectedParts)
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
#pragma mark - SelectDatePopupViewControllerdelegate method
-(void)selectedDate:(NSDate *)date
{
    chequeDate                 = date;
    [formatter setDateFormat:@"MMM dd, yyyy"];
    lblChequeDate.text         = [formatter stringFromDate:date];
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
#pragma mark - SignatureCaptured delegate method
-(void)Signature:(UIImage *)signature
{
    [btnSignature setTitle:@"" forState:UIControlStateNormal];
    [btnSignature setBackgroundImage:signature forState:UIControlStateNormal];
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
         if(frontOrBack == 1)
         {
             [btnFrontImage setTitle:@"" forState:UIControlStateNormal];
             [btnFrontImage setBackgroundImage:selectedImage forState:UIControlStateNormal];
             btnDelFrontCheck.hidden              = NO;
             btnFrontImage.userInteractionEnabled = NO;
         }
         else if(frontOrBack == 2)
         {
             [btnBackImage setTitle:@"" forState:UIControlStateNormal];
             [btnBackImage setBackgroundImage:selectedImage forState:UIControlStateNormal];
             
             btnDelBackCheck.hidden              = NO;
             btnBackImage.userInteractionEnabled = NO;
         }
     }];
}

@end
