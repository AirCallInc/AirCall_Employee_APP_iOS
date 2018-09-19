//
//  ACEACPartInfo.m
//  AircallEmployee
//
//  Created by ZWT111 on 30/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEACPartInfo.h"

NSString *const ACKeyUnitTon                   = @"UnitTon";
NSString *const ACKeyTypeOfUnit                = @"UnitType";
NSString *const ACKeyMbrand                    = @"ManufactureBrand";
NSString *const ACKeyMnumber                   = @"ModelNumber";
NSString *const ACKeyMdate                     = @"ManufactureDate";
NSString *const ACKeySerialNumber              = @"SerialNumber";
NSString *const ACKeyBooster                   = @"Thermostat";
NSString *const ACKeyBoosterId                 = @"ThermostatId";
NSString *const ACKeyTypeFreeon                = @"";
NSString *const ACKeyCapacityFreeon            = @"";

NSString *const ACKeyFilter                    = @"Filters";
NSString *const ACKeyQntFilter                 = @"FilterQty";
NSString *const ACKeyFilterSize                = @"FilterSize";
NSString *const ACKeyLocOfFilter               = @"FilterLocation";

NSString *const ACKeyInsideEquipment           = @"Inside Equipment";
NSString *const ACKeyInsideSpace               = @"Inside Space";
//RefrigerantType
NSString *const ACKeyRefrigerantType           = @"Refrigerant";

NSString *const ACKeyRefrigerantCharge         = @"";

NSString *const ACKeyEleService                = @"ElectricalService";
NSString *const ACKeyMaxBreaker                = @"MaxBreaker";
NSString *const ACKeyBreaker                   = @"Breaker";//4
NSString *const ACKeyCompressor                = @"Compressor";
NSString *const ACKeyCapacitor                 = @"Capacitor";
NSString *const ACKeyContractor                = @"Contactor";
NSString *const ACKeyFilterDryer               = @"Filterdryer";
NSString *const ACKeyDfrostBoard               = @"Defrostboard";
NSString *const ACKeyRelay                     = @"Relay";
NSString *const ACKeyTXVvalve                  = @"TXVValve";
NSString *const ACKeyReversingValve            = @"ReversingValve";

NSString *const ACKeyFuses                     = @"Fuses";
NSString *const ACKeyQntFuses                  = @"FusesQty";
NSString *const ACKeyFuseType                  = @"FuseType";

NSString *const ACKeyBlowerMotor               = @"BlowerMotor";
NSString *const ACKeyCondensingMotor           = @"Condensingfanmotor";
NSString *const ACKeyInducerMotor              = @"Inducerdraftmotor";
NSString *const ACKeyTransformer               = @"Transformer";
NSString *const ACKeyControlBoard              = @"Controlboard";
NSString *const ACKeyLimitSwitch               = @"Limitswitch";
NSString *const ACKeyIgnitor                   = @"Ignitor";
NSString *const ACKeyGasvalve                  = @"Gasvalve";
NSString *const ACKeyPressureSwitch            = @"Pressureswitch";
NSString *const ACKeyFlameSensor               = @"Flamesensor";
NSString *const ACKeyRollSensor                = @"Rolloutsensor";
NSString *const ACKeyDoorSwitch                = @"Doorswitch";
NSString *const ACKeyIgnitionCntrlBoard        = @"Ignitioncontrolboard";
NSString *const ACKeyCoilCleaner               = @"Coil";
NSString *const ACKeyMisc                      = @"Misc";

NSString *const ACKeyRefrigerantTypeID    = @"RefrigerantTypeId"      ;//1
NSString *const ACKeyBreakerID            = @"BreakerId"              ;//4
NSString *const ACKeyCompressorID         = @"CompressorId"           ;//5
NSString *const ACKeyCapacitorID          = @"CapacitorId"            ;//6
NSString *const ACKeyContractorID         = @"ContactorId"            ;//7
NSString *const ACKeyFilterDryerID        = @"FilterdryerId"          ;//8
NSString *const ACKeyDfrostBoardID        = @"DefrostboardId"         ;//9
NSString *const ACKeyRelayID              = @"RelayId"                ;//10
NSString *const ACKeyTXVvalveID           = @"TXVValveId"             ;//11
NSString *const ACKeyReversingValveID     = @"ReversingValveId"       ;//12
NSString *const ACKeyBlowerMotorID        = @"BlowerMotorId"          ;//13
NSString *const ACKeyCondensingMotorID    = @"CondensingfanmotorId"   ;//14
NSString *const ACKeyInducerMotorID       = @"InducerdraftmotorId"    ;//15
NSString *const ACKeyTransformerID        = @"TransformerId"          ;//16
NSString *const ACKeyControlBoardID       = @"ControlboardId"         ;//17
NSString *const ACKeyLimitSwitchID        = @"LimitswitchId"          ;//18
NSString *const ACKeyIgnitorID            = @"IgnitorId"              ;//19
NSString *const ACKeyGasvalveID           = @"GasvalveId"             ;//20
NSString *const ACKeyPressureSwitchID     = @"PressureswitchId"       ;//21
NSString *const ACKeyFlameSensorID        = @"FlamesensorId"          ;//22
NSString *const ACKeyRollSensorID         = @"RolloutsensorId"        ;//23
NSString *const ACKeyDoorSwitchID         = @"DoorswitchId"           ;//24
NSString *const ACKeyIgnitionCntrlBoardID = @"IgnitioncontrolboardId" ;//25
NSString *const ACKeyCoilCleanerID        = @"CoilId"                 ;//26
NSString *const ACKeyMiscID               = @"MiscId" ;//27

NSString *const ACKeyIsOlder                   = @"UnitAge";
@implementation ACEACPartInfo

@synthesize modelNumber,serialNumber,typeofunit,manuDate,manuBrand,unitTon,booster,boosterId,refriType,compressor,capacitor,contractor,filterdryer,defrostboard,relay,txvvalve,reversingvalve,blowermotor,condansingFanMotor,inducerDraftMotor,transformer,controlboard,limitSwitch,ignitor,pressureSwitch,flameSensor,rolloutsensor,doorswitch,ignitioncontrolBoard,coilCleaner,misc,arrFilter,filterQnty,arrFuse,fuseQnty,gasValve,electricalService,maxBreaker,breaker,arrManuals,arrPictures,isUnitOld;

@synthesize refriTypeID,compressorID,capacitorID,contractorID,filterdryerID,defrostboardID,relayID,txvvalveID,reversingvalveID,blowermotorID,condansingFanMotorID,inducerDraftMotorID,transformerID,controlboardID,limitSwitchID,ignitorID,gasValveID,breakerID,pressureSwitchID,flameSensorID,rolloutsensorID,doorswitchID,ignitioncontrolBoardID,coilCleanerID,miscID;


-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    
    if(dict.count == 0)
    {
        return nil;
    }
    if(self = [super init])
    {
        modelNumber      =   dict[ACKeyMnumber];
        serialNumber     =   dict[ACKeySerialNumber];
        typeofunit       =   dict[ACKeyTypeOfUnit];
        manuBrand        =   dict[ACKeyMbrand];
        manuDate         =   dict[ACKeyMdate];
        unitTon          =   dict[ACKeyUnitTon];
        booster          =   dict[ACKeyBooster];
        boosterId        =   [dict[ACKeyBoosterId]stringValue];
        refriType        =   dict[ACKeyRefrigerantType];
        compressor       =   dict[ACKeyCompressor];
        capacitor        =   dict[ACKeyCapacitor];
        contractor       =   dict[ACKeyContractor];
        filterdryer      =   dict[ACKeyFilterDryer];
        defrostboard     =   dict[ACKeyDfrostBoard];
        relay            =   dict[ACKeyRelay];
        txvvalve         =   dict[ACKeyTXVvalve];
        
        electricalService   = dict[ACKeyEleService];
        maxBreaker          = dict[ACKeyMaxBreaker];
        breaker             = dict[ACKeyBreaker];
        
        reversingvalve     =   dict[ACKeyReversingValve];
        blowermotor        =   dict[ACKeyBlowerMotor];
        condansingFanMotor =   dict[ACKeyCondensingMotor];
        inducerDraftMotor  =   dict[ACKeyInducerMotor];
        transformer        =   dict[ACKeyTransformer];
        controlboard       =   dict[ACKeyControlBoard];
        limitSwitch        =   dict[ACKeyLimitSwitch];
        ignitor            =   dict[ACKeyIgnitor];
        gasValve           =   dict[ACKeyGasvalve];
        pressureSwitch     =   dict[ACKeyPressureSwitch];
        flameSensor        =   dict[ACKeyFlameSensor];
        rolloutsensor      =   dict[ACKeyRollSensor];
        doorswitch         =   dict[ACKeyDoorSwitch];
        
        ignitioncontrolBoard    = dict[ACKeyIgnitionCntrlBoard];
        coilCleaner             = dict[ACKeyCoilCleaner];
        misc                    = dict[ACKeyMisc];
        
        filterQnty              = [dict[ACKeyQntFilter]intValue];
        arrFilter               = dict[ACKeyFilter];
        fuseQnty                = [dict[ACKeyQntFuses]intValue];
        arrFuse                 = dict[ACKeyFuses];
        arrManuals              = dict[ACKeyManual];
        arrPictures             = dict[ACKeyPictures];
        isUnitOld               = [dict[ACKeyIsOlder] boolValue];
        
        refriTypeID            = [dict[ACKeyRefrigerantTypeID] stringValue]    ;
        compressorID           = [dict[ACKeyCompressorID] stringValue]         ;
        capacitorID            = [dict[ACKeyCapacitorID] stringValue]          ;
        contractorID           = [dict[ACKeyContractorID] stringValue]         ;
        filterdryerID          = [dict[ACKeyFilterDryerID] stringValue]        ;
        defrostboardID         = [dict[ACKeyDfrostBoardID] stringValue]        ;
        relayID                = [dict[ACKeyRelayID] stringValue]              ;
        txvvalveID             = [dict[ACKeyTXVvalveID] stringValue]           ;
        reversingvalveID       = [dict[ACKeyReversingValveID] stringValue]     ;
        blowermotorID          = [dict[blowermotorID] stringValue]             ;
        condansingFanMotorID   = [dict[ACKeyCondensingMotorID] stringValue]    ;
        inducerDraftMotorID    = [dict[ACKeyInducerMotorID] stringValue]         ;
        transformerID          = [dict[ACKeyTransformerID] stringValue]        ;
        controlboardID         = [dict[ACKeyControlBoardID] stringValue]       ;
        limitSwitchID          = [dict[ACKeyLimitSwitchID] stringValue]        ;
        ignitorID              = [dict[ACKeyIgnitorID] stringValue]            ;
        gasValveID             = [dict[ACKeyGasvalveID] stringValue]           ;
        breakerID              = [dict[ACKeyBreakerID] stringValue]            ;
        pressureSwitchID       = [dict[ACKeyPressureSwitchID] stringValue]     ;
        flameSensorID          = [dict[ACKeyFlameSensorID] stringValue]        ;
        rolloutsensorID        = [dict[ACKeyRollSensorID] stringValue]         ;
        doorswitchID           = [dict[ACKeyDoorSwitchID] stringValue]         ;
        ignitioncontrolBoardID = [dict[ACKeyIgnitionCntrlBoardID] stringValue] ;
        coilCleanerID          = [dict[ACKeyCoilCleanerID] stringValue]        ;
        miscID                 = [dict[ACKeyMiscID] stringValue]               ;
    }
    
    return self;
}

@end
