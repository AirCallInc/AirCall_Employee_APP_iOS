//
//  ACEWebService.m
//  AircallEmployee
//
//  Created by ZWT111 on 29/03/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService.h"

//#define BasePath @""

#define BasePath @"https://system.aircallservices.com/"

//#define BasePath @"http://166.62.36.157/"

//#define BasePath @"http://192.168.1.121:8989/"

#define BaseFilePath BasePath @""

NSString *const BaseAPIPath         = BasePath @"api/v1";

NSString *const BaseProfileImageURL = BaseFilePath @"";
NSString *const BaseUnitImageURL    = BaseFilePath @"";
NSString *const BaseServiceImageURL = BaseFilePath @"";

NSInteger const RCodeSuccess            = 200;
NSInteger const RCodeNoData             = 404;
NSInteger const RCodeUnitPartialMatch   = 206;
NSInteger const RCodePaymentFail        = 502;
NSInteger const RCodeUnauthorized       = 406;
NSInteger const RCodeSessionExpired     = 401;
NSInteger const RCodeRequestFail        = 00;

NSString *const RKeyCode     = @"StatusCode";
NSString *const RKeyData     = @"Data"      ;
NSString *const RKeyMessage  = @"Message"   ;
NSString *const RKeyToken    = @"Token"     ;

@implementation ACEWebService

+ (NSURL *)profileImageURL:(NSString *)profileImageName
{
    NSString *lastFileComponant = [profileImageName lastPathComponent];
    
    NSString *profileImagePath = [BaseProfileImageURL stringByAppendingPathComponent:lastFileComponant];
    
    NSURL *profileImageURL = [NSURL URLWithString:profileImagePath];
    
    return profileImageURL;
}
+ (NSURL *)unitImageURL:(NSString *)unitImageName
{
    NSString *lastFileComponant = [unitImageName lastPathComponent];
    
    NSString *profileImagePath = [BaseUnitImageURL stringByAppendingPathComponent:lastFileComponant];
    
    NSURL *profileImageURL = [NSURL URLWithString:profileImagePath];
    
    return profileImageURL;
}
+ (NSURL *)serviceImageURL:(NSString *)serviceImageName
{
    NSString *lastFileComponant = [serviceImageName lastPathComponent];
    
    NSString *profileImagePath = [BaseServiceImageURL stringByAppendingPathComponent:lastFileComponant];
    
    NSURL *profileImageURL = [NSURL URLWithString:profileImagePath];
    
    return profileImageURL;
}
+(ACEWebService *)APIClient
{
    static ACEWebService *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        NSURL *baseURL = [NSURL URLWithString:BaseAPIPath];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _sharedClient = [[ACEWebService alloc]initWithBaseURL:baseURL sessionConfiguration:config];
        
         _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    });
    return _sharedClient;
}

#pragma mark - Error Handler Method
-(void)requestFail:(NSURLSessionDataTask *)task withError:(NSError *)error
{
    NSString *htmlError = [[NSString alloc]initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    
    DDLogError(@"Error in Text format : %@",htmlError);
    
    [SVProgressHUD dismiss];
    
    if(error.code == kCFURLErrorTimedOut)
    {
         [ACEUtil showAlertFromController:nil withMessage:ACENoInternet];
    }
    else if (error.code == kCFURLErrorCannotConnectToHost)
    {
        [ACEUtil showAlertFromController:nil withMessage:ACENoConnectionToServer];
    }
    else
    {
       [ACEUtil showAlertFromController:nil withMessage:error.localizedDescription];
    }
}
+ (void)downloadImageWithURL:(NSURL *)URLImage complication:(void (^)(UIImage *image, NSError *error))completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URLImage.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         UIImage *image = [UIImage imageWithData:responseObject];
         
         if(image)
         {
             completion(image, nil);
         }
         else
         {
             completion(nil, nil);
         }
     }
         failure:^(NSURLSessionTask *operation, NSError *error)
     {
         completion(nil, error);
     }];
}
@end


@implementation ACEAPIResponse
@synthesize code,message,accessToken,error;

- (instancetype)initWithCode:(NSInteger)statusCode andMessage:(NSString *)responseMessage andAccessToken:(NSString *)token
{
    self = [super init];
    
    if(self)
    {
        code          = statusCode;
        message       = responseMessage;
        accessToken   = token;
    }
    return self;
}

- (instancetype)initWithCode:(NSInteger)statusCode andError:(NSError *)errorDetail
{
    self = [super init];
    if(self)
    {
        code  = statusCode;
        error = errorDetail;
    }
    return self;
}

@end
