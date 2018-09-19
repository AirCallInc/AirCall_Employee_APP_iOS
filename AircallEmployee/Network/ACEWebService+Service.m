//
//  ACEWebService+Service.m
//  AircallEmployee
//
//  Created by ZWT112 on 5/6/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService+Service.h"

@implementation ACEWebService (Service)

-(void)getScheduledDatesForMonth:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *, NSString *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetDashBoardMonthWiseServiceCount",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if(code == RCodeSuccess)
         {
             
             NSDictionary *scheduleInfo = responseObject[RKeyData];
             NSString *unreadCount = [scheduleInfo[GUnreadCount] stringValue];
             NSMutableArray *arr  = scheduleInfo[@"data"];
             
             completion(response, arr,unreadCount);
         }
         else
         {
             completion(response, nil,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,nil);
     }];

}
-(void)getScheduleListForDate:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *))completion
{
    //http://192.168.1.119:6987/v1/
     NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetDashBoardMonthDayWiseServiceList",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];

         if(code == RCodeSuccess)
         {
             
             NSArray *arrUserInfo = responseObject[RKeyData];
             
             NSMutableArray *scheduleArr = @[].mutableCopy;
             
             [arrUserInfo enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull scheduleInfo, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  
                  NSArray * arr = scheduleInfo[SCHKeyServices];
                  
                  for (NSDictionary *dict in arr)
                  {
                      ACESchedule *schedule = [[ACESchedule alloc]initWithDictionary:dict];
                      [scheduleArr addObject:schedule];
                  }
                  
              }];
             
             completion(response,scheduleArr);
         }
         else
         {
             completion(response, nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];
}
-(void)getScheduleDetail:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, ACEScheduleDetail *))completion
{
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetServiceDetails",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if(code == RCodeSuccess)
         {
             ACEScheduleDetail *scheduleDetail = [[ACEScheduleDetail alloc]initWithDictionary:responseObject[RKeyData]];
             
             completion(response, scheduleDetail);
         }
         else
         {
             completion(response, nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];

}

-(void)rescheduleService:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/ServiceRecheduleRequest",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         completion(response);
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)getServiceReportList:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *,NSString *))completion

{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetAllCompletedReports",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code = [responseObject[RKeyCode]integerValue];
        NSString *message = responseObject[RKeyMessage];
        
        NSString *token = responseObject[RKeyToken];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
        
        [ACEUtil updateAccessToken:token];
        
        //NSLog(@"%@",responseObject);
        
        NSString *pageNo = [responseObject[GKeyPageNumber]stringValue];
        
         NSMutableArray *arrServiceReport = [[NSMutableArray alloc]init];
        if(code == RCodeSuccess)
        {
            NSArray *arr = responseObject[RKeyData];
            
            [arr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 ACEServiceReport *report = [[ACEServiceReport alloc]initWithDictionary:dict];
                 
                 [arrServiceReport addObject:report];
            }];
            
            completion(response,arrServiceReport,pageNo);
        }
        else if (code == RCodeNoData)
        {
            completion(response,arrServiceReport,pageNo);
        }
        else
        {
            completion(response,nil,nil);
        }
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"signinWithUserDetail Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response, nil,nil);
        
    }];
    
}
-(void)submitServiceReportData:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSString *successId))completion
{
   // NSString *resourceAddress = @"http://192.168.1.119:6987/employee/SubmitServiceReport";
    //http://192.168.1.119:6987/v1/
    
     NSString *resourceAddress = [NSString stringWithFormat:@"%@/SubmitServiceReport",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict
      progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             completion(response,responseObject[RKeyData]);
         }
         else
         {
             completion(response,nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)submitServiceReportImage:(NSDictionary *)parameterDict withImage:(NSDictionary *)imgDict completionHandler:(void(^)(ACEAPIResponse *response))completion
{
    //http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/SubmitServiceReportImage",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
    {
        NSData *imageAsData = UIImageJPEGRepresentation(imgDict[SRKeySignature], 0.7);
       
        NSArray *arr = imgDict[SRKeyPictures];
        
        if(imageAsData)
        {
            [formData appendPartWithFileData:imageAsData name:SRKeySignature fileName:SRKeySignature mimeType:@"image/png"];
            
            for(int i =0 ; i < arr.count; i++)
            {
                [formData appendPartWithFileData:arr[i] name:SRKeyPictures fileName:SRKeyPictures mimeType:@"image/png"];
            }
        }
        else if(arr.count > 0)
        {
            for(int i =0 ; i < arr.count; i++)
            {
                [formData appendPartWithFileData:arr[i] name:SRKeyPictures fileName:SRKeyPictures mimeType:@"image/png"];
            }
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code    = [responseObject[RKeyCode] integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token   = responseObject[RKeyToken];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
        
        [ACEUtil updateAccessToken:token];
        
        if(code == RCodeSuccess)
        {
            completion(response);
        }
        else
        {
            completion(response);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        
        DDLogError(@"signinWithUserDetail Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response);
    }];
}
-(void)sendScheduleRequest:(NSDictionary*)dictInfo completionHandler:(void(^)(ACEAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/SubmitRequestServiceForClient",UKeyUrlEndpoint];
    
     //NSString *resourceAddress = [NSString stringWithFormat:@"http://192.168.1.119:6987/%@/SubmitRequestServiceForClient",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:dictInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         //NSLog(@"%@",responseObject);
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"sendScheduleRequest Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
         
     }];

}
-(void)resendServiceReport:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/ResendReport",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
        // NSLog(@"%@",responseObject);
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"sendScheduleRequest Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
         
     }];
}
-(void)getServiceReportDetail:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, ACEServiceReport *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/CompletedReportsDetail",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
        // NSLog(@"%@",responseObject);
         
         if(code == RCodeSuccess)
         {
             ACEServiceReport *reportDetail = [[ACEServiceReport alloc]initWithDetailDictionary:responseObject[RKeyData]];
             
             completion(response,reportDetail);
             
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
         
     }];

}
-(void)getRequestedPartList:(NSDictionary*)dictUnitInfo completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *arrUnits, NSString *pageNumber))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/RequestedPartList",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:dictUnitInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         NSArray *arrPartList = responseObject[RKeyData];
         NSString *pageNumber = [responseObject[GKeyPageNumber] stringValue];
         NSMutableArray *partList = @[].mutableCopy;
         
         if (code == RCodeSuccess)
         {
             [arrPartList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull parts, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACEParts *part = [[ACEParts alloc]initWithRequestedPartData:parts];
                  [partList addObject:part] ;
              }];
             
             completion(response,partList,pageNumber);
         }
         else
         {
             completion(response,nil,pageNumber);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getUnitList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,nil);
     }];
    
}
-(void)getPartListAccordingDate:(NSDictionary*)dictUnitInfo completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *arrUnits))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/ServicePartList",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:dictUnitInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         NSArray *arrPartList     = responseObject[RKeyData];
         NSMutableArray *partList = @[].mutableCopy;
         
         if (code == RCodeSuccess)
         {
             [arrPartList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull parts, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACEParts *unitDetail = [[ACEParts alloc]initDictioanryWithDate:parts];
                  [partList addObject:unitDetail] ;
              }];
             
             completion(response,partList);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getUnitList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];

}
-(void)submitPartRequest:(NSDictionary *)parameterDeict completionHandler:(void (^)(ACEAPIResponse *))completion
{
    // http://192.168.1.119:6987/v1/
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/EmpPartRequeste",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDeict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getUnitList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)getRequestedPartDetail:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/RequestedPartDetail",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[RKeyData];
             completion(response,dict);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getUnitList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)cancelRequestedPart:(NSDictionary *)dictPartInfo completionHandler:(void (^)(ACEAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/CancelRequestedPartDetail",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:dictPartInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         completion(response);
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getUnitList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
@end
