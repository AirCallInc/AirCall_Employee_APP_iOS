//
//  ACESalesPersonVisit.m
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACESalesPersonVisit.h"

NSString *const SPKeyID             = @"";
NSString *const SPKeyClientName     = @"";
NSString *const SPKeyDate           = @"RequestedDate";

NSString *const SPRequestId         = @"SalesVisitRequestId";
NSString *const SPKeyAddress        = @"Address";
NSString *const SPKeyFirstName      = @"FirstName";
NSString *const SPKeyLastName       = @"LastName";
NSString *const SPKeyLattitude      = @"Latitude";
NSString *const SPKeyLongitude      = @"Longitude";
NSString *const SPKeyMobileNumber   = @"MobileNumber";
NSString *const SPKeyPhoneNumber    = @"HomeNumber";
NSString *const SPKeyOfficeNumber   = @"OfficeNumber";
NSString *const SPKeyNotes          = @"Notes";
NSString *const SPKeyEmail          = @"Email";

@implementation ACESalesPersonVisit

@synthesize ID,clientName,date,address,lattitude,longitude,mobileNumber,phoneNumber,officeNumber,notes,email;

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        //ID = dict[SPKeyID];
        clientName = dict[OKeyClientName];
        date = dict[SPKeyDate];
    }
    return self;
}
-(instancetype)initWithDetailDictionary:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        ID = dict[SPKeyID];
        clientName      = [NSString stringWithFormat:@"%@ %@",
        dict[SPKeyFirstName],dict[SPKeyLastName]];
        address         = dict[SPKeyAddress];
        phoneNumber     = dict[SPKeyPhoneNumber];
        mobileNumber    = dict[SPKeyMobileNumber];
        officeNumber    = dict[SPKeyOfficeNumber];
        lattitude       = [dict[SPKeyLattitude]stringValue];
        longitude       = [dict[SPKeyLongitude]stringValue];
        notes           = dict[SPKeyNotes];
        email           = dict[SPKeyEmail];
    }
    return self;
}
@end
