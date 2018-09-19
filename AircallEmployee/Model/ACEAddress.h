//
//  ACEAddress.h
//  AircallEmployee
//
//  Created by ZWT111 on 30/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AdKeyAddress     ;
extern NSString *const ADKeyAddressId   ;
extern NSString *const ADKeycompany     ;
extern NSString *const AdKeyCityId      ;
extern NSString *const AdKeyCityName    ;
extern NSString *const AdKeyStateId     ;
extern NSString *const AdKeyStateName   ;
extern NSString *const AdKeyZipcode     ;
extern NSString *const AdKeyIsDefault   ;
extern NSString *const AdKeyShowAddress ;
extern NSString *const AdKeyDefaultId   ;
extern NSString *const AdKeyEmail       ;


@interface ACEAddress : NSObject

@property NSString *addressId   ;
@property NSString *addressName ;
@property NSString *cityId      ;
@property NSString *cityName    ;
@property NSString *stateId     ;
@property NSString *stateName   ;
@property NSString *zipcode     ;
@property BOOL isDefaultAddress ;
@property BOOL isShowAddress    ;
@property NSString *fullAddress ;
@property NSString *email       ;
@property NSString *company     ;

@property NSString *cardNumber      ;
@property NSString *cardType        ;
@property NSString *nameOnCard      ;
@property NSString *stripeCardId    ;
@property NSString *expMonth        ;
@property NSString *expYear         ;

-(instancetype)initWithDictionary:(NSDictionary *)addressInfo;
-(instancetype)initWithShortDictionary:(NSDictionary *)addressInfo;

@end
