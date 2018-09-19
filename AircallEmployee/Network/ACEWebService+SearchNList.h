//
//  ACEWebService+SearchNList.h
//  AircallEmployee
//
//  Created by ZWT111 on 09/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService.h"

extern NSString *const SKeyLocationEndPoint;
extern NSString *const SKeyCommonEndPoint;

@interface ACEWebService (SearchNList)

- (void)getPlanTypeWithcompletionHandler:(void (^)(ACEAPIResponse *response, NSMutableArray *planType))completion;

-(void)getPartsList:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response , NSMutableArray *partArray))completion;

-(void)getElecticalService:(void(^)(ACEAPIResponse *response, NSMutableArray *partArray))completion;

-(void)getMaxBreaker:(void(^)(ACEAPIResponse *response, NSMutableArray *partArray))completion;

-(void)getClientList:(BOOL)isShowAllClients completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *clientArray))completion;

-(void)getAddressListForClient:(NSString *)clientID completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *addressArray))completion;

-(void)getUnitListForClient:(NSString *)addressID withClientId:(NSString *)clientId completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *unitsArray))completion;

-(void)getUnitListFromClientAndPlanType:(NSDictionary *)dict completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *unitsArray))completion;

-(void)getPlanTypes:(NSDictionary *)dict completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *arrPlan))completion;

-(void)getNotificationList:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *notificationList,NSString *pageNumber, BOOL isPending))completion;

-(void)getStateList:(void(^)(ACEAPIResponse *response , NSMutableArray *stateArray))completion;

-(void)getCityListFromState:(NSString *)stateId completionHandler:(void(^)(ACEAPIResponse *response , NSMutableArray *cityArray))completion;

-(void)getPartInfo:(NSDictionary *)parameterDict completionHandler:
    (void(^)(ACEAPIResponse *response ,NSString *partInfo))completion;

//-(void)getPurposeAndTime:(void (^)(ACEAPIResponse *response, NSDictionary *purposeInfo))completion;

-(void)getScheduletimeByServiceId:(NSDictionary *)dict completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *dict))completion;

-(void)getSalesPersonNotificationDetail:(NSDictionary *)dict completionHandler:(void(^)(ACEAPIResponse *response, ACESalesPersonVisit *visitInfo))completion;


@end
