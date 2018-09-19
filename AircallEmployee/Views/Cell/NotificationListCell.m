//
//  NotificationListCell.m
//  AircallEmployee
//
//  Created by ZWT111 on 30/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "NotificationListCell.h"

@implementation NotificationListCell
@synthesize lblNotiMsg,lblDateTime;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}
-(void)setCellData:(ACENotification *)noti
{
    lblDateTime.text  = noti.dateTime;
    
    if([noti.notificationStatus isEqualToString:@"UnRead"])
    {
         self.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.95 alpha:1.0];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    
     CGSize constraint;
    if(ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone6Plus)
    {
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.30 , FLT_MAX);
    }
   else if (ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone6)
    {
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.35 , FLT_MAX);
    }
    else
    {
         constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.45 , FLT_MAX);
    }
    
     UIFont *font = [self setFontSize];

    // NSString *str = [NSString stringWithFormat:@"%@\n\n%@",noti.message,noti.dateTime];
    
    CGSize size = [noti.message boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font}context:nil].size;
    
   
    
    lblNotiMsg.numberOfLines = 0;
    lblNotiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    
    lblNotiMsg.frame = CGRectMake(lblNotiMsg.x, lblNotiMsg.y, size.width, size.height);
    
    lblNotiMsg.font = font;
    lblNotiMsg.text = noti.message;
    
    lblDateTime.frame = CGRectMake(lblDateTime.x, CGRectGetMaxY(lblNotiMsg.frame) + 10, lblDateTime.width, lblDateTime.height);
   
}
-(UIFont*)setFontSize
{
    UIFont *font;
    if(ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone4)
    {
        font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if (ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone5)
    {
        font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if (ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone6)
    {
        font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else
    {
        font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    
    return font;
}
@end
