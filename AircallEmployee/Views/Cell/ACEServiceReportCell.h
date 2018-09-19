//
//  ACEServiceReportCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACEServiceReportCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblPurpose;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceNo;

-(void)setCellData:(ACEServiceReport *)report;

@end
