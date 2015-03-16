//
//  LoggerSource.h
//  BeadedStream
//
//  Created by fsp on 7/8/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoggerSource : NSObject
{
    NSString *loggerName;
    NSString *gpscode;
    NSString *voltage;
    NSString *interva;
}

@property (nonatomic, retain) NSString *loggerName;
@property (nonatomic, retain) NSString *gpscode;
@property (nonatomic, retain) NSString *voltage;
@property (nonatomic, retain) NSString *interval;

-(id)initWithLoggerName:(NSString *)loggerName2 GPS:(NSString *)gpscode2 Voltage:(NSString *)voltage2 Interval:(NSString *)interval2;
@end
