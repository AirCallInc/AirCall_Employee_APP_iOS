//
//  ACUnitListViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACUnitListViewController.h"

@interface ACUnitListViewController ()<UITableViewDelegate,UITableViewDataSource,SelectDatePopupViewControllerdelegate,AddUnitPopupViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView  *tblvACUnits;
@property (strong, nonatomic) IBOutlet UIButton     *btnToday;
@property (strong, nonatomic) IBOutlet UIButton     *btnYesterday;
@property (strong, nonatomic) IBOutlet UIButton     *btnTomorrow;
@property (strong, nonatomic) IBOutlet UIButton     *btnDate;
@property (strong, nonatomic) IBOutlet UIView       *vwSelectDate;
@property (strong, nonatomic) IBOutlet UILabel      *lblStartDate;
@property (strong, nonatomic) IBOutlet UILabel      *lblEndDate;
@property (strong, nonatomic) ACELoadMoreCell       *loadMoreCell;

@property BOOL isDateviewOpen   ;
@property BOOL isSatrtDateTap   ;
@property BOOL isPendingUnits   ;

@property CGRect frmtblv;

@property NSString *startDate ;
@property NSString *endDate   ;

@property NSMutableArray *arrUnit;
@property NSString *pageNo;

@property NSDateFormatter *dateFormatter;
@end

@implementation ACUnitListViewController
@synthesize btnDate,btnToday,btnTomorrow,btnYesterday,lblEndDate,lblStartDate,vwSelectDate,isDateviewOpen,frmtblv,startDate,endDate,isSatrtDateTap,arrUnit,pageNo,loadMoreCell,dateFormatter,isPendingUnits;

@synthesize tblvACUnits;

- (void)viewDidLoad
{
    //[super viewDidLoad];
    arrUnit       = [[NSMutableArray alloc]init];
    dateFormatter = [[NSDateFormatter alloc]init];
    startDate     = [dateFormatter stringFromDate:[NSDate date]];
    endDate       = [dateFormatter stringFromDate:[NSDate date]];
    
   // [self btnFilterTap:btnToday];
   // frmtblv = tblvACUnits.frame;
    
   // [self getUnitList];
    
    [self btnFilterTap:btnToday];
    frmtblv = tblvACUnits.frame;

}
-(void)viewDidAppear:(BOOL)animated
{
//    [self btnFilterTap:btnToday];
//    frmtblv = tblvACUnits.frame;
}
#pragma mark - Helper Method
-(void)openSelectDateView
{
    startDate = @"";
    endDate   = @"";
    lblStartDate.text  = @"Start Date";
    lblEndDate.text    = @"End Date";
    isDateviewOpen = YES;
    
    [UIView animateWithDuration:0.5 animations:^
    {
        tblvACUnits.y       = vwSelectDate.y + vwSelectDate.height + 10;
        tblvACUnits.height  = [[UIScreen mainScreen] bounds].size.height - tblvACUnits.y;
        vwSelectDate.hidden = NO;
    }];
    
}
-(void)closeSelectDateView
{
    isDateviewOpen      =   NO;
    
    [UIView animateWithDuration:0.5 animations:^
     {
         tblvACUnits.frame   =   frmtblv;
         vwSelectDate.hidden =   YES;
     }];
}
-(void)openPickrView
{
    
    SelectDatePopupViewController *SDPVC = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectDatePopupViewController"];
    
    SDPVC.delegate       = self;
    SDPVC.isFromScheduleNRequest = NO;
    
    if(isSatrtDateTap)
    {
        if(![endDate isEqualToString:@""])
        {
            SDPVC.isMaximumDate = YES    ;
            SDPVC.selectedDate  = lblEndDate.text;
        }
    }
    else
    {
        if(![startDate isEqualToString:@""])
        {
            SDPVC.isMinimum     = YES;
            SDPVC.selectedDate  = lblStartDate.text;
        }
    }
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [SDPVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:SDPVC animated:NO completion:nil];
}
-(void)openPaymentOption
{
    AddUnitPopupViewController *viewController  = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddUnitPopupViewController"];
    viewController.delegate = self;
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [viewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:viewController animated:NO completion:nil];
}
//-(BOOL)isPreviouslyAddedUnit
//{
////    if([ACEUtil reachable])
////    {
////        
////    }
////    else
////    {
////        [self showAlertWithMessage:ACENoInternet];
////    }
//    
//}
#pragma mark - Event Methods
- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}
- (IBAction)btnStartDateTap:(UIButton *)btn
{
    isSatrtDateTap = YES;
    [self openPickrView];
}
- (IBAction)btnEndTap:(UIButton *)btn
{
    isSatrtDateTap = NO;
    [self openPickrView];
}
- (IBAction)btnFilterTap:(UIButton *)btn
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    pageNo = @"1";
    
    if(btn == btnToday)
    {
        startDate = [NSString stringWithFormat:@"%@",[NSDate date]];
        endDate   = @"";
        [self setSelectedButton:btnToday andDeseselect:btnYesterday and:btnTomorrow and:btnDate];
    }
    else if(btn == btnTomorrow)
    {
         [components setDay:1];
        
         NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
        
         startDate = [NSString stringWithFormat:@"%@",date];
         endDate   = @"";
        
        [self setSelectedButton:btnTomorrow andDeseselect:btnYesterday and:btnToday and:btnDate];
    }
    else if(btn == btnYesterday)
    {
        [components setDay:-1];
        
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
        
        startDate = [NSString stringWithFormat:@"%@",date];
        endDate   = @"";
        
        [self setSelectedButton:btnYesterday andDeseselect:btnTomorrow and:btnToday and:btnDate];
       
    }
    else if(btn == btnDate)
    {
        [self setSelectedButton:btnDate andDeseselect:btnYesterday and:btnToday and:btnTomorrow];
    }

}
-(void)setSelectedButton:(UIButton *)sbtn andDeseselect:(UIButton *)btn1 and:(UIButton *)btn2 and:(UIButton*)btn3
{
    sbtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shadow"]];
    sbtn.titleLabel.textColor = [UIColor whiteColor];
    
    [sbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btn1.backgroundColor        = [UIColor selectedBackgroundColor];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn2.backgroundColor        = [UIColor selectedBackgroundColor];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn3.backgroundColor        = [UIColor selectedBackgroundColor];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if(sbtn == btnDate)
    {
        [self openSelectDateView];
        if(![startDate isEqualToString:@""] && ![endDate isEqualToString:@""])
        {
            [self getUnitList];
        }
        else
        {
            startDate = @"";
            endDate   = @"";
            arrUnit   = nil;
            [tblvACUnits reloadData];
        }
    }
    else
    {
        if(isDateviewOpen)
        {
            [self closeSelectDateView];
        }
        [self getUnitList];
    }
}

- (IBAction)btnPlusTap:(id)sender
{
    if([ACEUtil reachable])
    {
        if(!isPendingUnits)
        {
       /* AddUnitClientInfoViewController *aucivc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddUnitClientInfoViewController"];
        aucivc.paymnetOption = CHKeyCC;
        
        [self.navigationController pushViewController:aucivc animated:YES];*/
        
        [self openPaymentOption];
        
        }
        else
        {
            [ACEUtil showAlertFromControllerWithDoubleAction:self withMessage:ACEPendingUnitMsg andHandler:^(UIAlertAction * _Nullable action)
             {
                 UnitSummaryViewController *usvc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"UnitSummaryViewController"];
             
                 usvc.isPending     = isPendingUnits;
             
                 [self.navigationController pushViewController:usvc animated:YES];
             }
            andNoHandler:^(UIAlertAction * _Nullable action)
             {
            
                 [self callWebserviceToDeleteUnit];
            
             }];
        }
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
#pragma mark - SelectDatePopupViewControllerdelegate method

-(void)selectedDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    //startDate = @"";
    //endDate   = @"";
    
    if(isSatrtDateTap)
    {
        dateFormatter.dateFormat = @"dd-MM-yyyy";
        lblStartDate.text   =   [formatter stringFromDate:date];
        startDate           =   [NSString stringWithFormat:@"%@",date];
    }
    else
    {
        dateFormatter.dateFormat = @"dd-MM-yyyy";
        endDate             =   [formatter stringFromDate:date];
        lblEndDate.text     =   [formatter stringFromDate:date];
    }
    
    if(![startDate isEqualToString:@""] && ![endDate isEqualToString:@""])
    {
        formatter     = [[NSDateFormatter alloc]init];
        //[formatter setDateFormat:@"MMM dd, yyyy"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zz";
        
        NSDate *start = [formatter dateFromString:startDate];
        NSDate *end   = [formatter dateFromString:endDate];
       
        NSDate *startAc = [self dateWithOutTime:start];
        NSDate *endAc   = [self dateWithOutTime:end];
        
        if([startAc compare:endAc]== NSOrderedAscending  || [startAc compare:endAc]== NSOrderedSame)
        {
            pageNo = @"1";
            [self getUnitList];
        }
        else
        {
           //[self showAlertWithMessage:ACEInvalidDate];
           
          // pageNo = @"1";
            arrUnit = [[NSMutableArray alloc]init];
           
            [tblvACUnits reloadData];
            
            tblvACUnits.backgroundView =   [ACEUtil viewNoDataWithMessage:ACEInvalidDate andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvACUnits.height];
        }
        
    }
}
-(NSDate *)dateWithOutTime:(NSDate *)datDate
{
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    if( datDate == nil )
    {
        datDate = [NSDate date];
    }
    
    NSString *strDate = [dateFormatter stringFromDate:datDate];
    return [dateFormatter dateFromString:strDate];
    
//    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
//    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}
#pragma mark - UITableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = arrUnit.count;
    
    if(numberOfRows > 0)
    {
        numberOfRows = arrUnit.count + 1;
    }
    return numberOfRows;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < arrUnit.count)
    {
        ACEAcUnitCell *cell = (ACEAcUnitCell *) [tableView dequeueReusableCellWithIdentifier:@"ACEAcUnitCell"];
        
        ACEACUnit  *unit    = arrUnit[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setCellData:unit];
        return cell;
    }
    else
    {
        if(!loadMoreCell)
        {
            loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell" forIndexPath:indexPath];
            loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return loadMoreCell;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell isKindOfClass:[ACELoadMoreCell class]])
    {
        loadMoreCell.lblTitle.text    = ACETextLoading;
        loadMoreCell.hidden           = NO;
        loadMoreCell.indicator.hidden = NO;
        
        [loadMoreCell.indicator startAnimating];
        
        [self performSelector:@selector(getUnitList) withObject:nil afterDelay:0.5];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < arrUnit.count)
    {
        ACEACUnit  *unit = arrUnit[indexPath.row];
        
        EditUnitViewController *euvc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"EditUnitViewController"];
        euvc.unitDetail    = unit;
        
        [self.navigationController pushViewController:euvc animated:YES];
    }
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}
#pragma mark - WebService Method
-(void)getUnitList
{
    if([ACEUtil reachable])
    {
        if(![startDate isEqualToString:@""])
        {
            NSDictionary *dict = @{
                                   UKeyEmployeeID :ACEGlobalObject.user.userID,
                                   GKeyPageNumber :pageNo,
                                   GKeyStartDate  :startDate,
                                   GKeyEndDate    :endDate
                                   };
            if([pageNo isEqualToString:@"1"])
            {
                [SVProgressHUD show];
            }
            
            [ACEWebServiceAPI getUnitList:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *arrUnits, NSString *pageNumber,BOOL isPending)
             {
                 [SVProgressHUD dismiss];
                 
                 isPendingUnits = isPending;
                 
                 if (response.code == RCodeSuccess)
                 {
                     if([pageNo isEqualToString:@"1"])
                     {
                         arrUnit = arrUnits.mutableCopy;
                     }
                     else if(arrUnits.count == 0)
                     {
                         arrUnit = arrUnits.mutableCopy;
                     }
                     else
                     {
                         [arrUnit addObjectsFromArray:arrUnits];
                     }
                     
                     [tblvACUnits reloadData];
                     
                     loadMoreCell.hidden = YES;
                     pageNo = pageNumber;
                     tblvACUnits.backgroundView = nil;
                 }
                 else if (response.code == RCodeNoData)
                 {
                     if([pageNumber isEqualToString:@"1"])
                     {
                         arrUnit = arrUnits;
                         
                         if(arrUnit.count == 0)
                         {
                             tblvACUnits.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.size.height / 1.9];
                         }
                         
                         [tblvACUnits reloadData];
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
                 else
                 {
                     loadMoreCell.hidden = YES;
                     tblvACUnits.backgroundView = [ACEUtil viewNoDataWithMessage:ACEUnknownError andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.size.height / 1.9];
                 }
                 
                 [loadMoreCell.indicator stopAnimating];
             }];
        }
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)callWebserviceToDeleteUnit
{
    if([ACEUtil reachable])
    {
        NSDictionary *dict = @{
                               UKeyEmployeeID :ACEGlobalObject.user.userID
                               };
        
        [ACEWebServiceAPI deletePendingUnits:dict CompletionHandler:^(ACEAPIResponse *response)
        {
            if(response.code == RCodeSuccess)
            {
                /*AddUnitClientInfoViewController *aucivc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddUnitClientInfoViewController"];
                
                aucivc.paymnetOption = CHKeyCC;
                
                [self.navigationController pushViewController:aucivc animated:YES];*/
                
                isPendingUnits = NO;
                [self openPaymentOption];
            }
            else
            {
                [self showAlertWithMessage:ACEUnknownError];
            }
        }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }

}

#pragma mark  - AddUnitPopupViewControllerDelegate Method
-(void)selectedPaymentOption:(NSString *)selectedOption
{
        AddUnitClientInfoViewController *aucivc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddUnitClientInfoViewController"];
    
        selectedOption = selectedOption;
    
        aucivc.paymnetOption = selectedOption;
    
        [self.navigationController pushViewController:aucivc animated:YES];
}
@end
