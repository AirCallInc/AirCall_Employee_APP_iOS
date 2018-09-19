//
//  UnitSummaryCell.h
//  AircallEmployee
//
//  Created by Manali on 04/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitSummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *llbNo;
@property (weak, nonatomic) IBOutlet UILabel *lblUnitName;
@property (weak, nonatomic) IBOutlet UILabel *lblQty;
@property (weak, nonatomic) IBOutlet UILabel *lblPayType;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;

-(void)setCellData:(NSDictionary *)dict;

@end
