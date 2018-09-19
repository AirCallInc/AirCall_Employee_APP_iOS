//
//  ACEOrderTableViewCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACEOrderTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (strong, nonatomic) IBOutlet UILabel *lblChargeBy;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderNo;

-(void)setCellData:(ACEOrder*)order;
@end
