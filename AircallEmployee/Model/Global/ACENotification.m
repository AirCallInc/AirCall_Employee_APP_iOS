//
//  ACENotification.m
//  AircallEmployee
//
//  Created by Manali on 10/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACENotification.h"

//For Listing
NSString *const NKeyId            = @"NId"      ;
NSString *const NKeyServiceID     = @"CommonId" ;
NSString *const NKeyMessage       = @"Msg"      ;
NSString *const NKeyType          = @"NType"    ;
//For Detail
NSString *const NKeyNotificationId   = @"NotificationId"    ;
NSString *const NKeyDateTime         = @"DateTime"          ;
NSString *const NKeyStatus           = @"Status"            ;
NSString *const NKeyNotiMessage      = @"Message"           ;
NSString *const NKeyNotificationType = @"NotificationType"  ;

@implementation ACENotification
@synthesize ID,notificationType,serviceID,message,status,dateTime,notificationStatus;

- (instancetype)initWithDictionary:(NSDictionary *)notificationInfo
{
    if (self = [super init])
    {
        ID                 = notificationInfo[NKeyNotificationId]  ;
        message            = notificationInfo[NKeyNotiMessage]     ;
        notificationType   = [notificationInfo[NKeyNotificationType] stringValue];
        serviceID          = [notificationInfo[NKeyServiceID] stringValue];
        dateTime           = notificationInfo[NKeyDateTime]  ;
        notificationStatus = notificationInfo[NKeyStatus]    ;
    }
    
    return self;
}
@end

@interface ACENotificationManager()

@property (strong, nonatomic) NSMutableArray *notifications;

@end

@implementation ACENotificationManager

@synthesize notifications;

+ (ACENotificationManager *)notificationManager
{
    static ACENotificationManager *notificationManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      notificationManager = [[ACENotificationManager alloc] init];
                  });
    
    return notificationManager;
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        notifications = @[].mutableCopy;
    }
    
    return self;
}

- (void)addNotification:(NSDictionary *)payload
{
    if(payload)
    {
        ACENotification *notification = [[ACENotification alloc] init];
        
        notification.ID               = payload[NKeyId];
        notification.message          = payload [@"aps"][@"alert"];
        notification.notificationType = [payload[NKeyType] stringValue];
        notification.status           = ACENotificationStatePending;
        notification.serviceID        = [payload[NKeyServiceID] stringValue];
        
        [notifications addObject:notification];
        
        [self processPendingNotifications];
    }
}

- (void)processPendingNotifications
{
    if(!ACEGlobalObject.user)
    {
        notifications = @[].mutableCopy;
        return;
    }
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [notifications enumerateObjectsUsingBlock:^(ACENotification * _Nonnull notification, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (notification.status == ACENotificationStatePending)
             {
                 [self showAlertForNotification:notification];
             }
         }];
    }
    else
    {
        [notifications enumerateObjectsUsingBlock:^(ACENotification * _Nonnull notification, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (notification.status == ACENotificationStatePending)
             {
                 [self navigateForNotification:notification];
             }
         }];
    }
}

- (void)showAlertForNotification:(ACENotification *)notification
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *controller = delegate.window.rootViewController;
    
    if (controller.presentedViewController)
    {
        controller = controller.presentedViewController;
    }

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:appName
                                                                       message:notification.message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:ACETextShowDetail style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              [self navigateForNotification:notification];
                          }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:ACETextCancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              [notifications removeObject:notification];
                              
                              [self processPendingNotifications];
                          }]];
        
        [controller presentViewController:alert animated:YES completion:nil];
    
        notification.status = ACENotificationStateShown;
}

- (void)navigateForNotification:(ACENotification *)notification
{
    [ACEUtil openControllerOnNotification:notification.notificationType withServiceId:notification.serviceID withNotificationId:notification.ID];
    
    notification.status = ACENotificationStateComplete;
}

- (void)clearAllNotifications
{
    notifications = @[].mutableCopy;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self processPendingNotifications];
}


@end

