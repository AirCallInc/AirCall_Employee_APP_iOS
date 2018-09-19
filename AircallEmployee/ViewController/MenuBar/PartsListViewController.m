//
//  PartsListViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "PartsListViewController.h"

@interface PartsListViewController ()<JKExpandTableViewDelegate,JKExpandTableViewDataSource,UITableViewDelegate,UITableViewDataSource,SelectDatePopupViewControllerdelegate>


@property (strong, nonatomic) IBOutlet JKExpandTableView *tblvPartList;
@property (strong, nonatomic) IBOutlet UITableView *tblvRequestedPartList;
@property (strong, nonatomic) IBOutlet UIButton *btnToday;
@property (strong, nonatomic) IBOutlet UIButton *btnTomorrow;
@property (strong, nonatomic) IBOutlet UIButton *btnDate;
@property (strong, nonatomic) IBOutlet UIButton *btnRequest;

@property (strong, nonatomic) IBOutlet UIView *vwSelectDate;
@property (strong, nonatomic) IBOutlet UILabel *lblStartDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDate;
@property BOOL isDateviewOpen   ;
@property BOOL isSatrtDateTap   ;

@property CGRect frmtblv        ;
@property NSString *startDate     ;
@property NSString *endDate       ;

@property (strong, nonatomic) ACELoadMoreCell *loadMoreCell;
@property NSMutableArray *arrRequestedParts;
@property NSMutableArray *arrParts;
@property NSArray *arrPartsInfo;
@property NSString *pageNo;

@end

@implementation PartsListViewController

@synthesize serviceReportList,materialList,tblvPartList,btnDate,btnToday,btnRequest,btnTomorrow,lblStartDate,lblEndDate,vwSelectDate,isDateviewOpen,isSatrtDateTap,frmtblv,startDate,endDate,tblvRequestedPartList,arrRequestedParts,loadMoreCell,pageNo,arrParts,arrPartsInfo;

#pragma mark - ACEViewcontroller Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageNo            = @"1";
    arrRequestedParts = [[NSMutableArray alloc]init];
    arrParts          = [[NSMutableArray alloc]init];
    arrPartsInfo      = [[NSArray alloc]init];
    
    tblvPartList.alwaysBounceVertical          = NO;
    tblvRequestedPartList.alwaysBounceVertical = NO;
    
    
    [tblvPartList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tblvPartList setSeparatorColor:[UIColor clearColor]];
    
    [self btnFilterDateTap:btnToday];
    //[self btnFilterDateTap:btnRequest];
    frmtblv = tblvPartList.frame;
    [tblvPartList          reloadData];
    [tblvRequestedPartList reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    //[self btnFilterDateTap:btnToday];
    //[self btnFilterDateTap:btnRequest];
    //frmtblv = tblvPartList.frame;
    pageNo    = @"1";
    [self getRequestedParts];
    [tblvRequestedPartList reloadData];
}
#pragma mark - Helper method

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
    }
    else
    {
        if(isDateviewOpen)
            [self closeSelectDateView];
    }
    if(sbtn == btnRequest)
    {
        tblvPartList.hidden = YES;
        tblvRequestedPartList.hidden = NO;
    }
    else
    {
        tblvPartList.hidden = NO;
        tblvRequestedPartList.hidden = YES;
    }
}
-(void)openSelectDateView
{
    startDate = @"";
    endDate   = @"";
    lblStartDate.text  = @"Start Date";
    lblEndDate.text    = @"End Date";
    isDateviewOpen     = YES;
    
    [UIView animateWithDuration:0.5 animations:^
     {
         tblvPartList.y       = vwSelectDate.y + vwSelectDate.height + 10;
         tblvPartList.height  = [[UIScreen mainScreen] bounds].size.height - tblvPartList.y;
         vwSelectDate.hidden  = NO;
     }];
    
}
-(void)closeSelectDateView
{
    isDateviewOpen      =   NO;
    
    [UIView animateWithDuration:0.5 animations:^
     {
         tblvPartList.frame   =   frmtblv;
         vwSelectDate.hidden  =   YES;
     }];
}
-(void)openDatePopUp
{
    SelectDatePopupViewController *SDPVC = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectDatePopupViewController"];
    SDPVC.delegate       = self ;
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

#pragma mark - webservice method
-(void)getPartList
{
    if ([ACEUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyEmployeeID : ACEGlobalObject.user.userID,
                               GKeyStartDate  : startDate,
                               GKeyEndDate    : endDate,
                               };
       [ACEWebServiceAPI getPartListAccordingDate:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *arrPartsList)
        {
            [SVProgressHUD dismiss];
            if (response.code == RCodeSuccess)
            {
                arrParts = arrPartsList;
                [tblvPartList setDataSourceDelegate:self];
                [tblvPartList setTableViewDelegate:self];
                [tblvPartList reloadData];
                tblvPartList.backgroundView = nil;
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
            else if (response.code == RCodeNoData)
            {
                 arrParts = arrPartsList;
                
                [tblvPartList setDataSourceDelegate:self];
                [tblvPartList setTableViewDelegate:self];
                [tblvPartList reloadData];
                
                tblvPartList.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.height/1.9];
            }
            else if(response.message)
            {
                [self showAlertWithMessage:response.message];
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
-(void)getRequestedParts
{
    if ([ACEUtil reachable])
    {
        if([pageNo isEqualToString:@"1"])
        {
            [SVProgressHUD show];
        }
        
        NSDictionary *dict = @{
                               UKeyEmployeeID : ACEGlobalObject.user.userID,
                               GKeyPageNumber : pageNo
                               };
        
        [ACEWebServiceAPI getRequestedPartList:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *arrPartList, NSString *pageNumber)
         {
             [SVProgressHUD dismiss];
             
            if (response.code == RCodeSuccess)
             {
                 if([pageNo isEqualToString:@"1"])
                 {
                     arrRequestedParts = arrPartList.mutableCopy;
                 }

                 else if(arrPartList.count == 0)
                 {
                     arrRequestedParts = arrPartList.mutableCopy;
                 }
                 else
                 {
                     [arrRequestedParts addObjectsFromArray:arrPartList];
                 }
                 
                 [tblvRequestedPartList reloadData];
                 tblvRequestedPartList.backgroundView = nil;
                 loadMoreCell.hidden = YES;
                 pageNo = pageNumber;
                 
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
             else if (response.code == RCodeNoData)
             {
                 if([pageNumber isEqualToString:@"1"])
                 {
                     arrRequestedParts = arrPartList;
                    
                     if(arrRequestedParts.count == 0)
                     {
                         tblvRequestedPartList.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.size.height / 1.9];
                     }
                      [tblvRequestedPartList reloadData];
                 }
                 else
                 {
                     loadMoreCell.indicator.hidden = YES;
                     loadMoreCell.lblTitle.text    = ACETextNoMoreData;
                 }
             }
             else if(response.message)
             {
                 loadMoreCell.hidden = YES;
                 tblvRequestedPartList.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.size.height / 1.9];
             }
             else
             {
                 loadMoreCell.hidden = YES;
                 tblvRequestedPartList.backgroundView = [ACEUtil viewNoDataWithMessage:ACEUnknownError andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.size.height / 1.9];
             }
             
             [loadMoreCell.indicator stopAnimating];
             
         }];

    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

#pragma mark - Event Method
- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}

- (IBAction)btnStartDateTap:(id)sender
{
     isSatrtDateTap = YES;
    [self openDatePopUp];
    
}
- (IBAction)btnEndDateTap:(id)sender
{
    isSatrtDateTap = NO;
    [self openDatePopUp];
}
- (IBAction)btnFilterDateTap:(UIButton *)btn
{
    pageNo    = @"1";
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    if(btn == btnToday)
    {
        startDate = [NSString stringWithFormat:@"%@",[NSDate date]];
        endDate   = @"";
        
        [self setSelectedButton:btnToday andDeseselect:btnRequest and:btnTomorrow and:btnDate];
        [self getPartList];
    }
    else if(btn == btnTomorrow)
    {
        [components setDay:1];
        
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
        
        startDate = [NSString stringWithFormat:@"%@",date];
        endDate   = @"";
        
        [self setSelectedButton:btnTomorrow andDeseselect:btnRequest and:btnToday and:btnDate];
        [self getPartList];
    }
    else if(btn == btnRequest)
    {
        [self setSelectedButton:btnRequest andDeseselect:btnTomorrow and:btnToday and:btnDate];
       
        [self getRequestedParts];
    }
    else if(btn == btnDate)
    {
        startDate = @"";
        endDate   = @"";
        arrParts  = nil;
        [tblvPartList reloadData];
        [self setSelectedButton:btnDate andDeseselect:btnRequest and:btnToday and:btnTomorrow];
        //[self getPartList];
    }
}

- (IBAction)btnPlusTap:(id)sender
{
    RequestPartViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestPartViewController"];
    
    [self.navigationController pushViewController:rvc animated:YES];
}

#pragma mark - JKExpandTableViewDelegate
- (BOOL) shouldSupportMultipleSelectableChildrenAtParentIndex:(NSInteger) parentIndex
{
    return NO;
}

- (void) tableView:(UITableView *)tableView didSelectCellAtChildIndex:(NSInteger) childIndex withInParentCellIndex:(NSInteger) parentIndex
{
    //[[self.dataModelArray objectAtIndex:parentIndex] setObject:[NSNumber numberWithBool:YES] atIndex:childIndex];
   // NSLog(@"data array: %@", self.dataModelArray);
}

- (void) tableView:(UITableView *)tableView didDeselectCellAtChildIndex:(NSInteger) childIndex withInParentCellIndex:(NSInteger) parentIndex
{
    //[[self.dataModelArray objectAtIndex:parentIndex] setObject:[NSNumber numberWithBool:NO] atIndex:childIndex];
    //NSLog(@"data array: %@", self.dataModelArray);
}

- (UIColor *) backgroundColor
{
 return [UIColor selectedBackgroundColor];
 
}

- (UIFont *) fontForParents {
    return [UIFont fontWithName:@"OpenSans" size:16];
}

- (UIFont *) fontForChildren {
    return [UIFont fontWithName:@"OpenSans" size:14];
}

#pragma mark - JKExpandTableViewDataSource
-(UIImage *)iconForParentCellAtIndex:(NSInteger)parentIndex
{
    return [UIImage imageNamed:@"nextarrow"];
}
-(UIImage *)reportIconForParentCellAtIndex:(NSInteger)parentIndex
{
    return [UIImage imageNamed:@"servicereport"];
}
- (NSInteger) numberOfParentCells
{
    return [self.arrParts count];
}

- (NSInteger) numberOfChildCellsUnderParentIndex:(NSInteger) parentIndex
{
//    NSMutableArray *childArray = [self.serviceReportList objectAtIndex:parentIndex];
    ACEParts *parts = arrParts[parentIndex];
    arrPartsInfo    = parts.arrParts;
    return arrPartsInfo.count;
}

- (NSString *) labelForParentCellAtIndex:(NSInteger) parentIndex
{
    
    ACEParts *part = arrParts[parentIndex];
    return [NSString stringWithFormat:@"%@(%@)",part.ReportNo,part.clientName];
   
}

- (NSString *) labelForCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex
{
    ACEParts *parts = arrParts[parentIndex];
    arrPartsInfo    = parts.arrParts;
    ACEParts *part  = [[ACEParts alloc]initDictioanryWithDate:arrPartsInfo[childIndex]];
    return [NSString stringWithFormat:@"%@",part.partName];
}

//mine code
-(NSString *)labelforQntyAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex
{
    ACEParts *parts = arrParts[parentIndex];
    arrPartsInfo    = parts.arrParts;
    ACEParts *part  = [[ACEParts alloc]initDictioanryWithDate:arrPartsInfo[childIndex]];
    return part.Qty;
}
- (BOOL) shouldDisplaySelectedStateForCellAtChildIndex:(NSInteger) childIndex withinParentCellIndex:(NSInteger) parentIndex
{
    NSMutableArray *childArray = [self.serviceReportList objectAtIndex:parentIndex];
    return [[childArray objectAtIndex:childIndex] boolValue];
}
- (BOOL) shouldRotateIconForParentOnToggle
{
    return YES;
}

#pragma mark - Tableview delegate and datasource method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        NSInteger numberOfRows = arrRequestedParts.count;
        
        if(numberOfRows > 0)
        {
            numberOfRows = arrRequestedParts.count + 1;
        }
        return numberOfRows;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < arrRequestedParts.count)
    {
            ACEPartListCell *partCell = [tableView dequeueReusableCellWithIdentifier:@"ACEPartListCell" forIndexPath:indexPath];
            
            partCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            ACEParts *parts = arrRequestedParts[indexPath.row];
        
            partCell.lblPartName.text   = parts.partName   ;
            partCell.lblClientName.text = parts.clientName ;
            partCell.lblDate.text       = parts.Date       ;
            partCell.lblQty.text        = parts.Qty        ;
            partCell.lblStatus.text     = parts.Status     ;
        
            if([parts.Status isEqualToString:PKeyStatusNeedToOrder])
            {
                partCell.imgvStatus.image = [UIImage imageNamed:@"edit-round"];
            }
            else if([parts.Status isEqualToString:PKeyStatusDiscontinued] || [parts.Status isEqualToString:PKeyStatusCancelled] )
            {
                partCell.imgvStatus.image = [UIImage imageNamed:@"error"];
            }
            else if([parts.Status isEqualToString:PKeyStatusCompleted])
            {
                partCell.imgvStatus.image = [UIImage imageNamed:@"correct"];
            }
            else
            {
               partCell.imgvStatus.image = [UIImage imageNamed:@"error"];
            }
            //unit = arrUnitsList[indexPath.row];
           // [partCell setCellData:parts];
            return partCell;
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
        
        [self performSelector:@selector(getRequestedParts) withObject:nil afterDelay:0.5];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < arrRequestedParts.count)
    {
        ACEParts *parts = arrRequestedParts[indexPath.item];
        if([parts.Status isEqualToString:PKeyStatusNeedToOrder])
        {
            
            RequestPartViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"RequestPartViewController"];
            
            vc.isEditable       = YES;
            vc.empRequestId     = parts.empRequestId;
            vc.partId           = parts.ID;
            
            [self.navigationController  pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - SelectDate Delegate Method
-(void)selectedDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    
    if(isSatrtDateTap)
    {
        startDate           =  [NSString stringWithFormat:@"%@",date];
        lblStartDate.text   =  [formatter stringFromDate:date];
    }
    else
    {
        endDate           =  [NSString stringWithFormat:@"%@",date];
        lblEndDate.text   =  [formatter stringFromDate:date];
    }
    if (![startDate isEqualToString:@""] && ![endDate isEqualToString:@""])
    {
        
        formatter     = [[NSDateFormatter alloc]init];
        //[formatter setDateFormat:@"MMM dd, yyyy"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zz";
        
        NSDate *start = [formatter dateFromString:startDate];
        NSDate *end   = [formatter dateFromString:endDate];
        
        NSDate *startAc = [self dateWithOutTime:start];
        NSDate *endAc   = [self dateWithOutTime:end];
        
        if([startAc compare:endAc]== NSOrderedAscending || [startAc compare:endAc]== NSOrderedSame)
        {
            pageNo = @"1";
            [self getPartList];
        }
        else
        {
            arrParts = [[NSMutableArray alloc]init];
            [tblvPartList reloadData];
            tblvPartList.backgroundView =   [ACEUtil viewNoDataWithMessage:ACEInvalidDate andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPartList.height];
        }

        
    }
    
    
}
-(NSDate *)dateWithOutTime:(NSDate *)datDate {
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}
/*
 //-(void)getPartsData
 //{
 //    [self initializeSampleDataModel];
 //}
 //
 //- (void) initializeSampleDataModel
 //{
 //    self.serviceReportList = [[NSMutableArray alloc] initWithCapacity:3];
 //
 //    NSMutableArray *parent0 = [NSMutableArray arrayWithObjects:
 //                               [NSNumber numberWithBool:YES],
 //                               [NSNumber numberWithBool:NO],
 //                               [NSNumber numberWithBool:NO],
 //                               nil];
 //    NSMutableArray *parent1 = [NSMutableArray arrayWithObjects:
 //                               [NSNumber numberWithBool:NO],
 //                               [NSNumber numberWithBool:NO],
 //                               [NSNumber numberWithBool:NO],
 //                               nil];
 //    NSMutableArray *parent2 = [NSMutableArray arrayWithObjects:
 //                               [NSNumber numberWithBool:NO],
 //                               [NSNumber numberWithBool:YES],
 //                               nil];
 //    NSMutableArray *parent3 = [NSMutableArray arrayWithObjects:
 //                               [NSNumber numberWithBool:NO],
 //                               [NSNumber numberWithBool:YES],
 //                               [NSNumber numberWithBool:NO],
 //                               nil];
 //
 //    [self.serviceReportList addObject:parent0];
 //    [self.serviceReportList addObject:parent1];
 //    [self.serviceReportList addObject:parent2];
 //    [self.serviceReportList addObject:parent3];
 //    [self.tblvPartList reloadData];
 //}
 */

@end
