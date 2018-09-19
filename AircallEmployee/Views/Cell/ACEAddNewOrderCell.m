//
//  ACEAddNewOrderCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEAddNewOrderCell.h"

@implementation ACEAddNewOrderCell
@synthesize lblPartName,lblPrice,lblQnty;

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setCellData:(ACEOrderIteam *)iteam
{
    //lblPartName.text = iteam.part;
    //lblQnty.text     = [NSString stringWithFormat:@"%@",iteam.Qnty];
    //lblPrice.text    = [NSString stringWithFormat:@"%@",iteam.Price];
}

- (IBAction)btnPlusTap:(id)sender
{
    int qnty = [lblQnty.text intValue];
    if(qnty < 10)
    {
        qnty ++;
        lblQnty.text = [NSString stringWithFormat:@"%d",qnty];
    }
    
}
- (IBAction)btnMinusTap:(id)sender
{
    int qnty = [lblQnty.text intValue];
    if(qnty > 0)
    {
        qnty --;
        lblQnty.text = [NSString stringWithFormat:@"%d",qnty];
    }
}

@end
