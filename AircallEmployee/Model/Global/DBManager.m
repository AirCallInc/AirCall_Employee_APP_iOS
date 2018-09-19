//
//  DBManager.m
//  AircallEmployee
//
//  Created by Manali on 09/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "DBManager.h"

static NSString  * databasePath;
static sqlite3   * database;

@implementation DBManager

#pragma mark - Helper Methods

+(NSString *) getDbFilePath
{
    NSString * docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:@"Aircall.db"];
}

+(void)copyDatabaseIntoDocumentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"Aircall.db"];
    
    if ([fileManager fileExistsAtPath:txtPath] == NO)
    {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"Aircall" ofType:@"db"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
}

#pragma mark - Create, Insert, Update, Delete operations on Table
+(BOOL)createTable:(const char *)query
{
    BOOL ans = NO;

    databasePath = [self getDbFilePath];
    
    NSFileManager * filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        const char * dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char * errMsg;
            
            if (sqlite3_exec(database, query, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                ans = YES;
            }
            else
            {
                ans = NO;
            }
            sqlite3_close(database);
        }
    }
    
    return ans;
}

// General Insert
+(BOOL)insertData:(NSString *)query //withStatement:(sqlite3_stmt *)statement
{
    databasePath = [self getDbFilePath];
    
    sqlite3_stmt  * statement;
    const char * dbpath = [databasePath UTF8String];
    
    BOOL ans = NO;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        const char * insert_stmt = [query UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,
                           -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            ans = YES;
        }
        else
        {
            ans = NO;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return ans;
}

//Insert ServiceData
+(BOOL)insertServiceData:(NSString *)serviceCaseNo workNotDone:(NSString *)workNotDone work_performed:(NSString *)workPerformed customerNotes:(NSString *)customerNotes clientEmail:(NSString *)clientEmail signature:(NSData *)signature
{
    databasePath = [self getDbFilePath];
    
    sqlite3_stmt  * statement;
    const char * dbpath = [databasePath UTF8String];
    
    BOOL ans = NO;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString * query  = @"INSERT INTO servicereport (service_case_no,work_not_done,work_performed,customer_notes,client_email,signature) VALUES (?,?,?,?,?,?)";
        
        const char * insert_stmt = [query UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,
                           -1, &statement, NULL);
        
        sqlite3_bind_text(statement, 1, [serviceCaseNo UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [workNotDone UTF8String], -1, SQLITE_TRANSIENT);;
        sqlite3_bind_text(statement, 3, [workPerformed UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [customerNotes UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [clientEmail UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_blob(statement, 6, [signature bytes],(int)[signature length], SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            ans = YES;
        }
        else
        {
            ans = NO;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }

    return ans;
}

//Get General Data
+(NSMutableArray *)getData:(NSString *)query whereStatement:(NSString *)whereStmt
{
    databasePath = [self getDbFilePath];
    
    const char     * dbpath = [databasePath UTF8String];
    sqlite3_stmt   * statement;
    NSMutableArray * arr;
    NSMutableArray * dataArray = [[NSMutableArray alloc]init];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        if(whereStmt)
        {
            query = [query stringByAppendingFormat:@" WHERE %@",whereStmt];
        }
        
        const char *query_stmt = [query UTF8String];
        
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                arr = [[NSMutableArray alloc] init];
                
                int totalColumns = sqlite3_column_count(statement);
                
                for (int i = 0 ; i < totalColumns ; i++)
                {
                    NSString * columndata = [[NSString alloc]initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, i)];
                    
                    [arr addObject:columndata];
                }
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
    }
    
    return dataArray;
}

// Get ServiceReport Data
+(NSDictionary *)getServiceData:(NSString *)whereStmt
{
    databasePath = [self getDbFilePath];
    
    const char     * dbpath = [databasePath UTF8String];
    sqlite3_stmt   * statement;
    int len = 0;
    NSDictionary * dicServiceData;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString  * query = @"SELECT * from servicereport";
        
        if(whereStmt)
        {
            query = [query stringByAppendingFormat:@" WHERE %@",whereStmt];
        }
        
        const char *query_stmt = [query UTF8String];
        
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString * work_not_done   =  [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSString * work_performed = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                NSString * customer_notes = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                NSString * client_email   = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                len = sqlite3_column_bytes(statement, 6);
                NSData *signData = [[NSData alloc] initWithBytes: sqlite3_column_blob(statement, 6) length: len];
                
                UIImage *imgSign = [[UIImage alloc] initWithData:signData];
                
                dicServiceData =[NSDictionary dictionaryWithObjectsAndKeys:work_not_done,@"workNotDone",work_performed,@"workPerformed",customer_notes,@"customerNotes", client_email,@"client_email",imgSign,@"signature",nil];
                
                // NSLog(@"name: %@, age=%ld , marks =%ld",name,(long)age,(long)marks);
                
                NSLog(@"Service Data Dic:%@",dicServiceData);
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
    }
    
    return dicServiceData;
}

// Delete All Records of Table
+(BOOL)deleteAllRecords:(NSString *)tableName
{
    databasePath = [self getDbFilePath];
    
    sqlite3_stmt  * statement;
    const char *dbpath = [databasePath UTF8String];
    BOOL ans           = NO;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM \"%@\"",tableName];
        
        const char *insert_stmt = [query UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,
                           -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            ans = YES;
        }
        else
        {
            ans = NO;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    return ans;
}

@end
