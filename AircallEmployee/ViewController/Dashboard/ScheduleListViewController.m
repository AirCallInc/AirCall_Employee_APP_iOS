//
//  ScheduleListViewController.m
//  AircallEmployee
//
//  Created by ZWT112 on 5/6/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ScheduleListViewController.h"

@interface ScheduleListViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UITableViewDataSource,UITableViewDelegate,ChangeCalenderPopupViewControllerProtocol>

@property (strong, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) FSCalendarAppearance *appreance;

@property (strong, nonatomic) NSMutableArray *arrscheduleDates;
@property (strong, nonatomic) NSMutableArray *arrScheduleData;


@property (strong, nonatomic) IBOutlet UITableView *tblvSchedule;

@property NSString *currentOption;
@property NSDate   *selectedDate;

@property UIButton *previousButton;
@property UIButton *nextButton;

@end

@implementation ScheduleListViewController
@synthesize calendar,appreance,arrscheduleDates,tblvSchedule,arrScheduleData,currentOption,selectedDate,lblNotificationCount,btnNotification,previousButton,nextButton;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
       //[self setTableData:[NSDate date]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setCalendarAppreance];
    [self prepareView];
}
#pragma mark - Helper Method
-(void)prepareView
{
    arrscheduleDates = [[NSMutableArray alloc]init]; // used to display dots below dates of Month
    
    arrScheduleData  = [[NSMutableArray alloc]init]; // used to display schedule data
    
    tblvSchedule.alwaysBounceVertical = NO;
    tblvSchedule.separatorStyle       = UITableViewCellSeparatorStyleNone;
    [tblvSchedule reloadData];
    [calendar reloadData];
    
    currentOption                     = CalenderOptionWeek;
    selectedDate                      = [NSDate date];
  
    if([ACEUtil reachable])
    {
        NSString *mnth = [NSString stringWithFormat:@"%ld",(long)[calendar monthOfDate:[NSDate date]]];
        
        NSString *year = [NSString stringWithFormat:@"%ld",(long)[calendar yearOfDate:[NSDate date]]];
        
        [self getScheduleDatesForMonth:mnth andYear:year]; //Gives Schedule dates list of current month and next month which will used to display event dot below date in calender
       
        [self setTableData:[NSDate date]]; // Gives list of schedules of today
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }

}

-(void)setCalendarAppreance
{
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.allowsMultipleSelection = NO;

    //OpenSans-Bold
    appreance                       = [calendar appearance];
    appreance.titleDefaultColor     = [UIColor blackColor];
    appreance.selectionColor        = [UIColor appGreenColor];
    appreance.subtitleWeekendColor  = [UIColor appGreenColor];
    appreance.weekdayTextColor      = [UIColor appGreenColor];
    appreance.weekdayFont           = [UIFont fontWithName:@"OpenSans-Bold" size:20.0f];
    
    appreance.subtitleFont          = [UIFont fontWithName:@"OpenSans-Regular" size:15.0f];
    appreance.headerTitleFont       = [UIFont fontWithName:@"OpenSans-Regular" size:10.0f];
    
    appreance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
    
    appreance.headerMinimumDissolvedAlpha = 0.0;

    appreance.titleSelectionColor   = [UIColor whiteColor];
    appreance.headerTitleColor      = [UIColor blackColor];
    appreance.todayColor            = [UIColor redColor];
    
    previousButton                  = [[UIButton alloc]init];
    
    previousButton.frame            = CGRectMake(0, 64+5, 50, 34);
    previousButton.backgroundColor  = [UIColor whiteColor];
    
    [previousButton setImage:[UIImage imageNamed:@"prevcal"] forState:UIControlStateNormal];
    
    [previousButton addTarget:self action:@selector(btnPreviousTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:previousButton];
  
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-50-5, 64+5, 50, 34);
    nextButton.backgroundColor = [UIColor whiteColor];
    
    [nextButton setImage:[UIImage imageNamed:@"nextcal"] forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(btnNextTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    [calendar selectDate:[NSDate date]];
    [calendar setCurrentPage:[NSDate date] animated:YES];
}
-(void)openMapApplication:(ACESchedule *)schedule
{
    
    AppDelegate  *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(delegate.latitude != nil && delegate.longitude != nil)
    {
        
       MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([schedule.destLattitude doubleValue], [schedule.destLongitude doubleValue]) addressDictionary:nil];
        
       //MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(34.0593550900,  -118.3730809500) addressDictionary:nil];
    
      MKMapItem *destMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
      [destMapItem setName:schedule.clientAddress];
    
        
       MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([delegate.latitude doubleValue], [delegate.longitude doubleValue]) addressDictionary:nil];
    
     // MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(34.0593550900,  -118.3730809500) addressDictionary:nil];
    
       MKMapItem *currentMapItem = [[MKMapItem alloc] initWithPlacemark:placemark1];
    
       [currentMapItem setName:@"Current Location"];
        
       // NSString *msg = [[NSString alloc]initWithFormat:@"Current Location\n lattitude : %@\n longitude : %@ \n Destination\n lattitude : %@\n longitude : %@",delegate.latitude,delegate.longitude,schedule.destLattitude,schedule.destLongitude];
        
       // [self showAlertFromWithMessageWithSingleAction:msg andHandler:^(UIAlertAction * _Nullable action)
        //{
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
            
            [MKMapItem openMapsWithItems:@[currentMapItem, destMapItem]
                           launchOptions:launchOptions];
        //}];
    
     
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"%@ does not have access to your Location. To enable Location, tap Settings and select location and check 'always' option.",appName];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                          }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}
#pragma mark - Event Method
- (IBAction)btnPreviousTap:(id)sender
{
    NSDate *currentDate = calendar.currentPage;
    NSDate *previousDate;
    
    if(calendar.scope == FSCalendarScopeWeek)
    {
        previousDate   = [calendar dateBySubstractingWeeks:1 fromDate:currentDate];
    }
    else
    {
       previousDate   = [calendar dateBySubstractingMonths:1 fromDate:currentDate];
    }
     [calendar setCurrentPage:previousDate animated:YES];
}
- (IBAction)btnNextTap:(id)sender
{
    NSDate *currentDate = calendar.currentPage;
    NSDate *previousDate;
    
    if(calendar.scope == FSCalendarScopeWeek)
    {
        previousDate   = [calendar dateByAddingWeeks:1 toDate:currentDate];
    }
    else
    {
        previousDate   = [calendar dateByAddingMonths:1 toDate:currentDate];
    }
    [calendar setCurrentPage:previousDate animated:YES];
}

- (IBAction)btnSettingsTap:(id)sender
{
    [self openOptionView];
}
- (IBAction)btnMapTap:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblvSchedule];
    NSIndexPath *indexPath = [tblvSchedule indexPathForRowAtPoint:buttonPosition];
    
    ACESchedule *schedule = arrScheduleData[indexPath.row];
    
    [self openMapApplication:schedule];
    
   /* CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblvSchedule];
    NSIndexPath *indexPath = [tblvSchedule indexPathForRowAtPoint:buttonPosition];
    
    ACESchedule *schedule = arrScheduleData[indexPath.row];
    
    MapViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    viewController.destLongitude = schedule.destLongitude;
    viewController.destLattitude = schedule.destLattitude;
    viewController.destAddress   = schedule.clientAddress;
    
    [self.navigationController pushViewController:viewController animated:YES];*/
}
- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}
- (IBAction)btnRequestNewTap:(id)sender
{
    RequestNewScheduleViewController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"RequestNewScheduleViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - alertViewMethods
-(void)openOptionView
{
    ChangeCalenderPopupViewController *CCPVC = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ChangeCalenderPopupViewController"];
    
    CCPVC.delegate          = self;
    CCPVC.selectedString    = currentOption;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [CCPVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:CCPVC animated:NO completion:nil];
}
-(void)selectMonthview
{
    [calendar setScope:FSCalendarScopeMonth animated:YES];
}
-(void)selectWeekView
{
    [calendar setScope:FSCalendarScopeWeek animated:YES];
}
-(void)selectTodayView
{
    //[calendar setScope:FSCalendarScopeWeek animated:YES];
    [calendar setCurrentPage:[NSDate date] animated:YES];
    [self setTableData:[NSDate date]];
}
#pragma mark - CalendarDelegateMethods

-(void)calendarCurrentScopeWillChange:(FSCalendar *)calendar1 animated:(BOOL)animated
{
    CGSize size = [calendar sizeThatFits:calendar.size];
    
    [calendar setFrame:CGRectMake(calendar.x, calendar.y, size.width, size.height)];
    
    float y = calendar.height + calendar.y+1;
    float tblvY = tblvSchedule.y;
    
    [tblvSchedule setFrame:CGRectMake(tblvSchedule.x, y, tblvSchedule.width, tblvSchedule.height-(y - tblvY))];
    
    //[tblvSchedule reloadData];
    
    [self.view layoutIfNeeded];
    if(arrScheduleData.count ==0)
    {
         [tblvSchedule setBackgroundView:[ACEUtil viewNoDataWithMessage:ACENoScheduleForDate andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvSchedule.height]];
    }
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    selectedDate = date;
    [self setTableData:date];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date
{
    
    if ([arrscheduleDates containsObject:date])
    {
        return [UIColor appGreenColor];
    }
    
    return 0;
}
-(NSInteger)calendar:(FSCalendar *)calendar1 numberOfEventsForDate:(NSDate *)date
{
    
    if([arrscheduleDates containsObject:date] && (currentOption == CalenderOptionMonth || currentOption == CalenderOptionWeek))
    {
        return 1;
    }
    if([arrscheduleDates containsObject:date] && currentOption == CalenderOptionToday) // For hiding eventsof other dates in case of 'Today' Option except todays date
    {
       BOOL ans =  [calendar1 isDate:date equalToDate:[NSDate date] toCalendarUnit:FSCalendarUnitDay];
        
        if(ans)
        {
            return 1;
        }
    }
    return 0;
    
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date // for select date
{
    
        if ([arrscheduleDates containsObject:date])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    
    //return YES;
}

-(UIColor *)calendar:(FSCalendar *)calendar1 appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date
{
    if(currentOption == CalenderOptionToday && (![calendar1 isDateInToday:date]))
    {
        return [UIColor grayColor];
    }
    else
    {
        return nil;
    }
}
//- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date // for deselect date
//{
//    if ([arrscheduleDates containsObject:date])
//    {
//        return YES;
//    }
//    return NO;
//}

-(void)calendarCurrentPageDidChange:(FSCalendar *)calendarL
{
    
     NSDate *currentDate = calendar.currentPage;
    
    if(calendar.scope == FSCalendarScopeMonth)
    {
        NSString *mnth = [NSString stringWithFormat:@"%ld",(long)[calendarL monthOfDate:currentDate]];
    
        NSString *year = [NSString stringWithFormat:@"%ld",(long)[calendarL yearOfDate:currentDate]];
    
        [self getScheduleDatesForMonth:mnth andYear:year];
    }
    else
    {
       // NSDate *next = calendar.currentPage;
    
        NSString *nmnth = [NSString stringWithFormat:@"%ld",(long)[calendar monthOfDate:currentDate]];
        
        NSString *nyear = [NSString stringWithFormat:@"%ld",(long)[calendar yearOfDate:currentDate]];
    
        [self getScheduleDatesForMonth:nmnth andYear:nyear];
    }

}
#pragma mark -UITableView Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrScheduleData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundView.hidden = YES;
    
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell" forIndexPath:indexPath];
    
    [cell setCellData:arrScheduleData[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACESchedule *sch = arrScheduleData[indexPath.row];
    
    ScheduleDetailViewController *sdvc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ScheduleDetailViewController"];
    
    sdvc.scheduleId     = sch.Id;
    sdvc.selectedDate   = selectedDate;
    sdvc.notificationId = @"";
    [self.navigationController pushViewController:sdvc animated:YES];
}
#pragma mark -WebService Method
-(void)setTableData:(NSDate*)date
{
    if([ACEUtil reachable])
    {
        NSString *mnth = [NSString stringWithFormat:@"%ld",(long)[calendar monthOfDate:date]];
        
        NSString *day = [NSString stringWithFormat:@"%ld",(long)[calendar dayOfDate:date]];
        
        NSString *year = [NSString stringWithFormat:@"%ld",(long)[calendar yearOfDate:date]];
        
        NSDictionary *dict = @{
                               SCHKeyEmpId  : ACEGlobalObject.user.userID,
                               SCHKeyMonth  : mnth,
                               SCHKeyDay    : day,
                               SCHKeyYear   : year
                               };
        [SVProgressHUD show];
        
        [ACEWebServiceAPI getScheduleListForDate:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *scheduleList)
         {
            
             [SVProgressHUD dismiss];

             if (response.code == RCodeSuccess)
             {
                 arrScheduleData = scheduleList.mutableCopy;
                 
                 if(arrScheduleData.count == 0)
                 {
                     [tblvSchedule setBackgroundView:[ACEUtil viewNoDataWithMessage:ACENoScheduleForDate andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvSchedule.height]];
                 }
                 else
                 {
                     [tblvSchedule reloadData];
                 }
             }
             
             else if (response.code == RCodeNoData)
             {
                 
                 arrScheduleData = [[NSMutableArray alloc]init];
                 [tblvSchedule reloadData];
                 
                 [tblvSchedule setBackgroundView:[ACEUtil viewNoDataWithMessage:ACENoScheduleForDate andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvSchedule.height]];
                 
                  //[SVProgressHUD dismiss];
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
            
         }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
        [tblvSchedule reloadData];
    }
}
-(void)getScheduleDatesForMonth:(NSString *)month andYear:(NSString *)year
{
    NSDictionary *dict = @{
                              SCHKeyEmpId   : ACEGlobalObject.user.userID,
                              SCHKeyMonth   : month,
                              SCHKeyYear    : year
                           };
    //[SVProgressHUD show];
    
    if([ACEUtil reachable])
    {
        [ACEWebServiceAPI getScheduledDatesForMonth:dict completionHandler:^(ACEAPIResponse *response, NSMutableArray *scheduleDates, NSString *unreadCount)
         {
             
             if (response.code == RCodeSuccess)
             {
                 [self setNotificationBadge:unreadCount];
                 [self setDates:scheduleDates];
                 //[self setTableData:[NSDate date]];
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
             //[SVProgressHUD dismiss];
         }];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }

}
-(void)setDates:(NSMutableArray *)datesArray
{
    for (NSDictionary *dict in datesArray)
    {
        NSString *date = dict[SCHKeyScheduleDate];
        NSString *validDate = [ACEUtil convertDate:date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        
        NSDate *yourDate = [dateFormatter dateFromString:validDate];
        [arrscheduleDates addObject:yourDate];
    }
    [calendar reloadData];
}
-(void)setNotificationBadge:(NSString *)badge
{
    ACEGlobalObject.notificationCount = [badge integerValue];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:ACEGlobalObject.notificationCount];
    
    if([badge isEqualToString:@"0"])
    {
        btnNotification.badgeValue = @"";
    }
    else
    {
        btnNotification.badgeValue   = badge;
    }
    
    btnNotification.badgeOriginX = (CGRectGetWidth(btnNotification.frame) / 2);
    btnNotification.badgeOriginY = -10;
    btnNotification.badgeBGColor = [UIColor appGreenColor];
    btnNotification.badgeFont    = [UIFont fontWithName:@"OpenSans" size:12];
    btnNotification.badgeMinSize = 8;
    btnNotification.shouldHideBadgeAtZero = YES;

}

#pragma mark - ChangeCalenderPopupViewController delegate method
-(void)selectedOption:(NSString *)option
{
    currentOption = option;
    
    if(option == CalenderOptionMonth)
    {
        [self selectMonthview];
        calendar.userInteractionEnabled = YES  ;
        previousButton.hidden           = NO   ;
        nextButton.hidden               = NO   ;
        [calendar reloadData];
    }
    else if (option == CalenderOptionWeek)
    {
        [self selectWeekView];
        calendar.userInteractionEnabled = YES  ;
        previousButton.hidden           = NO   ;
        nextButton.hidden               = NO   ;
        [calendar reloadData];
    }
    else if (option == CalenderOptionToday)
    {
        [calendar deselectDate:selectedDate];
        [self selectWeekView];
        [self selectTodayView];
        calendar.userInteractionEnabled = NO    ;
        previousButton.hidden           = YES   ;
        nextButton.hidden               = YES   ;
        
        [calendar reloadData];
    }
}


@end
