//
//  ACEServiceReportCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEServiceReportCell.h"

@implementation ACEServiceReportCell

@synthesize lblClientName,lblPurpose,lblTime,lblServiceNo;

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)setCellData:(ACEServiceReport *)report
{
    lblClientName.text = report.ClientName  ;
    lblPurpose.text    = report.Purpose     ;
    lblServiceNo.text  = report.reportNumber;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    
//    [formatter setDateFormat:@"MMM d, yyyy HH:mm a"];
//    
//    NSString *stringFromDate = [formatter stringFromDate:report.date];
    lblTime.text             = report.date;
}

@end
