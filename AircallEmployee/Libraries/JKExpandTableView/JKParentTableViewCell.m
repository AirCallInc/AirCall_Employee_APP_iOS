//
//  JKParentTableViewCell.m
//  ExpandTableView
//
//  Created by Jack Kwok on 7/5/13.
//  Copyright (c) 2013 Jack Kwok. All rights reserved.
//

#import "JKParentTableViewCell.h"

@implementation JKParentTableViewCell

@synthesize label,iconImage,selectionIndicatorImgView,parentIndex,selectionIndicatorImg,reportImage;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [[self contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    if(!self) {
        return self;
    }
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.reportImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    //[self.iconImage setContentMode:UIViewContentModeCenter];
    [self.contentView addSubview:iconImage];
    [self.contentView addSubview:reportImage];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.textColor = [UIColor darkTextColor];
    label.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:label];
    
    self.selectionIndicatorImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //[self.selectionIndicatorImgView setContentMode:UIViewContentModeCenter];
   // [self.contentView addSubview:selectionIndicatorImgView];
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setupDisplay];
}

- (void)setupDisplay {
    CGRect contentRect = [self bounds];
    CGFloat contentAreaWidth = self.contentView.bounds.size.width;
    CGFloat contentAreaHeight = self.contentView.bounds.size.height;
    CGFloat checkMarkHeight = 0.0;
    CGFloat checkMarkWidth = 0.0;
    CGFloat iconHeight = 0.0; //  set this according to icon
    CGFloat iconWidth = 0.0;
    
    CGFloat reportIconHeight = 0.0; //  set this according to icon
    CGFloat reportIconWidth = 0.0;
    
    if (self.iconImage.image)
    {
        //iconImage.transform = CGAffineTransformMakeRotation(M_PI * 2);

        iconWidth = MIN(contentAreaWidth, self.iconImage.image.size.width);
        iconHeight = MIN(contentAreaHeight, self.iconImage.image.size.height);
        iconWidth = 15;
        iconHeight = 15;
        
    }
    
    
    if (self.selectionIndicatorImgView.image)
    {
        checkMarkWidth = MIN(contentAreaWidth, self.selectionIndicatorImgView.image.size.width);
        checkMarkHeight = MIN(contentAreaHeight, self.selectionIndicatorImgView.image.size.height);
    }
    if(self.reportImage.image) //mine
    {
        reportIconWidth = MIN(contentAreaWidth, self.reportImage.image.size.width);
        reportIconHeight = MIN(contentAreaHeight, self.reportImage.image.size.height);
    }
    
    CGFloat sidePadding = 6.0;
    CGFloat icon2LabelPadding = 6.0;
    CGFloat checkMarkPadding = 16.0;
    [self.contentView setAutoresizesSubviews:YES];

   // self.iconImage.frame = CGRectMake(sidePadding, (contentAreaHeight - iconHeight)/2, iconWidth, iconHeight);
    
   
    
    self.reportImage.frame = CGRectMake(sidePadding, (contentAreaHeight - reportIconHeight)/2, reportIconWidth, reportIconHeight);
    
    CGFloat XOffset = reportIconWidth + sidePadding + icon2LabelPadding;
    
    CGFloat labelWidth = contentAreaWidth - XOffset - checkMarkWidth - checkMarkPadding;
    
    self.label.frame = CGRectMake(XOffset, 0, labelWidth, contentAreaHeight);
    //self.label.backgroundColor = [UIColor redColor];
    
    self.iconImage.frame = CGRectMake(contentAreaWidth - iconWidth - checkMarkPadding,
                                      (contentRect.size.height/2)-(iconHeight/2),
                                      iconWidth,
                                      iconHeight);
    
//    //self.selectionIndicatorImgView.frame = CGRectMake(contentAreaWidth - checkMarkWidth - checkMarkPadding,
//                                                 (contentRect.size.height/2)-(checkMarkHeight/2),
//                                                 checkMarkWidth,
//                                                 checkMarkHeight);
    
}

- (void)rotateIconToExpanded
{
    [UIView beginAnimations:@"rotateDisclosure" context:nil];
    [UIView setAnimationDuration:0.2];
    iconImage.transform = CGAffineTransformMakeRotation(M_PI * 2.5);
    [UIView commitAnimations];
    //iconImage.image = [UIImage imageNamed:@"downarrow"];
}

- (void)rotateIconToCollapsed {
    [UIView beginAnimations:@"rotateDisclosure" context:nil];
    [UIView setAnimationDuration:0.2];
    iconImage.transform = CGAffineTransformMakeRotation(M_PI * 2);
    [UIView commitAnimations];
   // iconImage.image = [UIImage imageNamed:@"nextarrow"];
}

- (void)selectionIndicatorState:(BOOL) visible {
    //
    visible = NO;
    if (!self.selectionIndicatorImg) {
        self.selectionIndicatorImg = [UIImage imageNamed:@"checkmark"];
    }
    self.selectionIndicatorImgView.image = self.selectionIndicatorImg;  // probably better to init this elsewhere
    if (visible) {
        self.selectionIndicatorImgView.hidden = NO;
    } else {
        self.selectionIndicatorImgView.hidden = YES;
    }
}

- (void)setCellForegroundColor:(UIColor *) foregroundColor {
    self.label.textColor = foregroundColor;
}

- (void)setCellBackgroundColor:(UIColor *) backgroundColor {
    self.contentView.backgroundColor = backgroundColor;
}

@end
