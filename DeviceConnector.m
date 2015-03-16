////
//  DeviceConnector.m
//  BeadedStream
//
//  Created by dev8 on 29/06/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "DeviceConnector.h"
#import "AppDelegate.h"


@implementation DeviceConnector
@synthesize brspObject,delegate;


#pragma mark BrspDelegate

-(void)connectactivePeripheral
{
    
    if([[AppDelegate app].activePeripheral isConnected])
    {
        NSLog(@"isConnected");
        [AppDelegate app].cManager.delegate = self;
        self.brspObject = [[Brsp alloc] initWithPeripheral:[AppDelegate app].activePeripheral InputBufferSize:512 OutputBufferSize:512];
        
        //It is important to set this delegate before calling [Brsp open]
        self.brspObject.delegate = self;
        [self.brspObject open];
        //[self performSelector:@selector(sendCommand:) withObject:@"STATUS" afterDelay:1];
        
        [self performSelector:@selector(deviceAlreadyConnectedSelector) withObject:nil afterDelay:1];
         
    }
    else
    {
        NSLog(@"Not - isConnected");
        [AppDelegate app].cManager.delegate = self;
        self.brspObject = [[Brsp alloc] initWithPeripheral:[AppDelegate app].activePeripheral InputBufferSize:512 OutputBufferSize:512];
    
    //It is important to set this delegate before calling [Brsp open]
        self.brspObject.delegate = self;
        
    //Use CBCentral Manager to connect this peripheral
        [[AppDelegate app].cManager connectPeripheral:[AppDelegate app].activePeripheral options:nil];
        
    //[[AppDelegate app].cManager retrieveConnectedPeripherals];
    }
}

-(void)deviceAlreadyConnectedSelector{
    
    if([self.delegate respondsToSelector:@selector(deviceAlreadyConnected)]){
    [self.delegate performSelector:@selector(deviceAlreadyConnected)];
    }
}

- (void)brsp:(Brsp*)brsp OpenStatusChanged:(BOOL)isOpen {
       NSLog(@"OpenStatusChanged == %d", isOpen);
    if (isOpen) {
        //The BRSP object is ready to be used
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //Print the security level of the brsp service to console
        NSLog(@"BRSP Security Level is %d", brspObject.securityLevel);
           if(self.typeCommand){
               if([self.delegate respondsToSelector:@selector(deviceConnected)]){
                   [self.delegate performSelector:@selector(deviceConnected)];
               }
           }
        
    } else {
        //brsp object has been closed
    }
}
- (void)brsp:(Brsp*)brsp SendingStatusChanged:(BOOL)isSending {

}
- (void)brspDataReceived:(Brsp*)brsp {

    //If there are items in the _commandQueue array, assume this data is part of a command response
    
    NSLog(@"brspDataReceived %d %d",self.typeCommand,brspObject.isSending);
    
    //If there are items in the _commandQueue array, assume this data is part of a command response
    
    _tempResStringFromDevice = [[brspObject readString] mutableCopy];
    
    NSLog(@"_tempResStringFromDevice - %@",[brspObject readString]);
    
    // NSLog(@"_tempResStringFromDevice %@ - %d",_tempResStringFromDevice,_tempResStringFromDevice.length);
    
    if(_responseStringFromDevice == nil){
        
        _responseStringFromDevice = [[NSMutableString alloc] init];
    }
    _responseStringFromDevice = [[_responseStringFromDevice stringByAppendingString:_tempResStringFromDevice] mutableCopy];
    
    
    if(self.typeCommand){
        
        NSLog(@"self.typeCommand");
        
        if([_tempResStringFromDevice rangeOfString:@">"].location != NSNotFound)
        {
            NSLog(@"_responseStringFromDevice %@",_responseStringFromDevice);
            [self.delegate receivingData:self.brspObject result:_tempResStringFromDevice];
            [self.delegate requestCompleted:self.brspObject result:_responseStringFromDevice];
        }else{
            [self.delegate receivingData:self.brspObject result:_tempResStringFromDevice];
        }
        
        
        //
        
        if(([_responseStringFromDevice rangeOfString:@"ERROR: command \"BRSP,0,1\" not recognized"].location != NSNotFound)){
            
            _responseStringFromDevice = nil;
            _responseStringFromDevice = [[NSMutableString alloc] init];
            //[self sendCommand:@"STATUS"];
             if([self.delegate respondsToSelector:@selector(deviceConnected)]){
            [self.delegate performSelector:@selector(deviceConnected)];
             }
        }
        
        //
        
        return;
    }
    
    if([_tempResStringFromDevice rangeOfString:@">"].location != NSNotFound)
    {
        NSLog(@"Found >  %@",_responseStringFromDevice);
        //[lAnimate hide:YES];
        if(([_responseStringFromDevice rangeOfString:@"ERROR: command \"BRSP,0,1\" not recognized"].location != NSNotFound)){
           
            _responseStringFromDevice = nil;
            _responseStringFromDevice = [[NSMutableString alloc] init];
            //[self sendCommand:@"STATUS"];
             if([self.delegate respondsToSelector:@selector(deviceConnected)]){
            [self.delegate performSelector:@selector(deviceConnected)];
             }
        }else if(([_responseStringFromDevice rangeOfString:@"BRSP"].location != NSNotFound)){
            
        }else if(([_responseStringFromDevice rangeOfString:@"ERROR:"].location != NSNotFound)){
          
        }else if(([_responseStringFromDevice rangeOfString:@"No data!"].location != NSNotFound)){
            
            UIAlertView *noDa = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data! " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [noDa show];
            if([self.delegate respondsToSelector:@selector(requestCompleted:result:)]){
                [self.delegate performSelector:@selector(requestCompleted:result:) withObject:self.brspObject withObject:@"NO"];
            }
        }else{ //for showing data only
            
            NSLog(@"INTO DATA %@",_responseStringFromDevice);
            NSRange delLocation = [_responseStringFromDevice rangeOfString:@">"];
            [_responseStringFromDevice deleteCharactersInRange:delLocation];
            
            //NSLog(@"Final result: %@",_responseStringFromDevice);
            
            //NSLog(@"OMG %@",[_responseStringFromDevice componentsSeparatedByString:@"\n"]);
            
             if([self.delegate respondsToSelector:@selector(requestCompleted:result:)]){
                 [self.delegate performSelector:@selector(requestCompleted:result:) withObject:self.brspObject withObject:_responseStringFromDevice];
             }
            
//            NSMutableArray *res = [[_responseStringFromDevice componentsSeparatedByString:@"\n"] mutableCopy];
//            NSMutableDictionary *status = [[NSMutableDictionary alloc] init];
//            
//            for (id val in res) {
//                
//                if([val rangeOfString:@":"].location != NSNotFound)
//                {
//                    NSRange loc = [val rangeOfString:@":"];
//                    [status setObject:[val substringFromIndex:NSMaxRange(loc)] forKey:[val substringToIndex:NSMaxRange(loc)]];
//                }
//                
//            }
//            [res removeAllObjects];
//            res = [status mutableCopy];
            
        }
        
        
        
    }else{
        
        
        NSLog(@"_responseStringFromDevice %@ ",_responseStringFromDevice);
        
        
        
    }
    
    
     NSLog(@"end output %@ ",_responseStringFromDevice);
}
- (void)brsp:(Brsp*)brsp ErrorReceived:(NSError*)error {
    NSLog(@"ErrorReceived %@", error.description);
}
- (void)brspModeChanged:(Brsp*)brsp BRSPMode:(BrspMode)mode {
    //    NSLog(@"BRSP Mode changed to %d", mode);
    
}

#pragma mark CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    //call the open function to prepare the brsp service
    [self.brspObject open];
    
    
    NSLog(@"didConnectPeripheral");
   //[self.delegate performSelector:@selector(deviceConnected)];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self.brspObject close];
  
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral");
}

-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
     NSLog(@"didRetrieveConnectedPeripherals %@",peripherals);
}

-(void)sendCommand:(NSString *)str {
    
    NSLog(@"sendCommand %@",str);
    
    
    if([self.brspObject isOpen]){
        NSLog(@"OPEN");
    }else{
         NSLog(@"CLOSE");
    }
      if([self.delegate respondsToSelector:@selector(requestStarted)]){
          [self.delegate performSelector:@selector(requestStarted)];
      }
    
    if (![[str substringFromIndex:str.length-1] isEqualToString:@"\r"])
        str = [NSString stringWithFormat:@"%@\r", str];  //Append a carriage return
    //Write as string
    NSError *writeError = [self.brspObject writeString:str];
    if (writeError){
        NSLog(@"%@", writeError.description);
    }
    
    
}

@end
