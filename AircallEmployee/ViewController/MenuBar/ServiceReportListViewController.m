//
//  ServiceReportListViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ServiceReportListViewController.h"

@interface ServiceReportListViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblvServiceReport;
@property (weak, nonatomic) IBOutlet UIButton    *btnSearchClose;

@property (strong, nonatomic) NSMutableArray *arrServiceReport     ;
//@property (strong, nonatomic) NSMutableArray *arrSearch            ;

@property NSString *pageNo      ;
@property NSString *searchTerm  ;
@property CGRect   tblvFrame    ;

@property (strong, nonatomic)ACELoadMoreCell   *loadMoreCell;
@end

@implementation ServiceReportListViewController
@synthesize arrServiceReport,tblvServiceReport,txtSearch,pageNo,loadMoreCell,searchTerm,tblvFrame,btnSearchClose;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
      //arrSearch        = [[NSMutableArray alloc]init];
    tblvServiceReport.alwaysBounceVertical = NO;
    
    arrServiceReport = [[NSMutableArray alloc]init];
    
    tblvFrame        = tblvServiceReport.frame;
    //[self setUpKeyboardNotificationHandlers];
    pageNo      = @"1";
    searchTerm  = @"";
    btnSearchClose.hidden = YES;
    [self getServiceReportList];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self setUpKeyboardNotificationHandlers];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserver];
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
#pragma mark - Keyboard Notification Methods
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardRect        = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSTimeInterval duration    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    tblvServiceReport.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^
     {
         [UIView setAnimationCurve:curve];
         
         [tblvServiceReport setFrame:CGRectMake(tblvServiceReport.x,
                                         tblvServiceReport.y,
                                         tblvServiceReport.width,
                                         CGRectGetHeight(tblvServiceReport.frame) - CGRectGetHeight(keyboardRect))];
     }
      completion:^(BOOL finished)
     {
         tblvServiceReport.scrollEnabled = YES;

     }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval duration    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    tblvServiceReport.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^
     {
         [UIView setAnimationCurve:curve];
         tblvServiceReport.frame = tblvFrame;
         
     }
    completion:^(BOOL finished)
     {
         tblvServiceReport.scrollEnabled = YES;
     }];
}

#pragma mark - event method
- (IBAction)btnMenuTap:(id)sender
{
    [self.view endEditing:YES];
    [self openSideBar];
}
- (IBAction)btnSearchCloseTap:(UIButton *)sender
{
    txtSearch.text = @"";
    searchTerm     = @"";
    pageNo         = @"1";
    btnSearchClose.hidden = YES;
    
    [self.view endEditing:YES];
    [self getServiceReportList];
    //arrSearch      = arrServiceReport;
}

#pragma mark - Webservice Method
-(void)getServiceReportList
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
    if([pageNo isEqualToString:@"1"] && [searchTerm isEqualToString:@""])
    {
        [SVProgressHUD show];
    }
    
    NSDictionary *dict =@{
                          UKeyEmployeeID : ACEGlobalObject.user.userID,
                          GKeyPageNumber : pageNo,
                          GKeySearchTerm : searchTerm
                         };
    
    [ACEWebServiceAPI getServiceReportList:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *reportArray, NSString *pageNumber)
     {
         [SVProgressHUD dismiss];
         
         if(response.code == RCodeSuccess)
         {
             if([pageNo isEqualToString:@"1"])
             {
                 arrServiceReport = reportArray.mutableCopy;
             }
             else if(reportArray.count == 0)
             {
                 arrServiceReport = reportArray.mutableCopy;
                 //arrSearch        = reportArray.mutableCopy;
             }
             else
             {
                 [arrServiceReport addObjectsFromArray:reportArray];
                 //[arrSearch addObjectsFromArray:reportArray];
             }
             
            [tblvServiceReport reloadData];
            loadMoreCell.hidden = YES;
             pageNo = pageNumber;
         }
         else if (response.code == RCodeNoData)
         {
             if([pageNumber isEqualToString:@"1"])
             {
                 arrServiceReport = reportArray;
                 
                 if(reportArray.count == 0)
                 {
                     tblvServiceReport.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvServiceReport.height];
                 }
                 [tblvServiceReport reloadData];
             }
             else
             {
                 loadMoreCell.indicator.hidden = YES;
                 loadMoreCell.lblTitle.text = ACETextNoMoreData;
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
         else if(response.message)
         {
             [self showAlertWithMessage:response.message];
         }
         else
         {
             //[self showAlertWithMessage:response.error.localizedDescription];
             [self showAlertWithMessage:ACEUnknownError];
         }
         [loadMoreCell.indicator stopAnimating];
     }];
}
#pragma mark - Helper Method
-(BOOL)isStringNumeric:(NSString *)inputString
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([inputString rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }
    return NO;
}
#pragma mark - textfield delegate method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    searchTerm     = newString;
    pageNo         = @"1";
    
    if ([searchTerm isEqualToString:@""])
    {
        btnSearchClose.hidden = YES;
    }
    else
    {
        btnSearchClose.hidden = NO;
    }
    
    [self getServiceReportList];
    return YES;
}

#pragma mark - tableViewDelegateMethods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = arrServiceReport.count;
    if(numOfRows > 0)
    {
        numOfRows += 1;
    }
    
    return numOfRows;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tblvServiceReport.backgroundView = nil;
    
    if(indexPath.row < arrServiceReport.count)
    {
        ACEServiceReportCell *cell = (ACEServiceReportCell *)[tableView dequeueReusableCellWithIdentifier:@"ServiceReportCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ACEServiceReport *report = arrServiceReport[indexPath.row];
    
        [cell setCellData:report];
    
        [cell setSeparatorInset:UIEdgeInsetsZero];
        return cell;
    }
    else
    {
        if(!loadMoreCell)
        {
            loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"LoadMoreCell"];
            loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return loadMoreCell;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([cell isKindOfClass:[ACELoadMoreCell class]])
    {
        loadMoreCell.lblTitle.text = ACETextLoading;
        loadMoreCell.hidden = NO;
        loadMoreCell.indicator.hidden = NO;
        
        [loadMoreCell.indicator startAnimating];
        
        [self performSelector:@selector(getServiceReportList) withObject:nil afterDelay:0.5];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row < arrServiceReport.count)
    {
        ACEServiceReport *report = arrServiceReport[indexPath.row];
    
        ServiceReportDetailViewController *SRDVC = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ServiceReportDetailViewController"];
    
        SRDVC.serviceReportId = report.ID;
    
        [self.navigationController pushViewController:SRDVC animated:YES];
    }
}

/*-(void)serachInApplication
{
    if ([newString rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        // newString consists only of the digits 0 through 9
    }
        if(![newString isEqualToString:@""])
        {
            NSPredicate *predicate;
            if([self isStringNumeric:newString])
            {
                predicate = [NSPredicate predicateWithFormat:@"clientMobileNum BEGINSWITH[c] %@",newString];
                arrSearch = [arrServiceReport filteredArrayUsingPredicate:predicate];
                if(arrSearch.count == 0)
                {
                    predicate = [NSPredicate predicateWithFormat:@"clientPhoneNum BEGINSWITH[c] %@",newString];
    
                    arrSearch = [arrServiceReport filteredArrayUsingPredicate:predicate];
    
                    if(arrSearch.count == 0)
                    {
                        predicate = [NSPredicate predicateWithFormat:@"clientOfficeNum BEGINSWITH[c] %@",newString];
    
                        arrSearch = [arrServiceReport filteredArrayUsingPredicate:predicate];
                    }
                }
            }
            else
            {
                predicate = [NSPredicate predicateWithFormat:@"ClientName BEGINSWITH[c] %@",newString];
                arrSearch = [arrServiceReport filteredArrayUsingPredicate:predicate];
            }
    
    
    
    
            if (arrSearch.count == 0)
            {
                tblvServiceReport.backgroundView = [ACEUtil viewNoDataWithMessage:@"No service report found" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvServiceReport.height];
            }
        }
        else
        {
            arrSearch = arrServiceReport.copy;
        }
        [tblvServiceReport reloadData];
 
 
 //animated tableview
 dispatch_async(dispatch_get_main_queue(), ^{
 [UIView transitionWithView:tblvServiceReport
 duration:0.8f
 options:UIViewAnimationOptionTransitionCrossDissolve
 animations:^(void) {
 [tblvServiceReport reloadData];
 } completion:NULL];
 });

}*/
@end
