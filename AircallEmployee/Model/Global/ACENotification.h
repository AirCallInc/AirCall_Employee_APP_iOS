//
//  ACENotification.h
//  AircallEmployee
//
//  Created by Manali on 10/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

//For Listing
extern NSString *const NKeyId               ;
extern NSString *const NKeyServiceID        ;
extern NSString *const NKeyMessage          ;
extern NSString *const NKeyType             ;
//For Detail
extern NSString *const NKeyNotificationId   ;
extern NSString *const NKeyDateTime         ;
extern NSString *const NKeyStatus           ;
extern NSString *const NKeyNotiMessage      ;
extern NSString *const NKeyNotificationType ;

typedef NS_ENUM(NSInteger, ACENotificationState)
{
    ACENotificationStatePending,
    ACENotificationStateShown,
    ACENotificationStateRedirected,
    ACENotificationStateComplete,
};

@interface ACENotification : NSObject

@property (nonatomic) ACENotificationState status;

@property (strong, nonatomic) NSString *notificationType    ;
@property (strong, nonatomic) NSString *ID                  ;
@property (strong, nonatomic) NSString *message             ;
@property (strong, nonatomic) NSString *serviceID           ;
@property (strong, nonatomic) NSString *dateTime            ;
@property (strong, nonatomic) NSString *notificationStatus  ;

- (instancetype)initWithDictionary:(NSDictionary *)notificationInfo;

@end

#define ACENotificationManagerObject [ACENotificationManager notificationManager]

@interface ACENotificationManager : NSObject

+ (ACENotificationManager *)notificationManager;

- (void)addNotification:(NSDictionary *)payload;

- (void)clearAllNotifications;
@end
