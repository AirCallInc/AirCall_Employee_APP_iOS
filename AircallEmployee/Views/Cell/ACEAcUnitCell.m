//
//  ACEAcUnitCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEAcUnitCell.h"

@implementation ACEAcUnitCell
@synthesize lblDate,lblUnitName,lblclientName,lblStatus;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellData:(ACEACUnit*)acunit
{
    lblUnitName.text    = acunit.unitName   ;
    lblclientName.text  = acunit.clientName ;
    NSString *date = [ACEUtil convertDate:[NSString stringWithFormat:@"%@",acunit.serviceDate]];
    
    lblDate.text = [NSString stringWithFormat:@"%@  %@",date,acunit.serviceTime];
    if(acunit.isMatched)
    {
        lblStatus.text = @"Matched";
        lblStatus.textColor = [UIColor appGreenColor];
    }
    else
    {
        lblStatus.text = @"UnMatched";
        lblStatus.textColor = [UIColor redColor];
    }
        
}
@end
