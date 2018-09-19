//
//  ACESalesPersonRequestViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol SalesPersonRequest<NSObject>

-(void)submitSalesPerson;

@end

@interface SalesPersonRequestViewController : ACEViewController

@property (weak) id <SalesPersonRequest> delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrlvbg;
@property (strong, nonatomic) IBOutlet UIView *vwAddress;

@property (strong, nonatomic) IBOutlet UITableView *tblvAddress;
@property (strong, nonatomic) IBOutlet UIView *vwBelowAddress;

@end
