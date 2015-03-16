//
//  DeviceConnector.h
//  BeadedStream
//
//  Created by dev8 on 29/06/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Brsp.h"

@protocol DeviceConnectorDelegate <NSObject>

//***** DeviceConnector delegate declartion *****//

-(void)requestStarted;
-(void)requestCompleted:(Brsp*)brspObject result:(NSString*)str;
-(void)requestCompleted2:(NSString *)rowNumber;
-(void)deviceConnected;
-(void)receivingData:(Brsp*)brspObject result:(NSString*)DataStr;
-(void)deviceAlreadyConnected;
-(void)requestCompleted1:(NSMutableString*)output NumbeofRow:(NSString *)numberOfRow;
-(void)createFile:(NSMutableString *)receivedData;

@end

@interface DeviceConnector : NSObject<BrspDelegate, CBCentralManagerDelegate>{
    BrspMode _lastMode;
    NSString *p1,*p2,*baseString;
     
    //unsigned char payloadvalue1,payloadvalue2,payloadvalue3,payloadvalue4,payloadvalue;
    NSString *payloadvalue1,*payloadvalue2,*payloadvalue3,*payloadvalue4,*payloadvalue,*payloadString;
    NSTimer *timer1;
    
    UIAlertView *tryMessage;
    
}

@property (strong, nonatomic) Brsp *brspObject;
@property (strong, nonatomic) NSString *tempResStringFromDevice;
@property (strong, nonatomic) NSMutableString *numberOfRecord,*flashOutValue;
@property (strong, nonatomic) NSMutableString *responseStringFromDevice;
@property (strong,nonatomic) NSData *data1;
@property (strong, nonatomic) NSMutableData *data2;
@property (strong, nonatomic) id<DeviceConnectorDelegate> delegate;


@property (strong,nonatomic) NSString *binaryrow;

@property (nonatomic,assign) NSString *resp_str; 

@property (assign) BOOL typeCommand;

//***** Method declaration to sendcommand and connect a peripheral device to the application *****//

-(void)sendCommand:(NSString*)str;
-(void)connectactivePeripheral;
//-(id)init;
@end
