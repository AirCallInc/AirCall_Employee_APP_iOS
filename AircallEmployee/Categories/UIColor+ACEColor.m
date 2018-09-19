//
//  UIColor+ACEColor.m
//  AircallEmployee
//
//  Created by ZWT112 on 4/2/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "UIColor+ACEColor.h"

@implementation UIColor (ACEColor)
+(UIColor *)borderColor
{
    return [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
}
+(UIColor*)placeholderColor
{
    return [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.0];
}
+(UIColor*)appGreenColor
{
    return [UIColor colorWithRed:0.023 green:0.76 blue:0.80 alpha:1.0];
}
+(UIColor*)selectedBackgroundColor
{
    return [UIColor colorWithRed:0.91 green:0.92 blue:0.95 alpha:1.0];
}
+(UIColor *)separatorColor
{
    return [UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0];
}
+(UIColor *)fontColor
{
     return [UIColor colorWithRed:57/255.0f green:57/255.0f blue:57/255.0f alpha:1.0];
}
+(UIColor *)headerColor
{
    return [UIColor colorWithRed:0.09 green:0.31 blue:0.53 alpha:1.0];
}
@end
