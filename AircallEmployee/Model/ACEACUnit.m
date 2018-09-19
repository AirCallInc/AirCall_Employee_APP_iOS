//
//  ACEACUnit.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEACUnit.h"

NSString *const AKeyUnits                      = @"Units";
NSString *const ACKeyID                        = @"UnitId";

NSString *const ACKeyClientFirstName           = @"FirstName";
NSString *const ACKeyClientLastName            = @"LastName";

NSString *const ACKeyNameOfUnit                = @"UnitName";
NSString *const ACKeyAddress                   = @"Address";

NSString *const ACKeyPlan                      = @"Name";
NSString *const ACKeyUnitParts                 = @"UnitParts";
NSString *const ACKeyNotes                     = @"Notes";

NSString *const ACKeyPictures                  = @"UnitPictures";
NSString *const ACKeyPictureUrl                = @"UnitImageUrl";

NSString *const ACKeyHistory                   = @"ServiceHistory";
NSString *const ACKeyReportNumber              = @"ServiceReportNumber";

NSString *const ACKeyManual                    = @"UnitManuals";
NSString *const ACKeyManualName                = @"ManualName";
NSString *const ACKeyManualUrl                 = @"ManualURL";
NSString *const ACKeyPaymentOption             = @"CurrentPaymentMethod";
NSString *const ACKeyPaymentMethod             = @"PaymentMethod";
NSString *const ACKeyPoNum                     = @"PONo";

//for sending unit data
NSString *const ACKeyOptionalInfo              = @"OptionalInformation";
NSString *const ACKeySplitType                 = @"SplitType";
NSString *const ACKeyQntyFilter                = @"QuantityOfFilter";
NSString *const ACKeyQntyFuse                  = @"QuantityOfFuses";
NSString *const ACKeyLocationOfPart            = @"LocationOfPart";
NSString *const ACKeyBoosterTypes              = @"ThermostatTypes";
NSString *const ACKeyFuseTypes                 = @"FuseTypes";
NSString *const ACKeySizeOfFilter              = @"Size";
NSString *const ACKeyQty                       = @"Qty";

//for listing
NSString *const ACKeyClientName                = @"ClientName";
NSString *const ACKeyIsMatched                 = @"IsMatched";
NSString *const ACKeyServiceDate               = @"ServiceDate";
NSString *const ACKeyServiceTime               = @"ServiceTime";
NSString *const ACKeyUnitType                  = @"UnitType";
NSString *const ACKeyPlanType                  = @"PlanType";
NSString *const ACKeyClientUnitParts           = @"ClientUnitPart";
NSString *const ACKeyMfgDate                   = @"ManufactureDate";
NSString *const ACKeyUnitAge                   = @"UnitAge";

@implementation ACEACUnit

@synthesize clientName,address,arrPartsInfo,plan,unitName,notes,pictures,serviceReports,manuals,arrPasrts,unitId,serviceDate,serviceTime,isMatched,unitType,arrModelSerial,unitAge;

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        
        clientName = [NSString stringWithFormat:@"%@ %@",dict[ACKeyClientFirstName],dict[ACKeyClientLastName]];
        
        unitName   = dict[ACKeyNameOfUnit];
        
        ACEAddress *add = [[ACEAddress alloc]initWithDictionary:dict[ACKeyAddress]];
        
        //address     = [NSString stringWithFormat:@"%@ ,%@ ,%@ ,%@",add.addressName, add.cityName,add.stateName,add.zipcode];
        
        address         = add.fullAddress       ;
        plan            = dict[ACKeyPlan]       ;
        notes           = dict[ACKeyNotes]      ;
        pictures        = dict[ACKeyPictures]   ;
        manuals         = dict[ACKeyManual]     ;
        serviceReports  = dict[ACKeyHistory]    ;
        arrPasrts       = dict[ACKeyUnitParts]  ;
        arrPartsInfo    = [[NSMutableArray alloc]init];
        
        NSArray *unitParts = dict[ACKeyUnitParts];
        
        [unitParts enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
        {
            ACEACPartInfo *info = [[ACEACPartInfo alloc]initWithDictionary:dict];
            
            [arrPartsInfo addObject:info];
        }];

    }
    return self;
}
-(instancetype)initWithListDictionary:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        unitId      = [dict[ACKeyID] stringValue];
        clientName  = dict[ACKeyClientName];
        isMatched   = [dict[ACKeyIsMatched]boolValue];
        serviceDate = dict[ACKeyServiceDate];
        serviceTime = dict[ACKeyServiceTime];
        unitName    = dict[ACKeyNameOfUnit];
        unitType    = dict[ACKeyUnitType];
        plan        = dict[ACKeyPlanType];
        
        ACEAddress *add = [[ACEAddress alloc]initWithDictionary:dict[ACKeyAddress]];
        
       // address     = [NSString stringWithFormat:@"%@ ,%@ ,%@ ,%@",add.addressName, add.cityName,add.stateName,add.zipcode];
        
        address         = add.fullAddress;
        //unitAge         = [dict[ACKeyUnitAge]intValue];
        arrModelSerial  = dict[ACKeyClientUnitParts];
    }
    return self;
}
@end
