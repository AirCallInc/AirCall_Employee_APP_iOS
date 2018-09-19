//
//  NSString+ACEString.h
//  AircallEmployee
//
//  Created by ZWT111 on 07/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ACEString)


@property (NS_NONATOMIC_IOSONLY, readonly, strong) id jsonObject;

- (instancetype)initWithJSONObject:(id)jsonObject;

@end
