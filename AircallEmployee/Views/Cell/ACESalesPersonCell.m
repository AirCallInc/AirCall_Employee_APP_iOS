//
//  ACESalesPersonCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACESalesPersonCell.h"

@implementation ACESalesPersonCell

@synthesize lblClientName,lblDate;

- (void)awakeFromNib
{
    
}
-(void)setCellData:(ACESalesPersonVisit *)sales
{
    lblClientName.text  = sales.clientName;
    lblDate.text        = sales.date;
    // remove start
    
//    NSDate *date = [[NSDate alloc]init];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
//
//    lblClientName.text = @"joseph Cerl";
//    lblDate.text = [formatter stringFromDate:date];
    //remove end
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
