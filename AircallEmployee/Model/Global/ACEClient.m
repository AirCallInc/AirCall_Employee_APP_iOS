//
//  ACEClient.m
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEClient.h"

NSString *const CKeyID             =@"ClientId";
NSString *const CKeyName           =@"ClientName";
NSString *const CKeyPhoneNumbers   =@"client_phone";
NSString *const CKeyACList         =@"client_aclist";
NSString *const CKeyAc             =@"client_ac";
NSString *const CKeyAddress        =@"client_address";
NSString *const CKeyNotes          =@"";
NSString *const CKeyEmail          =@"Email";

@implementation ACEClient

@synthesize ID,Name,PhoneNumbers,AcList,Ac,Address,email;

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        ID = @([[NSString stringWithFormat:@"%@",dict[GKeyId]]integerValue]);
        Name         = dict[CKeyName];
        PhoneNumbers = dict[CKeyPhoneNumbers];
        AcList       = dict[CKeyACList];
        Ac           = dict[CKeyAc];
        Address      = dict[CKeyAddress];
        email        = dict[CKeyEmail];
    }
    return self;
}

@end
