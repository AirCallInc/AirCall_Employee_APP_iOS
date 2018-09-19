//
//  ACEOrder.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEOrder.h"

NSString *const OKeyID             = @"OrderId";
NSString *const OKeyClientId       = @"ClientId" ;
NSString *const OKeyClientName     = @"ClientName";
NSString *const OKeyChargeBy       = @"ChargeBy";
NSString *const OKeyDate           = @"OrderDate";
NSString *const OKeyTime           = @"";
NSString *const OKeyPrice          = @"OrderAmount";
NSString *const OKeyOrderNo        = @"OrderNumber";
NSString *const OKeyWorkOrder      = @"";
NSString *const OKeyAddress        = @"Address";
NSString *const OKeyState          = @"State";
NSString *const OKeyCity           = @"City";
NSString *const OKeyZip            = @"ZipCode";
NSString *const OKeyEmail          = @"Email";
NSString *const OKeyCCEmail        = @"CCEmail" ;
NSString *const OKeyIteamList      = @"OrderItems";
NSString *const OKeyTotalAmt       = @"Total";
NSString *const OKeyRecomm         = @"Recommendation";
NSString *const OKeyEmailToClient  = @"EmailToClientEmail" ;
NSString *const OKeySignature      = @"ClientSignature";


@implementation ACEOrder
@synthesize Id,ClientName,ChargeBy,OrderDate,Price,WorkOrder,Address,State,City,Zip,Email,IteamList,TotalPrice,Recomm,Signature,time,orderNo,OrderTime,CCEmail;

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        Id              = [dict[OKeyID] stringValue];
        orderNo         = dict[OKeyOrderNo];
        ClientName      = dict[OKeyClientName];
        ChargeBy        = dict[OKeyChargeBy];
        OrderDate       = dict[OKeyDate];
       // OrderTime       = dict[OKeyTime];
        Price           = [dict[OKeyPrice]floatValue];
    }
    return self;
}
-(instancetype)initWithDetailDictionary:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        Id              = [dict[OKeyID] stringValue];
        orderNo         = dict[OKeyOrderNo];
        ClientName      = dict[OKeyClientName];
        ChargeBy        = dict[OKeyChargeBy];
        OrderDate       = dict[OKeyDate];
        Address         = dict[OKeyAddress];
        City            = dict[OKeyCity];
        State           = dict[OKeyState];
        Zip             = dict[OKeyZip];
        Email           = dict[OKeyEmail];
        CCEmail         = dict[OKeyCCEmail];
        // OrderTime       = dict[OKeyTime];
        
        TotalPrice      = [dict[OKeyPrice]floatValue];
        IteamList       = [[NSMutableArray alloc]init];
        Recomm          = dict[OKeyRecomm];
        
        if(![dict[OKeySignature] isEqualToString:@""])
        {
            Signature = [NSURL URLWithString:dict[OKeySignature]];
        }
        
        NSArray *arr    = dict[OKeyIteamList];
        
        [arr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
        {
            ACEOrderIteam *iteam = [[ACEOrderIteam alloc]initWithDictionary:dict];
            [IteamList addObject:iteam];
            
        }];
        
    }
    return self;

}
@end
