//
//  ACEACPartInfo.h
//  AircallEmployee
//
//  Created by ZWT111 on 30/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ACKeyTypeOfUnit         ;
extern NSString *const ACKeyMbrand             ;
extern NSString *const ACKeyMnumber            ;
extern NSString *const ACKeyMdate              ;
extern NSString *const ACKeyUnitTon            ;
extern NSString *const ACKeySerialNumber       ;
extern NSString *const ACKeyBooster            ;
extern NSString *const ACKeyBoosterId          ;

extern NSString *const ACKeyTypeFreeon         ;
extern NSString *const ACKeyCapacityFreeon     ;

extern NSString *const ACKeyRefrigerantType    ;//1
extern NSString *const ACKeyRefrigerantCharge  ;
extern NSString *const ACKeyEleService         ;//2
extern NSString *const ACKeyMaxBreaker         ;//3
extern NSString *const ACKeyBreaker            ;//4
extern NSString *const ACKeyCompressor         ;//5
extern NSString *const ACKeyCapacitor          ;//6
extern NSString *const ACKeyContractor         ;//7
extern NSString *const ACKeyFilterDryer        ;//8
extern NSString *const ACKeyDfrostBoard        ;//9
extern NSString *const ACKeyRelay              ;//10
extern NSString *const ACKeyTXVvalve           ;//11
extern NSString *const ACKeyReversingValve     ;//12
extern NSString *const ACKeyBlowerMotor        ;//13
extern NSString *const ACKeyCondensingMotor    ;//14
extern NSString *const ACKeyInducerMotor       ;//15
extern NSString *const ACKeyTransformer        ;//16
extern NSString *const ACKeyControlBoard       ;//17
extern NSString *const ACKeyLimitSwitch        ;//18
extern NSString *const ACKeyIgnitor            ;//19
extern NSString *const ACKeyGasvalve           ;//20
extern NSString *const ACKeyPressureSwitch     ;//21
extern NSString *const ACKeyFlameSensor        ;//22
extern NSString *const ACKeyRollSensor         ;//23
extern NSString *const ACKeyDoorSwitch         ;//24
extern NSString *const ACKeyIgnitionCntrlBoard ;//25
extern NSString *const ACKeyCoilCleaner        ;//26
extern NSString *const ACKeyMisc               ;//27


//Keys for IDs of Parts
extern NSString *const ACKeyRefrigerantTypeID    ;//1
extern NSString *const ACKeyRefrigerantChargeID  ;
extern NSString *const ACKeyBreakerID            ;//4
extern NSString *const ACKeyCompressorID         ;//5
extern NSString *const ACKeyCapacitorID          ;//6
extern NSString *const ACKeyContractorID         ;//7
extern NSString *const ACKeyFilterDryerID        ;//8
extern NSString *const ACKeyDfrostBoardID        ;//9
extern NSString *const ACKeyRelayID              ;//10
extern NSString *const ACKeyTXVvalveID           ;//11
extern NSString *const ACKeyReversingValveID     ;//12
extern NSString *const ACKeyBlowerMotorID        ;//13
extern NSString *const ACKeyCondensingMotorID    ;//14
extern NSString *const ACKeyInducerMotorID       ;//15
extern NSString *const ACKeyTransformerID        ;//16
extern NSString *const ACKeyControlBoardID       ;//17
extern NSString *const ACKeyLimitSwitchID        ;//18
extern NSString *const ACKeyIgnitorID            ;//19
extern NSString *const ACKeyGasvalveID           ;//20
extern NSString *const ACKeyPressureSwitchID     ;//21
extern NSString *const ACKeyFlameSensorID        ;//22
extern NSString *const ACKeyRollSensorID         ;//23
extern NSString *const ACKeyDoorSwitchID         ;//24
extern NSString *const ACKeyIgnitionCntrlBoardID ;//25
extern NSString *const ACKeyCoilCleanerID        ;//26
extern NSString *const ACKeyMiscID               ;//27

extern NSString *const ACKeyFuses              ;
extern NSString *const ACKeyQntFuses           ;
extern NSString *const ACKeyFuseType           ;

extern NSString *const ACKeyFilter             ;
extern NSString *const ACKeyQntFilter          ;
extern NSString *const ACKeyFilterSize         ;
extern NSString *const ACKeyLocOfFilter        ;

extern NSString *const ACKeyInsideEquipment    ;
extern NSString *const ACKeyInsideSpace        ;

extern NSString *const ACKeyIsOlder            ;

@interface ACEACPartInfo : NSObject

@property NSString *modelNumber         ;
@property NSString *serialNumber        ;
@property NSString *typeofunit          ;
@property NSString *manuBrand           ;
@property NSString *manuDate            ;
@property NSString *unitTon             ;
@property NSString *booster             ;
@property NSString *boosterId           ;
@property NSString *refriType           ;
@property NSString *compressor          ;
@property NSString *capacitor           ;
@property NSString *contractor          ;
@property NSString *filterdryer         ;
@property NSString *defrostboard        ;
@property NSString *relay               ;
@property NSString *txvvalve            ;
@property NSString *reversingvalve      ;
@property NSString *blowermotor         ;
@property NSString *condansingFanMotor  ;
@property NSString *inducerDraftMotor   ;
@property NSString *transformer         ;
@property NSString *controlboard        ;
@property NSString *limitSwitch         ;
@property NSString *ignitor             ;
@property NSString *gasValve            ;
@property NSString *electricalService   ;
@property NSString *maxBreaker          ;
@property NSString *breaker             ;
@property NSString *pressureSwitch      ;
@property NSString *flameSensor         ;
@property NSString *rolloutsensor       ;
@property NSString *doorswitch          ;
@property NSString *ignitioncontrolBoard  ;
@property NSString *coilCleaner         ;
@property NSString *misc                ;


//ID of Parts
@property NSString *refriTypeID           ;
@property NSString *compressorID          ;
@property NSString *capacitorID           ;
@property NSString *contractorID          ;
@property NSString *filterdryerID         ;
@property NSString *defrostboardID        ;
@property NSString *relayID               ;
@property NSString *txvvalveID            ;
@property NSString *reversingvalveID      ;
@property NSString *blowermotorID         ;
@property NSString *condansingFanMotorID  ;
@property NSString *inducerDraftMotorID   ;
@property NSString *transformerID         ;
@property NSString *controlboardID        ;
@property NSString *limitSwitchID         ;
@property NSString *ignitorID             ;
@property NSString *gasValveID            ;
@property NSString *breakerID             ;
@property NSString *pressureSwitchID      ;
@property NSString *flameSensorID         ;
@property NSString *rolloutsensorID       ;
@property NSString *doorswitchID          ;
@property NSString *ignitioncontrolBoardID  ;
@property NSString *coilCleanerID         ;
@property NSString *miscID                ;

@property int filterQnty                  ;
@property NSArray *arrFilter              ;
@property int fuseQnty                    ;
@property NSArray *arrFuse                ;

@property NSArray *arrPictures            ;
@property NSArray *arrManuals             ;
@property bool     isUnitOld              ;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
