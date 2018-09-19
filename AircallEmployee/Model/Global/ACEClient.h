//
//  ACEClient.h
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CKeyID;
extern NSString *const CKeyName;
extern NSString *const CKeyPhoneNumbers;
extern NSString *const CKeyACList;
extern NSString *const CKeyAc;
extern NSString *const CKeyAddress;
extern NSString *const CKeyNotes;
extern NSString *const CKeyEmail;

@interface ACEClient : NSObject

@property NSNumber        *ID;
@property NSString        *Name;
@property NSMutableArray  *PhoneNumbers;
@property NSMutableArray  *AcList;
@property NSMutableArray  *Ac;
@property NSMutableArray  *Address;
@property NSString        *email;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
