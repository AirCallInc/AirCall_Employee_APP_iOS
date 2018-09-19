//
//  RequestPartViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol RequestPartViewControllerDelegate <NSObject>

-(void)requestedPartDetail:(NSDictionary *)dict;

@end

@interface RequestPartViewController : ACEViewController

@property BOOL isFromServiceReport          ;
@property BOOL isEditable                   ;
@property NSMutableArray *arrAddress        ;
@property NSMutableArray *arrunit           ;
@property NSString       *clientName        ;
@property NSString       *empRequestId      ;
@property NSString       *partId            ;

@property (nonatomic) id<RequestPartViewControllerDelegate> delegate;

@end
