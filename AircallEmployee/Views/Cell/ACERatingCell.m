//
//  ACERatingCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACERatingCell.h"

@implementation ACERatingCell

@synthesize lblClientName,lblReview,ratingView;

- (void)awakeFromNib
{
  
}
-(void)setCellData:(ACERatingNReviews *)rate
{
    lblClientName.text  = rate.ContactName;
    lblReview.text      = rate.Reviews;
    ratingView.value    = [rate.Ratings floatValue];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated]; 
}

@end
