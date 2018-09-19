//
//  UnitUnMatchedPopupViewController.m
//  AircallEmployee
//
//  Created by Manali on 30/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "UnitUnMatchedPopupViewController.h"

@interface UnitUnMatchedPopupViewController()
@property (weak, nonatomic) IBOutlet UIView *vwUnMatched;

@end

@implementation UnitUnMatchedPopupViewController
@synthesize btnCreateNewUnit,btnReEnterDetail,vwUnMatched,delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}
-(void)viewDidAppear:(BOOL)animated
{
    vwUnMatched.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^
                    {
                         vwUnMatched.transform = CGAffineTransformIdentity;
                         vwUnMatched.hidden    = NO;
                     }
                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    vwUnMatched.hidden = YES;
    btnCreateNewUnit.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnCreateNewUnit.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnCreateNewUnit.titleLabel.numberOfLines = 2;
    btnReEnterDetail.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnReEnterDetail.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnReEnterDetail.titleLabel.numberOfLines = 2;
}

#pragma mark - Event Methods
- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnCreateNewUnitTap:(id)sender
{
    [self zoomOutAnimation];
    [delegate openAddUnitACHeating:3];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnReEnterDetailTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
