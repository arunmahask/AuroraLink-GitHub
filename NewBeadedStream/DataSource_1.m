//
//  DataSource_1.m
//  New_Database
//
//  Created by fsp on 7/1/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "DataSource_1.h"

@implementation DataSource_1

@synthesize loggerName;
@synthesize date;
@synthesize processDescription;
@synthesize data;
@synthesize time;

//***** Class used to create the instance for the logger process to add in to history *****//

-(id)initWithLoggerName:(NSString *)loggerName1 Date:(NSString *)date1 Time:(NSString *)time1 Description:(NSString *)processDescription1 Data:(NSString *)data1
{
    self=[super init];
    if(self){
        self.loggerName=loggerName1;
        self.date=date1;
        self.processDescription=processDescription1;
        self.data=data1;
        self.time=time1;
    }
    return self;
}

@end
