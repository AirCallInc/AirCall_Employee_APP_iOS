//
//  PartInfoPopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 13/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "PartInfoPopupViewController.h"

@interface PartInfoPopupViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lblPartName;
@property (strong, nonatomic) IBOutlet UITextView *txtvPartInfo;
@property (strong, nonatomic) IBOutlet UIView *vwPopUp;

@end

@implementation PartInfoPopupViewController

@synthesize part,lblPartName,txtvPartInfo,vwPopUp;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareview];
    [self getPartInfo];
}
-(void)viewDidAppear:(BOOL)animated
{
    vwPopUp.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwPopUp.transform = CGAffineTransformIdentity;
                         vwPopUp.hidden    = NO;
                     }
                     completion:nil];
}
#pragma mark - helper method
-(void)prepareview
{
    lblPartName.text      = [NSString stringWithFormat:@"%@ %@",part.partName,part.partSize];
    txtvPartInfo.editable = NO;
}
#pragma mark -webservice Method
-(void)getPartInfo
{
    if([ACEUtil reachable])
    {
        [self callWebservice];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)callWebservice
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           SRKeyPartId    : part.ID,
                           UKeyEmployeeID : ACEGlobalObject.user.userID
                           };
    
    [ACEWebServiceAPI getPartInfo:dict completionHandler:^(ACEAPIResponse *response, NSString *partInfo)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
            if(![partInfo isEqualToString:@""])
            {
                txtvPartInfo.text = partInfo;
            }
            else
            {
                txtvPartInfo.text = @"No Description Found.";
            }
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
            txtvPartInfo.text = response.message;
            
            //[self showAlertWithMessage:response.message];
        }
        else
        {
            txtvPartInfo.text = ACEUnknownError;
           // [self showAlertWithMessage:response.error.localizedDescription];
        }
        
    }];
}
#pragma mark - event method
- (IBAction)btnCloseTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}



@end
