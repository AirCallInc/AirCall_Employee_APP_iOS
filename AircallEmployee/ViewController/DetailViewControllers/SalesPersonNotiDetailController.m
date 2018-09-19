//
//  SalesPersonNotiDetailController.m
//  AircallEmployee
//
//  Created by ZWT111 on 24/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "SalesPersonNotiDetailController.h"

@interface SalesPersonNotiDetailController ()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblClient;
@property (strong, nonatomic) IBOutlet UITextView *txtvNotes;

@property (strong, nonatomic) ACESalesPersonVisit *visitInfo;

@end

@implementation SalesPersonNotiDetailController

@synthesize btnEmail,lblClient,btnPhoneNumber,btnMobileNumber,btnOfficeNumber,txtvNotes,notificationId,visitInfo,lblAddress,salesVisitId;

#pragma mark - ACEViewControllerMethod
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}
-(void)prepareView
{
    [self getRequestDetail];
}
-(void)setDetail
{
    lblClient.text  = visitInfo.clientName  ;
    lblAddress.text = visitInfo.address     ;
    if([visitInfo.mobileNumber isKindOfClass:[NSNull class]] || [visitInfo.mobileNumber isEqualToString:@""])
    {
         [btnMobileNumber setTitle:ACENoMobileNumber forState:UIControlStateNormal];
    }
    else
    {
         [btnMobileNumber setTitle:visitInfo.mobileNumber forState:UIControlStateNormal];
    }
    if([visitInfo.phoneNumber isKindOfClass:[NSNull class]] || [visitInfo.phoneNumber isEqualToString:@""])
    {
    
        [btnPhoneNumber setTitle:ACENoHomeNumber forState:UIControlStateNormal];
    }
    else
    {
       [btnPhoneNumber setTitle:visitInfo.phoneNumber forState:UIControlStateNormal];
    }
    if([visitInfo.officeNumber isKindOfClass:[NSNull class]] ||[visitInfo.officeNumber isEqualToString:@""])
    {
        
        [btnOfficeNumber setTitle:ACENoOfficeNumber forState:UIControlStateNormal];
    }
    else
    {
        [btnOfficeNumber setTitle:visitInfo.officeNumber forState:UIControlStateNormal];
    }
    [btnEmail setTitle:visitInfo.email forState:UIControlStateNormal];
    txtvNotes.text = visitInfo.notes;
}
#pragma mark - Event Method
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnAddressTap:(id)sender
{
    [self openMapApplication:visitInfo];
   /* MapViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    viewController.destLongitude = visitInfo.longitude;
    viewController.destLattitude = visitInfo.lattitude;
    
    [self.navigationController pushViewController:viewController animated:YES];*/
    
}
- (IBAction)btnMobileNumberTap:(id)sender
{
    if(![btnMobileNumber.titleLabel.text isEqualToString:ACENoMobileNumber])
    {
        [self openCallSMSPopup:btnMobileNumber.titleLabel.text];
    }
}
- (IBAction)btnPhoneNumberTap:(id)sender
{
    if(![btnPhoneNumber.titleLabel.text isEqualToString:ACENoHomeNumber])
    {
        [self openCallSMSPopup:btnPhoneNumber.titleLabel.text];
    }
}
- (IBAction)btmOfficeNumber:(id)sender
{
    if(![btnOfficeNumber.titleLabel.text isEqualToString:ACENoOfficeNumber])
    {
        [self openCallSMSPopup:btnOfficeNumber.titleLabel.text];
    }
}
- (IBAction)btnEmail:(id)sender
{
     [self openMailViewController];
}
#pragma mark - Helper method
-(void)openCallSMSPopup:(NSString *)number
{
    CallSMSPopupViewController *CSPVC = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"CallSMSPopupViewController"];
    CSPVC.number = number;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [CSPVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:CSPVC animated:NO completion:nil];
}
-(void)openMailViewController
{
    if (![MFMailComposeViewController canSendMail])
    {
        NSLog(@"Mail services are not available.");
        return;
    }
    else
    {
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        
        mailController.mailComposeDelegate = self;
        
        [mailController setSubject:@"Aircall"];
        
        [mailController setToRecipients:[NSArray arrayWithObjects:btnEmail.titleLabel.text,nil]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:mailController animated:YES completion:nil];
        });
    }
}
-(void)openMapApplication:(ACESalesPersonVisit *)visitDetail
{
    
    AppDelegate  *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(delegate.latitude != nil && delegate.longitude != nil)
    {
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([visitDetail.lattitude doubleValue], [visitDetail.longitude doubleValue]) addressDictionary:nil];
        
        //MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(34.0593550900,  -118.3730809500) addressDictionary:nil];
        
        MKMapItem *destMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [destMapItem setName:visitDetail.address];
        
              
        MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([delegate.latitude doubleValue], [delegate.longitude doubleValue]) addressDictionary:nil];
        
        // MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(34.0593550900,  -118.3730809500) addressDictionary:nil];
        
        MKMapItem *currentMapItem = [[MKMapItem alloc] initWithPlacemark:placemark1];
        
        [currentMapItem setName:@"Current Location"];
        
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        
        [MKMapItem openMapsWithItems:@[currentMapItem, destMapItem]
                       launchOptions:launchOptions];
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"%@ does not have access to your Location. To enable Location, tap Settings and select location and check 'always' option.",appName];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                          }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark - MailComposer Delegate method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Webservice Method
-(void)getRequestDetail
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               SPRequestId : salesVisitId,
                               UKeyEmployeeID : ACEGlobalObject.user.userID
                               };
        
        [ACEWebServiceAPI getSalesPersonNotificationDetail:dict completionHandler:^(ACEAPIResponse *response, ACESalesPersonVisit *salesVisitInfo)
        {
            [SVProgressHUD dismiss];
            if(response.code == RCodeSuccess)
            {
                visitInfo = salesVisitInfo;
                [self setDetail];
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
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}


@end
