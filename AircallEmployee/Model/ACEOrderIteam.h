//
//  ACEOrderIteam.h
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const OIKeyID          ;
extern NSString *const OIKeyName        ;
extern NSString *const OIKeySize        ;
extern NSString *const OIKeyPrice       ;
extern NSString *const OIKeyIteamQty    ;

extern NSString *const OIKeyQunty   ;
extern NSString *const OIKeyPart    ;

@interface ACEOrderIteam : NSObject

@property NSNumber *Id          ;
@property NSString *PartName    ;
@property NSString *PartSize    ;
@property float     PartPrice   ;
@property int       PartQnty    ;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
