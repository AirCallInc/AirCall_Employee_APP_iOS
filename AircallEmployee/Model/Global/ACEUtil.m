//
//  ACEUtil.m
//  AircallEmployee
//
//  Created by ZWT111 on 29/03/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//
NSString *const UKeyTokenType       = @"bearer";
NSString *const UKeyHTTPHeader      = @"Authorization";
NSString *const UKeyCurrentToken    = @"currentToken";

#import "ACEUtil.h"

@implementation ACEUtil

#pragma mark - Helper Method
+ (void)prepareApplication
{
    [self prepareAppreance];
    [self prepareUser];
    [self prepareServiceReportData];
    [self prepareInitialStoryboard];
    [self registerForPushNotification];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
+ (void)prepareUser
{
    ACEGlobalObject.user = [[ACEUser alloc] initFromUserDefault];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    ACEGlobalObject.accessToken = [userDefaults valueForKey:UKeyCurrentToken];
    
    if(ACEGlobalObject.accessToken)
    {
        [ACEWebServiceAPI.requestSerializer setValue:ACEGlobalObject.accessToken forHTTPHeaderField:UKeyHTTPHeader];
    }
}
+(void)prepareServiceReportData
{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     BOOL ans = [userDefaults boolForKey:GKeyIsTimerRunning];
    
    if(ans)
    {
        NSMutableDictionary *dict = [userDefaults valueForKey:GKeySavedReportData];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        
        [dateFormat setDateFormat:@"MMMM dd, yyyy"];
        if(![dict[GKeySavedDate] isEqualToString:[dateFormat stringFromDate:[NSDate date]]])
        {
            [ACEGlobalObject clearAllData];
        }
        else
        {
            
            ACEGlobalObject.isRelaunch              = YES                       ;
            ACEGlobalObject.isTimerRunning          = YES                       ;
            ACEGlobalObject.totalSheduleSeconds     = [dict[GKeyTotalSheduleSeconds]intValue];
            ACEGlobalObject.arrSelectedUnit         = [self getUnitArray:dict[GKeyUnitlist]];
            ACEGlobalObject.arrSelectedMaterial     = [self getMaterialArray:dict[GKeyMaterialList]]    ;
            ACEGlobalObject.arrServiceImage         = dict[GKeyImageList]       ;
            ACEGlobalObject.arrRequestedPart        = [self getRequestedPartArray:
                                                       dict[GKeyRequestedPart]]   ;
            ACEGlobalObject.isWorknotDone           = [dict[GKeyIsWorkNotDone]boolValue];            ;
            ACEGlobalObject.scheduleId              = dict[GKeyScheduleId]      ;
            ACEGlobalObject.timeStarted             = dict[GKeyTimeStarted]     ;
            ACEGlobalObject.signatureImg            = dict[GKeySignatureImage]  ;
            ACEGlobalObject.arrSelectedMaterialQty  = [self getSelectedMaterialQty:dict[GKeyMaterialQty]];
            ACEGlobalObject.workPerformed           = dict[GKeyWorkPerformed]   ;
            ACEGlobalObject.recomm                  = dict[GKeyNotesToCustomer] ;
            ACEGlobalObject.startReportLattitude    = dict[GKeyStartlattitude]  ;
            ACEGlobalObject.startReportLongitude    = dict[GKeyStartLongitude]  ;
            ACEGlobalObject.signatureImg            = [UIImage imageWithData:dict[GKeySignature]];
            ACEGlobalObject.arrServiceImage         = [self getImageArray:dict[GKeyServiceImgArr]];
            ACEGlobalObject.savedDate               = dict[GKeySavedDate];
        }
    }
    
}
+ (void)prepareAppreance
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor appGreenColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
}
+(void)unauthorizedUser:(NSString *)msg
{
    [SVProgressHUD dismiss];
    
    [self showAlertFromControllerWithSingleAction:nil withMessage:msg andHandler:^(UIAlertAction * _Nullable action)
    {
        [self logoutUser];
    }];
}
+ (void)logoutUser
{
    if ([ACEUtil reachable])
    {
    
        NSDictionary *dict = @{
                                UKeyEmployeeID : ACEGlobalObject.user.userID
                               };
        
        [SVProgressHUD show];
        
       [ACEWebServiceAPI logoutUser:dict completionHandler:^(ACEAPIResponse *response)
        {
      
            if (response.code == RCodeSuccess)
            {
                [ACEGlobalObject.user logout];
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                
                UINavigationController *rootController = [ACEGlobalObject.storyboardLogin instantiateInitialViewController];
        
                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
                appDelegate.window.rootViewController = rootController;
        
                ACEGlobalObject.navigationController = rootController;
                
            }
            else
            {
                [self showAlertFromController:nil withMessage:response.message];
            }
            
            [SVProgressHUD dismiss];
        }];
    
    
    }
    else
    {
        [self showAlertFromController:nil withMessage:ACENoInternet];
    }

}

+(void)sendUpdatedDeviceToken
{
    if (ACEGlobalObject.user && ACEGlobalObject.deviceToken)
    {
        NSDictionary *deviceTokenInfo = @{
                                          UKeyEmployeeID  : ACEGlobalObject.user.userID,
                                          UKeyDeviceToken : ACEGlobalObject.deviceToken,
                                          UKeyDeviceType  : ACEDeviceType
                                         };
        
        [ACEWebServiceAPI updateDeviceToken:deviceTokenInfo completionHandler:^(ACEAPIResponse *response)
         {
             
             
         }];
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }

}

+(void)registerForPushNotification
{
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

+(void)saveProfileImage:(NSURL*)profileImage
{
    if (profileImage != nil)
    {
        [ACEWebService downloadImageWithURL:profileImage complication:^(UIImage *image, NSError *error)
         {
             if (image)
             {
                 [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:UKeyImage];
             }
         }];
    }
}

+(void)openControllerOnNotification:(NSString *)notificationType withServiceId:(NSString *)serviceId withNotificationId:(NSString *)notificationId
{
    ScheduleListViewController *slvc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ScheduleListViewController"];
    
    if ([notificationType isEqualToString:@"10"]) // Schedule Detail Type Notification
    {
        ScheduleDetailViewController *sdvc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ScheduleDetailViewController"];
        
        sdvc.scheduleId = serviceId         ;
        sdvc.notificationId = notificationId;
        
        [ACEGlobalObject.rootNavigationController setViewControllers:@[slvc,sdvc] animated:YES];
    }
    else if ([notificationType isEqualToString:@"5"]) // Rating and Review Type Notification
    {
        RatingDetailViewController *rdvc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"RatingDetailViewController"];
        
        rdvc.rateId = serviceId;
        rdvc.notificationId = notificationId;
        [ACEGlobalObject.rootNavigationController setViewControllers:@[slvc,rdvc] animated:YES];
    }
    else if ([notificationType isEqualToString:@"15"]) // Sales Person Request Notification
    {
        NotificationListViewController *nlvc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
        
        SalesPersonNotiDetailController *spvc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"SalesPersonNotiDetailController"];
        
        spvc.salesVisitId   = serviceId;
        spvc.notificationId = notificationId;
        
        [ACEGlobalObject.rootNavigationController setViewControllers:@[nlvc,spvc] animated:YES];
    }
    else //General Notification
    {
        if(ACEGlobalObject.user.isSalesPerson)
        {
            SPNotificationListViewController *nlvc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"SPNotificationListViewController"];
            
            [ACEGlobalObject.rootNavigationController setViewControllers:@[slvc,nlvc] animated:YES];
        }
        else
        {
            NotificationListViewController *nlvc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
            
            [ACEGlobalObject.rootNavigationController setViewControllers:@[slvc,nlvc] animated:YES];
        }
        
    }
    
    ACEGlobalObject.notificationCount = ACEGlobalObject.notificationCount - 1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:ACEGlobalObject.notificationCount];
}

#pragma mark - Reachability
+ (BOOL)reachable
{
    Reachability *reachability   = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - Alert Method
+ (void)showAlertFromController:(UIViewController *)controller withMessage:(NSString *)message
{
    if(message == nil)
    {
        return;
    }
    else if (controller == nil)
    {
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        controller = appDelegate.window.rootViewController;
    }
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:appName message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:ACETextOk style:UIAlertActionStyleDefault handler:nil]];
    
    [controller presentViewController:alert animated:YES completion:nil];
                   
}

+ (void)showAlertFromControllerWithSingleAction:(UIViewController * _Nullable)controller
                                    withMessage:(NSString * _Nullable)message
                                     andHandler:(void (^__nullable)(UIAlertAction * _Nullable action))handler
{
    if (controller == nil)
    {
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        controller = appDelegate.window.rootViewController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:appName
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:ACETextOk style:UIAlertActionStyleDefault handler:handler]];
    
    [controller presentViewController:alert animated:YES completion:nil];
}
+(void)showAlertFromControllerWithDoubleAction:(UIViewController *)controller withMessage:(NSString *)message andHandler:(void (^)(UIAlertAction * _Nullable))handler andNoHandler:(void (^ _Nullable)(UIAlertAction * _Nullable))noHadler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:appName
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    [alert addAction:[UIAlertAction actionWithTitle:ACETextYes style:UIAlertActionStyleDefault handler:handler]];
    [alert addAction:[UIAlertAction actionWithTitle:ACETextNo style:UIAlertActionStyleCancel handler:noHadler]];

    [controller presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Storyboard Method
+ (void)prepareInitialStoryboard
{
    UINavigationController *rootController;
    
    if(ACEGlobalObject.user)
    {
        if(ACEGlobalObject.user.isSalesPerson)
        {
            [self prepareAppForSalesPerson];
        }
        else
        {
            [self prepareDashboard];
        }
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        rootController = [ACEGlobalObject.storyboardLogin instantiateInitialViewController];
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        appDelegate.window.rootViewController = rootController;
        
        ACEGlobalObject.navigationController = rootController;
    }
}

+(void)prepareDashboard
{
    
    RootNavigationViewController *rootController;
    
    rootController = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"rootNavigationController"];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelegate.window.rootViewController = rootController;
    
    ACEGlobalObject.rootNavigationController = rootController;
    
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    /*    SideBarViewController *leftDrawer = [rootController.storyboard instantiateViewControllerWithIdentifier:@"SideBarViewController"];
    
        [ACEGlobalObject setDrawer:[[MMDrawerController alloc]initWithCenterViewController:rootController.viewControllers[0] leftDrawerViewController:leftDrawer]];
    
        [[ACEGlobalObject drawer]setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [[ACEGlobalObject drawer]setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
        [rootController setViewControllers:@[[ACEGlobalObject drawer]]];
    
        [rootController setModalPresentationStyle:UIModalPresentationCurrentContext]; */

    
}
+(void)prepareAppForSalesPerson
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    RootNavigationViewController *rootController;
    
    rootController = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"NotificationNavigationController"];
   
   AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelegate.window.rootViewController = rootController;
    
   ACEGlobalObject.rootNavigationController = rootController;
   
}
#pragma mark - Helper Method

+ (UIView *)viewNoDataWithMessage:(NSString *)message andImage:(UIImage *)imgNoData withFontColor:(UIColor *)color withHeight:(CGFloat)height
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIView *viewNoData      = [[UIView alloc] initWithFrame:CGRectMake(0,0, screenSize.width, height)];
    
    UIImageView *imgvNoData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    UILabel *lblNoData      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    imgvNoData.image           = imgNoData;
    imgvNoData.backgroundColor = [UIColor clearColor];
    imgvNoData.frame           = CGRectMake((height / 9), (height / 9), 500, 500);
    
    NSString *labelText        = message ? message:@"";
    
   // NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    
   // NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //[paragraphStyle setLineSpacing:10];
    
    //[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    
    lblNoData.textColor       = color;
    lblNoData.backgroundColor = [UIColor clearColor];
    //lblNoData.attributedText  = attributedString;
    lblNoData.text            = labelText;
    lblNoData.numberOfLines   = 2;
    //lblNoData.frame           = CGRectMake(0, screenSize.height/8 , screenSize.width-15, height);
    lblNoData.frame           = CGRectMake(15, 0 , screenSize.width-30, height);
    lblNoData.textAlignment   = NSTextAlignmentCenter;
    
    [lblNoData setFont:[UIFont fontWithName:@"OpenSans" size:16]];
    
    [viewNoData addSubview:imgvNoData];
    [viewNoData addSubview:lblNoData];
    
    return viewNoData;
}

//MD5 Encryption
+ (NSString *) MD5HashForString:(NSString *)normalString
{
    const char *str = [normalString UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (int)strlen(str), result);
    
    NSMutableString *md5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [md5 appendFormat:@"%02x",result[i]];
    }
    
    return md5;
}

+ (void)updateAccessToken:(NSString *)updatedToken
{
     // NSLog(@"=========== sent Token ======= \n %@",[ACEWebService APIClient].requestSerializer.HTTPRequestHeaders);
    
    if(![updatedToken isKindOfClass:[NSNull class]])
    {
        if( updatedToken != nil && ![updatedToken isEqualToString:@""])
        {
            
            ACEGlobalObject.accessToken = [NSString stringWithFormat:@"%@ %@",UKeyTokenType,updatedToken];
        
            //NSLog(@"=========== Updated Token ======= \n %@",ACEGlobalObject.accessToken);
            
            [ACEWebServiceAPI.requestSerializer setValue:ACEGlobalObject.accessToken forHTTPHeaderField:UKeyHTTPHeader];
        
        // Update new token in userdefault
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
            [userDefaults setValue:ACEGlobalObject.accessToken forKey:UKeyCurrentToken];
        
            [userDefaults synchronize];
        }
        
    }
}
+(NSString *)convertDate:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    
    NSDate *dateFromString = [dateFormatter dateFromString:strDate];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    NSString * convertedString = [dateFormatter stringFromDate:dateFromString];
    
    return convertedString;
}
+(NSDate *)getDefaultDateWithoutWeekends:(NSInteger)daysGap
{
    NSDate *todayDate = [NSDate date];
    
    NSDate *pickedDate = [todayDate dateByAddingTimeInterval:daysGap * 24 * 60  * 60];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:pickedDate];
    NSInteger weekday = [weekdayComponents weekday];
    
    if (weekday == 1 || weekday == 7)
    {
        // Sunday or Saturday
        
        NSDate *nextMonday = nil;
        
        if (weekday == 1) // sunday
        {
            nextMonday = [pickedDate dateByAddingTimeInterval:24 * 60  *60]; // Add 24 hours
        }
        else //saturday
        {
            nextMonday = [pickedDate dateByAddingTimeInterval:2  * 24 * 60 * 60]; // Add two days
        }
        
        pickedDate = nextMonday;
    }
    return pickedDate;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MMM DD,yyyy"];
//    
//    NSString *convertedDateString = [dateFormatter stringFromDate:pickedDate];
//    return convertedDateString;
}

+(void)rememberMe:(NSMutableDictionary *)dict
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:dict forKey:UKeyRememberMe];
    
    [userDefaults synchronize];
}

+(NSMutableArray *)getMaterialArray:(NSArray*)arrMaterial
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [arrMaterial enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull Dict, NSUInteger idx, BOOL * _Nonnull stop)
     {
         ACEParts *part = [[ACEParts alloc]initDictionaryWithSavedata:Dict];
         [arr addObject:part];
     }];
    return arr;
}
+(NSMutableArray *)getUnitArray:(NSArray *)arrUnit
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [arrUnit enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
     {
         NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
         NSMutableArray *arrPart    = [[NSMutableArray alloc]init];
         
         [dict[SDKeyPartsList] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull pDict, NSUInteger idx, BOOL * _Nonnull stop)
          {
              ACEParts *part = [[ACEParts alloc]initDictionaryWithSavedata:pDict];
              [arrPart addObject:part];
          }];
         
         [mdict setValue:arrPart forKey:SDKeyPartsList];
         [arr addObject:mdict];
     }];
    
    return arr;
    
}
+(NSMutableArray *)getRequestedPartArray:(NSArray *)arrREquestedPart
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arrREquestedPart enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
     {
         NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
         
         ACEParts *part = [[ACEParts alloc]initDictionaryWithSavedata:dict[SRKeySelectedPart]] ;
         [mdict setValue:part forKey:SRKeySelectedPart];
         [arr addObject:mdict];
     }];
    
    return arr;
}
+(NSMutableArray *)getSelectedMaterialQty:(NSArray *)arrMaterial
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [arrMaterial enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
     {
         NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
         
         ACEParts *part =  [[ACEParts alloc]initDictionaryWithSavedata:mdict[GKeyPart]];
         [mdict setValue:part forKey:GKeyPart];
         [arr addObject:mdict];
     }];
    
    return arr;
}
+(NSMutableArray *)getImageArray:(NSArray*)arrImage
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arrImage enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
     {
         ACEServiceImage *sImage = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageWithData:dict[GKeyServiceImage]]];
         
         sImage.status = (ACEImageStatus)[dict[GKeyImageStatus]intValue];
         
         [arr addObject:sImage];
     }];
    
    return arr;
}
@end
