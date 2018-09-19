//
//  ACESearchUserCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACESearchUserCell.h"

@implementation ACESearchUserCell

@synthesize lblClientName,lblClientEmail;

- (void)awakeFromNib
{
    
}
-(void)setCellData:(ACEClient *)client
{
    lblClientName.text  = client.Name;
    lblClientEmail.text = client.email;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
