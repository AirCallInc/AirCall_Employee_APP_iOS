//
//  ACESchedule.m
//  AircallEmployee
//
//  Created by ZWT112 on 5/6/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

NSString *const SCHKeyId            = @"Id";

NSString *const SCHKeyEmpId         = @"EmployeeId";
NSString *const SCHKeyAddressId     = @"AddressId";
NSString *const SCHKeyUnitsId       = @"UnitIds";
NSString *const SCHKeyTimeSlot      = @"TimeSlot";
NSString *const SCHKeyMonth         = @"Month";
NSString *const SCHKeyDay           = @"Day";
NSString *const SCHKeyYear          = @"Year";

NSString *const SCHKeyStartTime     = @"ScheduleStartTime";
NSString *const SCHKeyEndTime       = @"ScheduleEndTime";

NSString *const SCHKeyScheduleDate  = @"ScheduleDate";
NSString *const SCHKeyServices      = @"Services";

NSString *const SCHKeyClientFirstName   = @"FirstName" ;
NSString *const SCHKeyClientLastName    = @"LastName";
NSString *const SCHKeyClientAddress     = @"Address";

NSString *const SCHKeyPurpose       = @"PurposeOfVisit";
NSString *const SCHKeyTimeSlot1     = @"ServiceSlot1";
NSString *const SCHKeyTimeSlot2     = @"ServiceSlot2";
NSString *const SCHKeyDestLongitude = @"Longitude";
NSString *const SCHKeyDestLattitude = @"Latitude";
NSString *const SCHKeyStatus        = @"Status";

#import "ACESchedule.h"

@implementation ACESchedule

@synthesize Id,clientName,purpose,startTime,endTime,destLattitude,destLongitude,clientAddress,status;

-(instancetype)initWithDictionary:(NSDictionary*)scheduleInfo
{
    if(scheduleInfo.count == 0)
        return nil;
    
    if(self = [super init])
    {
        Id              = [scheduleInfo[SCHKeyId]stringValue];
        
        clientName      = [NSString stringWithFormat:@"%@ %@",scheduleInfo[SCHKeyClientFirstName],scheduleInfo[SCHKeyClientLastName]];
        clientAddress   = scheduleInfo[SCHKeyClientAddress];
        purpose         = scheduleInfo[SCHKeyPurpose];
        startTime       = scheduleInfo[SCHKeyStartTime];
        endTime         = scheduleInfo[SCHKeyEndTime];
        status          = scheduleInfo[SCHKeyStatus];
        
        if(![scheduleInfo[SCHKeyDestLattitude] isKindOfClass:[NSNull class]])
        {
            destLattitude   = [scheduleInfo[SCHKeyDestLattitude] stringValue];
        }
        if(![scheduleInfo[SCHKeyDestLongitude] isKindOfClass:[NSNull class]])
        {
            destLongitude   = [scheduleInfo[SCHKeyDestLongitude] stringValue];
        }
    }
    return self;
}
@end
