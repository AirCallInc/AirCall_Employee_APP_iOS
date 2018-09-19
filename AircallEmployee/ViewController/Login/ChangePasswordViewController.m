//
//  ChangePasswordViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 26/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<ZWTTextboxToolbarHandlerDelegate>


@end

@implementation ChangePasswordViewController

@synthesize txtfNewPassword,txtfOldPassword,txtfConfirmPassword,textboxHandler,bgScrlv;

#pragma maek - ACEViewcontroller Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    bgScrlv.contentSize = CGSizeMake(bgScrlv.width, txtfConfirmPassword.y);
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:@[txtfOldPassword, txtfNewPassword,txtfConfirmPassword]];
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arr andScroll:bgScrlv];
    
    textboxHandler.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}
-(void)savePasswordInuserDefault:(NSString *)newPassword
{
    NSMutableDictionary *user    = [[[NSUserDefaults standardUserDefaults] objectForKey:UKeyRememberMe] mutableCopy];
    
    if(user.count > 0)
    {
        [user setObject:newPassword forKey:UKeyPassword];
        [ACEUtil rememberMe:user];
    }
    
}
#pragma mark - Webservice Method
-(void)changePassword
{
    NSDictionary *dict = @{
                           UKeyID : ACEGlobalObject.user.userID,
                           UKeyOldPassword : [ACEUtil MD5HashForString: txtfOldPassword.text],
                           UKeyNewPassword : [ACEUtil MD5HashForString:txtfNewPassword.text]
                           };
    [SVProgressHUD show];
    [ACEWebServiceAPI changePassword:dict completionHandler:^(ACEAPIResponse *response)
    {
        [SVProgressHUD dismiss];
            if(response.code == RCodeSuccess)
            {
                //[self savePasswordInuserDefault:txtfConfirmPassword.text];
                [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
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
#pragma mark - Helper Method
-(BOOL)isValidateDetail
{
    ZWTValidationResult result;
    
    result = [txtfOldPassword validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankPassword belowView:txtfOldPassword];
        
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEPasswordSpace belowView:txtfOldPassword];
        
        return NO;
    }
    else if (result == ZWTValidationResultLessLength)
    {
        [self showErrorMessage:ACEShortPassword belowView:txtfOldPassword];
        
        return NO;
    }
    result = [txtfNewPassword validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankNewPassword belowView:txtfNewPassword];
        
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEPasswordSpace belowView:txtfNewPassword];
        
         return NO;
    }
    else if (result == ZWTValidationResultLessLength)
    {
        [self showErrorMessage:ACEShortPassword belowView:txtfNewPassword];
        
        return NO;
    }
    result = [txtfConfirmPassword validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankConfirmPassword belowView:txtfConfirmPassword];
        
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEPasswordSpace belowView:txtfConfirmPassword];
         return NO;
    }
    
    else if (result == ZWTValidationResultLessLength)
    {
        [self showErrorMessage:ACEShortPassword belowView:txtfConfirmPassword];
        
        return NO;
    }
    
    if(![txtfNewPassword.text isEqualToString:txtfConfirmPassword.text])
    {
        [self showErrorMessage:ACEPasswordNotMatch belowView:txtfConfirmPassword];
        return NO;
    }
    return YES;
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
    
}

#pragma mark - Event Method
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTap:(id)sender
{
    if([self isValidateDetail])
    {
        if([ACEUtil reachable])
        {
            [self changePassword];
        }
        else
        {
            [self showAlertWithMessage:ACENoInternet];
        }
    }
}



@end
