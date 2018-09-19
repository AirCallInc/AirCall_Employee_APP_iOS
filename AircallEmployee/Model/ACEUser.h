//
//  ACEUser.h
//  AircallEmployee
//
//  Created by ZWT112 on 3/31/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

extern NSString *const UKeyUsername   ;
extern NSString *const UKeyPassword   ;

extern NSString *const UKeyOldPassword  ;
extern NSString *const UKeyNewPassword  ;

extern NSString *const UKeyID           ;

extern NSString *const UKeyEmployeeID   ;
extern NSString *const UKeyIsSalesPerson;

extern NSString *const UKeyImage       ;
extern NSString *const UKeyProfileImage;
extern NSString *const UKeyFirstName  ;
extern NSString *const UKeyLastName   ;
extern NSString *const UKeyEmail      ;
extern NSString *const UKeyAddress    ;


extern NSString *const UKeyStateId    ;
extern NSString *const UKeyCityId     ;

extern NSString *const UKeyCityName   ;
extern NSString *const UKeyStateName  ;
extern NSString *const UKeyZipcode    ;
extern NSString *const UKeyMobileNo   ;
extern NSString *const UKeyPhoneNo    ;
extern NSString *const UkeyWorkingHr  ;

extern NSString *const UKeyCurrentUser ;

extern NSString *const UKeyDeviceToken  ;
extern NSString *const UKeyDeviceType   ;

extern NSString *const UKeyDeviceTokenSent;
extern NSString *const UKeyRememberMe   ;


@interface ACEUser : NSObject

@property  NSString *userID         ;
@property  NSString *accessToken    ;
@property  NSString *userName       ;
@property  NSString *password       ;
@property  NSString *firstName      ;
@property  NSString *lastName       ;
@property  NSString *email          ;
@property  NSString *address        ;
@property  NSString *profileImage   ;
@property  NSString *stateId        ;
@property  NSString *cityId         ;

@property  NSString *cityName       ;
@property  NSString *stateName      ;

@property  NSString *zipcode        ;
@property  NSString *mobileNum      ;
@property  NSString *phoneNum       ;
@property  NSString *workingHr      ;
@property  NSURL    *profileImageURL;
@property  BOOL      isSalesPerson  ;

- (instancetype)initWithDictionary:(NSDictionary *)userInfo;
- (instancetype)initFromUserDefault;
- (void)saveInUserDefaults:(NSDictionary*)dict;
- (void)login;
- (void)logout;

@end
