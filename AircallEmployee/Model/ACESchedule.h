//
//  ACESchedule.h
//  AircallEmployee
//
//  Created by ZWT112 on 5/6/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SCHKeyId            ;

extern NSString *const SCHKeyEmpId         ;
extern NSString *const SCHKeyAddressId     ;
extern NSString *const SCHKeyUnitsId       ;
extern NSString *const SCHKeyTimeSlot      ;
extern NSString *const SCHKeyMonth         ;
extern NSString *const SCHKeyDay           ;
extern NSString *const SCHKeyYear          ;

extern NSString *const SCHKeyStartTime     ;
extern NSString *const SCHKeyEndTime       ;

extern NSString *const SCHKeyScheduleDate  ;
extern NSString *const SCHKeyServices      ;

extern NSString *const SCHKeyClientFirstName;
extern NSString *const SCHKeyClientLastName ;
extern NSString *const SCHKeyClientAddress  ;

extern NSString *const SCHKeyPurpose       ;
extern NSString *const SCHKeyTimeSlot1     ;
extern NSString *const SCHKeyTimeSlot2     ;
extern NSString *const SCHKeyDestLongitude ;
extern NSString *const SCHKeyDestLattitude ;
extern NSString *const SCHKeyStatus        ;


@interface ACESchedule : NSObject

@property NSString * Id             ;
@property NSString *clientName      ;
@property NSString *clientAddress   ;
@property NSString *purpose         ;
@property NSString *startTime       ;
@property NSString *endTime         ;
@property NSString *destLongitude   ;
@property NSString *destLattitude   ;
@property NSString *status          ;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
