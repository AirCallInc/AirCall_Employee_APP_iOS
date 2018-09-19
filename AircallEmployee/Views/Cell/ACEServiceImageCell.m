//
//  ACEServiceImageCell.m
//  AircallEmployee
//
//  Created by ZWT112 on 4/1/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEServiceImageCell.h"
@interface ACEServiceImageCell()
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@end

@implementation ACEServiceImageCell
@synthesize serviceImage,imgvService,btnDelete,viewIndicator;

- (void)setServiceImage:(ACEServiceImage *)servicePhoto
{
    serviceImage = servicePhoto;
    
    imgvService.image = serviceImage.image;
    
    switch (serviceImage.status)
    {
        case ACEImageStatusPlaceholder:
        {
            imgvService.layer.borderColor = [UIColor clearColor].CGColor;
            btnDelete.hidden = YES;
            
            [viewIndicator startAnimating];
            
            imgvService.contentMode = UIViewContentModeScaleToFill;
            
            break;
        }
        case ACEImageStatusSet:
        {
            imgvService.layer.borderColor = [UIColor clearColor].CGColor;
            btnDelete.hidden = NO;
            
           [viewIndicator startAnimating];
            
            imgvService.contentMode = UIViewContentModeScaleToFill;
            
            break;
        }
        case ACEImageStatusUploding:
        {
            imgvService.layer.borderColor = [UIColor clearColor].CGColor;
            btnDelete.hidden = YES;
            
            viewIndicator.hidden = NO;
            
            [viewIndicator startAnimating];
            
            imgvService.contentMode = UIViewContentModeScaleToFill;
            
            break;
        }
        case ACEImageStatusUploded:
        {
            imgvService.layer.borderColor = [UIColor blackColor].CGColor;
            imgvService.layer.borderWidth = 2.0;
            btnDelete.hidden = NO;
            
            viewIndicator.hidden = YES;
            
            [viewIndicator stopAnimating];
            
            imgvService.contentMode = UIViewContentModeScaleToFill;
            
            break;
        }
    }
}
@end
