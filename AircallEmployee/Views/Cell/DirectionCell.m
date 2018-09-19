//
//  DirectionCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 27/10/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "DirectionCell.h"

@implementation DirectionCell
@synthesize lblDirection;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
-(void)setCellData:(MKRouteStep *)step
{
    CGSize constraint;
    if(ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone6Plus)
    {
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.30 , FLT_MAX);
    }
    else if (ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone6)
    {
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.35 , FLT_MAX);
    }
    else
    {
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.45 , FLT_MAX);
    }
    
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:15];
    
    NSString *str = [NSString stringWithFormat:@"%0.2f Miles\n%@",(step.distance * 0.000621371192),step.instructions];
    
    NSLog(@"cell str : %@",str);
    
    CGSize size = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font}context:nil].size;
    
    lblDirection.numberOfLines = 0;
    lblDirection.lineBreakMode = NSLineBreakByWordWrapping;
    
    lblDirection.frame = CGRectMake(lblDirection.x, lblDirection.y, size.width, size.height);
    
    lblDirection.font = font;
    lblDirection.text = str;

}
-(UIFont*)setFontSize
{
    UIFont *font;
    if(ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone4)
    {
        font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if (ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone5)
    {
        font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if (ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone6)
    {
        font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else
    {
        font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    
    return font;
}

@end
