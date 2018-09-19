//
//  JKSubTableViewCellCell.m
//  ExpandTableView
//
//  Created by Jack Kwok on 7/5/13.
//  Copyright (c) 2013 Jack Kwok. All rights reserved.
//

#import "JKSubTableViewCellCell.h"

@implementation JKSubTableViewCellCell
@synthesize titleLabel, iconImage, selectionIndicatorImg,lblQnty;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [[self contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    if(!self)
        return self;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImage      = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:iconImage];
    
    self.titleLabel     = [[UILabel alloc] initWithFrame:CGRectZero];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.opaque          = NO;
    titleLabel.textColor       = [UIColor blackColor];
    titleLabel.textAlignment   = NSTextAlignmentLeft;
    
    [self.contentView addSubview:titleLabel];
    
    self.selectionIndicatorImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:selectionIndicatorImg];
    
    //mine code
    self.lblQnty            = [[UILabel alloc]initWithFrame:CGRectZero];
    lblQnty.backgroundColor = [UIColor clearColor];
    lblQnty.opaque          = NO;
    lblQnty.textColor       = [UIColor blackColor];
    lblQnty.textAlignment   = NSTextAlignmentRight;
    [self.contentView addSubview:self.lblQnty];
    // mine code
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self setupDisplay];
}

- (void) setupDisplay {
    CGRect contentRect          = [self bounds];
    CGFloat contentAreaWidth    = self.contentView.bounds.size.width;
    CGFloat contentAreaHeight   = self.contentView.bounds.size.height;
    CGFloat checkMarkHeight     = 0.0;
    CGFloat checkMarkWidth      = 0.0;
    CGFloat iconHeight          = 0.0; //  set this according to icon
    CGFloat iconWidth           = 0.0;
    
    if (self.iconImage.image) {
        iconWidth = MIN(contentAreaWidth, self.iconImage.image.size.width);
        iconHeight = MIN(contentAreaHeight, self.iconImage.image.size.height);
    }
    if (self.selectionIndicatorImg.image) {
        checkMarkWidth = MIN(contentAreaWidth, self.selectionIndicatorImg.image.size.width);
        checkMarkHeight = MIN(contentAreaHeight, self.selectionIndicatorImg.image.size.height);
    }
    
    CGFloat sidePadding = 22.0;
    CGFloat icon2LabelPadding = 6.0;
    CGFloat checkMarkPadding = 16.0;
    [self.contentView setAutoresizesSubviews:YES];
    
    self.iconImage.frame = CGRectMake(sidePadding, (contentAreaHeight - iconHeight)/2, iconWidth, iconHeight);
    //self.iconImage.backgroundColor = [UIColor blueColor];
    
    CGFloat XOffset = iconWidth + sidePadding + icon2LabelPadding;
    
    CGFloat labelWidth = contentAreaWidth - XOffset - checkMarkWidth - checkMarkPadding-10;
    self.titleLabel.frame = CGRectMake(XOffset, 0, labelWidth, contentAreaHeight);

    //self.titleLabel.backgroundColor = [UIColor purpleColor];
    //self.selectionIndicatorImg.backgroundColor = [UIColor yellowColor];
    
    self.selectionIndicatorImg.frame = CGRectMake(contentAreaWidth - checkMarkWidth - checkMarkPadding,
                                                      (contentRect.size.height/2)-(checkMarkHeight/2),
                                                      checkMarkWidth,
                                                      checkMarkHeight);
    
    //mine code
    self.lblQnty.frame = CGRectMake(labelWidth ,
                                                  (contentRect.size.height/2)-(checkMarkHeight/2)-10,
                                                 45,
                                                 20);
    
}

- (void)setCellForegroundColor:(UIColor *) foregroundColor {
    titleLabel.textColor = foregroundColor;
}

- (void)setCellBackgroundColor:(UIColor *) backgroundColor {
    self.contentView.backgroundColor = backgroundColor;
}


@end
