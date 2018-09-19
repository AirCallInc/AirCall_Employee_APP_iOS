//
//  AccountSettingViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 24/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//


#import "AccountSettingViewController.h"

@interface AccountSettingViewController ()<ZWTTextboxToolbarHandlerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectedStateCity>

@property (strong, nonatomic) IBOutlet UIScrollView *bgscrlv            ;
@property (strong, nonatomic) IBOutlet UITextField  *txtFirstName       ;
@property (strong, nonatomic) IBOutlet UITextField  *txtLastName        ;
@property (strong, nonatomic) IBOutlet UITextField  *txtUserName        ;
@property (strong, nonatomic) IBOutlet UITextField  *txtPassword        ;
@property (strong, nonatomic) IBOutlet UITextField  *txtEmail           ;
@property (strong, nonatomic) IBOutlet ACETextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField  *txtCity            ;
@property (strong, nonatomic) IBOutlet UITextField  *txtState           ;
@property (strong, nonatomic) IBOutlet UITextField  *txtZip             ;
@property (strong, nonatomic) IBOutlet UITextField  *txtMobileNum       ;
@property (strong, nonatomic) IBOutlet UITextField  *txtPhnNo           ;
@property (strong, nonatomic) IBOutlet UILabel      *lblWorkingHr       ;

@property (strong, nonatomic) IBOutlet UIButton     *btnUpdate          ;
@property (strong, nonatomic) IBOutlet UIButton     *btnProfileImage    ;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler  ;

@property NSString *stateId         ;
@property NSString *cityId          ;
@property UIImage  *imgSelected     ;

@end

@implementation AccountSettingViewController

@synthesize bgscrlv,txtFirstName,txtLastName,txtUserName,txtPassword,txtEmail,txtAddress,txtCity,txtState,txtZip,txtMobileNum,txtPhnNo,lblWorkingHr,btnUpdate,textboxHandler,stateId,cityId,btnProfileImage,imgSelected;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [bgscrlv setContentSize:CGSizeMake(bgscrlv.width, lblWorkingHr.y + lblWorkingHr.height +20)];
    
    [self prepareView];
}

#pragma mark - helper method
-(void)prepareView
{
    btnProfileImage.layer.cornerRadius  = btnProfileImage.width / 2;
    btnProfileImage.layer.masksToBounds = YES;
    imgSelected                         = [[UIImage alloc]init];
    
    NSMutableArray *arr                 = [[NSMutableArray alloc]initWithArray:@[txtFirstName,txtLastName,txtMobileNum,txtPhnNo]];
    
    textboxHandler                      = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arr andScroll:bgscrlv];
    textboxHandler.delegate             = self;
    
    [self getEmployeeData];
}
-(void)getEmployeeData
{
    if([ACEUtil reachable])
    {
        [self getUserData];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)saveDataInUserDefault
{
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(imgSelected) forKey:UKeyImage];
    
    NSDictionary *userInfo = @{
                               UKeyID          : ACEGlobalObject.user.userID,
                               UKeyEmail       : ACEGlobalObject.user.email,
                               UKeyPassword    : txtPassword.text,
                               UKeyLastName    : txtLastName.text,
                               UKeyFirstName   : txtFirstName.text
                               };
    
    ACEGlobalObject.user.firstName = txtFirstName.text;
    ACEGlobalObject.user.lastName  = txtLastName.text;
    ACEGlobalObject.user.password  = txtPassword.text;
    
    [ACEGlobalObject.user saveInUserDefaults:userInfo];
}
-(void)setUserData:(ACEUser *)empInfo
{
    txtFirstName.text   =   empInfo.firstName               ;
    txtLastName.text    =   empInfo.lastName                ;
//    txtUserName.text    =   empInfo.userName;
    txtPassword.text    =   ACEGlobalObject.user.password   ;
    txtEmail.text       =   empInfo.email                   ;
    txtAddress.text     =   empInfo.address                 ;
    txtCity.text        =   empInfo.cityName                ;
    txtState.text       =   empInfo.stateName               ;
    txtZip.text         =   empInfo.zipcode                 ;
    txtMobileNum.text   =   empInfo.mobileNum               ;
    txtPhnNo.text       =   empInfo.phoneNum                ;
    lblWorkingHr.text   =   empInfo.workingHr               ;
    stateId             =   empInfo.stateId                 ;
    cityId              =   empInfo.cityId                  ;
    
    NSData *dataImage   = [[NSUserDefaults standardUserDefaults] objectForKey:UKeyImage];
    UIImage *image      = [UIImage imageWithData:dataImage];
    
    if (dataImage == nil)
    {
        imgSelected     = [UIImage imageNamed:@"Profileimage"];
        [btnProfileImage setImage:[UIImage imageNamed:@"Profileimage"] forState:UIControlStateNormal];
        
    }
    else
    {
        imgSelected    = image;
        [btnProfileImage setImage:image forState:UIControlStateNormal];
    }
    [SVProgressHUD dismiss];
}

- (BOOL)isProfileDetailValid
{
    ZWTValidationResult result;
    
    result = [txtFirstName validate:ZWTValidationTypeName showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankFirstName belowView:txtFirstName];
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEInvalidFirstName belowView:txtFirstName];
        return NO;
    }
    result = [txtLastName validate:ZWTValidationTypeName showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankLastName belowView:txtLastName];
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEInvalidLastName belowView:txtLastName];
        return NO;
    }
    
//    result = [txtUserName validate:ZWTValidationTypeName showRedRect:YES getFocus:YES];
//    
//    if (result == ZWTValidationResultBlank)
//    {
//        [self showErrorMessage:ACEBlankUsername belowView:txtUserName];
//        return NO;
//    }
//    
//    else if (result == ZWTValidationResultInvalid)
//    {
//        [self showErrorMessage:ACEInvalidUsername belowView:txtUserName];
//        return NO;
//    }
    
    result = [txtMobileNum validate:ZWTValidationTypeNumber showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankMobileNumber belowView:txtMobileNum];
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEInvalidCardNumber belowView:txtMobileNum];
        return NO;
    }
    else if (txtMobileNum.text.length < 10)
    {
        txtMobileNum.layer.borderColor = [UIColor redColor].CGColor;
        [self showErrorMessage:ACEInvalidMobileNumber belowView:txtMobileNum];
        
        return NO;
    }
    
    result = [txtPhnNo validate:ZWTValidationTypeNumber showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBLankPhoneNumber belowView:txtPhnNo];
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEInvalidCardNumber belowView:txtPhnNo];
        return NO;
    }
    else if (txtPhnNo.text.length < 8)
    {
        txtPhnNo.layer.borderColor = [UIColor redColor].CGColor;
        [self showErrorMessage:ACEInvalidPhoneNumber belowView:txtPhnNo];
        return NO;
    }
    
    return YES;
}
- (BOOL)validatePhone:(NSString *)phoneNumber
{
    NSString *phoneRegex   = @"^([0-9]{3})[0-9]{3}-[0-9]{4}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNumber];
}
-(void)askForImage
{
    [self.view endEditing:YES];
    
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:appName
                                                                             message:ACETextAskImageSource
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:ACETextFromCamera
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action)
                                    {
                                        [self selectProfileImageFrom:UIImagePickerControllerSourceTypeCamera];
                                    }];
        
        UIAlertAction *fromAlbum = [UIAlertAction actionWithTitle:ACETextFromLibrary
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action)
                                    {
                                        [self selectProfileImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
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
        [self presentViewController:actionSheet animated:YES completion:nil];
}
- (void)selectProfileImageFrom:(UIImagePickerControllerSourceType)sourceType
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
                     [self showAlertWithMessage:ACEAllowAccessPhotoLibrary];
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
                                        [self showAlertWithMessage:ACEAllowAccessCamera];
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
#pragma mark - open StateCity controller
-(void)openStateCityViewControllerIsState:(BOOL)ans andSelectedState:(NSString *)sID andSelectedCity:(NSString *)cId
{
    SelectStateCityViewController *scvc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectStateCityViewController"];
    
    scvc.isState       = ans    ;
    scvc.stateId       = sID    ;
    scvc.cityId        = cId    ;
    scvc.delegate      = self   ;
    
    [self presentViewController:scvc animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
         
         imgSelected = selectedImage;
         [btnProfileImage setImage:selectedImage forState:UIControlStateNormal];
         
     }];
}

#pragma mark - Event Method
- (IBAction)btnMenuTap:(id)sender
{
    [self.view endEditing:YES];
    [self openSideBar];
}

- (IBAction)btnUpdateTap:(id)sender
{
    if([self isProfileDetailValid])
    {
        if([ACEUtil reachable])
        {
            [self sendUpdatedDataToServer];
        }
        else
        {
            [self showAlertWithMessage:ACENoInternet];
        }
    }
    
}
- (IBAction)btnEditTap:(id)sender
{
    ChangePasswordViewController *vc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)btnImgvTap:(id)sender
{
    [self askForImage];
}
#pragma mark - webservice Method
-(void)getUserData
{
    [SVProgressHUD show];
    
    [ACEWebServiceAPI getEmployeeFullData:ACEGlobalObject.user.userID completionHandler:^(ACEAPIResponse *response, ACEUser *user)
    {
        
        if(response.code == RCodeSuccess)
        {
            [self setUserData:user];
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
        else if(response.message)
        {
            [SVProgressHUD dismiss];
            [self showAlertWithMessage:response.message];
        }
        else
        {
            [SVProgressHUD dismiss];
            [self showAlertWithMessage:ACEUnknownError];
        }
    }];
}
-(void)sendUpdatedDataToServer
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyID   : ACEGlobalObject.user.userID,
                           UKeyFirstName : txtFirstName.text,
                           UKeyLastName  : txtLastName.text,
                           UKeyMobileNo  : txtMobileNum.text,
                           UKeyPhoneNo   : txtPhnNo.text,
                           //UKeyImage     : btnProfileImage.imageView.image
                           };
    [ACEWebServiceAPI sendUpdatedEmployeeData:dict withProfileImage:btnProfileImage.imageView.image completionHandler:^(ACEAPIResponse *response,ACEUser *user)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
            [self saveDataInUserDefault];
            //[self setUserData:user];
            [self showAlertWithMessage:@"Profile Updated successfully"];
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

#pragma mark - textfield delegate method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == txtCity)
    {
        [self openStateCityViewControllerIsState:NO andSelectedState:stateId andSelectedCity:cityId];
    }
    else if(textField == txtState)
    {
        [self openStateCityViewControllerIsState:YES andSelectedState:stateId andSelectedCity:cityId];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
    
    
    if(textField == txtMobileNum || textField == txtPhnNo)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
        NSInteger length = [currentString length];
        if (length > 15)
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - SelectedStateCity delegate Method
-(void)selectedStatecity:(NSDictionary *)dict andIsstate:(BOOL)isSatate
{
    if(isSatate)
    {
        txtState.text = dict[GKeyName];
        stateId       = [dict[GKeyId]stringValue];
    }
    else
    {
        txtCity.text  = dict[GKeyName];
        cityId        = [dict[GKeyId]stringValue];
    }
}

#pragma mark - ZWTTexttolbarHandler Method
-(void)doneTap
{
    
}
@end
