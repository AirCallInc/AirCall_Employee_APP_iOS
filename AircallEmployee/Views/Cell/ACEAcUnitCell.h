//
//  ACEAcUnitCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACEAcUnitCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblclientName;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitName;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

-(void)setCellData:(ACEACUnit*)acunit;

@end
