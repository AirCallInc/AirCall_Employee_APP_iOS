//
//  UIImage+ACEImage.m
//  AircallEmployee
//
//  Created by ZWT111 on 01/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "UIImage+ACEImage.h"

static const CGSize allImageSize = {400, 700};
static const CGFloat allImageQuality = 0.5;

static const CGSize profileImageSize = {100, 100};
static const CGFloat profileImageQuality = 0.5; //50 percent compression

@implementation UIImage (ACEImage)

- (UIImage *)compressWithMaxSize:(CGSize)maxSize andQuality:(CGFloat)quality
{
    CGFloat actualHeight = self.size.height;
    CGFloat actualWidth  = self.size.width;
    
    CGFloat imgRatio = actualWidth / actualHeight;
    CGFloat maxRatio = maxSize.width / maxSize.height;
    
    if (actualHeight > maxSize.height || actualWidth > maxSize.width)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            
            imgRatio     = maxSize.height / actualHeight;
            actualWidth  = imgRatio * actualWidth;
            actualHeight = maxSize.height;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            
            imgRatio     = maxSize.width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth  = maxSize.width;
        }
        else
        {
            actualHeight = maxSize.height;
            actualWidth  = maxSize.width;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth , actualHeight);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2.0);
    
    [self drawInRect:rect];
    
    UIImage *img       = UIGraphicsGetImageFromCurrentImageContext();
    NSData  *imageData = UIImageJPEGRepresentation(img, quality);
    
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}

- (UIImage *)compressImages
{
    return [self compressWithMaxSize:allImageSize andQuality:allImageQuality];
}

- (UIImage *)compressProfileImage
{
    return [self compressWithMaxSize:profileImageSize andQuality:profileImageQuality];
}

@end
