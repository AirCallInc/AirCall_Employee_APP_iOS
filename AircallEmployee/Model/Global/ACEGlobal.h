//
//  ACEGlobal.h
//  AircallEmployee
//
//  Created by ZWT111 on 29/03/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//
#import "RootNavigationViewController.h"
#import "ContainerViewController.h"

typedef NS_ENUM(NSInteger, ACEScreenSizeType)
{
    ACEScreenSizeTypeUndefined      = 0,
    ACEScreenSizeTypeiPhone4        = 1,
    ACEScreenSizeTypeiPhone5        = 2,
    ACEScreenSizeTypeiPhone6        = 3,
    ACEScreenSizeTypeiPhone6Plus    = 4
};

#define ACEGlobalObject [ACEGlobal global]

static const int ddLogLevel = DDLogLevelVerbose;

@interface ACEGlobal : NSObject

+(ACEGlobal *)global;

-(void)openMenu;
-(void)clearAllData;

@property (nonatomic, strong) UIStoryboard *storyboardLogin    ;
@property (nonatomic, strong) UIStoryboard *storyboardMenuBar  ;
@property (nonatomic, strong) UIStoryboard *storyboardDashboard;

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *deviceToken;

@property (nonatomic)         NSInteger notificationCount;
@property (strong,nonatomic)  ACEUser *user;
@property (nonatomic)         ACEScreenSizeType screenSizeType;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) RootNavigationViewController *rootNavigationController;
@property (strong, nonatomic) MMDrawerController      *drawer;
@property (strong, nonatomic) ContainerViewController *container;

// for Storing Service Report Data
@property (strong, nonatomic) NSMutableArray *arrSelectedUnit       ;
@property (strong, nonatomic) NSMutableArray *arrSelectedMaterial   ;
@property (strong, nonatomic) NSMutableArray *arrSelectedMaterialQty;
@property (strong, nonatomic) NSMutableArray *arrServiceImage       ;
@property (strong, nonatomic) NSMutableArray *arrRequestedPart      ;
@property (strong, nonatomic) NSString       *scheduleId            ;
@property (strong, nonatomic) NSString       *timeStarted           ;

@property (strong, nonatomic) NSString       *workPerformed         ;
@property (strong, nonatomic) NSString       *employeeNotes         ;
@property (strong, nonatomic) NSString       *recomm                ;
@property (strong, nonatomic) UIImage        *signatureImg          ;
@property (strong, nonatomic) NSString       *startReportLattitude  ;
@property (strong, nonatomic) NSString       *startReportLongitude  ;

@property (strong, nonatomic) NSString       *currentLattitude      ;
@property (strong, nonatomic) NSString       *currentLongitude      ;
@property (strong, nonatomic) NSString       *savedDate             ;

@property  int totalSheduleSeconds;

@property BOOL isWorknotDone    ;
@property BOOL isTimerRunning   ;
@property BOOL isRelaunch       ;
@property BOOL shouldAutoRotate ;

@end
