//
//  ACEFilterCell.h
//  AircallEmployee
//
//  Created by Manali on 01/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACEFilterCell : UITableViewCell


@property (weak, nonatomic) IBOutlet ACETextField *txtFilterSize;
@property (weak, nonatomic) IBOutlet ACETextField *txtCFilterSize;
@property (weak, nonatomic) IBOutlet UIButton *btnInsideEquipment;
@property (weak, nonatomic) IBOutlet UIButton *btnInsideSpace;
@property (weak, nonatomic) IBOutlet UILabel *lblFilterSize;
@property (weak, nonatomic) IBOutlet UILabel *lblFilterLocation;

@end
