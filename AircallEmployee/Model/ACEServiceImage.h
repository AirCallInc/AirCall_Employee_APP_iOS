//
//  ACEServiceImage.h
//  AircallEmployee
//
//  Created by ZWT112 on 4/1/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

extern NSString *const IMGKey    ;
extern NSString *const IMGKeyName;

typedef NS_ENUM(NSInteger, ACEImageStatus)
{
    ACEImageStatusPlaceholder,
    ACEImageStatusSet,
    ACEImageStatusUploding,
    ACEImageStatusUploded
};

@interface ACEServiceImage : NSObject

@property (strong, nonatomic) UIImage  *image    ;
@property (strong, nonatomic) NSString *fileName ;
@property (strong, nonatomic) NSURL    *imageURL ;

@property (nonatomic) ACEImageStatus status;

- (instancetype)initWithUIImage:(UIImage *)imageObject      ;
- (instancetype)initWithDictionary:(NSDictionary *)imageInfo;
- (instancetype)initWithUrl:(NSString *)urlString;

@end
