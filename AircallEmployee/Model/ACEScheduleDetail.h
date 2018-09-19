//
//  ACEScheduleDetail.h
//  AircallEmployee
//
//  Created by ZWT111 on 12/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>



extern NSString *const SDKeyID               ;
extern NSString *const SDKeyTimeAllotted     ;

extern NSString *const SDKeyUnitId            ;
extern NSString *const SDKeyUnitName          ;
extern NSString *const SDKeyServiceCompleted  ;

extern NSString *const SDKeyClientFirstName   ;
extern NSString *const SDKeyClientLastName    ;
extern NSString *const SDKeyClientId          ;
extern NSString *const SDKeyCompany           ;

extern NSString *const SDKeyScheduleStartTime ;
extern NSString *const SDKeyScheduleEndTime   ;

extern NSString *const SDKeyScheduleDate      ;

extern NSString *const SDKeyLattitude   ;
extern NSString *const SDKeyLongitude   ;

extern NSString *const SDKeyAddress         ;
extern NSString *const SDKeyMobileNum       ;
extern NSString *const SDKeyOfficeNum       ;
extern NSString *const SDKeyHomeNum         ;
extern NSString *const SDKeyEmail           ;
extern NSString *const SDKeyPurpose         ;
extern NSString *const SDKeyPurposeId       ;
extern NSString *const SDKeyContract        ;

extern NSString *const SDKeyServiceCaseNumber;
extern NSString *const SDKeyAccountNumber    ;

extern NSString *const SDKeyCustComplaints   ;
extern NSString *const SDKeyDispatcherNotes  ;
extern NSString *const SDKeyTechnicianNotes  ;

extern NSString *const SDKeyUnitList        ;
extern NSString *const SDKeyPartsList       ;

extern NSString *const SDKeyReportsList     ;

extern NSString *const SDKeyReportNumber    ;
extern NSString *const SDKeyReportDate      ;

extern NSString *const SDKeyStatus          ;

extern NSString *const SDKeyManualList      ;
extern NSString *const SDKeyManualName      ;
extern NSString *const SDKeyManualURL       ;

extern NSString *const SKeyFirstTimeSlot    ;
extern NSString *const SKeySecondTimeSlot   ;



@interface ACEScheduleDetail : NSObject

@property NSString *ID;
@property NSString *timeAllotted;
@property NSString *ClientId;
@property NSString *clientName;
@property NSString *company;

@property NSString *lattitude;
@property NSString *longitude;

@property ACEAddress *address;
@property NSString   *mobileNum;
@property NSString   *officeNum;
@property NSString   *homeNum;
@property NSString   *email;
@property NSString   *purpose;
@property NSString   *contract;

@property NSString *serviceCaseNum;
@property NSString *accountNum;

@property NSString *startTime   ;
@property NSString *EndTime     ;
@property NSString *scheduleDate    ;

@property NSString *custComplaints  ;
@property NSString *dispatcherNotes ;
@property NSString *technicianNotes ;

@property NSString *status          ;
@property NSInteger purposeId       ;

@property NSMutableArray  *unitList;

@property NSArray         *reportsList;
@property NSArray         *manualList;

-(instancetype )initWithDictionary:(NSDictionary *)dict;
@end
