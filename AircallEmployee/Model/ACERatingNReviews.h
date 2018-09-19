//
//  ACERatingNReviews.h
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const RKeyId          ;
extern NSString *const RKeyRateArray   ;
extern NSString *const RKeyRatings     ;
extern NSString *const RKeyPackageName ;
extern NSString *const RKeyReview      ;
extern NSString *const RKeyNotes       ;
extern NSString *const RKeyAverageRating;

@interface ACERatingNReviews : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *ContactName;
@property (strong, nonatomic) NSString *ServiceCaseNo;
@property (strong, nonatomic) NSString *Ratings;
@property (strong, nonatomic) NSString *Reviews;
@property (strong, nonatomic) NSString *Notes;
@property (strong, nonatomic) NSString *PackageName;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
