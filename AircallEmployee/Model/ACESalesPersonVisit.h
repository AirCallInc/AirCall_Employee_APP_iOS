//
//  ACESalesPersonVisit.h
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SPKeyID          ;
extern NSString *const SPKeyClientName  ;
extern NSString *const SPKeyDate        ;

extern NSString *const SPRequestId      ;

// for sales person request detail
extern NSString *const SPKeyAddress     ;
extern NSString *const SPKeyFirstName   ;
extern NSString *const SPKeyLastName    ;
extern NSString *const SPKeyLattitude   ;
extern NSString *const SPKeyLongitude   ;
extern NSString *const SPKeyMobileNumber;
extern NSString *const SPKeyPhoneNumber ;
extern NSString *const SPKeyOfficeNumber;
extern NSString *const SPKeyEmail       ;
extern NSString *const SPKeyNotes       ;


@interface ACESalesPersonVisit : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *clientName;
@property (strong, nonatomic) NSString *date;

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *lattitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *officeNumber;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *notes;


-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDetailDictionary:(NSDictionary *)dict;

@end
