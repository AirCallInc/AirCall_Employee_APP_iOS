//
//  ACEACUnit.h
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AKeyUnits               ;
extern NSString *const ACKeyID                 ;

extern NSString *const ACKeyClientFirstName    ;
extern NSString *const ACKeyClientLastName     ;

extern NSString *const ACKeyNameOfUnit         ;
extern NSString *const ACKeyUnitParts          ;

extern NSString *const ACKeyAddress            ;
extern NSString *const ACKeyPlan               ;

extern NSString *const ACKeyNotes              ;

extern NSString *const ACKeyPictures           ;
extern NSString *const ACKeyPictureUrl         ;

extern NSString *const ACKeyHistory            ;
extern NSString *const ACKeyReportNumber       ;

extern NSString *const ACKeyManual             ;
extern NSString *const ACKeyManualName         ;
extern NSString *const ACKeyManualUrl          ;


// for sending data
extern NSString *const ACKeyOptionalInfo       ;
extern NSString *const ACKeySplitType          ;
extern NSString *const ACKeyQntyFilter         ;
extern NSString *const ACKeyQntyFuse           ;
extern NSString *const ACKeyLocationOfPart     ;
extern NSString *const ACKeyBoosterTypes       ;
extern NSString *const ACKeyFuseTypes          ;
extern NSString *const ACKeySizeOfFilter       ;
extern NSString *const ACKeyPaymentOption      ;
extern NSString *const ACKeyPaymentMethod      ;
extern NSString *const ACKeyPoNum              ;
extern NSString *const ACKeyQty                ;

// for listing
extern NSString *const ACKeyClientName         ;
extern NSString *const ACKeyIsMatched          ;
extern NSString *const ACKeyServiceDate        ;
extern NSString *const ACKeyServiceTime        ;
extern NSString *const ACKeyUnitType           ;
extern NSString *const ACKeyPlanType           ;
extern NSString *const ACKeyMfgDate            ;
extern NSString *const ACKeyClientUnitParts    ;
extern NSString *const ACKeyUnitAge            ;

@interface ACEACUnit : NSObject

@property NSString *clientName          ;
@property NSString *unitId              ;

@property NSString *serviceDate         ;
@property NSString *serviceTime         ;
@property NSString *unitType            ;

@property BOOL      isMatched           ;

@property int       unitAge             ;
@property NSString *address             ;
@property NSString *plan                ;
@property NSString *unitName            ;
@property NSString *notes               ;
@property NSArray  *pictures            ;
@property NSArray  *serviceReports      ;
@property NSArray  *manuals             ;

@property NSMutableArray *arrPartsInfo      ;
@property NSArray        *arrPasrts         ;
@property NSArray        *arrModelSerial    ;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

-(instancetype)initWithListDictionary:(NSDictionary *)dict;
@end
