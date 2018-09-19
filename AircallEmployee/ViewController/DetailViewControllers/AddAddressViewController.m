//
//  AddAddressViewController.m
//  AircallEmployee
//
//  Created by Manali on 13/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()<UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,ZWTTextboxToolbarHandlerDelegate,SelectedStateCity>

@property (weak, nonatomic) IBOutlet UITextView *tvAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlv;

@property NSString *stateId;
@property NSString *cityId;

@property ZWTTextboxToolbarHandler *textboxHandler;
@property NSMutableArray *arrTextBoxes;

@end

@implementation AddAddressViewController
@synthesize tvAddress,txtState,txtCity,txtZipCode,scrlv;
@synthesize textboxHandler,arrTextBoxes,stateId,cityId,delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [scrlv setContentOffset:CGPointMake(0, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Method
-(void)prepareView
{
    arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[tvAddress,txtZipCode]];
    [scrlv setContentSize:CGSizeMake(scrlv.width, txtZipCode.y + txtZipCode.height)];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlv];
    textboxHandler.delegate = self;
}

#pragma mark - UITextField Delegate Method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField != txtZipCode)
    {
        SelectStateCityViewController *sscvc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectStateCityViewController"];
        
        if (textField == txtState)
        {
            sscvc.isState = YES;
        }
        else
        {
            sscvc.isState = NO;
        }
        sscvc.delegate = self;
        [self presentViewController:sscvc animated:YES completion:nil];
    }
}

#pragma mark - Event Methods
- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnAddTap:(id)sender
{
    NSDictionary *dict = @{
                           AdKeyAddress  : tvAddress.text,
                           AdKeyStateId  : @(stateId.intValue),
                           AdKeyStateName: txtState.text,
                           AdKeyCityId   : @(cityId.intValue),
                           AdKeyCityName : txtCity.text,
                           AdKeyZipcode  : txtZipCode.text
                           };
    [delegate addedAddress:dict];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SelectStateCityViewController Delegate Method
-(void)selectedStatecity:(NSDictionary *)dict andIsstate:(BOOL)isSatate
{
    if(isSatate)
    {
        txtState.text = dict[GKeyName];
        stateId       = [dict[GKeyId]stringValue];
    }
    else
    {
        txtCity.text  = dict[GKeyName];
        cityId        = [dict[GKeyId]stringValue];
    }
}
@end
