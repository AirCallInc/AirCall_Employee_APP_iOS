//
//  ACEFuseCell.m
//  AircallEmployee
//
//  Created by Manali on 01/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEFuseCell.h"

@implementation ACEFuseCell
@synthesize txtFuseType,txtCFuseType;
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
    txtFuseType.text = nil;
    txtCFuseType.text = nil;
    txtFuseType.placeholder = nil;
    txtCFuseType.placeholder = nil;
}
@end
