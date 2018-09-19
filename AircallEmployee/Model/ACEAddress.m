//
//  ACEAddress.m
//  AircallEmployee
//
//  Created by ZWT111 on 30/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEAddress.h"
NSString *const AdKeyAddress     = @"Address";
NSString *const ADKeyAddressId   = @"Id";
NSString *const ADKeycompany     = @"Company";
NSString *const AdKeyCityId      = @"City";
NSString *const AdKeyCityName    = @"CityName";
NSString *const AdKeyStateId     = @"State";
NSString *const AdKeyStateName   = @"StateName";
NSString *const AdKeyZipcode     = @"ZipCode";
NSString *const AdKeyIsDefault   = @"IsDefaultAddress";
NSString *const AdKeyShowAddress = @"ShowAddressInApp";
NSString *const AdKeyDefaultId   = @"DefaultAddressId";
NSString *const AdKeyEmail       = @"Email";

@implementation ACEAddress
@synthesize addressId,addressName,cityId,cityName,stateId,stateName,zipcode,isDefaultAddress,isShowAddress,fullAddress,email,cardType,cardNumber,stripeCardId,nameOnCard,expYear,expMonth,company;

-(instancetype)initWithDictionary:(NSDictionary *)addressInfo
{
    if(addressInfo.count == 0)
    {
        return nil;
    }
    
    if(self = [super init])
    {
        addressId          = [addressInfo[ADKeyAddressId] stringValue];
        addressName        = addressInfo[AdKeyAddress];
        company            = addressInfo[ADKeycompany];
        stateId            = [addressInfo[AdKeyStateId] stringValue];
        stateName          = addressInfo[AdKeyStateName];
        cityId             = [addressInfo[AdKeyCityId] stringValue];
        cityName           = addressInfo[AdKeyCityName];
        zipcode            = addressInfo[AdKeyZipcode];
        isDefaultAddress   = [addressInfo[AdKeyIsDefault] boolValue];
        isShowAddress      = [addressInfo[AdKeyShowAddress] boolValue];
        email              = addressInfo[AdKeyEmail];
        fullAddress        = [NSString stringWithFormat:@"%@\n%@, %@ %@",addressName, cityName,stateName,zipcode];
        
        cardNumber         = addressInfo[GKeyCardNumber];
        nameOnCard         = addressInfo[GKeyNameOnCard];
        cardType           = addressInfo[GKeyCardType];
        stripeCardId       = addressInfo[GKeyStipeCardId];
        expYear            = [addressInfo[GKeyExpiryYear] stringValue];
        expMonth           = [addressInfo[GKeyExpiryMonth] stringValue];
        
    }
    return self;
}
-(instancetype)initWithShortDictionary:(NSDictionary *)addressInfo
{
    if(addressInfo.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        
        addressName        = addressInfo[AdKeyAddress];
        stateName          = addressInfo[AdKeyStateId];
        cityName           = addressInfo[AdKeyCityId];
        zipcode            = addressInfo[AdKeyZipcode];
        
        fullAddress        = [NSString stringWithFormat:@"%@\n%@, %@ %@",addressName, cityName,stateName,zipcode];
    }
    return self;
}
@end
