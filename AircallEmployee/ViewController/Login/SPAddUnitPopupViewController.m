//
//  SPAddUnitPopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 12/01/17.
//  Copyright © 2017 com.zwt. All rights reserved.
//

#import "SPAddUnitPopupViewController.h"

@interface SPAddUnitPopupViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnCC;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

@property (weak, nonatomic) IBOutlet UIButton *btnPO;
@property (weak, nonatomic) IBOutlet UIView   *vwPopup;


@property NSString *selectedOption;
@end

@implementation SPAddUnitPopupViewController

@synthesize btnCC,btnCheck,btnPO,vwPopup,selectedOption;

#pragma mark - UIViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
    
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
     }
                     completion:nil];
    
}
-(void)prepareView
{
    [self btnPaymentOptionsTap:btnCheck];
    
}
#pragma mark - Event Method
- (IBAction)btnOKTap:(id)sender
{
    [self.delegate selectedPaymentOption:selectedOption];
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)btnPaymentOptionsTap:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"radiobutton-selected"] forState:UIControlStateNormal];
    
    if(sender == btnCheck)
    {
        [btnPO setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
        selectedOption = CHKeyCheque;
    }
    else if(sender == btnPO)
    {
        [btnCheck setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
        selectedOption = CHKeyPO;
    }
}


@end
