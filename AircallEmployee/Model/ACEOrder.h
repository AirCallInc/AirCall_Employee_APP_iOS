//
//  ACEOrder.h
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const OKeyID              ;
extern NSString *const OKeyClientId        ;
extern NSString *const OKeyClientName      ;
extern NSString *const OKeyChargeBy        ;
extern NSString *const OKeyDate            ;
extern NSString *const OKeyTime            ;
extern NSString *const OKeyPrice           ;
extern NSString *const OKeyOrderNo         ;
extern NSString *const OKeyWorkOrder       ;
extern NSString *const OKeyAddress         ;
extern NSString *const OKeyState           ;
extern NSString *const OKeyCity            ;
extern NSString *const OKeyCCEmail         ;
extern NSString *const OKeyZip             ;
extern NSString *const OKeyEmail           ;
extern NSString *const OKeyIteamList       ;
extern NSString *const OKeyTotalAmt        ;
extern NSString *const OKeyRecomm          ;
extern NSString *const OKeyEmailToClient   ;
extern NSString *const OKeySignature       ;

@interface ACEOrder : NSObject

@property (strong, nonatomic) NSString *Id          ;
@property (strong, nonatomic) NSString *ClientName  ;
@property (strong, nonatomic) NSString *ChargeBy    ;
@property (strong, nonatomic) NSString *OrderDate   ;
@property (strong, nonatomic) NSString *OrderTime   ;
@property (strong, nonatomic) NSString *WorkOrder   ;
@property (strong, nonatomic) NSString *Address     ;
@property (strong, nonatomic) NSString *State       ;
@property (strong, nonatomic) NSString *City        ;
@property (strong, nonatomic) NSString *Zip         ;
@property (strong, nonatomic) NSString *Email       ;
@property (strong, nonatomic) NSString *CCEmail     ;
@property (strong, nonatomic) NSMutableArray  *IteamList   ;
@property (strong, nonatomic) NSString *Recomm      ;
@property (strong, nonatomic) NSURL    *Signature   ;

@property (nonatomic) float Price;
@property (nonatomic) float TotalPrice;
@property (nonatomic) NSString *time;
@property (strong,nonatomic) NSString *orderNo;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDetailDictionary:(NSDictionary *)dict;
@end
