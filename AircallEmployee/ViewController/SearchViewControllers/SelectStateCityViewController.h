//
//  SelectStateCityViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 09/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"
@protocol SelectedStateCity

-(void)selectedStatecity:(NSDictionary *)dict andIsstate:(BOOL)isSatate;

@end

@interface SelectStateCityViewController : ACEViewController

@property BOOL isState;

@property NSString *stateId ;
@property NSString *cityId  ;

@property id<SelectedStateCity> delegate;

@end
