//
//  CRC16.h
//  AuroraLink
//
//  Created by dev13 on 06/08/14.
//  Copyright (c) 2014 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoggerData.h"
#import "ViewData.h"
#import "Brsp.h"
#import "BinaryImplementation.h"

@interface CRC16 : UIViewController
{
    NSMutableString *outString;
    int crc, stringLength;
    NSMutableArray *dataArray,*record,*finalarray,*errorInfo,*lastArray;
    NSMutableString *processedString, *collectionOfData;
    NSMutableData *dataArray1;
    uint32_t numberOfRecord,payloadLength,remainingLength,dataLength,recordNumber,disable,crcResult,recordCount;
    NSString *p1,*p2,*baseString;
}

@property (nonatomic,retain)NSString *referenceKeyword;
@property (nonatomic,retain)id calledClass;
@property (nonatomic,retain)Brsp *brspObject;
@property (strong, nonatomic)NSMutableString *outputString;

-(void)startProcess:(NSMutableString *)loggerData NumberofRow:(int)numberOfRow;
-(void)splitRows:(NSMutableString *)collection;

@end
