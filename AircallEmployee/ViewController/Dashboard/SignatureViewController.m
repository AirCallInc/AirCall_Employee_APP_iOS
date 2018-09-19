//
//  SignatureViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 31/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()

@property (strong, nonatomic) IBOutlet TESignatureView *signatureView;
@property (strong, nonatomic) IBOutlet UIButton *btnReset;
@property (strong, nonatomic) IBOutlet UIButton *btnCapture;

@end

@implementation SignatureViewController
#pragma mark - ACEViewController method
- (void)viewDidLoad
{
    [super viewDidLoad];
    ACEGlobalObject.shouldAutoRotate = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Event method
- (IBAction)btnResetTap:(id)sender
{
    [_signatureView clearSignature];
}
- (IBAction)btnCaptureTap:(id)sender
{
    UIImage *img = [_signatureView getSignatureImage];
//    if(img == nil)
//    {
//        [self showAlertWithMessage:ACEBlankSignature];
//    }
//    else
//    {
        [self.delegate Signature:img];
        ACEGlobalObject.shouldAutoRotate = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
   // }
}
- (IBAction)btnCLoseTap:(id)sender
{
    ACEGlobalObject.shouldAutoRotate = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
