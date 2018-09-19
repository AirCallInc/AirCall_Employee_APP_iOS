//
//  LoginViewController.m
//  AircallEmployee
//
//  Created by ZWT112 on 3/29/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<ZWTTextboxToolbarHandlerDelegate>

@property (weak, nonatomic) IBOutlet ACETextField      *txtUsername     ;
@property (weak, nonatomic) IBOutlet ACETextField      *txtPassword     ;
@property (weak, nonatomic) IBOutlet UIScrollView      *scrvLogin       ;
@property (weak, nonatomic) IBOutlet UIImageView       *imgvCheckMark   ;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler  ;
@property BOOL         isRemember   ;
@property AppDelegate *delegate     ;

@end

@implementation LoginViewController

@synthesize scrvLogin,txtPassword,txtUsername,textboxHandler,imgvCheckMark;
@synthesize isRemember,delegate;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareViews];
}
#pragma mark - Helper Method
-(void)prepareViews
{
    scrvLogin.contentSize   = CGSizeMake(scrvLogin.width, txtPassword.height + 30);
    isRemember              = NO;
    delegate                = [[AppDelegate alloc]init];
    NSMutableArray *arr     = [[NSMutableArray alloc]initWithArray:@[txtUsername, txtPassword]];
    
    textboxHandler          = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arr andScroll:scrvLogin];
    
    textboxHandler.delegate = self;
    // **** Get data from user default for Remember me and set in to text field
    NSDictionary *user      = [[NSUserDefaults standardUserDefaults] objectForKey:UKeyRememberMe];
    
    if(user.count > 0)
    {
        txtUsername.text = user[UKeyEmail];
        txtPassword.text = user[UKeyPassword];
        isRemember       = YES;
        [imgvCheckMark setImage:[UIImage imageNamed:@"worknotdone-selected"]];
    }
}

- (BOOL)isSigninDetailValid
{
    ZWTValidationResult result;
    
    result = [txtUsername validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankEmail belowView:txtUsername];
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACEInvalidEmail belowView:txtUsername];
        return NO;
    }
    
    result = [txtPassword validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankPassword belowView:txtPassword];
        return NO;
    }
    else if(result == ZWTValidationResultContainSpace)
    {
        [self showErrorMessage:ACEPasswordSpace belowView:txtPassword];
        return NO;
    }
    
    return YES;
}
-(void)openDashboard // For normal employee
{
    [ACEUtil prepareDashboard];
}
-(void)openNotification // For sales person employee
{
    [ACEUtil prepareAppForSalesPerson];
}

-(void)checkForRememberMe
{
    if(isRemember)
    {
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc]init];
        [userDict setValue:txtUsername.text forKey:UKeyEmail];
        [userDict setValue:txtPassword.text forKey:UKeyPassword];
        [userDict setValue:[NSNumber numberWithBool:YES] forKey:UKeyRememberMe];
        [ACEUtil rememberMe:userDict];
    }
    else
    {
        NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
        [defs removeObjectForKey:UKeyRememberMe];
        [defs synchronize];
    }
    
}

#pragma mark - Event Method
- (IBAction)btnLoginTap:(id)sender
{
    if ([self isSigninDetailValid])
    {
        [textboxHandler btnDoneTap];
        
        if ([ACEUtil reachable])
        {
            [self signIn];
        }
        else
        {
            [self showAlertWithMessage:ACENoInternet];
        }
    }
}
- (IBAction)btnForgotPasswordTap:(id)sender
{
    ForgotPasswordViewController *viewController    = [self.storyboardLogin instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext                 = YES;
    
    [viewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:viewController animated:NO completion:nil];
}
- (IBAction)btnRememberMeTap:(UIButton *)sender
{
    isRemember = !isRemember;
    if(isRemember)
    {
        [imgvCheckMark setImage:[UIImage imageNamed:@"worknotdone-selected"]];
    }
    else
    {
        [imgvCheckMark setImage:[UIImage imageNamed:@"worknotdone"]];
    }
    
}

#pragma mark - Webservice Methods
- (void)signIn
{
    
    NSString *lattitude = [NSString stringWithFormat:@"%@",ACEGlobalObject.currentLattitude];
    NSString *longitude = [NSString stringWithFormat:@"%@",ACEGlobalObject.currentLongitude];
   
    NSDictionary *userDetail = @{
                                 
                                 UKeyEmail       : txtUsername.text,
                                  
                                 UKeyPassword    : [ACEUtil MD5HashForString:txtPassword.text],
                                 
                                 UKeyDeviceType  : ACEDeviceType,
                                 
                                 UKeyDeviceToken : ACEGlobalObject.deviceToken != nil ? ACEGlobalObject.deviceToken : @"",
                                 
                                 GKeyLattitude : lattitude,
                                 GKeyLongitude : longitude
                                 };
    
    
    [SVProgressHUD show];
    
    [ACEWebServiceAPI signinWithUserDetail:userDetail completionHandler:^(ACEAPIResponse *response, ACEUser *user)
     {
         [SVProgressHUD dismiss];
         
         if(response.code == RCodeSuccess)
         {
             [self checkForRememberMe];
             user.password = txtPassword.text;
             [user login];
             
             if(ACEGlobalObject.user.isSalesPerson)
             {
                 [self openNotification];
             }
             else
             {
                 [self openDashboard];
             }
         }
         else
         {
             if(response.message)
             {
                 [self showAlertWithMessage:response.message];
             }
             else
             {
                 //[self showAlertWithMessage:response.error.localizedDescription];
                 [self showAlertWithMessage:ACEUnknownError];
             }
             txtPassword.text = @"";
             //txtUsername.text = @"";
         }
     }];
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

@end
