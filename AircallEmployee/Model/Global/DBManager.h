//
//  DBManager.h
//  AircallEmployee
//
//  Created by Manali on 09/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+(NSString *) getDbFilePath;

+(void)copyDatabaseIntoDocumentsDirectory;

+(BOOL)insertData:(NSString *)query;

+(BOOL)createTable:(const char *)query;

@end
