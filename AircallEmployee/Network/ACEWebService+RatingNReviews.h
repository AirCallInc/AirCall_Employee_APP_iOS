//
//  ACEWebService+RatingNReviews.h
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEWebService.h"

@interface ACEWebService (RatingNReviews)

-(void)getReviewsNRatingList:(NSString *)userID completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *, CGFloat rate))completion;

-(void)sendReviewNotes:(NSDictionary *)reviewNotesInfo completionHandler:(void (^)(ACEAPIResponse *response))completion;

-(void)sendSalesPersonRequest:(NSDictionary*)dictInfo completionHandler:(void (^)(ACEAPIResponse *response))completion;

-(void)getSalesPersonVisitList:(NSDictionary *)userID completionHandler:(void (^)(ACEAPIResponse *, NSMutableArray *,NSString *))completion;

-(void)getRatingDetail:(NSDictionary *)rateId completionHandler:(void(^)(ACEAPIResponse *,ACERatingNReviews *))completion;

@end
