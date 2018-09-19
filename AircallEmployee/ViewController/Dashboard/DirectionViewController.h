//
//  DirectionViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 27/10/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol DirectionViewControllerDelegate <NSObject>

-(void)selectedDirection:(MKPolyline *)line;

@end

@interface DirectionViewController : ACEViewController

@property NSMutableArray *arrInfo;
@property NSString       *strTime;

@property id<DirectionViewControllerDelegate> delegate;

@end
