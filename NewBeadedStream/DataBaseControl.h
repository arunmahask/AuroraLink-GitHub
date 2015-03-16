//
//  DataBaseControl.h
//  New_Database
//
//  Created by fsp on 7/1/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource_1.h"
#import "LoggerSource.h"
#import <sqlite3.h>

@interface DataBaseControl : NSObject<UIAlertViewDelegate>
{
    
//Object to access the local database in the handheld device
    sqlite3 *databaseHandle;
    
//Object declaration to store the local memory location
    NSArray *paths;
    NSString *documentDirectroy;
    NSString *databasePath;
    NSString *fileName;
    NSString *filecontent,*filePath;
    
//object to create show the functionality alert to the user
    UIAlertView *databaseop,*UAlert;
    NSString *name12,*email12;
}

//Method declaration

-(void)initDatabase; 
-(void)insertDataforDetail:(DataSource_1 *)datasoruce;
-(void)insertDataforLogger:(LoggerSource *)loggersource;
-(void)insertDataforSettings:(NSString *)name mailaddress:(NSString *)email;
-(void)viewdetailData;

-(void)logfile:(NSString *)infoEntry;
-(void)updatesetting:(NSString *)name1 Email:(NSString *)email1;
-(void)readLog;

-(NSString *)getTime:(NSString *)loggername;
-(NSString *)getDownloadedTime:(NSString *)loggername;

//****** Method with some return value in array format ******//

-(NSMutableArray *)getHistoryInfo;
-(NSMutableArray *)getLoggerDetail:(NSString *)setLoggerName;
-(NSMutableArray *)Selectview;

-(void)deleteRow:(int)index_val;
@end
