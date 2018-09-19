//
//  ACEGlobal.m
//  AircallEmployee
//
//  Created by ZWT111 on 29/03/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEGlobal.h"

@implementation ACEGlobal
@synthesize screenSizeType,storyboardLogin,storyboardMenuBar,storyboardDashboard,notificationCount;

+ (ACEGlobal *)global
{
    static ACEGlobal *global = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        global = [[ACEGlobal alloc]init];
    });
    
    return global;
}

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        screenSizeType = [self identifyDeviceType];
    }
    return self;
}

-(ACEScreenSizeType)identifyDeviceType
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if(screenSize.height == 480)
    {
        return ACEScreenSizeTypeiPhone4;
    }
    else if(screenSize.height == 568)
    {
        return ACEScreenSizeTypeiPhone5;
    }
    else if(screenSize.height == 667)
    {
        return ACEScreenSizeTypeiPhone6;
    }
    else if(screenSize.height == 736)
    {
        return ACEScreenSizeTypeiPhone6Plus;
    }
    
    return ACEScreenSizeTypeUndefined;
}

-(void)openMenu
{
    [ACEGlobalObject.drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)clearAllData
{
    AppDelegate  *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    ACEGlobalObject.isTimerRunning = NO ;
    ACEGlobalObject.isRelaunch     = NO ;
    
    [delegate stopTimer];
      
    _arrSelectedUnit            = nil   ;
    _arrSelectedMaterial        = nil   ;
    _arrSelectedMaterialQty     = nil   ;
    _arrServiceImage            = nil   ;
    _arrRequestedPart           = nil   ;
    _scheduleId                 = nil   ;
    _timeStarted                = nil   ;
    _signatureImg               = nil   ;
    _workPerformed              = nil   ;
    _employeeNotes              = nil   ;
    _recomm                     = nil   ;
    _isWorknotDone              = NO    ;
    _totalSheduleSeconds        = 0     ;
    _savedDate                  = @""   ;
    
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:GKeySavedReportData];
    [userDefault removeObjectForKey:GKeyIsTimerRunning];
    [userDefault synchronize];
    
}
#pragma mark - Storyboard Method
- (UIStoryboard *)storyboardLogin
{
    if (!storyboardLogin)
    {
        storyboardLogin = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    }
    return storyboardLogin;
}

- (UIStoryboard *)storyboardMenuBar
{
    if (!storyboardMenuBar)
    {
        storyboardMenuBar = [UIStoryboard storyboardWithName:@"MenuBar" bundle:nil];
    }
    return storyboardMenuBar;
}

- (UIStoryboard *)storyboardDashboard
{
    if (!storyboardDashboard)
    {
        storyboardDashboard = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
    }
    return storyboardDashboard;
}
@end
