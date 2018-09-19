//
//  ACEPartListCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 27/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEPartListCell.h"

@implementation ACEPartListCell
@synthesize lblQty,lblDate,lblPartName,lblClientName,imageView,lblStatus;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
-(void)setCellData:(ACEParts*)part
{
    lblQty.text         = part.Qty          ;
    lblPartName.text    = part.partName     ;
    lblClientName.text  = part.clientName   ;
    lblDate.text        = part.Date         ;
    lblStatus.text      = part.Status       ;
}
@end
