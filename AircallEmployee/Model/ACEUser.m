//
//  ACEUser.m
//  AircallEmployee
//
//  Created by ZWT112 on 3/31/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEUser.h"

NSString *const UKeyUsername = @"" ;
NSString *const UKeyPassword = @"Password" ;
NSString *const UKeyOldPassword  = @"OldPassword" ;
NSString *const UKeyNewPassword  = @"NewPassword" ;
NSString *const UKeyImage        = @"Image";
NSString *const UKeyProfileImage = @"ProfileImage";
NSString *const UKeyID           = @"Id" ;
NSString *const UKeyEmployeeID   = @"EmployeeId" ;
NSString *const UKeyIsSalesPerson= @"IsSalesPerson";

NSString *const UKeyFirstName   = @"FirstName" ;
NSString *const UKeyLastName    = @"LastName" ;
NSString *const UKeyEmail       = @"Email" ;
NSString *const UKeyAddress     = @"Address" ;

NSString *const UKeyStateId     = @"StateId" ;
NSString *const UKeyCityId      = @"CitiesId" ;

NSString *const UKeyCityName    = @"City" ;
NSString *const UKeyStateName   = @"StateName" ;
NSString *const UKeyZipcode     = @"ZipCode" ;
NSString *const UKeyMobileNo    = @"MobileNumber" ;
NSString *const UKeyPhoneNo     = @"PhoneNumber" ;
NSString *const UkeyWorkingHr   = @"WorkingHours" ;
NSString *const UKeyCurrentUser = @"currentUser" ;

NSString *const UKeyDeviceToken = @"DeviceToken" ;
NSString *const UKeyDeviceType  = @"DeviceType" ;

NSString *const UKeyDeviceTokenSent =@"DeviceTokenSent";
NSString *const UKeyRememberMe      =@"RememberMe";

@implementation ACEUser

@synthesize accessToken,userID,userName,password,firstName,lastName,email,address,cityId,stateId,cityName,stateName,zipcode,mobileNum,phoneNum,workingHr,profileImage,profileImageURL,isSalesPerson;

- (instancetype)initWithDictionary:(NSDictionary *)userInfo
{
    if(userInfo.count == 0)
    {
        return nil;
    }
    
    if (self = [super init])
    {
        userID             = userInfo[UKeyID];
        userName           = userInfo[UKeyPassword];
        password           = userInfo[UKeyPassword];

        firstName          = userInfo[UKeyFirstName];
        lastName           = userInfo[UKeyLastName];
        email              = userInfo[UKeyEmail];
        address            = userInfo[UKeyAddress];
        
        profileImage       = userInfo[UKeyImage];
        profileImageURL    = [NSURL URLWithString:userInfo[UKeyProfileImage]];
        
        stateName          = userInfo[UKeyStateName];
        cityName           = userInfo[UKeyCityName];
        
        cityId             = [userInfo[UKeyCityId] stringValue];
        stateId            = [userInfo[UKeyStateId] stringValue];
        
        zipcode            = userInfo[UKeyZipcode];
        mobileNum          = userInfo[UKeyMobileNo];
        phoneNum           = userInfo[UKeyPhoneNo];
        workingHr          = userInfo[UkeyWorkingHr];
        isSalesPerson      = [userInfo[UKeyIsSalesPerson]boolValue];
    }
    
    return self;
}
- (instancetype)initFromUserDefault
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [userDefaults valueForKey:UKeyCurrentUser];
    
    if (userInfo)
    {
        self = [[ACEUser alloc] initWithDictionary:userInfo];
    }
    else
    {
        return nil;
    }
    
    return self;
}
#pragma mark - Helper Method
- (void)saveInUserDefaults:(NSDictionary*)dict
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:dict forKey:UKeyCurrentUser];
    
    [userDefaults synchronize];
}

- (NSDictionary *)getDictionary
{
    NSDictionary *userInfo = @{
                                UKeyID          : userID,
                                UKeyEmail       : email,
                                UKeyPassword    : password,
                                UKeyLastName    : lastName,
                                UKeyFirstName   : firstName,
                                UKeyIsSalesPerson : @(isSalesPerson)
                               };
    return userInfo;
}

- (void)login
{
    ACEGlobalObject.user = self;
    [self saveInUserDefaults:[self getDictionary]];
    [ACEUtil saveProfileImage:profileImageURL];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [ACEUtil registerForPushNotification];
}
- (void)logout
{
    [ACEGlobalObject clearAllData];
    
    ACEGlobalObject.user = nil;
    
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    
//    [userDefaults removePersistentDomainForName:appDomain];

    [self resetUserDefaults];
    
    [ACEWebServiceAPI.requestSerializer clearAuthorizationHeader];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}
-(void)resetUserDefaults
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (NSString *key in dict)
    {
        if(![key isEqualToString:UKeyRememberMe])
            [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
@end
