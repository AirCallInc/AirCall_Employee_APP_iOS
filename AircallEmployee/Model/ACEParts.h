//
//  ACEParts.h
//  AircallEmployee
//
//  Created by ZWT111 on 28/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const PKeyId       ;
extern NSString *const PKeyName     ;
extern NSString *const PKeySize     ;
extern NSString *const PKeyPrice    ;
extern NSString *const PKeyQty      ;
extern NSString *const PKeyReportNo ;
extern NSString *const PKeyClientName;
extern NSString *const PKeyDate      ;
extern NSString *const PKeyParts     ;
extern NSString *const PKeyPartQuantity;
extern NSString *const PKeyPartTypeId  ;
extern NSString *const PKeyPartMasterId;

//requested part
extern NSString *const PKeyRequestDate     ;
extern NSString *const PKeyStatus          ;
extern NSString *const PKeyPartRequestId   ;
extern NSString *const PKeyPartRequestedQty;

extern NSString *const PKeyStatusNeedToOrder   ;
extern NSString *const PKeyStatusDiscontinued  ;
extern NSString *const PKeyStatusBackordered   ;
extern NSString *const PKeyStatusCancelled     ;
extern NSString *const PKeyStatusCompleted     ;

@interface ACEParts : NSObject

@property NSString *ID;
@property NSString *partName;
@property NSString *partSize;
@property NSString *partInfo;
@property NSString *partMasterId;
@property float    partPrice;
@property NSString *Qty;
@property NSString *clientName;
@property NSString *ReportNo;
@property NSString *Date;
@property NSArray *arrParts;
@property NSString *Status;
@property NSString *empRequestId;


-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(instancetype)initDictionaryWithSavedata:(NSDictionary *)dict;
-(instancetype)initDictioanryWithDate:(NSDictionary*)dict;
-(instancetype)initWithRequestedPartData:(NSDictionary *)dict;
-(void)encodeWithCoder:(NSCoder *)coder forPart:(ACEParts*)part;
-(instancetype)initWithCoder:(NSCoder *)coder;
-(NSDictionary *)toDictionary;

@end
