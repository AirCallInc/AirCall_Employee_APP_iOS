//
//  NSString+ACEString.m
//  AircallEmployee
//
//  Created by ZWT111 on 07/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "NSString+ACEString.h"

@implementation NSString (ACEString)

- (instancetype)initWithJSONObject:(id)jsonObject
{
    self = [self init];
    
    if(self)
    {
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&error];
        
        if (!jsonData)
        {
            DDLogError(@"Got an error: %@", error);
            
            return Nil;
        }
        else
        {
            self = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            return self;
        }
    }
    
    return self;
}

- (id)jsonObject
{
    NSError *error;
    
    id JSON = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                              options:NSJSONReadingMutableContainers
                                                error:&error];
    return JSON;
}

@end
