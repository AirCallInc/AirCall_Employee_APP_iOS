//
//  AddUnitPopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 05/01/17.
//  Copyright © 2017 com.zwt. All rights reserved.
//

#import "AddUnitPopupViewController.h"

@interface AddUnitPopupViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnCC;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnPO;

@property (weak, nonatomic) IBOutlet UIView   *vwPopup;

@property NSString *selectedOption;
@end

@implementation AddUnitPopupViewController

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
    [self btnPaymentOptionsTap:btnCC];
    
}
#pragma mark - Event Method
- (IBAction)btnOKTap:(id)sender
{
    [self.delegate selectedPaymentOption:selectedOption];
    //[self zoomOutAnimation];
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
    if(sender == btnCC)
    {
         [btnCheck setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
         [btnPO setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
        selectedOption = CHKeyCC;
    }
    else if(sender == btnCheck)
    {
        [btnCC setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
        [btnPO setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
        selectedOption = CHKeyCheque;
    }
    else if(sender == btnPO)
    {
        [btnCheck setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
        [btnCC setImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
        selectedOption = CHKeyPO;
    }
}


@end
