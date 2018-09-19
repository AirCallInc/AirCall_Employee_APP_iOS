//
//  AppDelegate.h
//  AircallEmployee
//
//  Created by ZWT111 on 29/03/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSTimer                      *serviceReportTimer;
@property NSString                     *latitude          ;
@property NSString                     *longitude         ;

@property int secondsLeft,hours,minutes,seconds,totalSeconds;

-(void)findTimeIntervalFromTime:(NSTimeInterval)interval;
-(void)stopTimer;

@end

