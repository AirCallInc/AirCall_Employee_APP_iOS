//
//  AddOrderReceiptViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 08/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface AddOrderReceiptViewController : ACEViewController

@property (strong, nonatomic) IBOutlet UITableView *tblvPartList;
@property (strong, nonatomic) IBOutlet UIButton *btndDashboard;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;

@property NSDictionary *dictReceiptData;
@end
