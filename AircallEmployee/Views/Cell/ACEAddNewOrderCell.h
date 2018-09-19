//
//  ACEAddNewOrderCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACEAddNewOrderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblPartName;
@property (strong, nonatomic) IBOutlet UILabel *lblQnty;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet ACELabel *lblIndex;


-(void)setCellData:(ACEOrderIteam *)iteam;

@end
