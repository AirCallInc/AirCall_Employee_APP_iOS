//
//  SearchUserViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "SearchUserViewController.h"

@interface SearchUserViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property NSArray *arrUserData;
@property NSArray *arrUserSearch;

@property (strong, nonatomic) IBOutlet UITableView *tblvUserData;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchClose;


@property CGRect tblvFrame;
@property BOOL   isKeyboardShow;
@end

@implementation SearchUserViewController

@synthesize tblvUserData,arrUserData,txtSearch,arrUserSearch,tblvFrame,isKeyboardShow,isWorkAreaClient,btnSearchClose;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
    [self getUserDetail];
}
-(void)viewDidAppear:(BOOL)animated
{
    //[txtSearch becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserver];
}

-(void)prepareView
{
    arrUserData     = [[NSArray alloc]init];
    arrUserSearch   = [[NSArray alloc]init];
    tblvFrame       = tblvUserData.frame;
    [self setUpKeyboardNotificationHandlers];
    btnSearchClose.hidden = YES;
    //[tblvUserData reloadData];
    
}
#pragma mark - Helper method
- (void)setUpKeyboardNotificationHandlers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
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
    
    tblvUserData.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^
     {
         [UIView setAnimationCurve:curve];
         
         [tblvUserData setFrame:CGRectMake(tblvUserData.x,
                                                tblvUserData.y,
                                                tblvUserData.width,
                                                CGRectGetHeight(tblvUserData.frame) - CGRectGetHeight(keyboardRect))];
     }
                     completion:^(BOOL finished)
     {
         tblvUserData.scrollEnabled = YES;
         
     }];
     isKeyboardShow = YES;
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    isKeyboardShow = NO;
    NSTimeInterval duration    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    tblvUserData.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^
     {
         [UIView setAnimationCurve:curve];
         tblvUserData.frame = tblvFrame;
         
     }
                     completion:^(BOOL finished)
     {
         tblvUserData.scrollEnabled = YES;
     }];
}

#pragma mark - Webservice Method
-(void)getUserDetail
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACEWebServiceAPI getClientList:isWorkAreaClient completionHandler:^(ACEAPIResponse *response, NSMutableArray *clientArray)
         {
             [SVProgressHUD dismiss];
             
             if(response.code == RCodeSuccess)
             {
                 arrUserData   = clientArray.copy;
                 arrUserSearch = clientArray.copy;
                 [tblvUserData reloadData];
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
                 arrUserData   = clientArray.copy;
                 arrUserSearch = clientArray.copy;
                 [tblvUserData reloadData];
                 
                 tblvUserData.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUserData.height];
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

#pragma mark - Event Method
- (IBAction)btnCloseTap:(id)sender
{
    [txtSearch resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnSearchCancelTap:(id)sender
{
    [txtSearch resignFirstResponder];
    txtSearch.text = @"";
    btnSearchClose.hidden = YES;
    arrUserSearch  = arrUserData.copy;
    [tblvUserData reloadData];
}
#pragma mark - Textfield delegate method
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if(textField == txtSearch)
    {
        [textField resignFirstResponder];
        return YES;
    }
    //    NSInteger nextTag = textField.tag + 1;
    //
    //    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    //    if (nextResponder)
    //    {
    //        [nextResponder becomeFirstResponder];
    //    }
    //    else
    //    {
    //        [textField resignFirstResponder];
    //    }
    return NO;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == txtSearch)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if(![newString isEqualToString:@""])
        {
            btnSearchClose.hidden = NO;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name CONTAINS[c] %@",newString];
            
            arrUserSearch = [arrUserData filteredArrayUsingPredicate:predicate];
            
            if (arrUserSearch.count == 0)
            {
               tblvUserData.backgroundView = [ACEUtil viewNoDataWithMessage:@"No Client Found" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.height/1.9];
                [tblvUserData reloadData];
            }
            else
            {
                tblvUserData.backgroundView = nil;
            }
        }
        else
        {
            arrUserSearch = arrUserData.copy;
            btnSearchClose.hidden = YES;
        }
        
        [tblvUserData reloadData];
    }
    else
    {
        [self removeErrorMessageBelowView:textField];
        textField.layer.borderColor = [UIColor borderColor].CGColor;
        
    }
    return YES;
}

-(void)doneTap
{
    
}

#pragma mark - Tableview delegate & datasource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrUserSearch.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACESearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACESearchUserCell"];
    //cell.lblClientName.text = arrUserSearch[indexPath.item];
   // ACEClient *client = [[ACEClient alloc]initWithDictionary:arrUserSearch[indexPath.item]];
    [cell setCellData:arrUserSearch[indexPath.item]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectedUser:arrUserSearch[indexPath.row]];
    [self btnCloseTap:nil];
}
@end
