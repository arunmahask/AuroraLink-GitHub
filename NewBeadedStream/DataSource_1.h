//
//  DataSource_1.h
//  New_Database
//
//  Created by fsp on 7/1/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <Foundation/Foundation.h>

//***** class used to create the instance for the logger proces like send mail, download data *****//

@interface DataSource_1 : NSObject
{
    
//String Variable declaration
    NSString *loggerName,*date,*processDescription,*data,*time;
}

@property (nonatomic, retain) NSString *loggerName;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *processDescription;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSString *time;

-(id)initWithLoggerName:(NSString *)loggerName1 Date:(NSString *)date1 Time:(NSString *)time1 Description:(NSString *)processDescription1 Data:(NSString *)data1 ;
@end
