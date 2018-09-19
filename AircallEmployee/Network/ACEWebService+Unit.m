//
//  ACEWebService+Unit.m
//  AircallEmployee
//
//  Created by ZWT111 on 24/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService+Unit.h"

@implementation ACEWebService (Unit)

-(void)getUnitList:(NSDictionary*)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *arrUnits, NSString *pageNumber, BOOL isPendingUnit))completion
{
   // http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetAllScheduledServices",UKeyUrlEndpoint];
 
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         // NSLog(@"%@",message);
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
             NSArray *arrUnitList = responseObject[RKeyData];
             NSString *pageNumber = [responseObject[GKeyPageNumber] stringValue];
             BOOL ispending       = [responseObject[GKeyIsPending] boolValue];
         
             NSMutableArray *unitList = @[].mutableCopy;
             
             if (code == RCodeSuccess)
             {
                 [arrUnitList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull unit, NSUInteger idx, BOOL*  _Nonnull stop)
                  {
                      ACEACUnit *unitDetail = [[ACEACUnit alloc]initWithListDictionary:unit];
                      [unitList addObject:unitDetail] ;
                  }];
                 
                 completion(response,unitList,pageNumber,ispending);
             }
             else
             {
                 completion(response,nil,pageNumber,ispending);
             }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getUnitList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil,nil,NO);
     }];

}
-(void)getUnitDetail:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, ACEACUnit *))completion
{
    //http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetServiceUnitDetails",UKeyUrlEndpoint];

    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
        // NSLog(@"%@",responseObject);
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if(code == RCodeSuccess)
         {
             ACEACUnit *ac = [[ACEACUnit alloc]initWithDictionary:responseObject[RKeyData]];
             
             completion(response,ac);
         }
         else
         {
             completion(response, nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getReviewsNRatingList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];

}
-(void)getOrderDetail:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, ACEOrder *))completion
{
     NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetOrderDetails",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];

         if(code == RCodeSuccess)
         {
             ACEOrder *order = [[ACEOrder alloc]initWithDetailDictionary:responseObject[RKeyData]];
             
             completion(response, order);
         }
         else
         {
             completion(response, nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getReviewsNRatingList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];

}

-(void)getOrderList:(NSDictionary*)parameterDict completionHandler:(void(^)(ACEAPIResponse *response, NSMutableArray *arrOrders))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetOrderList",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         NSArray *arrOrderList = responseObject[RKeyData];
         NSMutableArray *orderList = @[].mutableCopy;
         
         if (code == RCodeSuccess)
         {
             [arrOrderList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull orders, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACEOrder *order = [[ACEOrder alloc]initWithDictionary:orders];
                  [orderList addObject:order];
              }];
             
             completion(response,orderList);
         }
         else
         {
             completion(response, nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];

}
-(void)resendOrderDetail:(NSDictionary *)parameterDict completionhandler:(void (^)(ACEAPIResponse *))completion
{
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/ResendOrder",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
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
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)getDefaultAddress:(NSString *)userId completionHandler:(void (^)(ACEAPIResponse *,ACEAddress *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetClientDefaultAddress?ClientId=%@&EmployeeId=%@",UKeyUrlEndpoint,userId,ACEGlobalObject.user.userID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             
            ACEAddress *add = [[ACEAddress alloc]initWithDictionary:responseObject[RKeyData]];
                   ;
             
             completion(response,add);
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
-(void)getUnitClientInfo:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, ACEACUnit *))completion
{
    //http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetScheduledServiceUnitDetails",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess)
         {
             ACEACUnit *ac = [[ACEACUnit alloc]initWithDictionary:responseObject[RKeyData]];
             completion(response,ac);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)submitOrderPayment:(NSDictionary *)parameterDict withSignatureImage:(NSDictionary *)dictImages completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    //http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/SubmitPartOrder",UKeyUrlEndpoint];

    [self POST:resourceAddress parameters:parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         
         NSData *signAsData  = UIImageJPEGRepresentation(dictImages[OKeySignature], 0.7);
         NSData *frontAsData = UIImageJPEGRepresentation(dictImages[GKeyChequeFrontImage], 0.7);
         NSData *backAsData  = UIImageJPEGRepresentation(dictImages[GKeyChequeBackImage], 0.7);
         
         if(signAsData)
         {
             [formData appendPartWithFileData:signAsData name:OKeySignature fileName:OKeySignature mimeType:@"image/png"];
         }
         if(frontAsData)
         {
             [formData appendPartWithFileData:frontAsData name:GKeyChequeFrontImage fileName:GKeyChequeFrontImage mimeType:@"image/png"];
         }
         if(backAsData)
         {
             [formData appendPartWithFileData:backAsData name:GKeyChequeBackImage fileName:GKeyChequeBackImage mimeType:@"image/png"];
         }
     }
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
             completion(response, nil);
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
-(void)submitOrderQuote:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *))completion
{
     NSString *resourceAddress = [NSString stringWithFormat:@"%@/SubmitPartQuote",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
        
         completion(response);
        
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

    
    
}
-(void)checkUnitMatchDetails:(NSDictionary *)parameterDict completionHandler:(void(^)(ACEAPIResponse *response,NSMutableArray *arrUnitInfo))completion
{
    //http://192.168.1.119:6987/v1/
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/CheckUnitMatchDetails",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess || code == RCodeUnitPartialMatch)
         {
             NSMutableArray *arrunitInfo   = [[NSMutableArray alloc]init];
             
             NSArray *arr  = responseObject[RKeyData];
             
             [arr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 ACEACPartInfo *part = [[ACEACPartInfo alloc]initWithDictionary:dict];
                 
                 [arrunitInfo addObject:part];
             }];
             
             completion(response,arrunitInfo);
         }
         else if(code == RCodeNoData)
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)editUnitUnmatched:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    //http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/UpdateUnitDetails",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         if(response.code == RCodeSuccess)
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
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)addNewUnit:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSString *))completion
{
    //http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/AddUnitDetails",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if(response.code == RCodeSuccess)
         {
             NSString *unitId = [responseObject[RKeyData]stringValue];
             completion(response,unitId);
         }
         else
         {
             completion(response,nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)addUnitImages:(NSDictionary *)parameterDict withImages:(NSArray *)arrImages andSplitImage:(NSArray *)arrSplitImages completionHandler:(void (^)(ACEAPIResponse * , NSDictionary *))completion
{
        // NSString *resourceAddress = @"http://192.168.1.119:6987/employee/SubmitServiceReportImage";
        
        NSString *resourceAddress = [NSString stringWithFormat:@"%@/SubmitUnitImage",UKeyUrlEndpoint];
        
        [self POST:resourceAddress parameters:parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
         {
//                 NSArray *arr = parameterDict[SRKeyPictures];
                 for(int i =0 ; i < arrImages.count; i++)
                 {
                     NSDictionary *dict = arrImages[i];
                     [formData appendPartWithFileData:dict[ACKeyPictures] name:dict[ACKeyUnitType] fileName:dict[ACKeyUnitType] mimeType:@"image/png"];
                 }
                for(int i =0 ; i< arrSplitImages.count ; i++)
                {
                    NSDictionary *dict = arrSplitImages[i];
                    
                    [formData appendPartWithFileData:dict[ACKeyPictures] name:dict[ACKeyUnitType] fileName:dict[ACKeyUnitType] mimeType:@"image/png"];
                    
                }
             
         }
          progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSInteger code    = [responseObject[RKeyCode] integerValue];
             NSString *message = responseObject[RKeyMessage];
             NSString *token   = responseObject[RKeyToken];
             
             ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
             
             [ACEUtil updateAccessToken:token];
             
             if(code == RCodeSuccess)
             {
                 NSDictionary *dictUnitInfo = responseObject[RKeyData];
                 completion(response,dictUnitInfo);
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
             
             completion(response,nil);
         }];

}
-(void)UpdateUnitImages:(NSDictionary *)parameterDict withImages:(NSArray *)arrImages andSplitImage:(NSArray *)arrSplitImages completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    // NSString *resourceAddress = @"http://192.168.1.119:6987/employee/SubmitServiceReportImage";
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/UpdateUnitImage",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         //                 NSArray *arr = parameterDict[SRKeyPictures];
         for(int i =0 ; i < arrImages.count; i++)
         {
             NSDictionary *dict = arrImages[i];
             [formData appendPartWithFileData:dict[ACKeyPictures] name:dict[ACKeyUnitType] fileName:dict[ACKeyUnitType] mimeType:@"image/png"];
         }
         for(int i =0 ; i< arrSplitImages.count ; i++)
         {
             NSDictionary *dict = arrSplitImages[i];
             
             [formData appendPartWithFileData:dict[ACKeyPictures] name:dict[ACKeyUnitType] fileName:dict[ACKeyUnitType] mimeType:@"image/png"];
             
         }
         
     }
      progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dictUnitInfo = responseObject[RKeyData];
             completion(response,dictUnitInfo);
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
         
         completion(response,nil);
     }];

}
-(void)getUnitManualField:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetUnitExtraInfo",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess)
         {
            // ACEACUnit *unitDetail =
             NSArray *arr  = responseObject[RKeyData];
             completion(response,arr);
         }
         else if(code == RCodeNoData)
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)getPendingUnitList:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
   
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetPaymentFailedUnit",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess)
         {
             // ACEACUnit *unitDetail =
             NSDictionary *dict  = responseObject[RKeyData];
             completion(response,dict);
         }
         else if(code == RCodeNoData)
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)deletePendingUnits:(NSDictionary *)parameterDict CompletionHandler:(void (^)(ACEAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/DeleteOldData",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];

         completion(response);
        
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}
-(void)deleteUnit:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/RemoveClientUnit",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess)
         {
             // ACEACUnit *unitDetail =
            NSDictionary *dictUnitInfo = responseObject[RKeyData];
            completion(response,dictUnitInfo);
         }
         else if(code == RCodeNoData)
         {
             completion(response,nil);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)getFailedPaymentUnits:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    //192.168.1.119:6987/v1
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetPaymentFailedUnit",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess)
         {
             // ACEACUnit *unitDetail =
             NSDictionary *unitInfo = responseObject[RKeyData];
             completion(response,unitInfo);
         }
         else if(code == RCodeNoData)
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)validateCardInfo:(NSDictionary *)parameterDict withImage:(NSDictionary *)dictImages completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    //http://192.168.1.119:6987/v1/
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/SubmitUnitPayment",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         
        // NSData *imageAsData = UIImageJPEGRepresentation(imgSignature, 0.7);
         
       /*  if(imageAsData)
         {
             [formData appendPartWithFileData:imageAsData name:UKeyImage fileName:UKeyImage mimeType:@"image/png"];
         }*/
         NSData *signAsData  = UIImageJPEGRepresentation(dictImages[OKeySignature], 0.7);
         NSData *frontAsData = UIImageJPEGRepresentation(dictImages[GKeyChequeFrontImage], 0.7);
         NSData *backAsData  = UIImageJPEGRepresentation(dictImages[GKeyChequeBackImage], 0.7);
         
         if(signAsData)
         {
             [formData appendPartWithFileData:signAsData name:UKeyImage fileName:OKeySignature mimeType:@"image/png"];
         }
         if(frontAsData)
         {
             [formData appendPartWithFileData:frontAsData name:GKeyChequeFrontImage fileName:GKeyChequeFrontImage mimeType:@"image/png"];
         }
         if(backAsData)
         {
             [formData appendPartWithFileData:backAsData name:GKeyChequeBackImage fileName:GKeyChequeBackImage mimeType:@"image/png"];
         }
     }
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
             completion(response, nil);
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
-(void)getPaymentStatus:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/CheckClientPaymentStatus",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess)
         {
             // ACEACUnit *unitDetail =
             NSDictionary *unitInfo = responseObject[RKeyData];
             completion(response,unitInfo);
         }
         else if(code == RCodeNoData)
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
 
}
-(void)getSpecialRateofPlan:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetSpecialRateByPlanType",SKeyCommonEndPoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if (code == RCodeSuccess)
         {
             // ACEACUnit *unitDetail =
             NSDictionary *unitInfo = responseObject[RKeyData];
             completion(response,unitInfo);
         }
         else if(code == RCodeNoData)
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
-(void)spAddUnit:(NSDictionary *)parameterDict completionHandler:(void (^)(ACEAPIResponse *, NSDictionary *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/AddClientUnitSalesPerson",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:parameterDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:response.accessToken];
         
         if(response.code == RCodeSuccess)
         {
             NSDictionary *dictUnitInfo = responseObject[RKeyData];
             completion(response,dictUnitInfo);

         }
         else
         {
             completion(response,nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"OrderList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
@end
