//
//  ACEOrderTableViewCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEOrderTableViewCell.h"

@implementation ACEOrderTableViewCell
@synthesize lblDate,lblPrice,lblOrderNo,lblChargeBy,lblClientName;
- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
-(void)setCellData:(ACEOrder*)order
{
    lblClientName.text = order.ClientName;
    lblChargeBy.text   = order.ChargeBy;
    //lblDate.text       = [NSString stringWithFormat:@"%@ %@",order.OrderDate,order.OrderTime];
    lblDate.text      = order.OrderDate;
    
    lblOrderNo.text = order.orderNo;
    lblPrice.text   = [NSString stringWithFormat:@"$%.02f",order.Price];
}
@end
