//
//  ForgotPasswordViewController.m
//  AircallClient
//
//  Created by ZWT112 on 3/28/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()<ZWTTextboxToolbarHandlerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtEmail  ;
@property (weak, nonatomic) IBOutlet UIView      *vwPopup   ;

@end

@implementation ForgotPasswordViewController

@synthesize txtEmail,vwPopup;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    vwPopup.hidden = YES;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    vwPopup.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^
                    {
                         vwPopup.transform = CGAffineTransformIdentity;
                         vwPopup.hidden    = NO;
                         [txtEmail becomeFirstResponder];
                     }
                     completion:nil];
}

#pragma mark - Webservice Method
-(void)sendEmailAddress
{
    NSDictionary *emailAddress = @{ 
                                    UKeyEmail  : txtEmail.text
                                   };
    
    [SVProgressHUD show];
    
    [ACEWebServiceAPI forgotPassword:emailAddress completionHandler:^(ACEAPIResponse *response)
    {
        [SVProgressHUD dismiss];
        
        if (response.code == RCodeSuccess)
        {
            [txtEmail resignFirstResponder];
            
            [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
            {
                [self zoomOutAnimation];
                [self dismissViewControllerAnimated:NO completion:nil];
             }];
        }
        else if(response.message)
        {
            [self showAlertWithMessage:response.message];
        }
        else
        {
           // [self showAlertWithMessage:response.error.localizedDescription];
            [self showAlertWithMessage:ACEUnknownError];
        }
        
    }];
    
}

#pragma mark - Event Method
- (IBAction)btnSubmitTap:(id)sender
{
    if ([self validateEmail])
    {
        if ([ACEUtil reachable])
        {
            [self sendEmailAddress];
        }
        else
        {
            [self showAlertWithMessage:ACENoInternet];
        }
        
    }
}

- (IBAction)btnCancelTap:(id)sender
{
    [txtEmail resignFirstResponder];
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Helper Methods
-(BOOL)validateEmail
{
    ZWTValidationResult result;
    
    NSString *email = [txtEmail.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    txtEmail.text   = email;
    
    result          = [txtEmail validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
    
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
    return YES;
}

#pragma mark - ZWTTextboxToolbarHandler Delegate Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    return YES;
}

-(void)doneTap
{
    
}

@end
