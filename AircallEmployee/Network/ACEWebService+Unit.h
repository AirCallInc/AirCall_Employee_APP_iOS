//
//  ACEWebService+Unit.h
//  AircallEmployee
//
//  Created by ZWT111 on 24/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService.h"

@interface ACEWebService (Unit)

-(void)getUnitList:(NSDictionary*)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *arrUnits, NSString *pageNumber, BOOL isPendingUnit))completion;

//for Unit detail Viewable
-(void)getUnitDetail:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, ACEACUnit *ACDetail))completion;
                                                           
-(void)getOrderDetail:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, ACEOrder *orderDetail))completion;

-(void)getOrderList:(NSDictionary*)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *arrOrders))completion;

-(void)resendOrderDetail:(NSDictionary *)parameterDict completionhandler:(void(^)(ACEAPIResponse *response))completion;

-(void)getDefaultAddress:(NSString *)userId completionHandler:(void(^)(ACEAPIResponse *response , ACEAddress *defaultAddress))completion;

-(void)getUnitClientInfo:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, ACEACUnit *unit ))completion;

-(void)getUnitManualField:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSArray *arrUnitInfo))completion;

-(void)getPendingUnitList:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *dictUnit))completion;

-(void)deletePendingUnits:(NSDictionary *)parameterDict CompletionHandler:(void(^)(ACEAPIResponse *response))completion;

-(void)editUnitUnmatched:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response , NSDictionary *dictInfo))completion;

-(void)addNewUnit:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSString *unitId))completion;

-(void)addUnitImages:(NSDictionary *)parameterDict withImages:(NSArray *)arrImages andSplitImage:(NSArray *)arrSplitImages completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *unitInfo))completion;

-(void)UpdateUnitImages:(NSDictionary *)parameterDict withImages:(NSArray *)arrImages andSplitImage:(NSArray *)arrSplitImages completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *unitInfo))completion;

-(void)submitOrderPayment:(NSDictionary *)parameterDict withSignatureImage:(NSDictionary *)dictImages completionHandler:(void(^)(ACEAPIResponse *response , NSDictionary *dictParts))completion;

-(void)submitOrderQuote:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *response))completion;

-(void)checkUnitMatchDetails:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response,NSMutableArray *arrUnitInfo))completion;

-(void)deleteUnit:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *unitInfo))completion;

-(void)getFailedPaymentUnits:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *unitInfo))completion;

-(void)validateCardInfo:(NSDictionary *)parameterDict withImage:(NSDictionary *)imgSignature completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *dictUnitInfo))completion;

-(void)getPaymentStatus:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *dictUnitInfo))completion;

-(void)getSpecialRateofPlan:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *dictInfo))completion;

-(void)spAddUnit:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *unitInfo))completion;

@end
