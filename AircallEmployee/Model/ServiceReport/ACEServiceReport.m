//
//  ACEServiceReport.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEServiceReport.h"

NSString *const SRKeyID                 = @"ServiceId"      ;
NSString *const SRKeyServiceReportId    = @"ReportId"       ;

NSString *const SRKeyEmployeeId         =@"EmployeeId"      ;
NSString *const SRKeyIsWorkNoteDone     =@"IsWorkNotDone"   ;

NSString *const SRKeyStartReportLattitude =@"StartLatitude";
NSString *const SRKeyStartReportLongitude =@"StartLongitude";
NSString *const SRKeyEndReportLattitude   =@"EndLatitude";
NSString *const SRKeyEndReportLongitude   =@"EndLongitude";

NSString *const SRKeyUnitId            =@"Id"               ;
NSString *const SRKeyIsCompleted       =@"IsCompleted"      ;
NSString *const SRKeyServiceUnitParts  =@"ServiceUnitParts" ;
NSString *const SRKeyPartId            =@"PartId"           ;
NSString *const SRKeyPartQnty          =@"Qty"              ;
NSString *const SRKeyCompany           =@"Company"          ;
NSString *const SRKeyClientName        =@"ClientName"       ;
NSString *const SRKeyAccountNo         =@"AccountNo"        ;
NSString *const SRKeyPurpose           =@"purpose"          ;

NSString *const SRKeyBillingType       =@"BillingType"      ;
NSString *const SRKeyDate              =@"ReportDate"       ;
NSString *const SRKeyReportNo          =@"ReportNumber"     ;

NSString *const SRKeyStartedWork       =@"WorkStartedTime"  ;
NSString *const SRKeyCompletedWork     =@"WorkCompletedTime";

NSString *const SRKeyAssignedStartTime =@"ScheduleStartTime";
NSString *const SRKeyAsisgnedEndTime   =@"ScheduleEndTime"  ;

NSString *const SRKeyExtraTime         =@"ExtraTime"        ;
NSString *const SRKeyIsDiffrentTime    =@"IsDifferentTime"  ;
NSString *const SRKeyTotalAssignedTime =@"AssignedTotalTime";

NSString *const SRKeyUnitList          =@"Units"            ;
NSString *const SRKeyRequestedPart     =@"RequestedParts"   ;
NSString *const SRKeyMaterialList      =@"material_list"    ;
NSString *const SRKeyPictures          =@"Images"           ;

NSString *const SRKeyRecomm            =@"Recommendationsforcustomer"   ;
NSString *const SRKeyEmpNotes          =@"EmployeeNotes"                ;
NSString *const SRKeyWorkPerformed     =@"WorkPerformed"                ;

NSString *const SRKeyEmail             =@"EmailToClient"    ;
NSString *const SRKeyCCEmail           =@"CCEmail"          ;

NSString *const SRKeySignature         =@"ClientSignature"  ;

NSString *const SRKeySelectedPart      =@"SelectedPart"     ;
NSString *const SRKeyUnitArray         =@"UnitArray"        ;
NSString *const SRKeyReqPartNotes      =@"EmpNotes"         ;

NSString *const SRKeyReqUnitId         =@"UnitId"           ;
NSString *const SRKeyReqPartId         =@"PartId"           ;
NSString *const SRKeyReqPartQnty       =@"Quantity"         ;
NSString *const SRKeyReqPartName       =@"PartName"         ;
NSString *const SRKeyReqPartSize       =@"PartSize"         ;
NSString *const SRKeyReqPartDes        =@"Description"      ;

//for listing of service report

NSString *const SRKeyClientFirstName  =@"FirstName"         ;
NSString *const SRKeyClientLastName   =@"LastName"          ;
NSString *const SRKeyReportId         =@"Id"                ;
NSString *const SRKeyMobileNumber     =@"MobileNumber"      ;
NSString *const SRKeyPhoneNumber      =@"PhoneNumber"       ;
NSString *const SRKeyOfficeNumber     =@"OfficeNumber"      ;
NSString *const SRKeyPurposeOfVisit   =@"PurposeOfVisit"    ;
NSString *const SRKeyReportDate       =@"ReportDateTime"    ;
NSString *const SRKeyReportNumber     =@"ServiceReportNumber";

@implementation ACEServiceReport

@synthesize ID,ClientName,Purpose,BillingType,date,StartedWork,CompletedWork,UnitList,WorkPerformed,MaterialList,Pictures,Recomm,Email,SignatureUrl,reportNumber,clientPhoneNum,clientMobileNum,clientOfficeNum,CCEmail,empNotes,isWorkNotedone,RequestedPart,AccountNo,assignEndTime,assignStartTime,extraTime,isDifferent,totalAssignTime,Company;

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (dict.count == 0)
    {
        return nil;
    }
    
    if(self = [super init])
    {
        ID              = dict[SRKeyReportId]       ;
        ClientName      = dict[SRKeyClientName]     ;
        reportNumber    = dict[SRKeyReportNumber]   ;
        clientMobileNum = dict[SRKeyMobileNumber]   ;
        clientOfficeNum = dict[SRKeyOfficeNumber]   ;
        clientPhoneNum  = dict[SRKeyPhoneNumber]    ;
        Purpose         = dict[SRKeyPurposeOfVisit] ;
        date            = dict[SRKeyReportDate]     ;
        
       // BillingType     = dict[SRKeyBillingType];
//        //date            = dict[SRDate];
//        StartedWork     = dict[SRKeyStartedWork];
//        CompletedWork   = dict[SRKeyCompletedWork];
//        UnitList        = dict[SRKeyUnitList];
//        WorkPerformed   = dict[SRKeyWorkPerformed];
//        MaterialList    = dict[SRKeyMaterialList];
//        Pictures        = dict[SRKeyPictures];
//        Recomm          = dict[SRKeyRecomm];
//        Email           = dict[SRKeyEmail];
//        SignatureUrl    = [NSURL URLWithString:dict[SRKeySignature]];
    }
    return self;
}
-(instancetype)initWithDetailDictionary:(NSDictionary *)dict
{
    if (dict.count == 0)
    {
        return nil;
    }
    
    if(self = [super init])
    {
        //ID              = dict[SRKeyReportId];
        ClientName      = dict[SRKeyClientName] ;
        AccountNo       = dict[SRKeyAccountNo]  ;
        
        BillingType     = [dict[SRKeyBillingType] isEqualToString:@""]?@"No Billing Type":dict[SRKeyBillingType];
        
        CCEmail         = dict[SRKeyCCEmail];
        Company         = dict[SRKeyCompany];
        
        if(![dict[SRKeySignature] isKindOfClass:[NSNull class]])
        {
            SignatureUrl    = [NSURL URLWithString:dict[SRKeySignature]];
        }
        
        Email           = dict[SRKeyEmail][0]   ;
        empNotes        = dict[SRKeyEmpNotes]   ;

        NSArray *arr   = dict[SRKeyPictures]    ;
        Pictures       = [[NSMutableArray alloc]init];
        
        [arr enumerateObjectsUsingBlock:^(NSString *  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop)
        {
            NSURL *url = [NSURL URLWithString:str];
            [Pictures addObject:url];
        }];
        
        isWorkNotedone  = [dict[SRKeyIsWorkNoteDone] boolValue] ;
        Purpose         = dict[SRKeyPurposeOfVisit]             ;
        Recomm          = dict[SRKeyRecomm]                     ;
        date            = dict[SRKeyDate]                       ;
        reportNumber    = dict[SRKeyReportNo]                   ;
        RequestedPart   = dict[SRKeyRequestedPart]              ;
        StartedWork     = dict[SRKeyStartedWork]                ;
        CompletedWork   = dict[SRKeyCompletedWork]              ;
        assignStartTime = dict[SRKeyAssignedStartTime]          ;
        assignEndTime   = dict[SRKeyAsisgnedEndTime]            ;
        extraTime       = dict[SRKeyExtraTime]                  ;
        totalAssignTime = dict[SRKeyTotalAssignedTime]          ;
        isDifferent     = [dict[SRKeyIsDiffrentTime]boolValue]  ;
        UnitList        = dict[SRKeyUnitList]                   ;
        WorkPerformed   = dict[SRKeyWorkPerformed]              ;
     // MaterialList    = dict[SRKeyMaterialList];
       
    }
    return self;
}
@end
