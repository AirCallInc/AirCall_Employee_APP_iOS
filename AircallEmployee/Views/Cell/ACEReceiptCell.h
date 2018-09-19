//
//  ACEReceiptCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 17/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACEReceiptCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblUnitName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblPlanName;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentMethod;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentError;
@property (weak, nonatomic) IBOutlet UIButton *btnPaymentProcess;

-(void)setCellData:(NSDictionary *)unitInfo;
-(void)setCellDataForCheckNPO:(NSDictionary *)unitInfo;

@end
