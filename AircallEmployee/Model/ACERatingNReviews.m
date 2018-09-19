//
//  ACERatingNReviews.m
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACERatingNReviews.h"

NSString *const RKeyId                 = @"RatingReviewId";
NSString *const RKeyRateArray          = @"RatingReview";
NSString *const RKeyRatings            = @"Rating";
NSString *const RKeyPackageName        = @"PackageName";
NSString *const RKeyReview             = @"Review";
NSString *const RKeyNotes              = @"EmpNotes";
NSString *const RKeyAverageRating      = @"AverageRating";

@implementation ACERatingNReviews

@synthesize ID,ContactName,ServiceCaseNo,Reviews,Ratings,Notes,PackageName;

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(dict.count == 0)
    {
        return nil;
    }
    
    if(self = [super init])
    {
        ID              = dict[RKeyId];
        ContactName     = dict[SRKeyClientName];
        ServiceCaseNo   = dict[SDKeyServiceCaseNumber];
        Reviews         = dict[RKeyReview];
        Ratings         = dict[RKeyRatings];
        PackageName     = dict[RKeyPackageName];
        Notes           = dict[RKeyNotes];
    }
    return self;
}


@end
