//
//  ACEUtil.h
//  AircallEmployee
//
//  Created by ZWT111 on 29/03/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//


extern NSString *const UKeyHTTPHeader   ;
extern NSString *const UKeyCurrentToken ;
extern NSString *const UKeyTokenType    ;

@interface ACEUtil : NSObject

+ (void)prepareApplication;
+ (void)prepareUser;
+ (BOOL)reachable;
+ (void)logoutUser;
+ (void)prepareDashboard;
+ (void)prepareServiceReportData;
+ (void)prepareAppForSalesPerson;
+ (void)registerForPushNotification;
+ (void)unauthorizedUser:(NSString *)msg;
+ (NSDate *)getDefaultDateWithoutWeekends:(NSInteger)daysGap;
+ (void)showAlertFromController:(UIViewController * _Nullable)controller withMessage:(NSString * _Nullable)message;

+ (void)showAlertFromControllerWithSingleAction:(UIViewController * _Nullable)controller
                                    withMessage:(NSString * _Nullable)message
                                     andHandler:(void (^__nullable)(UIAlertAction * _Nullable action))handler;
+ (void)showAlertFromControllerWithDoubleAction:(UIViewController * _Nullable)controller
                                    withMessage:(NSString * _Nullable)message
                                     andHandler:(void (^__nullable)(UIAlertAction * _Nullable action)) handler andNoHandler:(void (^__nullable)(UIAlertAction * _Nullable action))noHadler;

+ (UIView * _Nonnull)viewNoDataWithMessage:(NSString *_Nullable)message andImage:(UIImage *_Nullable)imgNoData withFontColor:(UIColor *_Nullable)color withHeight:(CGFloat)height;

+ (NSString * _Nullable) MD5HashForString:(NSString * _Nullable)normalString;
+ (void)sendUpdatedDeviceToken;
+ (void)updateAccessToken:(NSString * _Nullable)updatedToken;
+ (NSString * _Nullable)convertDate:(NSString * _Nullable)strDate;
+ (void)saveProfileImage:(NSURL* _Nullable)profileImage;
+ (void)openControllerOnNotification:(NSString * _Nullable)notificationType withServiceId:(NSString * _Nullable)serviceId withNotificationId:(NSString * _Nullable)notificationId;

+ (void)rememberMe:(NSMutableDictionary * _Nullable)dict;
@end
