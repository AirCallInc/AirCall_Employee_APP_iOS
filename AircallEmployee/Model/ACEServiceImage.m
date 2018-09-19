//
//  ACEServiceImage.m
//  AircallEmployee
//
//  Created by ZWT112 on 4/1/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEServiceImage.h"

NSString *const IMGKey     = @"v_image"     ;
NSString *const IMGKeyName = @"v_image_name";

@implementation ACEServiceImage
@synthesize image,imageURL,status,fileName;

- (instancetype)initWithUIImage:(UIImage *)imageObject
{
    self = [super init];
    
    if(self)
    {
        image = imageObject;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)imageInfo
{
    self = [super init];
    
    if(self)
    {
        fileName = imageInfo[IMGKeyName];
        status   = ACEImageStatusUploded;
    }
    return self;
}
-(instancetype)initWithUrl:(NSString *)urlString
{
    self = [super init];
    if(self)
    {
        imageURL = [NSURL URLWithString:urlString];
        status   =  ACEImageStatusUploded;
    }
    return self;
}
@end
