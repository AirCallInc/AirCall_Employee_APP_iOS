//
//  ACEReceiptCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 17/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEReceiptCell.h"

@implementation ACEReceiptCell

@synthesize lblPlanName,lblPrice,lblUnitName,lblPaymentMethod,indicator,lblPaymentError,btnPaymentProcess;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellData:(NSDictionary *)unitInfo
{
    if ([unitInfo[GPaymentStatus] isEqualToString:@"Received"])
    {
        indicator.hidden = YES;
        [indicator stopAnimating];
        [btnPaymentProcess setTitleColor:[UIColor appGreenColor] forState:UIControlStateNormal];
        [btnPaymentProcess setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        [btnPaymentProcess setTitle:unitInfo[GPaymentStatus] forState:UIControlStateNormal];
    }
    else if ([unitInfo[GPaymentStatus] isEqualToString:@"Processing"])
    {
        if (indicator.hidden == YES)
        {
            indicator.hidden = NO;
        }
        
        [btnPaymentProcess setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnPaymentProcess setTitle:unitInfo[GPaymentStatus] forState:UIControlStateNormal];
        
        if (!indicator.isAnimating)
        {
            [indicator startAnimating];
        }
        
    }
    else
    {
        indicator.hidden = YES;
        [indicator stopAnimating];
        [btnPaymentProcess setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btnPaymentProcess setImage:[UIImage imageNamed:@"Error"] forState:UIControlStateNormal];
        [btnPaymentProcess setTitle:unitInfo[GPaymentStatus] forState:UIControlStateNormal];
        
        if (unitInfo[GPaymentError] == nil || [unitInfo[GPaymentError] isEqualToString:@""])
        {
            lblPaymentError.text = @"";
        }
        else
        {
            lblPaymentError.text = [NSString stringWithFormat:@"* %@",unitInfo[GPaymentError]];
        }
    }
    
    lblUnitName.text = unitInfo[ACKeyNameOfUnit];
    lblPlanName.text = unitInfo[GPlanName];
    lblPrice.text    = [NSString stringWithFormat:@"$%0.2f",[unitInfo[GPrice]floatValue]];
    
    lblPaymentMethod.text = [NSString stringWithFormat:@"(%@)", unitInfo[ACKeyPlanType]];
}
-(void)setCellDataForCheckNPO:(NSDictionary *)unitInfo
{
    lblUnitName.text = unitInfo[ACKeyNameOfUnit];
    lblPlanName.text = unitInfo[GPlanName];
    lblPrice.text    = [NSString stringWithFormat:@"$%0.2f",[unitInfo[GPrice]floatValue]];
    
    lblPaymentMethod.text = [NSString stringWithFormat:@"(%@)", unitInfo[ACKeyPlanType]];
    
    indicator.hidden = YES;
    [indicator stopAnimating];
    btnPaymentProcess.hidden = YES;
    
    self.height = lblPlanName.y + lblPaymentMethod.height + 20;
    
}
@end
