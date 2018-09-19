//
//  UnitSummaryCell.m
//  AircallEmployee
//
//  Created by Manali on 04/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "UnitSummaryCell.h"

@implementation UnitSummaryCell

@synthesize llbNo,lblQty,lblPayType,lblUnitName,lblPrice;

- (void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setCellData:(NSDictionary *)dict
{
    lblQty.text      = @"1";
    lblUnitName.text = [NSString stringWithFormat:@"%@ - %@",dict[ACKeyNameOfUnit],dict[GPlanName]];
    lblPayType.text  = dict[ACKeyPlanType];
    float price      = [dict[GPrice]floatValue];
    lblPrice.text    = [NSString stringWithFormat:@"$%0.2f",price];
}

@end
