//
//  ACEServiceReport.h
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SRKeyID                    ;
extern NSString *const SRKeyServiceReportId       ;

extern NSString *const SRKeyEmployeeId     ;
extern NSString *const SRKeyIsWorkNoteDone ;

extern NSString *const SRKeyStartReportLattitude ;
extern NSString *const SRKeyStartReportLongitude ;
extern NSString *const SRKeyEndReportLattitude   ;
extern NSString *const SRKeyEndReportLongitude   ;

extern NSString *const SRKeyUnitId              ;
extern NSString *const SRKeyIsCompleted         ;
extern NSString *const SRKeyServiceUnitParts    ;
extern NSString *const SRKeyPartId              ;
extern NSString *const SRKeyPartQnty            ;

extern NSString *const SRKeyClientName     ;
extern NSString *const SRKeyCompany        ;
extern NSString *const SRKeyAccountNo      ;
extern NSString *const SRKeyPurpose        ;
extern NSString *const SRKeyBillingType    ;
extern NSString *const SRKeyDate           ;
extern NSString *const SRKeyReportNo       ;
extern NSString *const SRKeyStartedWork    ;
extern NSString *const SRKeyCompletedWork  ;

extern NSString *const SRKeyAssignedStartTime ;
extern NSString *const SRKeyAsisgnedEndTime   ;
extern NSString *const SRKeyExtraTime         ;
extern NSString *const SRKeyIsDiffrentTime    ;
extern NSString *const SRKeyTotalAssignedTime ;

extern NSString *const SRKeyUnitList       ;
extern NSString *const SRKeyRequestedPart  ;
extern NSString *const SRKeyMaterialList   ;
extern NSString *const SRKeyPictures       ;

extern NSString *const SRKeyWorkPerformed  ;
extern NSString *const SRKeyRecomm         ;
extern NSString *const SRKeyEmpNotes       ;

extern NSString *const SRKeyEmail          ;
extern NSString *const SRKeyCCEmail        ;
extern NSString *const SRKeySignature      ;

//for sending requestedPart Data
extern NSString *const SRKeySelectedPart    ;
extern NSString *const SRKeyUnitArray       ;
extern NSString *const SRKeyReqPartNotes    ;

extern NSString *const SRKeyReqUnitId       ;
extern NSString *const SRKeyReqPartId       ;
extern NSString *const SRKeyReqPartQnty     ;
extern NSString *const SRKeyReqPartName     ;
extern NSString *const SRKeyReqPartSize     ;
extern NSString *const SRKeyReqPartDes      ;

//for listing of service report

extern NSString *const SRKeyClientFirstName  ;
extern NSString *const SRKeyClientLastName   ;
extern NSString *const SRKeyReportId         ;
extern NSString *const SRKeyMobileNumber     ;
extern NSString *const SRKeyPhoneNumber      ;
extern NSString *const SRKeyOfficeNumber     ;
extern NSString *const SRKeyPurposeOfVisit   ;
extern NSString *const SRKeyReportDate       ;
extern NSString *const SRKeyReportNumber     ;

@interface ACEServiceReport : NSObject

@property (strong, nonatomic) NSString *ID              ;
@property (strong, nonatomic) NSString *ClientName      ;
@property (strong, nonatomic) NSString *Company         ;
@property (strong, nonatomic) NSString *AccountNo       ;
@property (strong, nonatomic) NSString *Purpose         ;
@property (strong, nonatomic) NSString *date            ;
@property (strong, nonatomic) NSString *reportNumber    ;
@property (strong, nonatomic) NSString *clientMobileNum ;
@property (strong, nonatomic) NSString *clientPhoneNum  ;
@property (strong, nonatomic) NSString *clientOfficeNum ;

@property (strong, nonatomic) NSString *BillingType     ;
@property (strong, nonatomic) NSString *StartedWork     ;
@property (strong, nonatomic) NSString *CompletedWork   ;
@property (strong, nonatomic) NSString *assignStartTime ;
@property (strong, nonatomic) NSString *assignEndTime   ;
@property (strong, nonatomic) NSString *extraTime       ;
@property (strong, nonatomic) NSString *totalAssignTime ;


@property  BOOL      isDifferent     ;

@property (strong, nonatomic) NSArray         *UnitList         ;
@property (strong, nonatomic) NSMutableArray  *Pictures         ;
@property (strong, nonatomic) NSArray         *MaterialList     ;
@property (strong, nonatomic) NSArray         *RequestedPart    ;

@property (strong, nonatomic) NSString *WorkPerformed   ;
@property (strong, nonatomic) NSString *Recomm          ;
@property (strong, nonatomic) NSString *empNotes        ;
@property (strong, nonatomic) NSString *Email           ;
@property (strong, nonatomic) NSString *CCEmail         ;
@property (strong, nonatomic) NSURL    *SignatureUrl    ;

@property  BOOL      isWorkNotedone  ;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

-(instancetype)initWithDetailDictionary:(NSDictionary *)dict;

@end
