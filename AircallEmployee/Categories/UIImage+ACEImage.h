//
//  UIImage+ACEImage.h
//  AircallEmployee
//
//  Created by ZWT111 on 01/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ACEImage)

- (UIImage *)compressWithMaxSize:(CGSize)maxSize andQuality:(CGFloat)quality;
- (UIImage *)compressImages;
- (UIImage *)compressProfileImage;

@end
