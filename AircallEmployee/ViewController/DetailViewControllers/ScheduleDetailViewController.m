//
//  ScheduleDetailViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ScheduleDetailViewController.h"

@interface ScheduleDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblHeaderTitle    ;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeAllotted   ;
@property (weak, nonatomic) IBOutlet UILabel *lblServiceCaseNo  ;
@property (weak, nonatomic) IBOutlet UILabel *lblClientName     ;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileNum      ;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeNum        ;
@property (weak, nonatomic) IBOutlet UILabel *lblOfficeNum      ;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress        ;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail          ;
@property (weak, nonatomic) IBOutlet UILabel *lblScheduleDate   ;
@property (weak, nonatomic) IBOutlet UILabel *lblPurpose        ;
@property (weak, nonatomic) IBOutlet UILabel *lblcontract       ;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany        ;

@property (weak, nonatomic) IBOutlet UITextView *txtvComplaints ;

@property (weak, nonatomic) IBOutlet UIButton *btnUnitList      ;
@property (weak, nonatomic) IBOutlet UIButton *btnDailyPart     ;
@property (weak, nonatomic) IBOutlet UIButton *btnServiceHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnUnitManual    ;
@property (weak, nonatomic) IBOutlet UIButton *btnStartService  ;
@property (weak, nonatomic) IBOutlet UIButton *btnReschedule    ;

@property (weak, nonatomic) IBOutlet UIScrollView *scrlvbg      ;

@property (weak, nonatomic) IBOutlet UIView *vwStatic           ;
@property (weak, nonatomic) IBOutlet UIView *vwDynamic          ;
@property (weak, nonatomic) IBOutlet UIView *vwBtnService       ;
@property (weak, nonatomic) IBOutlet UIView *vwUnitServiced     ;
@property (weak, nonatomic) IBOutlet UIView *vwServiceReport    ;
@property (weak, nonatomic) IBOutlet UIView *vwUnitManual       ;
@property (weak, nonatomic) IBOutlet UIView *vwDailyPartList    ;

@property (weak, nonatomic) IBOutlet UIImageView *imgvArrowUnitList         ;
@property (weak, nonatomic) IBOutlet UIImageView *imgvArrowDailyPart        ;
@property (weak, nonatomic) IBOutlet UIImageView *imgvArrowServiceHistory   ;
@property (weak, nonatomic) IBOutlet UIImageView *imgvArrowUnitManual       ;

@property (strong, nonatomic) ACEScheduleDetail * scheduleDetailFull        ;
@property (weak, nonatomic) NSArray *tblvArray;

@property CGRect frmScrlv;
@property CGSize frmScrlvContent;
@property CGRect frmvwStatic;
@property CGRect frmvwDynamic;
@property CGRect frmvwBtnService;

@property CGRect frmvwdailyPart;
@property CGRect frmvwUnitList;
@property CGRect frmvwUnitManual;
@property CGRect frmvwServiceHistory;

@property BOOL isServiceReport;
@property BOOL isUnitServiced;
@property BOOL isDailyPart;
@property BOOL isUnitManual;

@property UITableView *tblvData;

@end

@implementation ScheduleDetailViewController

@synthesize lblHeaderTitle,lblScheduleDate,lblTimeAllotted,lblClientName,lblMobileNum,lblHomeNum,lblOfficeNum,lblAddress,lblEmail,lblPurpose,lblServiceCaseNo,lblcontract,txtvComplaints,btnDailyPart,btnServiceHistory,btnUnitList,btnUnitManual,btnStartService,scrlvbg,vwStatic,vwDynamic,vwBtnService,lblCompany;

@synthesize vwUnitServiced,vwServiceReport,vwUnitManual,vwDailyPartList;

@synthesize frmScrlv,frmScrlvContent,frmvwStatic,frmvwDynamic,frmvwBtnService,frmvwdailyPart,frmvwUnitList,frmvwServiceHistory,frmvwUnitManual;

@synthesize tblvArray,scheduleId,imgvArrowUnitList,imgvArrowDailyPart,imgvArrowServiceHistory,imgvArrowUnitManual,scheduleDetailFull,btnReschedule;

@synthesize selectedDate,notificationId;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwBtnService.y +vwBtnService.height)];
    
    [self setBorderofViews];
    [self saveOriginalFrames];
    [self setScheduleData:scheduleId];
    
    //[self prepareView];
}
-(void)viewDidAppear:(BOOL)animated
{
    if(ACEGlobalObject.isTimerRunning)
    {
        if([ACEGlobalObject.scheduleId isEqualToString:scheduleDetailFull.ID])
        {
            [btnStartService setTitle:@"Continue Service Report" forState:UIControlStateNormal];
        }
        else
        {
            [btnStartService setTitle:@"Start Service Report" forState:UIControlStateNormal];
        }
    }
    else
    {
        [btnStartService setTitle:@"Start Service Report" forState:UIControlStateNormal];
    }

}
#pragma mark - Helper method
-(void)setBorderofViews
{
    [vwUnitServiced.layer  setBorderColor:[[UIColor separatorColor] CGColor]];
    [vwUnitManual.layer    setBorderColor:[[UIColor separatorColor] CGColor]];
    [vwServiceReport.layer setBorderColor:[[UIColor separatorColor] CGColor]];
    [vwDailyPartList.layer setBorderColor:[[UIColor separatorColor] CGColor]];
    
    [[vwUnitServiced layer]  setBorderWidth:0.5f];
    [[vwUnitManual layer]    setBorderWidth:0.5f];
    [[vwServiceReport layer] setBorderWidth:0.5f];
    [[vwDailyPartList layer] setBorderWidth:0.5f];
    
}
-(void)prepareView
{
    
    _isUnitServiced     = NO;
    _isUnitManual       = NO;
    _isServiceReport    = NO;
    _isDailyPart        = NO;
    
    lblHeaderTitle.text     = [NSString stringWithFormat:@"%@ Till %@",scheduleDetailFull.startTime,scheduleDetailFull.EndTime];
    
    lblTimeAllotted.text    = scheduleDetailFull.timeAllotted   ;
    lblClientName.text      = scheduleDetailFull.clientName     ;
    lblCompany.text         = scheduleDetailFull.company        ;
    lblAddress.text         = scheduleDetailFull.address.fullAddress;
    lblScheduleDate.text    = scheduleDetailFull.scheduleDate   ;
    lblServiceCaseNo.text   = scheduleDetailFull.serviceCaseNum ;
    
    if([scheduleDetailFull.mobileNum isKindOfClass:[NSNull class]] || [scheduleDetailFull.mobileNum isEqualToString:@""])
    {
        lblMobileNum.text   = ACENoMobileNumber;
    }
    else
    {
        lblMobileNum.text   = scheduleDetailFull.mobileNum      ;
    }
    if([scheduleDetailFull.homeNum isKindOfClass:[NSNull class]] || [scheduleDetailFull.homeNum isEqualToString:@""])
    {
        lblHomeNum.text   = ACENoHomeNumber;
    }
    else
    {
        lblHomeNum.text         = scheduleDetailFull.homeNum        ;
    }
    if([scheduleDetailFull.officeNum isKindOfClass:[NSNull class]] ||[scheduleDetailFull.officeNum isEqualToString:@""])
    {
        lblOfficeNum.text       = ACENoOfficeNumber;
    }
    else
    {
        lblOfficeNum.text       = scheduleDetailFull.officeNum;

    }
    lblEmail.text           = scheduleDetailFull.email          ;
    lblPurpose.text         = scheduleDetailFull.purpose        ;
    lblcontract.text        = scheduleDetailFull.contract       ;
    
    NSString *strComplaints =   @"Customer Complaints";
    NSString *strDispNotes  =   @"Dispatcher Notes"   ;
    NSString *strTechNotes  =   @"Technician Notes"   ;
    
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"OpenSans"size:30.0f],
                               NSForegroundColorAttributeName : [UIColor blackColor]
                               };
//    //NSDictionary *attrDict1 = @{
//                               NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:14.0],
//                               NSForegroundColorAttributeName : [UIColor blackColor]
//                               };
    
    NSDictionary *attrDict2 = @{
                               NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:16.0],
                               NSForegroundColorAttributeName : [UIColor appGreenColor]
                               };
    
    NSDictionary *attrDict3 = @{
                                NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:14.0],
                                NSForegroundColorAttributeName : [UIColor appGreenColor]
                                };
    
    NSAttributedString *strAComplaintsText = [[NSAttributedString alloc]initWithString:strComplaints attributes:attrDict];
  
    NSAttributedString *strADNotesText = [[NSAttributedString alloc]initWithString:strDispNotes attributes:attrDict];
    
    NSAttributedString *strATNotesText = [[NSAttributedString alloc]initWithString:strTechNotes attributes:attrDict];
    

    NSAttributedString *strAComplaints = [[NSAttributedString alloc]initWithString:scheduleDetailFull.custComplaints attributes:attrDict2];
    
    NSAttributedString *strADNotes = [[NSAttributedString alloc]initWithString:scheduleDetailFull.dispatcherNotes attributes:attrDict3];
    
    NSAttributedString *strATNotes = [[NSAttributedString alloc]initWithString:scheduleDetailFull.technicianNotes attributes:attrDict3];
    
    if ([[strAComplaints string] isEqualToString:@""])
    {
       strAComplaints = [[NSAttributedString alloc]initWithString:@"No customer complaints" attributes:attrDict2];
    }
    if ([[strADNotes string] isEqualToString:@""])
    {
        strADNotes = [[NSAttributedString alloc]initWithString:@"No Dispatcher Notes" attributes:attrDict3];
    }
    if ([[strATNotes string] isEqualToString:@""])
    {
        strATNotes = [[NSAttributedString alloc]initWithString:@"No Technician Notes" attributes:attrDict3];
    }

    txtvComplaints.text = [NSString stringWithFormat:@"%@ :\n%@\n\n%@ :\n%@\n\n%@ :\n%@",[strAComplaintsText string],[strAComplaints string],[strADNotesText string],[strADNotes string],[strATNotesText string],[strATNotes string]];
    
    
    if(ACEGlobalObject.isTimerRunning)
    {
        if([ACEGlobalObject.scheduleId isEqualToString:scheduleDetailFull.ID])
        {
            [btnStartService setTitle:@"Continue Service Report" forState:UIControlStateNormal];
        }
        else
        {
            [btnStartService setTitle:@"Start Service Report" forState:UIControlStateNormal];
            
            //btnStartService.userInteractionEnabled = NO;
        }
    }
  
    if(!selectedDate)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"MMMM dd, yyyy"];
        selectedDate = [formatter dateFromString:scheduleDetailFull.scheduleDate];
    }
    
    NSComparisonResult ans = [[NSCalendar currentCalendar]compareDate:selectedDate toDate:[NSDate date] toUnitGranularity:NSCalendarUnitDay];
    
    if(![scheduleDetailFull.status isEqualToString:@"Scheduled"]|| ans == NSOrderedAscending)
    {
        btnStartService.hidden  = YES;
        btnStartService.enabled = NO;
        btnReschedule.hidden    = YES;
        btnReschedule.enabled   = NO;
        [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwBtnService.y)];
    }
   // txtvComplaints.text    =
    

    
}
-(void)saveOriginalFrames
{
    frmScrlv                = scrlvbg.frame;
    frmScrlvContent         = scrlvbg.contentSize;
    frmvwStatic             = vwStatic.frame;
    frmvwDynamic            = vwDynamic.frame;
    frmvwBtnService         = vwBtnService.frame;
    
    frmvwdailyPart          = vwDailyPartList.frame;
    frmvwServiceHistory     = vwServiceReport.frame;
    frmvwUnitList           = vwUnitServiced.frame;
    frmvwUnitManual         = vwUnitManual.frame;
    
}

-(void)closeOpenTableView
{
    scrlvbg.frame           = frmScrlv;
    scrlvbg.contentSize     = frmScrlvContent;
    vwStatic.frame          = frmvwStatic;
    vwDynamic.frame         = frmvwDynamic;
    vwBtnService.frame      = frmvwBtnService;
    vwDailyPartList.frame   = frmvwdailyPart;
    vwServiceReport.frame   = frmvwServiceHistory;
    vwUnitServiced.frame    = frmvwUnitList;
    vwUnitManual.frame      = frmvwUnitManual;
    
    // transform arrow to original state
    
    imgvArrowUnitList.transform = CGAffineTransformMakeRotation(360 * M_PI/180);
    
    imgvArrowDailyPart.transform = CGAffineTransformMakeRotation(360 * M_PI/180);
    
    imgvArrowServiceHistory.transform = CGAffineTransformMakeRotation(360 * M_PI/180);
    
    imgvArrowUnitManual.transform = CGAffineTransformMakeRotation(360 * M_PI/180);
    
    [_tblvData removeFromSuperview];
    
    _tblvData = nil;
    
    
}
-(void)setBoolValueForUnit:(BOOL)ans daily:(BOOL)ansDaily serviceHistory:(BOOL)ansService unitManual:(BOOL)ansUnit
{
    _isUnitServiced     = ans;
    _isDailyPart        = ansDaily;
    _isServiceReport    = ansService;
    _isUnitManual       = ansUnit;
}

-(void)setTableViewFrameBelowButton:(UIButton *)btn
{
    
    UIView *vwsuper = btn.superview;
    
    _tblvData = [[UITableView alloc]initWithFrame:CGRectMake(vwsuper.frame.origin.x, vwsuper.frame.origin.y + vwsuper.frame.size.height,vwsuper.frame.size.width, 100) style:UITableViewStylePlain];
    
    _tblvData.separatorColor = [UIColor separatorColor];
    
    [_tblvData registerClass:[ACESelectionCell class] forCellReuseIdentifier:@"cell"];
    
    _tblvData.delegate = self;
    _tblvData.dataSource = self;
    
    [_tblvData reloadData];
    
    if(tblvArray.count > 0)
    {
        _tblvData.frame = CGRectMake(_tblvData.frame.origin.x, _tblvData.frame.origin.y, _tblvData.frame.size.width, _tblvData.contentSize.height);
    }
    else
    {
         _tblvData.frame = CGRectMake(_tblvData.frame.origin.x, _tblvData.frame.origin.y, _tblvData.frame.size.width, _tblvData.height);
        _tblvData.backgroundView = [ACEUtil viewNoDataWithMessage:@"No Data Found" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:_tblvData.height];
         _tblvData.separatorColor = [UIColor clearColor];
    }
    
    [vwDynamic addSubview:_tblvData];

    if(_isUnitServiced)
    {
        vwDailyPartList.y = _tblvData.y + _tblvData.height;
        vwServiceReport.y = vwDailyPartList.y + vwDailyPartList.height;
        vwUnitManual.y    = vwServiceReport.y + vwServiceReport.height;
    }
    else if(_isDailyPart)
    {
        vwServiceReport.y = _tblvData.y + _tblvData.height;
        vwUnitManual.y    = vwServiceReport.y + vwServiceReport.height;
    }
    else if (_isServiceReport)
    {
         vwUnitManual.y = _tblvData.y + _tblvData.height;
    }

    [vwDynamic setFrame:CGRectMake(CGRectGetMinX(vwDynamic.frame), CGRectGetMinY(vwDynamic.frame), CGRectGetWidth(vwDynamic.frame), CGRectGetHeight(vwDynamic.frame) + _tblvData.height)];
    
    if(!btnStartService.hidden)
    {
        [vwBtnService setFrame:CGRectMake(CGRectGetMinX(vwBtnService.frame), CGRectGetMinY(vwDynamic.frame) + CGRectGetHeight(vwDynamic.frame) + 8, CGRectGetWidth(vwBtnService.frame), CGRectGetHeight(vwBtnService.frame))];
    
        [scrlvbg setContentSize:CGSizeMake(CGRectGetWidth(scrlvbg.frame), CGRectGetMinY(vwBtnService.frame)+CGRectGetHeight(vwBtnService.frame))];
    }
    else
    {
        [vwBtnService setFrame:CGRectMake(CGRectGetMinX(vwBtnService.frame), CGRectGetMinY(vwDynamic.frame) + CGRectGetHeight(vwDynamic.frame) + 8, CGRectGetWidth(vwBtnService.frame), CGRectGetHeight(vwBtnService.frame))];
        
        [scrlvbg setContentSize:CGSizeMake(CGRectGetWidth(scrlvbg.frame), CGRectGetMinY(vwDynamic.frame)+CGRectGetHeight(vwDynamic.frame) + 10)];
    }
    //scrlvbg.contentOffset = CGPointMake(0, vwDynamic.y);
}
-(void)openMailViewController
{
    if (![MFMailComposeViewController canSendMail])
    {
        NSLog(@"Mail services are not available.");
        return;
    }
    else
    {
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        
        mailController.mailComposeDelegate = self;
    
        [mailController setSubject:@"Aircall"];
    
        [mailController setToRecipients:[NSArray arrayWithObjects:lblEmail.text,nil]];
    

        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self presentViewController:mailController animated:YES completion:nil];
        });
    }
}
-(void)openCallSMSPopup:(NSString *)number
{
    CallSMSPopupViewController *CSPVC = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"CallSMSPopupViewController"];
    
    CSPVC.number                                    = number;
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext                 = YES;
    
    [CSPVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:CSPVC animated:NO completion:nil];
}
-(BOOL)shouldOpenServiceReport
{
    AppDelegate  *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    if(selectedDate == nil)
    {
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        selectedDate  =  [dateFormat dateFromString:scheduleDetailFull.scheduleDate];
    }
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//    
//    if (![[dateFormat stringFromDate:selectedDate] isEqualToString:[dateFormat stringFromDate:[NSDate date]]])
//    {
//        [self showAlertWithMessage:ACEDatenotMatch];
//        return NO;
//    }
//    if(delegate.latitude == nil && delegate.longitude == nil)
//    {
//        NSString *msg = [NSString stringWithFormat:@"%@ does not have access to your Location. To enable Location, tap Settings and select location and check 'always' option.",appName];
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
//        
//        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
//        
//        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//                          {
//                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                          }]];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//    
    /*if([CLLocationManager locationServicesEnabled])
    {
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied )
        {
            NSString *title;
            
            title = @"Background location is not enabled";
            
            NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:ok];
            
            UIAlertAction *setting = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                      {
                                          NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                          [[UIApplication sharedApplication] openURL:settingsURL];
                                      }];
            
            [alert addAction:setting];
            
            [self presentViewController:alert animated:YES completion:nil];
            return NO;
        }
    }*/
    [dateFormat setDateFormat:@"MMMM dd, yyyy"];

    if(ACEGlobalObject.isTimerRunning)
    {
        if(![ACEGlobalObject.savedDate isEqualToString:[dateFormat stringFromDate:[NSDate date]]])
        {
            [ACEGlobalObject clearAllData];
            return YES;
        }
        if(![ACEGlobalObject.scheduleId isEqualToString:scheduleId])
        {
            [self showAlertWithMessage:ACEReportAlreadySaved];
            return NO;
        }
    }
    return YES;
}
-(void)openMapApplication:(ACEScheduleDetail *)schedule
{
    AppDelegate  *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(delegate.latitude != nil && delegate.longitude != nil)
    {
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([schedule.lattitude doubleValue], [schedule.longitude doubleValue]) addressDictionary:nil];
    
        MKMapItem *destMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [destMapItem setName:schedule.address.fullAddress];
    
        MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([delegate.latitude doubleValue], [delegate.longitude doubleValue]) addressDictionary:nil];
    
    //MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(39.5018431,  -119.7796647) addressDictionary:nil];
    
        MKMapItem *currentMapItem = [[MKMapItem alloc] initWithPlacemark:placemark1];
    
        [currentMapItem setName:@"Current Location"];
    
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    
        [MKMapItem openMapsWithItems:@[currentMapItem, destMapItem]
                   launchOptions:launchOptions];
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
- (IBAction)btnUnitListTap:(UIButton *)sender
{
    if(_isUnitServiced)
    {
        _isUnitServiced = NO;
        [self closeOpenTableView];
    }
    else
    {
        [self closeOpenTableView];
        [self setBoolValueForUnit:YES daily:NO serviceHistory:NO unitManual:NO];
        tblvArray = scheduleDetailFull.unitList;
        [self setTableViewFrameBelowButton:sender];
         imgvArrowUnitList.transform = CGAffineTransformMakeRotation(90 * M_PI/180); //transform arrow to down
    }
    
}

- (IBAction)btnDailyPartTap:(UIButton *)sender
{
    if(_isDailyPart)
    {
        _isDailyPart = NO;
        [self closeOpenTableView];
    }
    else
    {
        [self closeOpenTableView];
        [self setBoolValueForUnit:NO daily:YES serviceHistory:NO unitManual:NO];
        tblvArray = scheduleDetailFull.unitList;
        [self setTableViewFrameBelowButton:sender];
        imgvArrowDailyPart.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
      
    }
}
- (IBAction)btnServiceHistoryTap:(UIButton *)sender
{
    if(_isServiceReport)
    {
        _isServiceReport = NO;
        [self closeOpenTableView];
    }
    else
    {
        [self closeOpenTableView];
        [self setBoolValueForUnit:NO daily:NO serviceHistory:YES unitManual:NO];
        tblvArray = scheduleDetailFull.reportsList;
        [self setTableViewFrameBelowButton:sender];
         imgvArrowServiceHistory.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
    }
}
- (IBAction)btnUnitManualTap:(UIButton *)sender
{
    if(_isUnitManual)
    {
        _isUnitManual = NO;
        [self closeOpenTableView];
    }
    else
    {
        [self closeOpenTableView];
        [self setBoolValueForUnit:NO daily:NO serviceHistory:NO unitManual:YES];
        tblvArray = scheduleDetailFull.manualList;
        [self setTableViewFrameBelowButton:sender];
        
         imgvArrowUnitManual.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
    }
}
- (IBAction)btnStartServiceReportTap:(UIButton *)sender
{
    
    if([self shouldOpenServiceReport])
    {
        NewServiceReportViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"NewServiceReportViewController"];
    
        vc.scheduleDetail = scheduleDetailFull;
    
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnRescheduleTap:(UIButton *)sender
{
    
//    if([[NSCalendar currentCalendar] isDate:[NSDate date] inSameDayAsDate:selectedDate])
//    {
//        [self showAlertWithMessage:ACERescheduleDate];
//    }
//    else
//    {
        ReschedulePopupViewController *RPVC = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ReschedulePopupViewController"];
    
        RPVC.scheduleId     = scheduleId;
        RPVC.clientId       = scheduleDetailFull.ClientId;
        RPVC.selectedDate   = scheduleDetailFull.scheduleDate;
        RPVC.purposeOfVisit = scheduleDetailFull.purpose;
        RPVC.totalUnits     = (int)scheduleDetailFull.unitList.count;
        RPVC.purposeId      = scheduleDetailFull.purposeId;
    
        [self.navigationController pushViewController:RPVC animated:YES];
   // }
}
- (IBAction)btnLocationTap:(UIButton *)sender
{
    [self openMapApplication:scheduleDetailFull];
    
   /* MapViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    viewController.destLongitude = scheduleDetailFull.longitude          ;
    viewController.destLattitude = scheduleDetailFull.lattitude          ;
    viewController.destAddress   = scheduleDetailFull.address.fullAddress;
    
    [self.navigationController pushViewController:viewController animated:YES];*/
}

- (IBAction)btnMobileNoTap:(id)sender
{
    if(![lblMobileNum.text isEqualToString:ACENoMobileNumber])
    {
        [self openCallSMSPopup:lblMobileNum.text];
    }
}
- (IBAction)btnHomeNumTap:(id)sender
{
    if(![lblHomeNum.text isEqualToString:ACENoHomeNumber])
    {
        [self openCallSMSPopup:lblHomeNum.text];
    }
}
- (IBAction)btnOfficeNumTap:(id)sender
{
    if(![lblOfficeNum.text isEqualToString:ACENoOfficeNumber])
    {
        [self openCallSMSPopup:lblOfficeNum.text];
    }
}
- (IBAction)btnEmailTap:(id)sender
{
    [self openMailViewController];
}

#pragma mark - WebService Method
-(void)setScheduleData:(NSString *)ScheduleId
{
    if([ACEUtil reachable])
    {
        NSDictionary *dict = @{
                               
                               UKeyEmployeeID : ACEGlobalObject.user.userID,
                               GKeyserviceId : scheduleId,
                               NKeyNotificationId : notificationId
                               
                               };
        [SVProgressHUD show];
        
        [ACEWebServiceAPI getScheduleDetail:dict completionHandler:^(ACEAPIResponse *response, ACEScheduleDetail *scheduleDetail)
        {
            [SVProgressHUD dismiss];
            
            if(response.code == RCodeSuccess)
            {
                scheduleDetailFull = scheduleDetail;
                [self prepareView];
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
        [self showAlertFromWithMessageWithSingleAction:ACENoInternet andHandler:^(UIAlertAction * _Nullable action)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }
}

#pragma mark - TableView delegate Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_isDailyPart)
        return tblvArray.count;
    else
        return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vw     = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(35,10, vw.width, 20)];
   // label.center = CGPointMake(15, vw.height/2);
    
    NSDictionary *dict    = tblvArray[section];
    label.text            = dict[SDKeyUnitName];
    label.textColor       = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    [vw addSubview:label];
    
    vw.backgroundColor    = [UIColor selectedBackgroundColor];
    
    return vw;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_isDailyPart)
    {
        return 40;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isDailyPart)
    {
//        NSDictionary *dict = tblvArray[section];
//         return [dict[SDKeyPartsList] count];
        return [tblvArray[section][SDKeyPartsList] count];
    }
    else
    {
        return tblvArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundView.hidden = YES;
    
    ACESelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    CGRect screenFrame     = [UIScreen mainScreen].bounds;
    
    UILabel *lbl           = [[UILabel alloc]initWithFrame:CGRectMake(screenFrame.origin.x + 30, 7, screenFrame.size.width - 20, 30)];
    
    lbl.font               = [UIFont fontWithName:@"OpenSans" size:15.0];
    lbl.lineBreakMode      = NSLineBreakByTruncatingTail;
   // UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(screenFrame.size.width - 50, 12, 22, 22)];
    
    lbl.textColor       = [UIColor fontColor];
    
    if(_isUnitServiced)
    {
        NSDictionary *dict   = tblvArray[indexPath.row];
        lbl.text             = dict[SDKeyUnitName];
       // imgv.image              = [UIImage imageNamed:@"checkbox"];
        cell.backgroundColor = [UIColor selectedBackgroundColor];
        if(!dict[SDKeyServiceCompleted])
        {
            lbl.textColor    = [UIColor redColor];
        }
        
    }
    else if(_isDailyPart)
    {
        NSDictionary *dict   = tblvArray[indexPath.section];
        ACEParts *part       = dict[SDKeyPartsList][indexPath.row];
        lbl.text             = [NSString stringWithFormat:@"%@ %@ - (%@)",
        part.partName,part.partSize,part.Qty];
        //imgv.image           = nil;
        cell.backgroundColor = [UIColor whiteColor];
       
    }
    else if(_isServiceReport)
    {
        NSDictionary *dict   = scheduleDetailFull.reportsList[indexPath.row];
        lbl.text             = [NSString stringWithFormat:@"%@   %@",dict[SDKeyReportDate],
                              dict[SDKeyReportNumber]];;
       // imgv.image           = nil;
        cell.backgroundColor = [UIColor selectedBackgroundColor];
    }
    else if (_isUnitManual)
    {
        NSDictionary *dict    = scheduleDetailFull.manualList[indexPath.row];
        lbl.text              = dict[SDKeyManualName];
        // imgv.image           = nil;
         cell.backgroundColor = [UIColor selectedBackgroundColor];
    }
    
    [cell.contentView addSubview:lbl];
    //[cell.contentView addSubview:imgv];

   // cell.separatorColor = [UIColor separatorColor];
     cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.separatorInset   = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isUnitServiced)
    {
         NSDictionary *dict  = tblvArray[indexPath.row];
        UnitDetailViewableViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"UnitDetailViewableViewController"];
        vc.unitId       =   dict[SDKeyUnitId];
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    else if (_isServiceReport)
    {
        NSDictionary *dict = scheduleDetailFull.reportsList[indexPath.row];
        ServiceReportDetailViewableController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ServiceReportDetailViewableController"];
        vc.serviceId = [dict[GKeyId] stringValue];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if (_isUnitManual)
    {
        NSDictionary *dict = scheduleDetailFull.manualList[indexPath.row];
        NSURL *url = [NSURL URLWithString:dict[SDKeyManualURL]];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication]openURL:url];
        }
        else
        {
            [self showAlertWithMessage:ACECanNotOpenUrl];
        }
        
    }
}
#pragma mark - MailComposer Delegate method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Reschedule Popup Methods
//-(void)showPopUp
//{
//    
//    datePicker.datePickerMode = UIDatePickerModeDate;
//    
//    [datePicker setMinimumDate: [NSDate date]];
//    
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:vwReschedule.bounds];
//    
//    vwReschedule.layer.masksToBounds = NO;
//    vwReschedule.layer.shadowColor = [UIColor blackColor].CGColor;
//    
//    vwReschedule.layer.shadowOpacity = 0.5f;
//    vwReschedule.layer.shadowPath = shadowPath.CGPath;
//    
//    [self.view addSubview:vwReschedule];
//    
//    vwReschedule.center = self.view.center;
//    
//    scrlvbg.userInteractionEnabled = NO;
//    
//    vwReschedule.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
//     {
//         vwReschedule.transform = CGAffineTransformIdentity;
//     }
//    completion:^(BOOL finished)
//     {
//         
//     }];
//}
//-(void)hidePopup
//{
//    vwReschedule.transform = CGAffineTransformIdentity;
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
//     {
//         vwReschedule.transform = CGAffineTransformMakeScale(0.01, 0.01);
//     }
//                     completion:^(BOOL finished)
//     {
//         [vwReschedule removeFromSuperview];
//         scrlvbg.userInteractionEnabled = YES;
//     }];
//    
//}

@end
