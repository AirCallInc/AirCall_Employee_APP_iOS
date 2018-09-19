//
//  ACELabel.m
//  AircallEmployee
//
//  Created by ZWT111 on 30/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACELabel.h"

@implementation ACELabel
@synthesize leftOffset;

-(void)awakeFromNib
{
    leftOffset             = 10;
    self.layer.borderColor = [UIColor separatorColor].CGColor;
    self.layer.borderWidth = 1.0;
}

- (void)drawTextInRect:(CGRect)rect
{
    
    UIEdgeInsets insets = {0, leftOffset, 0, leftOffset};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
    //[super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
