//
//  ACEGeneral.m
//  AircallEmployee
//
//  Created by ZWT111 on 22/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEGeneral.h"

NSString *const GKeyId           =@"Id";
NSString *const GKeyName         =@"Name";
NSString *const GKeyStateId      =@"StateId";
NSString *const GKeyserviceId    =@"ServiceId";
NSString *const GKeyMessage      =@"Message";

//for sending current location in appdedegate

NSString *const GKeyLattitude    =@"Latitude";
NSString *const GKeyLongitude    =@"Longitude";

NSString *const GKeyPageNumber   =@"PageNumber";
NSString *const GKeySearchTerm   =@"SearchTerm";

NSString *const GKeyStartDate    =@"StatDate";
NSString *const GKeyEndDate      =@"EndDate";

NSString *const GKeyCardType     =@"CardType"    ;
NSString *const GKeyCardNumber   =@"CardNumber"  ;
NSString *const GKeyNameOnCard   =@"NameOnCard"  ;
NSString *const GKeyExpiryMonth  =@"ExpiryMonth" ;
NSString *const GKeyExpiryYear   =@"ExpiryYear"  ;
NSString *const GKeyStipeCardId  =@"StripeCardId";
NSString *const GKeyCVV          =@"CVV"         ;

NSString *const GKeyChequeNo     =@"ChequeNo"    ;
NSString *const GKeyBankName     =@"BankName"    ;
NSString *const GKeyChequeDate   =@"ChequeDate"  ;
NSString *const GKeyAcocuntingNotes  =@"AccountingNotes";
NSString *const GKeyChequeFrontImage =@"chqueimagefront";
NSString *const GKeyChequeBackImage  =@"chequeimageback";

NSString *const GKeyPart         =@"Part"        ;

NSString *const GUnitTypePackaged=@"Packaged"   ;
NSString *const GUnitTypeHeating =@"Heating"    ;
NSString *const GUnitTypeSplit   =@"Split"      ;
NSString *const GUnitTypeCooling =@"Cooling"    ;

NSString *const GPlanTypeId      =@"PlanTypeId";
NSString *const GAutoRenewal     =@"AutoRenewal";
NSString *const GSpecialOffer    =@"SpecialOffer";
NSString *const GSpecialText     =@"SpecialText";
NSString *const GSpecialPrice    = @"SpecialPrice";
NSString *const GShowAutoRenewal =@"ShowAutoRenewal";
NSString *const GPlanDuration    =@"DurationInMonth";

NSString *const GPlanName        =@"PlanName";
NSString *const GPrice           =@"Price";
NSString *const GPricePerMonth   =@"PricePerMonth";
NSString *const GPaymentStatus   =@"Status";
NSString *const GPaymentError    =@"StripeError";
NSString *const GDiscountPrice   = @"DiscountPrice";

NSString *const GScheduleId      =@"ServiceID";
NSString *const GShouldDisplay   =@"Display";
NSString *const GSplitImages     =@"SpliType";

NSString *const GServiceRequestedTime =@"ServiceRequestedTime";
NSString *const GServiceRequestedOn   =@"ServiceRequestedOn";
NSString *const GRescheduleReason     =@"Reason";

NSString *const GPurpose        = @"Purpose";
NSString *const GTimeSlot1      = @"TimeSlot1";
NSString *const GTimeSlot2      = @"TimeSlot2";
NSString *const GTimeEmergencySlot1  = @"EmergencyServiceSlot1";
NSString *const GTimeEmergencySloat2 = @"EmergencyServiceSlot2";

NSString *const GKeyEmergencyDays    = @"EmergencyAndOtherServiceWithinDays";
NSString *const GKeyMaintenanceDays  = @"MaintenanceServicesWithinDays";

NSString *const GUnreadCount      = @"UnReadCount" ;
NSString *const GKeyResendEmails  = @"ClientEmails";

NSString *const GKeyUnitLimit     = @"TotalUnitSlot2";
NSString *const GKeyIsPending     = @"HasPaymentFailedUnit";

// For storing data in userdefault
NSString *const GKeyUnitlist         =@"unitList";
NSString *const GKeyMaterialList     =@"materialList";
NSString *const GKeyImageList        =@"imageList";
NSString *const GKeyRequestedPart    =@"requestedPartList";
NSString *const GKeyIsWorkNotDone    =@"isWorkNotDone";
NSString *const GKeyScheduleId       =@"scheduleId";
NSString *const GKeyTimeStarted      =@"timeStarted";
NSString *const GKeySignatureImage   =@"signatureImage";
NSString *const GKeyMaterialQty      =@"materialQty";
NSString *const GKeyWorkPerformed    =@"workPerformed";
NSString *const GKeyNotesToCustomer  =@"notesToCustomer";
NSString *const GKeyIsTimerRunning   =@"isTimerRunning";
NSString *const GKeySavedReportData  =@"SavedReportData";
NSString *const GKeyStartlattitude   =@"startLattitude";
NSString *const GKeyStartLongitude   =@"endLattitude";
NSString *const GKeyTotalTime        =@"totalTime";
NSString *const GKeySignature        =@"signatureImage";
NSString *const GKeyServiceImgArr    =@"serviceImageArr";
NSString *const GKeyServiceImage     =@"serviceImage";
NSString *const GKeyImageStatus      =@"imageStatus";
NSString *const GKeyTotalSheduleSeconds  =@"totalScheduleSeconds";
NSString *const GKeySavedDate            =@"todayDate";

@implementation ACEGeneral

@end
