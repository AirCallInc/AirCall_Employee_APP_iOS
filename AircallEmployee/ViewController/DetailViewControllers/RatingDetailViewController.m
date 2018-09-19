//
//  RatingDetailViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "RatingDetailViewController.h"

@interface RatingDetailViewController ()<ZWTTextboxToolbarHandlerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblClientName;
@property (weak, nonatomic) IBOutlet UILabel *lblServiceName;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *vwRating;

@property (weak, nonatomic) IBOutlet UITextView *txtvNotes;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlv;

@property (weak, nonatomic) IBOutlet SAMTextView *txtvReviews;
@property (weak, nonatomic) IBOutlet UILabel *lblPackageNAme;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property ZWTTextboxToolbarHandler *textboxHandler;
@property NSMutableArray *arrTextBoxes;

@end

@implementation RatingDetailViewController

@synthesize rate,lblClientName,lblServiceName,txtvReviews,txtvNotes,textboxHandler,arrTextBoxes,vwRating,scrlv,rateId,notificationId,lblPackageNAme,btnSubmit;

#pragma mark - ACEViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    scrlv.contentSize = CGSizeMake(scrlv.width, txtvNotes.y + txtvNotes.height +20);
    
    arrTextBoxes   = [[NSMutableArray alloc]initWithArray:@[txtvNotes]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlv];
    
    textboxHandler.delegate         = self;
    textboxHandler.showNextPrevious = false;
    
    if(rate)
    {
        [self setDataOfRate:rate];
    }
    else
    {
        [self getRatingDetail];
    }
}
-(void)setDataOfRate:(ACERatingNReviews *)rating
{
    lblClientName.text  = rating.ContactName;
    lblPackageNAme.text = rating.PackageName;
    lblServiceName.text = rating.ServiceCaseNo;
    txtvReviews.text    = rating.Reviews;
    txtvNotes.text      = rating.Notes;
    vwRating.value      = [rating.Ratings floatValue];
    
    if(![rating.Notes isEqualToString:@""])
    {
        txtvNotes.editable   = NO;
        txtvNotes.selectable = NO;
        btnSubmit.hidden     = YES;
        scrlv.contentSize    = CGSizeMake(scrlv.width, txtvNotes.y + txtvNotes.height);
    }
    
}
-(BOOL)isValidateNotes
{
    txtvNotes.text = [self trimmWhiteSpaceFrom:txtvNotes.text];
    if ([txtvNotes.text isEqualToString:@""])
    {
        txtvNotes.layer.borderColor = [UIColor redColor].CGColor;
        txtvNotes.layer.borderWidth = 1.0;
        [self showErrorMessage:ACEBlankReviewNotes belowView:txtvNotes];
        [txtvNotes becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Webservice Methods
-(void)sendNotes
{
    NSDictionary *notesInfo;
    
        notesInfo      = @{
                           RKeyId       : rate.ID,
                           SRKeyEmpNotes: txtvNotes.text,
                           UKeyEmployeeID : ACEGlobalObject.user.userID
                           };
    
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACEWebServiceAPI sendReviewNotes:notesInfo completionHandler:^(ACEAPIResponse *response)
         {
             if (response.code == RCodeSuccess)
             {
                 [self.navigationController popViewControllerAnimated:YES];
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
             
             [SVProgressHUD dismiss];
         }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)getRatingDetail
{
    NSDictionary *dict = @{
                            GKeyserviceId : rateId,
                            NKeyNotificationId : notificationId,
                            UKeyEmployeeID : ACEGlobalObject.user.userID
                          };
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACEWebServiceAPI getRatingDetail:dict completionHandler:^(ACEAPIResponse * response, ACERatingNReviews * rating)
        {
            [SVProgressHUD dismiss];
            
            if(response.code == RCodeSuccess)
            {
                rate = rating;
                [self setDataOfRate:rating];
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
        [self showAlertFromWithMessageWithSingleAction:ACENoInternet andHandler:^(UIAlertAction * _Nullable action)
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }
}
#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSaveTap:(id)sender
{
    if ([self isValidateNotes])
    {
        [self sendNotes];
    }
}

#pragma mark - ZWTToolbarHandlerDelegate Method
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    txtvNotes.layer.borderColor = [UIColor separatorColor].CGColor;
    [self removeErrorMessageBelowView:txtvNotes];
    return YES;
}

-(void)doneTap
{
    
}
@end
