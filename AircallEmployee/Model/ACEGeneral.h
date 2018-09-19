//
//  ACEGeneral.h
//  AircallEmployee
//
//  Created by ZWT111 on 22/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GKeyId           ;
extern NSString *const GKeyName         ;
extern NSString *const GKeyStateId      ;
extern NSString *const GKeyserviceId    ;
extern NSString *const GKeyMessage      ;

extern NSString *const GKeyLattitude    ;
extern NSString *const GKeyLongitude    ;

extern NSString *const GKeyPageNumber   ;
extern NSString *const GKeySearchTerm   ;

extern NSString *const GKeyStartDate    ;
extern NSString *const GKeyEndDate      ;

extern NSString *const GKeyCardType     ;
extern NSString *const GKeyCardNumber   ;
extern NSString *const GKeyNameOnCard   ;
extern NSString *const GKeyExpiryMonth  ;
extern NSString *const GKeyExpiryYear   ;
extern NSString *const GKeyStipeCardId  ;
extern NSString *const GKeyCVV          ;

extern NSString *const GKeyChequeNo         ;
extern NSString *const GKeyBankName         ;
extern NSString *const GKeyChequeDate       ;
extern NSString *const GKeyAcocuntingNotes  ;
extern NSString *const GKeyChequeFrontImage ;
extern NSString *const GKeyChequeBackImage  ;

extern NSString *const GKeyPart             ;

extern NSString *const GUnitTypePackaged;
extern NSString *const GUnitTypeHeating ;
extern NSString *const GUnitTypeSplit   ;
extern NSString *const GUnitTypeCooling ;

extern NSString *const GPlanTypeId      ;
extern NSString *const GAutoRenewal     ;
extern NSString *const GSpecialOffer    ;

extern NSString *const GPlanName        ;
extern NSString *const GPrice           ;
extern NSString *const GDiscountPrice   ;
extern NSString *const GPricePerMonth   ;
extern NSString *const GSpecialText     ;
extern NSString *const GSpecialPrice    ;
extern NSString *const GShowAutoRenewal ;
extern NSString *const GPlanDuration    ;

extern NSString *const GPaymentStatus   ;
extern NSString *const GPaymentError    ;

extern NSString *const GScheduleId      ;
extern NSString *const GShouldDisplay   ;

extern NSString *const GSplitImages     ;

extern NSString *const GServiceRequestedTime ;
extern NSString *const GServiceRequestedOn   ;
extern NSString *const GRescheduleReason     ;

extern NSString *const GPurpose  ;
extern NSString *const GTimeSlot1;
extern NSString *const GTimeSlot2;
extern NSString *const GTimeEmergencySlot1  ;
extern NSString *const GTimeEmergencySloat2 ;
extern NSString *const GKeyEmergencyDays    ;
extern NSString *const GKeyMaintenanceDays  ;

extern NSString *const GUnreadCount      ;
extern NSString *const GKeyResendEmails  ;

extern NSString *const GKeyUnitLimit     ;
extern NSString *const GKeyIsPending     ;

// For storing data in userdefault
extern NSString *const GKeyUnitlist             ;
extern NSString *const GKeyMaterialList         ;
extern NSString *const GKeyImageList            ;
extern NSString *const GKeyRequestedPart        ;
extern NSString *const GKeyIsWorkNotDone        ;
extern NSString *const GKeyScheduleId           ;
extern NSString *const GKeyTimeStarted          ;
extern NSString *const GKeySignatureImage       ;
extern NSString *const GKeyMaterialQty          ;
extern NSString *const GKeyWorkPerformed        ;
extern NSString *const GKeyNotesToCustomer      ;
extern NSString *const GKeyIsTimerRunning       ;
extern NSString *const GKeySavedReportData      ;
extern NSString *const GKeyStartlattitude       ;
extern NSString *const GKeyStartLongitude       ;
extern NSString *const GKeySignature            ;
extern NSString *const GKeyTotalTime            ;
extern NSString *const GKeyServiceImgArr        ;
extern NSString *const GKeyServiceImage         ;
extern NSString *const GKeyImageStatus          ;
extern NSString *const GKeyTotalSheduleSeconds  ;
extern NSString *const GKeySavedDate            ;

@interface ACEGeneral : NSObject

@end
