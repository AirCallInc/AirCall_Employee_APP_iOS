//
//  ACEWebService+Service.h
//  AircallEmployee
//
//  Created by ZWT112 on 5/6/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService.h"


@interface ACEWebService (Service)


-(void)getScheduledDatesForMonth:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *response, NSMutableArray *scheduleDates,NSString *unreadCount))completion;

-(void)getScheduleListForDate:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *response, NSMutableArray *scheduleList))completion;

-(void)getScheduleDetail:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, ACEScheduleDetail *scheduleDetail))completion;

-(void)rescheduleService:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response))completion;

-(void)sendScheduleRequest:(NSDictionary*)dictInfo completionHandler:(void(^)(ACEAPIResponse *response))completion;

-(void)getServiceReportList:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *reportArray, NSString *pageNumber))completion;

-(void)getServiceReportDetail:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, ACEServiceReport *reportDEtail))completion;

-(void)submitServiceReportData:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSString *successId))completion;

-(void)resendServiceReport:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response))completion;

-(void)submitServiceReportImage:(NSDictionary *)parameterDict withImage:(NSDictionary *)imgDict completionHandler:(void(^)(ACEAPIResponse *response))completion;

-(void)getRequestedPartList:(NSDictionary*)dictUnitInfo completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *arrUnits, NSString *pageNumber))completion;

-(void)cancelRequestedPart:(NSDictionary *)dictPartInfo completionHandler:(void(^)(ACEAPIResponse *response))completion;

-(void)getRequestedPartDetail:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSDictionary *dict))completion;

-(void)getPartListAccordingDate:(NSDictionary*)dictUnitInfo completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *arrUnits))completion;

-(void)submitPartRequest:(NSDictionary *)parameterDeict completionHandler:(void(^)(ACEAPIResponse *response))completion;

@end
