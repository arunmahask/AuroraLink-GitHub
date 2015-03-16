//
//  LoggerSource.m
//  BeadedStream
//
//  Created by fsp on 7/8/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "LoggerSource.h"

//****** Class used to creat the instance, and store the object of the information to the database, about the logger *****//

@implementation LoggerSource
@synthesize loggerName;
@synthesize gpscode;
@synthesize voltage;
@synthesize interval;


-(id)initWithLoggerName:(NSString *)loggerName2 GPS:(NSString *)gpscode2 Voltage:(NSString *)voltage2 Interval:(NSString *)interval2
{
    self=[super init];
    if(self)
    {
        self.loggerName=loggerName2;
        self.gpscode=gpscode2;
        self.voltage=voltage2;
        self.interval=interval2;
    }
    return self;
}

@end
