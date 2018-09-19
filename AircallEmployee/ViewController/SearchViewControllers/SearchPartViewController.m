//
//  SearchPartViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "SearchPartViewController.h"

@interface SearchPartViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ZWTTextboxToolbarHandlerDelegate>

@property ZWTTextboxToolbarHandler *handler;

@property (strong, nonatomic) IBOutlet UITextField *txtfSearch;
@property (strong, nonatomic) IBOutlet UITableView *tblvPartData;

@property (strong, nonatomic) IBOutlet UIScrollView *scrlv;
@property (strong, nonatomic) IBOutlet UIView       *vwForm;

@property (strong, nonatomic) IBOutlet UITextField *txtPartSize;
@property (strong, nonatomic) IBOutlet UITextField *txtPartName;
@property (strong, nonatomic) IBOutlet SAMTextView *txtvDescription;
//@property (strong, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchButton;
@property CGRect tblvFrame;
@property BOOL isKeyboardShow;
@end

@implementation SearchPartViewController

@synthesize txtfSearch,tblvPartData,dataArray,searchArray,vwForm,scrlv,handler,txtPartSize,txtPartName,txtvDescription,isFromAddOrder,tblvFrame,partId,isKeyboardShow,btnSearchButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:txtPartName, txtPartSize,txtvDescription,nil];
    
    [scrlv setContentSize:CGSizeMake(scrlv.width, scrlv.height)];
    
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arr andScroll:scrlv];
    handler.delegate = self;
    
    txtvDescription.placeholder  = @"Part Description";
    btnSearchButton.hidden = YES;
    
    [self getPartData];
    tblvFrame                    = tblvPartData.frame;
    tblvPartData.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    tblvPartData.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self setUpKeyboardNotificationHandlers];
}
-(void)viewDidAppear:(BOOL)animated
{
    //[txtfSearch becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self removeObserver];
}
#pragma mark - Helper method
- (void)setUpKeyboardNotificationHandlers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //[center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self];
}
#pragma mark - KEyboard Notification Methods
- (void)keyboardWillShow:(NSNotification *)notification
{
    if(!isKeyboardShow)
    {
    CGRect keyboardRect        = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSTimeInterval duration    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    tblvPartData.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^
     {
         [UIView setAnimationCurve:curve];
         
         [tblvPartData setFrame:CGRectMake(tblvPartData.x,
                                                tblvPartData.y,
                                                tblvPartData.width,
                                                CGRectGetHeight(tblvPartData.frame) - CGRectGetHeight(keyboardRect))];
     }
     completion:^(BOOL finished)
     {
         tblvPartData.scrollEnabled = YES;
         
     }];
    isKeyboardShow = YES;
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval duration    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    tblvPartData.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^
     {
         [UIView setAnimationCurve:curve];
         tblvPartData.frame = tblvFrame;
     }
     completion:^(BOOL finished)
     {
         tblvPartData.scrollEnabled = YES;
     }];
    isKeyboardShow = NO;
}

#pragma mark - Webservice methods
-(void)getPartData
{
    if([ACEUtil reachable])
    {
        if([partId isEqualToString:@"Electrical"])
        {
            [self callWebserviceToGetElectricalService];
        }
        else if ([partId isEqualToString:@"MaxBreaker"])
        {
            [self callWebserviceToGetMaxBreaker];
        }
        else
        {
            [self callWebserviceToGetPartData];
        }
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
    
}
-(void)callWebserviceToGetPartData
{
    [SVProgressHUD show];
    NSDictionary *dict;
    if(partId)
    {
        dict = @{
                    PKeyPartTypeId : partId,
                    UKeyEmployeeID : ACEGlobalObject.user.userID
                };
    }
    else
    {
        dict = @{
                 PKeyPartTypeId  :@"",
                 UKeyEmployeeID : ACEGlobalObject.user.userID
                 };
    }
    
    [ACEWebServiceAPI getPartsList:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *partArray)
     {
         [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             dataArray   = partArray.copy;
             searchArray = partArray.copy;
             [tblvPartData reloadData];
             
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
             dataArray   = partArray.copy;
             searchArray = partArray.copy;
             
             [tblvPartData reloadData];
             
             tblvPartData.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPartData.height];
         }
         else
         {
             //[self showAlertWithMessage:response.error.localizedDescription];
             [self showAlertWithMessage:ACEUnknownError];
         }
     }];

}
-(void)callWebserviceToGetElectricalService
{
    [SVProgressHUD show];
    [ACEWebServiceAPI getElecticalService:^(ACEAPIResponse *response, NSMutableArray *partArray)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
            dataArray   = partArray.copy;
            searchArray = partArray.copy;
            [tblvPartData reloadData];
            
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
            dataArray   = partArray.copy;
            searchArray = partArray.copy;
            [tblvPartData reloadData];
            
            tblvPartData.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPartData.height];
        }
        else
        {
            //[self showAlertWithMessage:response.error.localizedDescription];
            [self showAlertWithMessage:ACEUnknownError];
        }
        
    }];
    
}
-(void)callWebserviceToGetMaxBreaker
{
    [SVProgressHUD show];
    [ACEWebServiceAPI getMaxBreaker:^(ACEAPIResponse *response, NSMutableArray *partArray)
     {
         [SVProgressHUD dismiss];
         
         if(response.code == RCodeSuccess)
         {
             dataArray   = partArray.copy;
             searchArray = partArray.copy;
             [tblvPartData reloadData];
             
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
             dataArray   = partArray.copy;
             searchArray = partArray.copy;
             [tblvPartData reloadData];
             
             tblvPartData.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPartData.height];
         }
         else
         {
             //[self showAlertWithMessage:response.error.localizedDescription];
             [self showAlertWithMessage:ACEUnknownError];
         }
         
     }];
    
}

#pragma mark -Helper method
-(void)openFormView:(BOOL)ans
{
    [txtfSearch resignFirstResponder];
    tblvPartData.hidden = ans;
    vwForm.hidden       = !ans;
    btnSearchButton.hidden = YES;
}
//For form which will open when part is not found
#pragma mark -Validation Method
-(bool)validateData
{
    ZWTValidationResult result;
    
    result = [txtPartName validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankPartName belowView:txtPartName];
        return NO;
    }
    result = [txtPartSize validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankPartSize belowView:txtPartSize];
        return NO;
    }
    
//    result = [txtv validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
//    
//    if (result == ZWTValidationResultBlank)
//    {
//        [self showErrorMessage:ACEBlankPartSize belowView:txtPartSize];
//        
//        return NO;
//    }

    
    return YES;
}
#pragma mark - Event Methods

- (IBAction)btnCloseTap:(id)sender
{
    [txtfSearch resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnRequestTap:(id)sender
{
    if([self validateData])
    {
        ACEParts *part = [[ACEParts alloc]init] ;
        part.ID        = @""                    ;
        part.partName  = txtPartName.text       ;
        part.partSize  = txtPartSize.text       ;
        part.partInfo  = txtvDescription.text   ;
        [self openFormView:NO];
        
        [_delegate SelectedPartName:part];
        
        [self btnCloseTap:nil];
    }
}
- (IBAction)btnInfoTap:(UIButton *)btn
{
    [txtfSearch resignFirstResponder];
    
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:tblvPartData];
    
    NSIndexPath *indexPath = [tblvPartData indexPathForRowAtPoint:buttonPosition];
    
    ACEParts *part         = searchArray[indexPath.row];
    
    PartInfoPopupViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"PartInfoPopupViewController"];
    vc.part = part;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:vc animated:NO completion:nil];

}

#pragma mark - tableview delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tblvPartData.backgroundView = nil;
    ACESearchPartCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"ACESearchPartCell"];
    if(searchArray.count > indexPath.row)
    {
        ACEParts *part         = searchArray[indexPath.row];
        cell.lblPartName.text  = part.partName   ;
        cell.lblSize.text      = part.partSize   ;
        cell.lblPartPrice.text = [NSString stringWithFormat:@"$%0.2f",
                                 part.partPrice];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate SelectedPartName:searchArray[indexPath.row]];
    [self btnCloseTap:nil];
}
#pragma mark - textfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if(textField == txtfSearch)
    {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == txtfSearch)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if(![newString isEqualToString:@""])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"partName CONTAINS[c] %@",newString];
            
            searchArray = [dataArray filteredArrayUsingPredicate:predicate];
            
            btnSearchButton.hidden = NO;
            
            if (searchArray.count == 0)
            {
                if(isFromAddOrder)
                {
                    tblvPartData.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoDataFound andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPartData.height];
                }
                else
                {
                    [self openFormView:YES];
                    
                }
            }
//            else
//                [self openFormView:NO];
            
        }
        else
        {
            if(!vwForm.hidden)
            {
                [self openFormView:NO];
            }
            searchArray = dataArray.copy;
            btnSearchButton.hidden = YES;
        }
        
        [tblvPartData reloadData];
        
    }
    else
    {
        [self removeErrorMessageBelowView:textField];
        textField.layer.borderColor = [UIColor separatorColor].CGColor;

    }
    return YES;
}

-(void)doneTap
{
    
}

- (IBAction)btnSearchCancelTap:(id)sender
{
    [txtfSearch resignFirstResponder];
    txtfSearch.text = @"";
    btnSearchButton.hidden = YES;
    [self openFormView:NO];
    searchArray     = dataArray.copy;
    [tblvPartData reloadData];
}
- (IBAction)btnFormCloseTap:(id)sender
{
    [vwForm endEditing:YES];
    [self openFormView:NO];
    txtfSearch.text = @"";
    searchArray     = dataArray.copy;
    [tblvPartData reloadData];
}

@end
