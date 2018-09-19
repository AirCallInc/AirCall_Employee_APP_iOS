//
//  ACCMessageBar.h
//  AssetArbor
//
//  Created by Manali on 29/01/16.
//  Copyright © 2016 com.ztt.www. All rights reserved.
//

extern NSInteger const ACEValidationMsgHeight    ;
extern NSInteger const ACEValidationMsgFontHeight;
extern NSString *const ACEValidationMsgFont      ;

@interface ACEMessageBar : UIControl

@property (strong, nonatomic) NSString *message    ;
@property (weak, nonatomic)   UIView   *relatedView;

- (void)prepareForError;

@end
