//
//  ACEOrderIteam.m
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEOrderIteam.h"
NSString *const OIKeyID         = @"iteam_key";
// used in order detail
NSString *const OIKeyName       = @"PartName"   ;
NSString *const OIKeyPrice      = @"Amount"     ;
NSString *const OIKeySize       = @"PartSize"   ;
NSString *const OIKeyIteamQty   = @"Quantity"   ;

NSString *const OIKeyQunty      = @"Qnty"; //used in add order
NSString *const OIKeyPart       = @"Part"; //used

@implementation ACEOrderIteam

@synthesize Id,PartName,PartQnty,PartSize,PartPrice;

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        //Id = @([[NSString stringWithFormat:@"%@",dict[OIKeyID]]integerValue]);
        
        PartName    = dict[OIKeyName];
        PartSize    = dict[OIKeySize];
        
        PartPrice = [dict[OIKeyPrice]floatValue];
        PartQnty  = [dict[OIKeyIteamQty]intValue];
    }
    return self;
}
@end
