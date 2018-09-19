//
//  ACERatingCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACERatingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (strong, nonatomic) IBOutlet UILabel *lblReview;

@property (strong, nonatomic) IBOutlet HCSStarRatingView *ratingView;

-(void)setCellData:(ACERatingNReviews *)rate;

@end
