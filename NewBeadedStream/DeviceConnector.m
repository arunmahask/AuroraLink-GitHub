//
//  DeviceConnector.m
//  BeadedStream
//
//  Created by dev8 on 29/06/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "DeviceConnector.h"
#import "AppDelegate.h"
#import "LoggerData.h"

@implementation DeviceConnector
@synthesize brspObject,delegate,resp_str,data1,binaryrow,data2;

unsigned int result=0;

int rowNumber=0, accountPacket=0,refCount=0;
int payloadLength1=0,payloadLength2=0,packetSize=0,count=1,crc,paysize;
int previousCount = -1, currentCount = 0;

#pragma mark BrspDelegate

-(id)init
{
    if(self=[super init])
    {
        data2=[[NSMutableData alloc]init];
    }
    return self;
}

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
        
        NSLog(@"Connected");
    }
}

-(void)deviceAlreadyConnectedSelector
{
    if([self.delegate respondsToSelector:@selector(deviceAlreadyConnected)]){
        [self.delegate performSelector:@selector(deviceAlreadyConnected)];
    }
}

-(void)sendCommand:(NSString *)str
{
    binaryrow=str;

    NSLog(@"binary row = [%@]", str);
    NSLog(@"sendCommand %@",str);
    
    if([self.brspObject isOpen]){
        NSLog(@"OPEN");
    }
    else{
        NSLog(@"CLOSE");
    }
    
    if([self.delegate respondsToSelector:@selector(requestStarted)]){
        [self.delegate performSelector:@selector(requestStarted)];
    }
    
    if (![[str substringFromIndex:str.length-1] isEqualToString:@"\r"])
        str = [NSString stringWithFormat:@"%@\r", str];  //Append a carriage return write as string
    
    NSError *writeError = [self.brspObject writeString:str];
    
    if (writeError)
    {
        NSLog(@"%@", writeError.description);
    }
}

- (void)brsp:(Brsp*)brsp OpenStatusChanged:(BOOL)isOpen
{
    NSLog(@"OpenStatusChanged == %d Ref count = %d", isOpen,refCount);
    
    if (isOpen)
    {
        //The BRSP object is ready to be used
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //Print the security level of the brsp service to console
        NSLog(@" Device BRSP Security Level is %d", brspObject.securityLevel);
        
        if(self.typeCommand)
        {
            if([self.delegate respondsToSelector:@selector(deviceConnected)])
            {
                [self.delegate performSelector:@selector(deviceConnected)];
            }
        }
    }
    else
    {
        //brsp object has been closed
    }
}

- (void)brsp:(Brsp*)brsp SendingStatusChanged:(BOOL)isSending
{
    
}

- (void)brspDataReceived:(Brsp*)brsp
{
    //If there are items in the _commandQueue array, assume this data is part of a command response
    //NSLog(@"brspDataReceived %d %d",self.typeCommand,brspObject.isSending);
    
    data1=[[brspObject readBytes]mutableCopy];
    
    [data2 appendData:data1];
    
//    NSLog(@"Output  = %@",data2);
    
    _tempResStringFromDevice=[[NSString alloc]initWithData:data1 encoding:NSASCIIStringEncoding];
    
    NSString *rowValueinHex;
    NSString *rowLSBValue=[[NSString alloc]init];
    NSString *rowMSBValue=[[NSString alloc]init];
    
    NSString *hexout=[NSString stringWithFormat:@"%@",data1];

    const char *bytes=[data2 bytes];
    NSMutableString *value=[[NSMutableString alloc]init];
    
    for(int i=0;i<=[data2 length];i++)
    {
        [value appendFormat:@"%02hhx",(unsigned char)bytes[i]];
    }
    
    if([binaryrow isEqualToString:@"flash-txfr-binary"])
    {
        _flashOutValue=[NSMutableString stringWithFormat:@"%@",data1];
        const char *bytes=[data1 bytes];
        for(int i=0;i<[data1 length];i++)
        {
            [_flashOutValue appendFormat:@"%02hhx",(unsigned char)bytes[i]];
        }
        NSLog(@"_flashOutVlaue    =   %@",_flashOutValue);
        data2=[[NSMutableData alloc]init];
    }
    
    if([binaryrow isEqualToString:@"r"])
    {
        _numberOfRecord=[[NSMutableString alloc]init];
        const char *bytes=[data1 bytes];
        for(int i=0;i<[data1 length];i++)
        {
                [_numberOfRecord appendFormat:@"%02hhx",(unsigned char)bytes[i]];
        }
        NSLog(@"_numberOfRecord    =     %@",_numberOfRecord);
    }
    
    if([binaryrow isEqualToString:@"r"])
    {
        
        NSLog(@"Hex Output = %@",hexout);
        
        if(hexout.length > 12)
        {
            rowLSBValue=[hexout substringWithRange:NSMakeRange(7, 2)];
            rowMSBValue=[hexout substringWithRange:NSMakeRange(10, 2)];
            
            rowValueinHex=[NSString stringWithFormat:@"%@%@",rowMSBValue,rowLSBValue];
            
            NSScanner *scanner=[NSScanner scannerWithString:rowValueinHex];
            [scanner scanHexInt:&result];
            rowNumber=result;
            NSLog(@"Row Value = %@   Equal Int Value = %d   Output Byte =%@",rowValueinHex,rowNumber,data1);
            
            [self.delegate performSelector:@selector(requestCompleted2:) withObject:[NSString stringWithFormat:@"%d",rowNumber]];
            
            data2=[[NSMutableData alloc]init];
        }
        
    }
    
//    NSLog(@"Output value = %@",data2);
    
    
    if([binaryrow isEqualToString:[NSString stringWithFormat:@"t%d",rowNumber]] || ([binaryrow rangeOfString:@","].location!=NSNotFound))
    {
//        NSLog(@"inside the binaryrow t process");
        
        if([binaryrow isEqualToString:@"t0"])
        {
            NSLog(@"There is no data");
            timer1=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sendOutput) userInfo:nil repeats:NO];
        }
        else
        {
            currentCount = [data2 length];
            
            if(previousCount == currentCount)
            {
                NSLog(@"Compelted");
            }
            else if( currentCount % 20 == 0)
            {
                previousCount = currentCount;
            }
            else
            {
                //post
                [[NSNotificationCenter defaultCenter] postNotificationName:@"downloaderror" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"downloaderror1" object:nil];
                
                NSLog(@"Start process with Array Length = %d, Array content = %@", [data2 length], data2);
                
                if([data2 length]>20)
                timer1=[NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(sendOutput) userInfo:nil repeats:NO];
            }
        }
    }
    
    if(_responseStringFromDevice == nil)
    {
        _responseStringFromDevice = [[NSMutableString alloc] init];
    }
    
    _responseStringFromDevice = [[_responseStringFromDevice stringByAppendingString:_tempResStringFromDevice] mutableCopy];
    
    if(self.typeCommand){
        
//        NSLog(@"self.typeCommand");
        
        if([_tempResStringFromDevice rangeOfString:@">"].location != NSNotFound)
        {
            [self.delegate receivingData:self.brspObject result:_tempResStringFromDevice];
            [self.delegate requestCompleted:self.brspObject result:_responseStringFromDevice];
            
//            NSLog(@"_responseStringFromDevice %@",_responseStringFromDevice);
        }
        else
        {
            [self.delegate receivingData:self.brspObject result:_tempResStringFromDevice];
        }
        
        if(([_responseStringFromDevice rangeOfString:@"ERROR: command \"BRSP,0,1\" not recognized"].location != NSNotFound))
        {
            _responseStringFromDevice = nil;
            _responseStringFromDevice = [[NSMutableString alloc] init];
            if([self.delegate respondsToSelector:@selector(deviceConnected)])
            {
                [self.delegate performSelector:@selector(deviceConnected)];
            }
        }
        return;
    }
    
    if([_tempResStringFromDevice rangeOfString:@">"].location != NSNotFound)
    {
        //NSLog(@"Found >  %@",_responseStringFromDevice);
        
        if(([_responseStringFromDevice rangeOfString:@"ERROR: command \"BRSP,0,1\" not recognized"].location != NSNotFound))
        {
            _responseStringFromDevice = nil;
            _responseStringFromDevice = [[NSMutableString alloc] init];
            if([self.delegate respondsToSelector:@selector(deviceConnected)])
            {
                [self.delegate performSelector:@selector(deviceConnected)];
            }
        }
        else if(([_responseStringFromDevice rangeOfString:@"ERROR:"].location != NSNotFound) || ([_responseStringFromDevice rangeOfString:@"BRSP"].location != NSNotFound))
        {
            
        }
        
        else if(([_responseStringFromDevice rangeOfString:@"No data!"].location != NSNotFound))
        {
//            NSLog(@"Out Put ======= %@",_responseStringFromDevice);
            
            if([self.delegate respondsToSelector:@selector(requestCompleted:result:)])
            {
                [self.delegate performSelector:@selector(requestCompleted:result:) withObject:self.brspObject withObject:@"NO"];
            }
        }
        
        else if(([_responseStringFromDevice rangeOfString:@"REALLY ERASE"].location != NSNotFound))
        {
            if([self.delegate respondsToSelector:@selector(requestCompleted:result:)])
            {
                [self.delegate performSelector:@selector(requestCompleted:result:) withObject:self.brspObject withObject:@"ERASE"];
            }
        }
    }
    else
    {
    
    }
}

-(int)hex2dec :(NSString *)str
{
    unsigned int result=0;
    int output;
    NSScanner *scanner=[NSScanner scannerWithString:str];
    [scanner scanHexInt:&result];
    return  output=result;
}

-(void)sendOutput
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloaderror" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloaderror1" object:nil];
    
    if(rowNumber==0)
    {
        NSString *sendData=[NSString stringWithFormat:@"%@",data2];
        NSString *countableRow =[NSString stringWithFormat:@"%d",rowNumber];
        [self.delegate performSelector:@selector(requestCompleted1:NumbeofRow:) withObject:sendData withObject:countableRow];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloaderror" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloaderror1" object:nil];
        
        NSString *rowString = [NSString stringWithFormat:@"t%d",rowNumber];
//        NSLog(@"Row String  ==  %@",rowString);
        if([binaryrow rangeOfString:rowString].location !=NSNotFound)
        {
            NSString *sendData=[NSString stringWithFormat:@"%@",data2];
            NSString *countableRow =[NSString stringWithFormat:@"%d",rowNumber];
            sendData=[sendData stringByReplacingOccurrencesOfString:@"<" withString:@""];
            sendData=[sendData stringByReplacingOccurrencesOfString:@">" withString:@""];
            sendData=[sendData stringByReplacingOccurrencesOfString:@" " withString:@""];
//            NSLog(@"inside the send command   =====  with data logger =====  %@  Number of Row ===== %d",sendData,rowNumber);

            if([sendData length]>20)
                [self.delegate performSelector:@selector(requestCompleted1:NumbeofRow:) withObject:sendData withObject:countableRow];
            else
            {
                [self sendCommand:binaryrow];
            }
            rowNumber = -1;
        }
    }
}

-(void)measureSizeofPacket:(NSData *)dataValue
{
    NSMutableArray *getData=[[NSMutableArray alloc]initWithObjects:dataValue, nil];
    NSString *data=[getData objectAtIndex:0];
    data = [data substringWithRange:NSMakeRange(0, 4)];
    //NSLog(@"payload length of the first row = %@",data);
}

- (void)brsp:(Brsp*)brsp ErrorReceived:(NSError*)error{
    NSLog(@"ErrorReceived %@", error.description);
}

- (void)brspModeChanged:(Brsp*)brsp BRSPMode:(BrspMode)mode{
    
}

#pragma mark CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    //call the open function to prepare the brsp service
    [self.brspObject open];
    NSLog(@"didConnectPeripheral");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self.brspObject close];
    
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didFailToConnectPeripheral");
}


-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
    NSLog(@"didRetrieveConnectedPeripherals %@",peripherals);
}


@end
