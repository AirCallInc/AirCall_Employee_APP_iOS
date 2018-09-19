//
//  ACEFilterCell.m
//  AircallEmployee
//
//  Created by Manali on 01/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEFilterCell.h"

@implementation ACEFilterCell
@synthesize txtFilterSize,txtCFilterSize,btnInsideSpace,btnInsideEquipment;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)prepareForReuse
{
    txtFilterSize.text = nil;
    txtCFilterSize.text = nil;
    txtFilterSize.placeholder = nil;
    txtCFilterSize.placeholder = nil;
    
    btnInsideEquipment.selected = NO;
    btnInsideSpace.selected     = NO;
}
@end
