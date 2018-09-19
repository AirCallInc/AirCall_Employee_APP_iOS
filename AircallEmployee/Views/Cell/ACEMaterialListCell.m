//
//  MaterialListCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 02/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEMaterialListCell.h"

@implementation ACEMaterialListCell
@synthesize lblMaterialName,btnCheck,vwLbz,lblQnty,maxQty,incrQty;


- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
-(void)setCellData:(NSString *)partName
{
    lblMaterialName.text = partName;
    lblQnty.text = @"22";
    
    if([partName isEqualToString:@"refrigerent"])
    {
        vwLbz.hidden = NO;
    }
    else
    {
        vwLbz.hidden = YES;
    }
    
}
-(void)setUnitCellData:(NSString *)unitName
{
    lblMaterialName.text = unitName;
}
-(void)setRequestedPartCellData:(NSString *)name
{
    lblMaterialName.text = name;
    lblQnty.text = @"1";
}
- (IBAction)btnCheckTap:(UIButton *)btn
{
    if(btn.selected)
    {
        btn.backgroundColor = [UIColor redColor];
        btn.selected = NO;
    }
    else
    {
        btn.backgroundColor = [UIColor greenColor];
        btn.selected = YES;
    }

}
- (IBAction)btnPlusTap:(UIButton *)sender
{
    int qnty = [lblQnty.text intValue];
    
    if(qnty < maxQty)
    {
        qnty = qnty + incrQty;
        lblQnty.text = [NSString stringWithFormat:@"%d",qnty];
    }
}
- (IBAction)btnMinusTap:(UIButton *)sender
{
    int qnty = [lblQnty.text intValue];
    if(qnty > 1)
    {
        qnty = qnty - incrQty;
        lblQnty.text = [NSString stringWithFormat:@"%d",qnty];
    }
}
@end
