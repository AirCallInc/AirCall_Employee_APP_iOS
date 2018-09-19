//
//  SelectStateCityViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "SelectStateCityViewController.h"

@interface SelectStateCityViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView      *vwSearch    ;
@property (strong, nonatomic) IBOutlet UILabel     *lblTitle    ;
@property (strong, nonatomic) IBOutlet UITableView *tblvData    ;
@property (strong, nonatomic) IBOutlet UITextField *txtfSearch  ;

@property NSMutableArray  *arrData          ;
@property NSMutableArray  *arrSearchData    ;
@property NSIndexPath     *selectedRow      ;
@property CGRect          tblvFrame         ;
@property BOOL            isKeyboardShow    ;
@end

@implementation SelectStateCityViewController

@synthesize tblvData,isState,stateId,cityId,arrData,selectedRow,lblTitle,vwSearch,tblvFrame,txtfSearch,arrSearchData,isKeyboardShow;

#pragma Mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view endEditing:YES];
    
    arrData       = [[NSMutableArray alloc]init];
    arrSearchData = [[NSMutableArray alloc]init];
    
    [self prepareView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserver];
}
-(void)prepareView
{
    if(isState)
    {
        lblTitle.text = @"Select State";
    }
    else
    {
        lblTitle.text  = @"Select City";
        tblvData.frame = CGRectMake(tblvData.x, vwSearch.y + vwSearch.height, tblvData.width, tblvData.height - vwSearch.height);
    }
    tblvFrame       = tblvData.frame;
    
    [self setUpKeyboardNotificationHandlers];
    [self getData];
}
#pragma mark - Helper Method
-(void)getData
{
    if([ACEUtil reachable])
    {
        if(isState)
        {
            [self getStateData];
        }
        else
        {
            [self getCityData];
        }
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

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
    
    tblvData.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^
     {
         [UIView setAnimationCurve:curve];
         
         [tblvData setFrame:CGRectMake(tblvData.x,
                                           tblvData.y,
                                           tblvData.width,
                                           CGRectGetHeight(tblvData.frame) - CGRectGetHeight(keyboardRect))];
         
     }
    completion:^(BOOL finished)
     {
         tblvData.scrollEnabled = YES;
         
     }];
        isKeyboardShow = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval duration    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    isKeyboardShow         = NO;
    tblvData.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^
     {
         [UIView setAnimationCurve:curve];
         tblvData.frame = tblvFrame;
     }
     completion:^(BOOL finished)
     {
         tblvData.scrollEnabled = YES;
     }];
}


#pragma mark - Webservice Method
-(void)getStateData
{
    [SVProgressHUD show];
    
    [ACEWebServiceAPI getStateList:^(ACEAPIResponse *response, NSMutableArray *stateArray)
     {
         [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             arrData       = stateArray.mutableCopy;
             arrSearchData = stateArray.mutableCopy;
             [tblvData reloadData];
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
             //[self showAlertWithMessage:response.error.localizedDescription];
             [self showAlertWithMessage:ACEUnknownError];
         }
     }];
}
-(void)getCityData
{
    [SVProgressHUD show];
    [ACEWebServiceAPI getCityListFromState:stateId completionHandler:^(ACEAPIResponse *response, NSMutableArray *cityArray)
    {
        [SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
             arrData       = cityArray.mutableCopy;
             arrSearchData = cityArray.mutableCopy;
            
             [tblvData reloadData];
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
            //[self showAlertWithMessage:response.error.localizedDescription];
            [self showAlertWithMessage:ACEUnknownError];
        }
    }];
}
#pragma mark - Event Method
- (IBAction)btnCancelTap:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnSearchCloseTap:(id)sender
{
    [txtfSearch resignFirstResponder];
    txtfSearch.text = @"";
    arrSearchData   = arrData.copy;
    [tblvData reloadData];

}
#pragma mark - UITableview delegate & DataSource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSearchData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACESelectionCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"StateCityCell"];
    
    cell.lblName.text  = [arrSearchData[indexPath.row] valueForKey:GKeyName];
    
    if(isState)
    {
        if([stateId isEqualToString:[[arrSearchData[indexPath.row] valueForKey:GKeyId] stringValue]])
        {
            cell.imgvTick.hidden = NO;
        }
        else
        {
            cell.imgvTick.hidden = YES;
        }
    }
    else
    {
        NSString *strCityId = [NSString stringWithFormat:@"%@",[arrSearchData[indexPath.row] valueForKey:GKeyId]];
        if([cityId isEqualToString:strCityId])
        {
            cell.imgvTick.hidden = NO;
        }
        else
        {
            cell.imgvTick.hidden = YES;
        }

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    selectedRow = indexPath;
//    [tblvData reloadData];
    [self.delegate selectedStatecity:arrSearchData[indexPath.row] andIsstate:isState];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(![newString isEqualToString:@""])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name BEGINSWITH[c] %@",newString];
        
        arrSearchData = [[arrData filteredArrayUsingPredicate:predicate]mutableCopy];
        
        if (arrSearchData.count == 0)
        {
            tblvData.backgroundView = [ACEUtil viewNoDataWithMessage:@"No Cities Found" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.height/1.9];
            //[tblvData reloadData];
        }
        else
        {
            tblvData.backgroundView = nil;
        }
    }
    else
    {
        arrSearchData = arrData.copy;
    }
    [tblvData reloadData];
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
