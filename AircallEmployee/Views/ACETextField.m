//
//  ACETextField.m
//  AircallEmployee
//
//  Created by ZWT112 on 4/2/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACETextField.h"

@implementation ACETextField

@synthesize rightOffset,borderColor,leftOffset;

- (void)awakeFromNib
{
    rightOffset = 10;
    leftOffset  = 10;
    
    borderColor = [UIColor separatorColor];
    
    //borderColor = [UIColor borderColor];
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0;
    
    self.font = [UIFont fontWithName:@"OpenSans" size:15];
    UIColor *color = [UIColor placeholderColor];
    if (self.placeholder != nil)
    {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
}

//- (void)drawRect:(CGRect)rect
//{
//    UIEdgeInsets insets = {0, rightOffset, 0, leftOffset};
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, rightOffset, 0, leftOffset);
    
    return UIEdgeInsetsInsetRect(rect, insets);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, rightOffset, 0, leftOffset);
    
    return UIEdgeInsetsInsetRect(rect, insets);
}

@end
