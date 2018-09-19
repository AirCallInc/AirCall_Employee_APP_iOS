//
//  ACEWebService+User.h
//  AircallEmployee
//
//  Created by ZWT112 on 3/31/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService.h"
#import "ACEUser.h"

extern NSString *const UKeyUrlEndpoint;

@interface ACEWebService (User)

-(void)updateDeviceToken:(NSDictionary *)deviceToken completionHandler:(void(^)(ACEAPIResponse *response))completion;

- (void)signinWithUserDetail:(NSDictionary *)userInfo completionHandler:(void (^)(ACEAPIResponse *response, ACEUser *user))completion;

-(void)logoutUser:(NSDictionary *)empDict completionHandler:(void(^)(ACEAPIResponse *response))completion;

- (void)forgotPassword:(NSDictionary *)userEmail completionHandler:(void (^)(ACEAPIResponse *response))completion;

-(void)getEmployeeFullData:(NSString *)empId completionHandler:(void(^)(ACEAPIResponse *response, ACEUser *user))completion;

-(void)changePassword:(NSDictionary *)passwordInfo completionHandler:(void(^)(ACEAPIResponse *response))completion;

-(void)sendUpdatedEmployeeData:(NSDictionary *)empData withProfileImage:(UIImage *)img completionHandler:(void(^)(ACEAPIResponse *response , ACEUser *user))completion;

-(void)sendCurrentLocation:(NSDictionary *)locationInfo completionHandler:(void(^)(ACEAPIResponse *response))completion;

-(void)validateBillingAddress:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *))completion;

@end
