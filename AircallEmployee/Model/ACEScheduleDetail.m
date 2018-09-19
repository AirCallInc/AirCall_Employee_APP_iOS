//
//  ACEScheduleDetail.m
//  AircallEmployee
//
//  Created by ZWT111 on 12/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEScheduleDetail.h"

NSString *const SDKeyID             = @"Id"             ;
NSString *const SDKeyTimeAllotted   = @"TimeAlloted"    ;

NSString *const SDKeyUnitId         = @"Id"             ;
NSString *const SDKeyUnitName       = @"UnitName"       ;
NSString *const SDKeyServiceCompleted = @"ServiceCompleted";

NSString *const SDKeyClientFirstName  =@"FirstName"  ;
NSString *const SDKeyClientLastName   =@"LastName"   ;
NSString *const SDKeyClientId         =@"ClientId"   ;
NSString *const SDKeyCompany          =@"Company"    ;

NSString *const SDKeyScheduleStartTime = @"ScheduleStartTime"   ;
NSString *const SDKeyScheduleEndTime   = @"ScheduleEndTime"     ;

NSString *const SDKeyScheduleDate      = @"ScheduleDate"    ;
NSString *const SDKeyLattitude         = @"Latitude"        ;
NSString *const SDKeyLongitude         = @"Longitude"       ;

NSString *const SDKeyAddress        = @"Address"            ;
NSString *const SDKeyMobileNum      = @"MobileNumber"       ;
NSString *const SDKeyOfficeNum      = @"OfficeNumber"       ;
NSString *const SDKeyHomeNum        = @"HomeNumber"         ;
NSString *const SDKeyEmail          = @"Email"              ;
NSString *const SDKeyPurpose        = @"PurposeOfVisit"     ;
NSString *const SDKeyPurposeId      = @"PurposeOfVisitId"   ;
NSString *const SDKeyContract       = @"FixedContractName"  ;

NSString *const SDKeyServiceCaseNumber =@"ServiceCaseNumber";
NSString *const SDKeyAccountNumber     =@"AccountNumber"    ;

NSString *const SDKeyCustComplaints   = @"CustomerComplaints" ;
NSString *const SDKeyDispatcherNotes  = @"DispatcherNotes"    ;
NSString *const SDKeyTechnicianNotes  = @"TechnicianNotes"    ;

NSString *const SDKeyUnitList       = @"ServiceUnits"   ;
NSString *const SDKeyPartsList      = @"DailyPartList"  ;
NSString *const SDKeyReportsList    = @"ServiceReports" ;

NSString *const SDKeyReportNumber   = @"ServiceReportNumber" ;
NSString *const SDKeyReportDate     = @"ReportDate"          ;

NSString *const SDKeyStatus         = @"Status" ;

NSString *const SDKeyManualList     = @"UnitManuals"    ;
NSString *const SDKeyManualName     = @"ManualName"     ;
NSString *const SDKeyManualURL      = @"ManualURL"      ;

NSString *const SKeyFirstTimeSlot   = @"ServiceSlot1";
NSString *const SKeySecondTimeSlot  = @"ServiceSlot2";

@implementation ACEScheduleDetail

@synthesize ID,timeAllotted,clientName,company,address,mobileNum,officeNum,homeNum,email,purpose,contract,custComplaints,dispatcherNotes,technicianNotes,unitList,reportsList,manualList,startTime,EndTime,serviceCaseNum,accountNum,lattitude,longitude,ClientId,scheduleDate,status,purposeId;

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        ID              = [dict[SDKeyID]stringValue];
        timeAllotted    = dict[SDKeyTimeAllotted];
        clientName      = [NSString stringWithFormat:@"%@ %@",
        dict[SDKeyClientFirstName],dict[SDKeyClientLastName]];
        
        company         = dict[SDKeyCompany];
        startTime       = dict[SDKeyScheduleStartTime];
        EndTime         = dict[SDKeyScheduleEndTime];
        ClientId        = dict[SDKeyClientId];
        scheduleDate    = dict[SDKeyScheduleDate];
        
        if(![dict[SDKeyLattitude] isKindOfClass:[NSNull class]])
        {
            lattitude       = [dict[SDKeyLattitude]stringValue];
        }
        if(![dict[SDKeyLongitude] isKindOfClass:[NSNull class]])
        {
            longitude       = [dict[SDKeyLongitude] stringValue];
        }
        
        //address         = dict[SDKeyAddress];
        address         = [[ACEAddress alloc]initWithShortDictionary:
                           dict[SDKeyAddress]];
        
        mobileNum       = dict[SDKeyMobileNum];
        officeNum       = dict[SDKeyOfficeNum];
        homeNum         = dict[SDKeyHomeNum];
        email           = dict[SDKeyEmail];
        purpose         = dict[SDKeyPurpose];
        purposeId       = [dict[SDKeyPurposeId]integerValue];
        contract        = [dict[SDKeyContract]isEqualToString:@""]?@"No fixed contract":dict[SDKeyContract];
        
        serviceCaseNum  = dict[SDKeyServiceCaseNumber];
        accountNum      = dict[SDKeyAccountNumber];
        
        custComplaints  = dict[SDKeyCustComplaints];
        dispatcherNotes = dict[SDKeyDispatcherNotes];
        technicianNotes = dict[SDKeyTechnicianNotes];
        
        NSArray *unitlist = dict[SDKeyUnitList];
        
        unitList            = [[NSMutableArray alloc]init];
        
        [unitlist enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull unitInfo, NSUInteger idx, BOOL * _Nonnull stop)
         {
             
             NSArray * arrpart = unitInfo[SDKeyPartsList];
             NSMutableArray *arrParts = [[NSMutableArray alloc]init];
             
             for (NSDictionary *dict in arrpart)
             {
                 ACEParts *part = [[ACEParts alloc]initWithDictionary:dict];
                 [arrParts addObject:part];
             }
             
             NSDictionary *dict = @{
                                    SDKeyUnitId : [unitInfo[SDKeyUnitId] stringValue],
                                    SDKeyUnitName : unitInfo[SDKeyUnitName],
                                    SDKeyPartsList : arrParts
                                    };
             
             [unitList addObject:dict];
             
         }];

       // unitList        = dict[SDKeyUnitList];
        //partsList       = dict[SDKeyPartsList];
        reportsList     = dict[SDKeyReportsList];
        manualList      = dict[SDKeyManualList];
        status          = dict[SDKeyStatus];
    
    }
    return self;
}
@end
