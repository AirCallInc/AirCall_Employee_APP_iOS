//
//  ACEWebService+RatingNReviews.m
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService+RatingNReviews.h"

@implementation ACEWebService (RatingNReviews)

-(void)getReviewsNRatingList:(NSString *)userID completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *, CGFloat rate))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetServiceRatingReviewList?EmployeeId=%@",UKeyUrlEndpoint,ACEGlobalObject.user.userID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code    = [responseObject[RKeyCode]integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token = responseObject[RKeyToken];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
        
        [ACEUtil updateAccessToken:token];
        
        if(code == RCodeSuccess)
        {
            NSArray *arrRateList = responseObject[RKeyData][RKeyRateArray];
            
            NSMutableArray *arrRateInfo = @[].mutableCopy;
            
            CGFloat rate = [responseObject[RKeyData][RKeyAverageRating] floatValue];
            
            [arrRateList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull rate, NSUInteger idx, BOOL*  _Nonnull stop)
             {
                 ACERatingNReviews *rating = [[ACERatingNReviews alloc]initWithDictionary:rate];
                 
                 [arrRateInfo addObject:rating];
             }];
            
            completion(response,arrRateInfo,rate);
        }
        else
        {
            completion(response, nil,0);
        }
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"getReviewsNRatingList Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response, nil,0);
    }];
}
-(void)getRatingDetail:(NSDictionary *)rateId completionHandler:(void (^)(ACEAPIResponse *, ACERatingNReviews *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetServiceRatingReviewDetail",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:rateId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             
            ACERatingNReviews *rating = [[ACERatingNReviews alloc]initWithDictionary:responseObject[RKeyData]];
             
             completion(response,rating);
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
-(void)sendReviewNotes:(NSDictionary *)reviewNotesInfo completionHandler:(void (^)(ACEAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/SubmitEmployeeNotesOnRating",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:reviewNotesInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode]integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:message andAccessToken:token];
         
         [ACEUtil updateAccessToken:token];
         
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
         DDLogError(@"SendReviewNotes Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)sendSalesPersonRequest:(NSDictionary*)dictInfo completionHandler:(void (^)(ACEAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/SubmitSalesVisitRequest",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:dictInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code = [responseObject [RKeyCode]integerValue];
         NSString *msg = responseObject[RKeyMessage];
         NSString *token = responseObject[RKeyToken];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:msg andAccessToken:token];
        [ACEUtil updateAccessToken:token];
         
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
         DDLogError(@"sendSalesPersonRequest Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
         
     }];

}
-(void)getSalesPersonVisitList:(NSDictionary *)userID completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *,NSString *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetSalesVisitRequestList",UKeyUrlEndpoint];
    
    [self POST:resourceAddress parameters:userID progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code = [responseObject [RKeyCode]integerValue];
        NSString *msg = responseObject[RKeyMessage];
        NSString *token = responseObject[RKeyToken];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:code andMessage:msg andAccessToken:token];
        
        [ACEUtil updateAccessToken:token];
        
        NSArray *arrSalesList = responseObject[RKeyData];
        NSString *pageNumber = [responseObject[GKeyPageNumber]stringValue];
        NSMutableArray *salesList = @[].mutableCopy;
        
        if (code == RCodeSuccess)
        {
            [arrSalesList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull sales, NSUInteger idx, BOOL*  _Nonnull stop)
             {
                 ACESalesPersonVisit *unitDetail = [[ACESalesPersonVisit alloc]initWithDictionary:sales];
                 [salesList addObject:unitDetail] ;
             }];
            
            completion(response,salesList,pageNumber);
        }
        else
        {
            completion(response, nil, pageNumber);
        }
        
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"getSalesPersonVisit Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACEAPIResponse *response = [[ACEAPIResponse alloc]initWithCode:RCodeRequestFail andError:error];
        
        completion(response, nil, nil);
        
    }];
}
@end
