//
//  ACEWebService+SearchNList.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService+SearchNList.h"

NSString *const SKeyLocationEndPoint    =  @"emplocation";
NSString *const SKeyCommonEndPoint      =  @"empcommon";

@implementation ACEWebService (SearchNList)

-(void)getPlanTypeWithcompletionHandler:(void (^)(ACEAPIResponse *response, NSMutableArray *planType))completion
{
    NSString * resourceAddress = [NSString stringWithFormat:@"%@/getallplantype?EmployeeId=%@",SKeyCommonEndPoint,ACEGlobalObject.user.userID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACEUtil updateAccessToken:token];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrPlanInfo = responseObject[RKeyData];
             
             NSMutableArray *planInfo = @[].mutableCopy;
             
             [arrPlanInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull planType, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  [planInfo addObject:planType] ;
              }];
             
             completion(response,planInfo);
         }
         else if (code == RCodeUnauthorized)
         {
             
         }
         else
         {
             completion(response,nil);
         }
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getPlanTypeList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}
-(void)getPartsList:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse * , NSMutableArray *))completion;
{
    //http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetPartsByTypeForUnit",SKeyCommonEndPoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSMutableArray *arrPart = [[NSMutableArray alloc]init];
             NSArray *arrPartInfo = responseObject[RKeyData];
             
             [arrPartInfo enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 ACEParts *part = [[ACEParts alloc]initWithDictionary:dict];
                 [arrPart addObject:part];
             }];
             completion(response,arrPart);
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

-(void)getClientList:(BOOL)isShowAllClients completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *clientArray))completion;

{
    NSString *str = isShowAllClients ? @"true" : @"false";
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetAllClients?EmployeeId=%@&ShowOnlyWorkAreaClient=%@",UKeyUrlEndpoint,ACEGlobalObject.user.userID,str];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code = [responseObject[RKeyCode]integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token = responseObject[RKeyToken];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
        
        [ACEUtil updateAccessToken:token];
        if(code == RCodeSuccess)
        {
            NSArray *arrClientInfo = responseObject[RKeyData];
            
            NSMutableArray *clientInfo = @[].mutableCopy;
            
            [arrClientInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull clients, NSUInteger idx, BOOL*  _Nonnull stop)
             {
                 ACEClient *client = [[ACEClient alloc]initWithDictionary:clients];
                 [clientInfo addObject:client] ;
             }];
            completion(response,clientInfo);
        }
        else
        {
            completion(response,nil);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"signinWithUserDetail Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response, nil);

    }];
}

-(void)getAddressListForClient:(NSString *)clientID completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *addressArray))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetClientAddress?ClientId=%@&EmployeeId=%@",UKeyUrlEndpoint,clientID,ACEGlobalObject.user.userID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         NSArray *arrAddressList = responseObject[RKeyData];
         
         NSMutableArray *addressList = @[].mutableCopy;

         if(code == RCodeSuccess)
         {
             [arrAddressList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull address, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACEAddress *add = [[ACEAddress alloc]initWithDictionary:address];
                  [addressList addObject:add] ;
              }];
             
             completion(response,addressList);
         }
         else
         {
             completion(response,addressList);
         }
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetAddressListForClient Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
         
     }];
}
-(void)getPlanTypes:(NSDictionary *)dict completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetAllPlanTypeFromAddressID?AddressID=%@&EmployeeId=%@",SKeyCommonEndPoint,dict[SCHKeyAddressId],ACEGlobalObject.user.userID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSMutableArray *arrPlan = responseObject[RKeyData];
             completion(response,arrPlan);
         }
         else
         {
             completion(response,nil);
         }
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetAddressListForClient Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
         
     }];

}

-(void)getUnitListForClient:(NSString *)addressID withClientId:(NSString *)clientId completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *unitsArray))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetClientUnitsByAddressId?ClientId=%@&AddressId=%@&EmployeeId=%@",UKeyUrlEndpoint,clientId,addressID,ACEGlobalObject.user.userID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         NSArray *arrUnitList = responseObject[RKeyData];
         
         NSMutableArray *unitList = @[].mutableCopy;
         
         if(code == RCodeSuccess)
         {
             [arrUnitList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull unit, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACEACUnit *unitInfo = [[ACEACUnit alloc]initWithListDictionary:unit];
                  [unitList addObject:unitInfo] ;
              }];
             
             completion(response,unitList);
         }
         else
         {
             completion(response,unitList);
         }
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getUnitListForClient Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
         
     }];
}
-(void)getUnitListFromClientAndPlanType:(NSDictionary *)dict completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *))completion
{
     NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetClientUnitByAddressIdPlanType",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code = [responseObject[RKeyCode]integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token = responseObject[RKeyToken];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
        
        [ACEUtil updateAccessToken:token];
        
       // NSArray *arrUnitList = responseObject[RKeyData];
        
        NSMutableArray *unitList = @[].mutableCopy;
        
        if(code == RCodeSuccess)
        {
            NSMutableArray *arrUnitList = responseObject[RKeyData];
            
//            [arrUnitList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull unit, NSUInteger idx, BOOL*  _Nonnull stop)
//             {
//                 ACEACUnit *unitInfo = [[ACEACUnit alloc]initWithListDictionary:unit];
//                 [unitList addObject:unitInfo] ;
//             }];
            
            completion(response,arrUnitList);
        }
        else
        {
            completion(response,unitList);
        }
 
        
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"getUnitListFromClientAndPlanType Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response, nil);
        
    }];
    
}

-(void)getNotificationList:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *, NSString *, BOOL))completion
{
    //NSString *resourceAddress = @"";
      NSString *resourceAddress = [NSString stringWithFormat:@"%@/NotificationList",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
          NSString *pageNo = [responseObject[GKeyPageNumber]stringValue];
         
          NSMutableArray *arr = [[NSMutableArray alloc]init];
         
         BOOL ispending       = [responseObject[GKeyIsPending] boolValue];
         if(code == RCodeSuccess)
         {
        
            // BOOL ispending       = [responseObject[GKeyIsPending] boolValue];
             
             NSArray *arrUnit = responseObject[RKeyData];
             
             [arrUnit enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 ACENotification *noti = [[ACENotification alloc]initWithDictionary:dict];
                 
                 [arr addObject:noti];
                 
             }];
             completion(response,arr,pageNo,ispending);
         }
         else if(code == RCodeNoData)
         {
             completion(response,arr,pageNo,ispending);
         }
         else
         {
             completion(response,nil,nil,ispending);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,nil,NO);
     }];
}
-(void)getStateList:(void(^)(ACEAPIResponse *response , NSMutableArray *stateArray))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetAllState?EmployeeId=%@",SKeyLocationEndPoint,ACEGlobalObject.user.userID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         [ACEUtil updateAccessToken:token];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         
         if(code == RCodeSuccess)
         {
             NSArray *arrStateInfo = responseObject[RKeyData];
             
             NSMutableArray *stateInfo = @[].mutableCopy;
             
             [arrStateInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull state, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  [stateInfo addObject:state] ;
              }];
             
             completion(response,stateInfo);
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
-(void)getCityListFromState:(NSString *)stateId completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *))completion
{
     NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetAllCityByStateId?StateId=%@&EmployeeId=%@",SKeyLocationEndPoint,stateId,ACEGlobalObject.user.userID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         NSString *token = responseObject[RKeyToken];
         
         [ACEUtil updateAccessToken:token];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrCityInfo = responseObject[RKeyData];
             
             NSMutableArray *cityInfo = @[].mutableCopy;
             
             [arrCityInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull city, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  [cityInfo addObject:city] ;
              }];
             
             completion(response,cityInfo);
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

-(void)getPartInfo:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSString *))completion
{
   NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetPartById",SKeyCommonEndPoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSString *partInfo = responseObject[RKeyData][SRKeyReqPartDes];
             completion(response,partInfo);
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
/*-(void)getPurposeAndTime:(void (^)(ACEAPIResponse *response, NSDictionary *purposeInfo))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetTimeAndPurposeOfRequest?EmployeeId=%@",UKeyUrlEndpoint,ACEGlobalObject.user.userID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACEUtil updateAccessToken:token];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[RKeyData];
             completion(response,dict);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask*  _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetPurposeTime Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}*/
-(void)getElecticalService:(void(^)(ACEAPIResponse *response, NSMutableArray *partArray))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/getElectricalServices",UKeyUrlEndpoint];
    
    NSDictionary *dict = @{
                           UKeyEmployeeID : ACEGlobalObject.user.userID
                           };
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSMutableArray *arrPart = [[NSMutableArray alloc]init];
             NSArray *arrPartInfo = responseObject[RKeyData];
             
             [arrPartInfo enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  ACEParts *part = [[ACEParts alloc]initWithDictionary:dict];
                  [arrPart addObject:part];
              }];
             completion(response,arrPart);
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
-(void)getMaxBreaker:(void (^)(ACEAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/getMaxBreaker",UKeyUrlEndpoint];
    
    NSDictionary *dict = @{
                           UKeyEmployeeID : ACEGlobalObject.user.userID
                           };
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSMutableArray *arrPart = [[NSMutableArray alloc]init];
             NSArray *arrPartInfo = responseObject[RKeyData];
             
             [arrPartInfo enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  ACEParts *part = [[ACEParts alloc]initWithDictionary:dict];
                  [arrPart addObject:part];
              }];
             completion(response,arrPart);
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
-(void)getScheduletimeByServiceId:(NSDictionary *)dict completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    //http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetScheduleTimeByServiceId",SKeyCommonEndPoint];
    
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACEUtil updateAccessToken:token];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[RKeyData];
             completion(response,dict);
         }
         else
         {
             completion(response,nil);
         }
     }
      failure:^(NSURLSessionDataTask*  _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetPurposeTime Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)getSalesPersonNotificationDetail:(NSDictionary *)dict completionHandler:(void (^)(ACEAPIResponse *, ACESalesPersonVisit *))completion
{
    //http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/salesPersonVisitDetail",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACEUtil updateAccessToken:token];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             ACESalesPersonVisit *info = [[ACESalesPersonVisit alloc]initWithDetailDictionary:responseObject[RKeyData]];
             
             completion(response,info);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask*  _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetPurposeTime Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
@end
