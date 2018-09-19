//
//  SalesPersonViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface SalesPersonViewController : ACEViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblvSalesPersonData;
@property (strong, nonatomic) NSMutableArray *arrSalesPerson;

@end
