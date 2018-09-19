//
//  ACEOrderReceiptCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 08/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEOrderReceiptCell.h"

@implementation ACEOrderReceiptCell
@synthesize lblQnty,lblIndex,lblPrice,lblPartName;

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderDetailCellData:(ACEOrderIteam *)orderIteam
{
    lblQnty.text     = [NSString stringWithFormat:@"%d", orderIteam.PartQnty];
    lblPartName.text = [NSString stringWithFormat:@"%@ %@",orderIteam.PartName,orderIteam.PartSize];
    lblPrice.text    = [NSString stringWithFormat:@"$%.02f",(orderIteam.PartPrice * orderIteam.PartQnty)];
}

@end
