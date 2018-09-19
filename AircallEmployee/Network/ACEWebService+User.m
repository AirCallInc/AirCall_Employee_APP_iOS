//
//  ACEWebService+User.m
//  AircallEmployee
//
//  Created by ZWT112 on 3/31/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService+User.h"

NSString *const UKeyUrlEndpoint = @"employee";

@implementation ACEWebService (User)

-(void)updateDeviceToken:(NSDictionary *)deviceToken completionHandler:(void(^)(ACEAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/employeeUpdateToken",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:deviceToken progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
    
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
          [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         
         DDLogError(@"Updating Devicetoken Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
-(void)signinWithUserDetail:(NSDictionary *)userInfo completionHandler:(void (^)(ACEAPIResponse *response, ACEUser *user))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/login",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             ACEUser *user = [[ACEUser alloc]initWithDictionary:responseObject[RKeyData]];
             completion(response, user);
         }
         else
         {
             completion(response, nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
}

- (void)forgotPassword:(NSDictionary *)userEmail completionHandler:(void (^)(ACEAPIResponse *response))completion
{
     NSString *resourceAddress = [NSString stringWithFormat:@"%@/ForgotPassword",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:userEmail progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)getEmployeeFullData:(NSString *)empId completionHandler:(void (^)(ACEAPIResponse *, ACEUser *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetProfile?EmployeeId=%@",UKeyUrlEndpoint,empId];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             
             ACEUser *empInfo = [[ACEUser alloc]initWithDictionary:responseObject[RKeyData]];
             
             completion(response,empInfo);
         }
         else
         {
             completion(response,nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}
-(void)logoutUser:(NSDictionary *)empDict completionHandler:(void(^)(ACEAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/logout",UKeyUrlEndpoint];
    
   //NSString *resourceAddress = @"http://192.168.1.119:6987/employee/logout";
    [self POST:resourceAddress parameters:empDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)sendUpdatedEmployeeData:(NSDictionary *)empData withProfileImage:(UIImage *)img completionHandler:(void(^)(ACEAPIResponse *response, ACEUser *user))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/UpdateProfile",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:empData constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
    {
        NSData *imageAsData = UIImageJPEGRepresentation(img, 0.7);
        
        [formData appendPartWithFileData:imageAsData name:UKeyImage fileName:UKeyImage mimeType:@"image/png"];
    }
      progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code    = [responseObject[RKeyCode] integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token   = responseObject[RKeyToken];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
        
        [ACEUtil updateAccessToken:token];
        if(code == RCodeSuccess)
        {
            ACEUser *user = [[ACEUser alloc]initWithDictionary:responseObject[RKeyData]];
            
            completion(response,user);
        }
        else
        {
            completion(response,nil);
        }
        
        
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"signinWithUserDetail Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response,nil);
    }];
    
}
-(void)changePassword:(NSDictionary *)passwordInfo completionHandler:(void (^)(ACEAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/ChangePassword",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:passwordInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
          [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)sendCurrentLocation:(NSDictionary *)locationInfo completionHandler:(void(^)(ACEAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/UpdateEmployeeLocation",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:locationInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}

-(void)validateBillingAddress:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/ValidateClientAddress",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"ValidateBillingAddress Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
    
}

@end
