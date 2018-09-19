//
//  ACEParts.m
//  AircallEmployee
//
//  Created by ZWT111 on 28/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEParts.h"

NSString *const PKeyId              =@"PartId"          ;
NSString *const PKeyName            =@"Name"            ;
NSString *const PKeySize            =@"Size"            ;
NSString *const PKeyPrice           =@"SellingPrice"    ;
NSString *const PKeyQty             =@"Quantity"        ;
NSString *const PKeyReportNo        =@"ServiceNumber"   ;
NSString *const PKeyClientName      =@"ClientName"      ;
NSString *const PKeyDate            = @"ServiceDate"    ;
NSString *const PKeyParts           = @"Parts"          ;
NSString *const PKeyPartQuantity    = @"PartQuantity"   ;
NSString *const PKeyPartTypeId      = @"PartTypeId"     ;
NSString *const PKeyPartMasterId    = @"DailyPartListMasterId";

NSString *const PKeyRequestDate         = @"RequestedDate"          ;
NSString *const PKeyStatus              = @"Status"                 ;
NSString *const PKeyPartRequestId       = @"EmployeePartRequestId"  ;
NSString *const PKeyPartRequestedQty    = @"RequestedQuantity"      ;

NSString *const PKeyStatusNeedToOrder   =@"Need to Order"   ;
NSString *const PKeyStatusDiscontinued  =@"Discontinued"    ;
NSString *const PKeyStatusBackordered   =@"Backordered"     ;
NSString *const PKeyStatusCancelled     =@"Cancelled"       ;
NSString *const PKeyStatusCompleted     =@"Completed"       ;


@implementation ACEParts
@synthesize ID,partName,partSize,partInfo,partPrice,Qty,ReportNo,clientName,Date,arrParts,Status,empRequestId,partMasterId;
-(void)awakeFromNib
{
    arrParts = [[NSArray alloc]init];
}
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        ID          = [dict[PKeyId] stringValue];
        partName    = dict[PKeyName];
        partSize    = dict[PKeySize];
        partPrice   = [dict[PKeyPrice] floatValue];
        partMasterId= dict[PKeyPartMasterId];
        //remove start
        //partPrice   = 20.00;
        //remove end
        partInfo    = @"";
        Qty         = [dict[PKeyPartQuantity] stringValue];
    }
    return self;
}
-(instancetype)initDictionaryWithSavedata:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        ID          = dict[PKeyId] ;
        partName    = dict[PKeyName];
        partSize    = dict[PKeySize];
        Qty         = dict[PKeyPartQuantity] ;
    }
    return self;
}
-(instancetype)initDictioanryWithDate:(NSDictionary*)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        ID          = [dict[PKeyId] stringValue];
        partName    = dict[SRKeyReqPartName];
        ReportNo    = dict[PKeyReportNo];
        clientName  = dict[PKeyClientName];
        Qty         = [dict[PKeyQty] stringValue];
        Date        = dict[PKeyDate];
        arrParts    = dict[PKeyParts];
    }
    return self;
}
-(instancetype)initWithRequestedPartData:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        ID              = [dict[PKeyId] stringValue];
        partName        = dict[SRKeyReqPartName];
        clientName      = dict[PKeyClientName];
        Qty             = [dict[PKeyQty] stringValue];
        Date            = dict[PKeyRequestDate];
        Status          = dict[PKeyStatus];
        empRequestId    = [dict[PKeyPartRequestId] stringValue];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)coder forPart:(ACEParts *)part
{
    [coder encodeObject:part.ID forKey:PKeyId];
    [coder encodeObject:part.partName forKey:PKeyName];
    [coder encodeObject:part.partSize forKey:PKeySize];
    [coder encodeFloat:part.partPrice forKey:PKeyPrice];
    [coder encodeObject:part.partMasterId forKey:PKeyPartMasterId];
    //[coder encodeObject:part.partInfo forKey:pkeypa]
    [coder encodeObject:part.Qty forKey:PKeyQty];
}
-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [[ACEParts alloc]init];
    if(self != nil)
    {
        ID       = [coder decodeObjectForKey:PKeyId];
        partName = [coder decodeObjectForKey:PKeyName];
        Qty      = [coder decodeObjectForKey:PKeyQty];
    }
    return self;
}
-(NSDictionary *)toDictionary
{
   return  @{
             PKeyId     : self.ID,
             PKeyName   : self.partName,
             PKeySize   : self.partSize,
             PKeyPartQuantity    : self.Qty == nil ?@"":self.Qty,
            };
}
@end
