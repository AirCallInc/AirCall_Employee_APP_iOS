//
//  OpenImageViewcontroller.h
//  AircallEmployee
//
//  Created by ZWT111 on 30/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface OpenImageViewcontroller : ACEViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgv;

@property (strong, nonatomic) ACEServiceImage *unitImage;

@property (strong, nonatomic) NSArray *arrImages;

@property  NSInteger index;

@end
