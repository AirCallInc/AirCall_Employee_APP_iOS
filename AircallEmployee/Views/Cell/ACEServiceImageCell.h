//
//  ACEServiceImageCell.h
//  AircallEmployee
//
//  Created by ZWT112 on 4/1/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACEServiceImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgvService   ;

@property (weak, nonatomic) IBOutlet UIImageView *imgvAcUnit    ;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *viewIndicator;


@property (weak, nonatomic) ACEServiceImage *serviceImage;

@end
