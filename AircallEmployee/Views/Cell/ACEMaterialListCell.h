//
//  MaterialListCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 02/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACEMaterialListCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *lblMaterialName;
@property (strong, nonatomic) IBOutlet UIButton *btnCheck;
@property (strong, nonatomic) IBOutlet UIView  *vwLbz;
@property (strong, nonatomic) IBOutlet UILabel *lblQnty;
@property (strong, nonatomic) IBOutlet UILabel *lblPartQty;

@property int   maxQty  ;
@property float incrQty ;

-(void)setCellData:(NSString *)partName;

-(void)setUnitCellData:(NSString *)unitName;

-(void)setRequestedPartCellData:(NSString *)name;
@end
