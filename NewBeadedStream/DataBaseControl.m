//
//  DataBaseControl.m
//  New_Database
//
//  Created by fsp on 7/1/13.\
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "DataBaseControl.h"

#import <sqlite3.h>

@implementation DataBaseControl

-(id)init
{
    self = [super init];
    return self;
}

//****** Method to initialize the database and create a table in database

-(void)initDatabase
{
//retrive the file location from the local machine (both PC as well as iOS device)
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectroy=[paths objectAtIndex:0];
    
//Append database name to the location retrive from the previous two statement (BeadedStream.db - is database name)
    
    databasePath=[documentDirectroy stringByAppendingPathComponent:@"BeadedStream.db"];
    
    bool databaseAvailability=[[NSFileManager defaultManager]fileExistsAtPath:databasePath];
    NSLog(@"Path %@",databasePath);
    
    if(sqlite3_open([databasePath UTF8String],&databaseHandle)==SQLITE_OK)
    {
        if(!databaseAvailability)
        {
            const char *sqlStatement="create table if not exists detail_data(id integer primary key autoincrement, loggerName varchar, date varchar,process_description varchar, data blob,time varchar);";
            char *error;
            
//After Execute the following sqlite3_exec() method detail_data table will create
            
            if(sqlite3_exec(databaseHandle,sqlStatement,NULL,NULL,&error)==SQLITE_OK)
            {
                NSLog(@"detail_data table Created");
                sqlStatement="create table if not exists settings(id integer, name text,email text);";
                
//After Execute the following sqlite3_exec() method settings table will create

                if(sqlite3_exec(databaseHandle,sqlStatement,NULL,NULL,&error)==SQLITE_OK)
                {
                    NSLog(@"setting tables created");
                    sqlStatement="create table if not exists logger_info(id integer primary key autoincrement, loggername text, gpscode text, voltage text, interval text);";
                    
//After Execute the following sqlite3_exec() method logger_info table will create

                    if(sqlite3_exec(databaseHandle,sqlStatement,NULL,NULL,&error)==SQLITE_OK)
                    {
                        NSLog(@"Logger_info tables created");
                    }
                }
            }
        }
    }
}

//******* Insert Data about the logger for History page ********//

-(void)insertDataforDetail:(DataSource_1 *)datasoruce
{
    //insert data in to the detail table (What operation is performed)
    NSString *insertStatement=[NSString stringWithFormat:@"insert into detail_data(loggerName,date,process_description,data,time)values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",datasoruce.loggerName,datasoruce.date,datasoruce.processDescription,datasoruce.data,datasoruce.time];
    char *error;
    if(sqlite3_exec(databaseHandle,[insertStatement UTF8String],NULL,NULL,&error)==SQLITE_OK)
    {
        NSLog(@"Row Inserted");
    }
    else
    {
        NSLog(@"Detail Error: %s",error);
    }
}

//****** Insert Data about the logger while tap the save button in logger Detail page for showing data in basic page while logger out of range ******//

-(void)insertDataforLogger:(LoggerSource *)loggersource
{
    
//insert data about the logger, from the logger while load the LoggerDetail page (save button tapped)
    NSLog(@"Logger Insert called");
    NSString *insertStatement=[NSString stringWithFormat:@"insert into logger_info(loggername,gpscode,voltage,interval)values(\"%@\",\"%@\",\"%@\",\"%@\")",loggersource.loggerName,loggersource.gpscode, loggersource.voltage, loggersource.interval];
    char *error;
    if(sqlite3_exec(databaseHandle,[insertStatement UTF8String],NULL,NULL,&error)==SQLITE_OK)
    {
        NSLog(@"Logger Row Inserted");
        
        [self getInsertedData2];
    }
    else
    {
        NSLog(@"Detail Error: %s",error);
    }
}


-(void)getInsertedData2
{
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectroy=[paths objectAtIndex:0];
    databasePath=[documentDirectroy stringByAppendingPathComponent:@"BeadedStream.db"];
    
    sqlite3_stmt *statement;
    NSString *selectStatement=[NSString stringWithFormat:@"select * from logger_info"];
    
    if(sqlite3_open([databasePath UTF8String], &databaseHandle)==SQLITE_OK)
    {
        NSLog(@"Data Path -----> %@",databasePath);
        if(sqlite3_prepare_v2(databaseHandle, [selectStatement UTF8String], -1, &statement, NULL)==SQLITE_OK)
        {
            NSLog(@"From getTime ---");
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                NSLog(@"From getTime  ---- %@ ------ %@ ----- %@ -------%@ -------%@",[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,0)],[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,1)],[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,2)],[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,3)],[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,4)]);
            }
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(databaseHandle));
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(databaseHandle);
}

//****** Insert Data for the Setting page, while tap the save button in setting page *******//

-(void)insertDataforSettings:(NSString *)name mailaddress:(NSString *)email
{
//insert data in to the setting table while press the save button in setting page
    
    if ([[self Selectview] count] == 0)
    {
//if the count not equal to 0 doesnt allow to Enter new Data
        NSLog(@"\rName: %@\rEmail: %@",name,email);
        name12=name;
        email12=email;
        
        NSString *insertStatement1=[NSString stringWithFormat:@"insert into settings(id,name,email)values(1,\"%@\",\"%@\")",name,email];
        char *error;
        if(sqlite3_exec(databaseHandle,[insertStatement1 UTF8String], NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Row Inserted");
            databaseop = [[UIAlertView alloc] initWithTitle:@"Database operation" message:@"Data saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            databaseop.tag=1234;
            [databaseop show];
        }
        else
        {
            NSLog(@"setting Error: %s",error);
        }
    }

}

//***** View the data from the Logger ******//

-(void)viewdetailData{
    
    NSString *selectStatement=[NSString stringWithFormat:@"select * from detail_data"];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(databaseHandle, [selectStatement UTF8String], -1, &statement,NULL)==SQLITE_OK){
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            NSLog(@"LoggerName: %@\r Entry Date: %@\r Process Description: %@\r Data: %@",
                  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)],
                  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)],
                  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)],
                  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)]);
        }
    }
}


//***** User to enter the operation to the log Registry ******//

-(void)logfile:(NSString *)infoEntry{
    
    NSString *data=[NSString stringWithFormat:@"%@\r",infoEntry];
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectroy=[paths objectAtIndex:0];
    fileName=[documentDirectroy stringByAppendingPathComponent:@"logregistry.txt"];
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:fileName])
        [[NSFileManager defaultManager]createFileAtPath:fileName contents:nil attributes:nil];
    
    NSFileHandle *file1=[NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file1 seekToEndOfFile];
    [file1 writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    [file1 closeFile];
    NSLog(@"insert in to file");
    
}

-(void)readLog
{
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectroy=[paths objectAtIndex:0];
    fileName=[documentDirectroy stringByAppendingPathComponent:@"logregistry.txt"];
    //filePath=[NSString stringWithFormat:@"%@%@",documentDirectroy,fileName];

    NSLog(@"\r%@\r",fileName);
    
    NSFileHandle *output=[NSFileHandle fileHandleForReadingAtPath:filePath];
    [output seekToFileOffset:0];
    
    filecontent=[NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:NULL];
//    NSLog(@"\r**********************File Content*******************\r%@",filecontent);
}

//******* Method used to rewrite the existing name and email id in the setting table ******//

-(void)updatesetting:(NSString *)name1 Email:(NSString *)email1{
    
    name12=name1;
    email12=email1;
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK)
    {
        NSLog(@"Data Path -----> %@",databasePath);
        const char *sqlStatement="Delete from settings where id = 1";
        sqlite3_stmt *compiledStatement;
        sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
        if(SQLITE_DONE != sqlite3_step(compiledStatement))
        {
            NSLog(@"Error while inserting data . '%s'",sqlite3_errmsg(database));
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    [self insertDataforSettings:name12 mailaddress:email12];
}

-(NSString *)getTime:(NSString *)loggername
{
    NSLog(@"From GetTime");
    NSString *timeofLogger,*dateofLogger;
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectroy=[paths objectAtIndex:0];
    databasePath=[documentDirectroy stringByAppendingPathComponent:@"BeadedStream.db"];
    
    sqlite3_stmt *statement;
    NSString *selectStatement=[NSString stringWithFormat:@"select date, time from detail_data where id=(select max(id) from detail_data where process_description like 'Downloaded %%' and loggerName=\"%@\")",loggername];
    
    if(sqlite3_open([databasePath UTF8String], &databaseHandle)==SQLITE_OK)
    {
        NSLog(@"Data Path -----> %@",databasePath);
        if(sqlite3_prepare_v2(databaseHandle, [selectStatement UTF8String], -1, &statement, NULL)==SQLITE_OK)
        {
            NSLog(@"From getTime");
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                dateofLogger=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,0)];
                timeofLogger=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,1)];
                NSLog(@"From getTime  ---- %@ ------ %@",dateofLogger,timeofLogger);
            }
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(databaseHandle));
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(databaseHandle);
    
    return [NSString stringWithFormat:@"%@ %@",dateofLogger,timeofLogger];
    
}

-(NSString *)getDownloadedTime:(NSString *)loggername
{
    NSLog(@"From GetTime");
    NSString *timeofLogger,*dateofLogger;
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectroy=[paths objectAtIndex:0];
    databasePath=[documentDirectroy stringByAppendingPathComponent:@"BeadedStream.db"];
    
    sqlite3_stmt *statement;
    NSString *selectStatement=[NSString stringWithFormat:@"select date, time from detail_data where id=(select max(id) from detail_data where loggerName=\"%@\" and process_description=\"Downloaded from logger\")",loggername];
    
    if(sqlite3_open([databasePath UTF8String], &databaseHandle)==SQLITE_OK)
    {
        NSLog(@"Data Path -----> %@",databasePath);
        if(sqlite3_prepare_v2(databaseHandle, [selectStatement UTF8String], -1, &statement, NULL)==SQLITE_OK)
        {
            NSLog(@"From getTime");
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                dateofLogger=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,0)];
                timeofLogger=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,1)];
                NSLog(@"From getTime  ---- %@ ------ %@",dateofLogger,timeofLogger);
            }
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(databaseHandle));
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(databaseHandle);
    
    return [NSString stringWithFormat:@"%@ %@",dateofLogger,timeofLogger];
    
}


//****** Select all row from the History table to populate in the history page ******//

-(NSMutableArray *)getHistoryInfo{
    //retrive the information about the logger and send to the history table view 
    
    NSLog(@"getHistoryInfo called.");
    NSMutableArray *tempHistory = [[NSMutableArray alloc] init];
    NSString *selectStatement=[NSString stringWithFormat:@"select * from detail_data order by id desc"];
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(databaseHandle, [selectStatement UTF8String], -1, &statement,NULL)==SQLITE_OK){
        NSLog(@"sqlite3_prepare_v2");
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            NSLog(@"Row_id: %@\r LoggerName: %@\r Entry Date: %@\r Time: %@\r Process Description: %@\r DataPath: %@\r",
                  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)],
                  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)],
                  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)],
                  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)],
                  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)],
                  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)]);
            
            [tempHistory addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)],@"row_id",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)],@"logger_name",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)], @"date",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)],@"time",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)],@"description",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)],@"dataPath",nil]];
            
        }
    }
    
    else
    {
        NSLog(@"Error ******* %s",sqlite3_errmsg(databaseHandle));
    }
    return tempHistory;
}

-(void)deleteRow:(int)index_val
{
    NSLog(@"Index_val - %d",index_val);
    NSString *selectStatement=[NSString stringWithFormat:@"delete from detail_data where id=%d",index_val];
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(databaseHandle, [selectStatement UTF8String], -1, &statement,NULL)==SQLITE_OK){
        NSLog(@"sqlite3_prepare_v2");
        while(sqlite3_step(statement)==SQLITE_ROW){
            NSLog(@"Sucessfully Deleted");
        }
    }
}


//****** Select all detail for the logger which mentioned in the query ******//

-(NSMutableArray *)getLoggerDetail:(NSString *)setLoggerName{
    
    NSLog(@"getLoggerInfo called.");
    NSMutableArray *tempLogger=[[NSMutableArray alloc]init];
    NSString *value=setLoggerName;
    NSLog(@"value %@",value);
    sqlite3_stmt *statement1 = NULL;
    
    NSString *selectQuery=[NSString stringWithFormat:@"select * from logger_info where id=(select max(id) from logger_info where loggername like \"%@%%\")",value];
    //NSString *selectQuery=[NSString stringWithFormat:@"select id,loggername, gpscode,voltage,interval from logger_info where loggername like \"%@%%\"",value];

    if(sqlite3_open([databasePath UTF8String], &databaseHandle)==SQLITE_OK)
    {
        if(sqlite3_prepare_v2(databaseHandle, [selectQuery UTF8String], -1, &statement1, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement1)==SQLITE_ROW)
            {
                NSLog(@"Dondndoandfklasdjflkasdjfasd");
                NSLog(@"LoggerName: %@\r gpscod: %@\r voltage: %@\r interval: %@\r",
                      [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1,1)],
                      [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1,2)],
                      [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1,3)],
                      [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1,4)]);
                
                [tempLogger addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1, 1)],@"loggerName",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1, 2)],@"gpscode",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1, 3)],@"voltage",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1, 4)],@"interval",nil]];

            }
        }
        else
        {
            NSLog(@"Error ******* %s",sqlite3_errmsg(databaseHandle));
        }
        sqlite3_finalize(statement1);
    }
    sqlite3_close(databaseHandle);
    return tempLogger;
}


//******* Select row of the setting table to display name and email ******//

-(NSMutableArray *)Selectview
{
    NSMutableArray *tempSettingArray=[[NSMutableArray alloc]init];
    NSString *selectSetting=[NSString stringWithFormat:@"select * from settings"];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(databaseHandle, [selectSetting UTF8String], -1, &statement, NULL)==SQLITE_OK){
        NSLog(@"Inside the select View");
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            [tempSettingArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)],@"Name",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)],@"Email",nil]];
        }
    }
    return tempSettingArray;
}

//***** Method used to close the connection after completion of the above methods *****//
-(void)dealloc{
    sqlite3_close(databaseHandle);
}

@end
