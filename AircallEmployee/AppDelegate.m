//
//  AppDelegate.m
//  AircallEmployee
//
//  Created by ZWT111 on 29/03/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property CLLocation        *prevloc             ;
@property CLLocationManager *locationManager     ;

@property NSTimer           *timer               ;

@property (strong, nonatomic) NSDate *lastTimestamp;

@end

@implementation AppDelegate

@synthesize latitude,longitude,locationManager,timer,prevloc,lastTimestamp,serviceReportTimer,totalSeconds;

@synthesize secondsLeft,hours,minutes,seconds;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [ACEUtil prepareApplication];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager requestAlwaysAuthorization];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIBackgroundTaskIdentifier bgTask = 0;
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^
    {
        [application endBackgroundTask:bgTask];
    }];
    
    //[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    
    //[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    if(ACEGlobalObject.isTimerRunning)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveDataInGlobal" object:nil];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    locationManager.distanceFilter = 500;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [ACEGlobalObject clearAllData];
    
}
#pragma mark - PushNotification Method
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *finalDeviceToken = [deviceToken description];
    
    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    ACEGlobalObject.deviceToken = finalDeviceToken;
    
    //NSLog(@"device token : %@",finalDeviceToken);
    [ACEUtil sendUpdatedDeviceToken];
    
   /* NSString *str = [[NSString alloc]initWithFormat:@"Did Register::\n device token %@",finalDeviceToken];
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"success" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [errorAlert addAction:alertOk];
    [self.window.rootViewController presentViewController:errorAlert animated:YES completion:nil];*/
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError : %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
   // NSLog(@"%@",userInfo);
    
    [ACENotificationManagerObject addNotification:userInfo];
    
   /* NSString *str = [[NSString alloc]initWithFormat:@"Did didReceiveRemoteNotification"];
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"success" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [errorAlert addAction:alertOk];
    [self.window.rootViewController presentViewController:errorAlert animated:YES completion:nil];*/
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result)
    {
        //[ACENotificationManagerObject addNotification:userInfo];
        
    }];
    /*NSString *str = [[NSString alloc]initWithFormat:@"Did didReceiveRemoteNotification"];
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"success" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [errorAlert addAction:alertOk];
    [self.window.rootViewController presentViewController:errorAlert animated:YES completion:nil];*/
}
#pragma mark - OrientationMethod
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    /* This code is for opening signatureview controller in landscape mode */
    
    if ([window.rootViewController.presentedViewController isKindOfClass:[SignatureViewController class]] && ACEGlobalObject.shouldAutoRotate)
    {
        return  UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}
#pragma mark - Helper Method
-(void)findTimeIntervalFromTime:(NSTimeInterval)interval
{
    ACEGlobalObject.isTimerRunning = YES;
    
   // NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    
    hours                   = (int)interval / 3600;
    minutes                 = (interval - (hours * 3600)) / 60;
    totalSeconds            = (hours * 3600) + (minutes * 60);
    
   // secondsLeft             = (hours * 3600) + (minutes * 60);
    secondsLeft             = interval;
    
    timer                   = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)updateCounter:(NSTimer *)timer
{
    //secondsLeft--;
    secondsLeft ++;
    
    hours          = secondsLeft / 3600;
    minutes        = (secondsLeft % 3600) / 60;
    seconds        = (secondsLeft % 3600) % 60;
    
    NSString *str;
    if(secondsLeft < 0)
    {
        str = [NSString stringWithFormat:@"%02d:%02d:%02d\nExtra Time", abs(hours),abs(minutes), abs(seconds)];
    }
    else
    {
        str = [NSString stringWithFormat:@"%02d:%02d:%02d", abs(hours),abs(minutes), abs(seconds)];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeNotification" object:str];
}
-(void)stopTimer
{
    [timer invalidate];
}
#pragma mark - Webservice Method
- (void)sendLoaction
{
    
    if (![latitude isEqualToString:@""] || ![longitude isEqualToString:@""])
    {
        if(ACEGlobalObject.user.userID)
        {
            NSDictionary *dict =@{
                                  UKeyEmployeeID : ACEGlobalObject.user.userID,
                                  GKeyLattitude  : latitude,
                                  GKeyLongitude   : longitude
                                  };
            
            [ACEWebServiceAPI sendCurrentLocation:dict completionHandler:^(ACEAPIResponse *response)
            {
                if(response.code == RCodeSuccess)
                {
                    
                    NSLog(@"Location send to server successfully");
                }
                
                
            }];
        }
        //NSLog(@"Latitude-%@ Longitude-%@",latitude,longitude);
    }
}

#pragma mark - CLLocationManagerDelegate Method

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
   // UIAlertAction *alertOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    //[errorAlert addAction:alertOk];
    //[self.window.rootViewController presentViewController:errorAlert animated:YES completion:nil];
    latitude = @"";
    longitude = @"";
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
        break;
        default:
        {
            [self.locationManager startUpdatingLocation];
        }
        break;
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
//    if (newLocation.coordinate.latitude != prevloc.coordinate.latitude)
//    {
        latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    
        ACEGlobalObject.currentLattitude = latitude ;
        ACEGlobalObject.currentLongitude = longitude;
    
        prevloc     = newLocation;
        
        NSDate *now = [NSDate date];
        
        NSTimeInterval interval = self.lastTimestamp ? [now timeIntervalSinceDate:self.lastTimestamp] : 0;
        
        if (!self.lastTimestamp || interval >= 3 * 60)
        {
            self.lastTimestamp = now;
            NSLog(@"Sending current location to web service.");
            [self sendLoaction];
        }
        //[self sendLoaction];
   // }
}

@end
