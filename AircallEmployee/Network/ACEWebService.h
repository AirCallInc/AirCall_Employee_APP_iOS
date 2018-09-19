//
//  ACEWebService.h
//  AircallEmployee
//
//  Created by ZWT111 on 29/03/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

extern NSString *const BaseAPIPath       ;
extern NSString *const BasePlantImagePath;

extern NSString *const RKeyCode     ;

extern NSString *const RKeyData     ;
extern NSString *const RKeyMessage  ;
extern NSString *const RKeyToken    ;

extern NSInteger const RCodeSuccess             ;
extern NSInteger const RCodeUnauthorized        ;
extern NSInteger const RCodeSessionExpired      ;

extern NSInteger const RCodePaymentFail         ;
extern NSInteger const RCodeNoData              ;
extern NSInteger const RCodeUnitPartialMatch    ;
extern NSInteger const RCodeRequestFail         ;

#define ACEWebServiceAPI [ACEWebService APIClient]

@interface ACEWebService : AFHTTPSessionManager

+(ACEWebService *)APIClient;

+ (void)downloadImageWithURL:(NSURL *)URLImage complication:(void (^)(UIImage *image, NSError *error))completion;

-(void)requestFail:(NSURLSessionDataTask *)task withError:(NSError *)error;

+ (NSURL *)profileImageURL:(NSString *)profileImageName;
+ (NSURL *)unitImageURL:(NSString *)unitImageName;
+ (NSURL *)serviceImageURL:(NSString *)serviceImageName;

@end

@interface ACEAPIResponse : NSObject

@property (nonatomic)         NSInteger code   ;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *accessToken  ;
@property (strong, nonatomic) NSError  *error  ;

- (instancetype)initWithCode:(NSInteger)statusCode andMessage:(NSString *)responseMessage andAccessToken:(NSString *)token;
- (instancetype)initWithCode:(NSInteger)statusCode andError:(NSError *)errorDetail;

@end