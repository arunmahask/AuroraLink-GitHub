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

-(void)requestStarted;
-(void)requestCompleted:(Brsp*)brspObject result:(NSString*)str;
-(void)deviceConnected;
-(void)receivingData:(Brsp*)brspObject result:(NSString*)DataStr;
-(void)deviceAlreadyConnected;

@end

@interface DeviceConnector : NSObject<BrspDelegate, CBCentralManagerDelegate>{
    BrspMode _lastMode;
    
}
@property (strong, nonatomic) Brsp *brspObject;
@property (strong, nonatomic) NSString *tempResStringFromDevice;
@property (strong, nonatomic) NSMutableString *responseStringFromDevice;
@property (strong, nonatomic) id<DeviceConnectorDelegate> delegate;
@property (assign) BOOL typeCommand;
-(void)sendCommand:(NSString*)str;
-(void)connectactivePeripheral;
//-(id)init;
@end
