//
//  BinaryImplementation.h
//  AuroraLink
//
//  Created by dev13 on 17/03/14.
//  Copyright (c) 2014 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "LoggerData.h"
#import "Brsp.h"

@interface BinaryImplementation : UIViewController
{
    NSMutableString *collectionOfData, *collectionOfmodifiedData,*tacId1,*tacId2,*tacId3,*tacId4,*outputString;
    
    NSString *processedString,*flashValue, *rowValue, *dataOriginal,*rowCount,*toGiveInputTemp,*Sstr;
    
    NSData *flagData;
    
    NSString *p1,*p2,*baseString;
    NSString *count11;
    
    NSMutableArray * part1array;
    
    NSMutableArray * snowpart;
    
    NSMutableDictionary * finalData, * finalsnow;
    
    uint32_t conv, airTemp,dateInclude,tacInfo,snowDepth,packetSize,payloadLength,newPayloadLength,payloadType,flag,recordNumber,year,month,date,hour,minute,idcount,port,stringLength,arrayIndex,numberOfTacfield,numberOfRecord,numberOfSensor,countrow,removebyte,tacSensor1,tacSensor2,tacSensor3,tacSensor4,snowValue,result,crc;
    
    double actualTemp,degree;
    
    NSMutableArray *dataArray,*payloadArray,*tempArray;
    
    double hextodec,interTemp,batteryVoltage,airValue;
    
    NSString *dateCombine,*timeCombine,*airSnowCombine;

}

@property (nonatomic,retain)id calledClass;
@property (nonatomic,retain)NSString *referenceKeyword;
@property (nonatomic,retain)Brsp *brspObject;

-(NSMutableString* )process:(NSMutableArray *)outOflogger Records:(int)numberOfRecords;
-(void)findFlags:(NSMutableString *)flagVal;
-(void)tacFlagChek:(NSMutableString *)flagVal1;

-(int)hex2dec :(NSString *)str;
-(int)makeShort:(NSString *)hexval;

@end
