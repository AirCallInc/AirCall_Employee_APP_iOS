//
//  ACEOrderReceiptCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 08/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACEOrderReceiptCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblPartName;
@property (strong, nonatomic) IBOutlet UILabel *lblQnty;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet ACELabel *lblIndex;

-(void)setOrderDetailCellData:(ACEOrderIteam *)orderIteam;

@end
