//
//  CRC16.m
//  AuroraLink
//
//  Created by dev13 on 06/08/14.
//  Copyright (c) 2014 fsp. All rights reserved.
//

#import "CRC16.h"
#import "AppDelegate.h"

//int splitcount=0;

// a colletion of hexdecimal values to select the polynomial for the process

static int CRC_CCITT_Table[]={
    0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7,
    0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef,
    0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7, 0x62d6,
    0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de,
    0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485,
    0xa56a, 0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d,
    0x3653, 0x2672, 0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4,
    0xb75b, 0xa77a, 0x9719, 0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc,
    
    0x48c4, 0x58e5, 0x6886, 0x78a7, 0x0840, 0x1861, 0x2802, 0x3823,
    0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948, 0x9969, 0xa90a, 0xb92b,
    0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50, 0x3a33, 0x2a12,
    0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b, 0xab1a,
    0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41,
    0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49,
    0x7e97, 0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70,
    0xff9f, 0xefbe, 0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78,
    
    0x9188, 0x81a9, 0xb1ca, 0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f,
    0x1080, 0x00a1, 0x30c2, 0x20e3, 0x5004, 0x4025, 0x7046, 0x6067,
    0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d, 0xd31c, 0xe37f, 0xf35e,
    0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214, 0x6277, 0x7256,
    0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c, 0xc50d,
    0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
    0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c,
    0x26d3, 0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634,
    
    0xd94c, 0xc96d, 0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab,
    0x5844, 0x4865, 0x7806, 0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3,
    0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e, 0x8bf9, 0x9bd8, 0xabbb, 0xbb9a,
    0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1, 0x1ad0, 0x2ab3, 0x3a92,
    0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b, 0x9de8, 0x8dc9,
    0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0, 0x0cc1,
    0xef1f, 0xff3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8,
    0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0
} ;


@interface CRC16 (){
    AppDelegate *theApp;
}

@end

@implementation CRC16

@synthesize referenceKeyword,calledClass,brspObject,outputString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

// Method is the entry point of the CRC and binary converison of the data, the method contain the logger data and number of row

-(void)startProcess:(NSMutableString *)loggerData NumberofRow:(int)numberOfRow
{
    theApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    collectionOfData=[loggerData mutableCopy];
//    NSLog(@"Collection of Data = %@",collectionOfData);
    numberOfRecord=numberOfRow;
    [self splitRows:collectionOfData];
}

-(void)splitRows:(NSMutableString *)collection
{
    dataArray=[[NSMutableArray alloc]init];
    record=[[NSMutableArray alloc]init];
    finalarray=[[NSMutableArray alloc]init];
    
    NSLog(@"theApp.anlastArr = %@",theApp.anlastArr);
    
    recordCount=0;
    
    processedString=[[collection stringByReplacingOccurrencesOfString:@" " withString:@""]mutableCopy]; // code to remove the whitespace in the received logger data

    
    stringLength=processedString.length;
    
    if((stringLength%2)!=0)
    {
        processedString=[[NSString stringWithFormat:@"%@0",processedString]mutableCopy]; // if the received value lenght is an odd number means we need to convert even
    }
    
//    NSLog(@"After = %@",processedString);
    
    int i=0;
    NSString *value1, *value2;
    
    while(i<processedString.length)
    {
        if(i==processedString.length)
            break;
                // Code is used to split the sequence of the data in to byte, each byte have a digits
        [dataArray addObject:[processedString substringWithRange:NSMakeRange(i, 2)]];

        i=i+2;
    }

    payloadLength=0;
    dataLength=0;
    disable=0;
   
    
   [self setSeed:0xffff];       // invoke the method to set the seed value for the CRC checing
    
    remainingLength=[dataArray count]-1; //to avoid array index out of bound exception, subtract the 1 from the array length
    
    @try
    {
        if(theApp.totalRowCount==0)
            theApp.totalRowCount=numberOfRecord;
        
        while(remainingLength!=0)
        {
            value1=[dataArray objectAtIndex:dataLength];
            value2=[dataArray objectAtIndex:dataLength+1];
            payloadLength=[self payLoadLength:value1 Byte:value2];      // invoke the method to calculate the payload length using the first 2 bytes of the every row
            
            for(int r=dataLength;r<=payloadLength+dataLength+3;r++)
            {
                [record addObject:[dataArray objectAtIndex:r]];                 // appeding the every byte to the new array to send the array for CRC process
            }
            
            int f1=0;
            //NSLog(@"Record = %@",record);
            
            
            // below loop is used to invoke the method for calculating the CRC for the received byte of single row
            while(f1<[record count])
            {
               crcResult = [self crcCheck:record[f1]];
//                NSLog(@"CRCResult = %d",crcResult);
                f1++;
            }
            
            /* if the Result of the CRC process is error for each row,
                that row will considered as a row without error, suppose 
                it is non-zero value that row will considered as a error row */
            
            if(crcResult==1){
                NSLog(@"Perfect Row");
                [finalarray addObjectsFromArray:record];
                recordCount++;
                theApp.refRowCount++;
                NSLog(@"Record Count =%d AppDelegate Rowcount = %d",recordCount,theApp.refRowCount);
            
            }
            else{
                NSLog(@"Not Perfect Row");
                NSLog(@"Error Row = %d",recordCount+1);
                //recordCount++;
            }
            
            crc=0;
            [self setSeed:0xffff];
            record=[[NSMutableArray alloc]init];    // reinitialize the array to add a new data to the it
            dataLength=dataLength+payloadLength+4; // this addition value is ued to the get the starting position of the each row in the data array
            
            //loop will execute the datalenght is not equal to the dataArray count, suppose if the equal then the loop will be break
            
            if(dataLength!=[dataArray count])
                remainingLength=remainingLength-dataLength;
            else
                break;
        }
        
        [theApp.anlastArr addObjectsFromArray:finalarray];
//        NSLog(@"Last array out side catch = %@",theApp.anlastArr);
    }
    @catch (NSException *exception)
    { // To handle the Array index out of bound exception
            
        NSLog(@"Exception = %@",exception);
        
        NSLog(@"Final Array count = %d Record Count = %d Total number of Records = %d Need records = %d Final array = %@",[finalarray count],recordCount,numberOfRecord,(numberOfRecord-recordCount),finalarray);
        
        [theApp.anlastArr addObjectsFromArray:finalarray];
        
        NSLog(@"Last array from inside catch = %@",theApp.anlastArr);
        
        LoggerData *ld=[[LoggerData alloc]init];
        [ld showData:(recordCount+1) NumberofRow:(numberOfRecord-recordCount)];
        
    }
    @finally
    {
        NSLog(@"Value of total count = %d",theApp.totalRowCount);
    }
    
    
    NSLog(@"Size of the Theapparray = %d",[theApp.anlastArr count]);
    
    NSLog(@"Total Row count  = %d, RefRow count = %d",theApp.totalRowCount,theApp.refRowCount);
    
    if(theApp.totalRowCount==theApp.refRowCount)
        [self binaryTransfer:theApp.totalRowCount];
    else
    {
        [MBProgressHUD hideHUDForView:theApp.window animated:YES];
    }
}

-(void)binaryTransfer:(int)numberOfrow1
{
    theApp.totalRowCount=0;
    theApp.refRowCount=0;
    
    BinaryImplementation *bin=[[BinaryImplementation alloc]init];
    outputString = [bin process:theApp.anlastArr Records:numberOfrow1]; // invoke the method for the binary to ASCII conversion process
    
    /* This following code is used to redirect the request to the corresponding class,
     because there are 2 posibilties 1) LoggerData 2) ViewData
     */
    
    [theApp.anlastArr removeAllObjects];
    
    if([referenceKeyword isEqualToString:@"LoggerData"])
        [((LoggerData *)calledClass) createFile:outputString];
    else if([referenceKeyword isEqualToString:@"ViewData"])
        [((ViewData *)calledClass) requestCompleted:brspObject result:outputString];
}

//Method to set the seed value for CRC process

-(void)setSeed:(int)_16bitData
{
    crc=_16bitData & 0xffff;
    NSLog(@"Seed Value after processing = %d",crc);
}

// Method to perform the XOR and shifting process

-(int)crcCheck:(NSString*)byte1
{
    int byte_2=[self hex2dec:byte1];
    
//    NSLog(@"Byte1 = %@ corresponding decimal = %d CRC = %d",byte1,byte_2,crc);
    
    crc=(crc << 8)^CRC_CCITT_Table[((crc>>8)^byte_2)&0xff];
    crc&=0xffff;
    
//    NSLog(@"CRC Value = %d",crc);
    
    if(crc==0)
        return 1;
    else
        return 0;
}

// Method to convert double byte of hexadecimal to the decimal value

-(int)payLoadLength:(NSString *)byte1 Byte:(NSString *)byte2
{
    p1=byte1;
    p2=byte2;
    baseString =[NSString stringWithFormat:@"%@%@",p2,p1];
    payloadLength=[self hex2dec:baseString];
    return payloadLength;
}

// Method to convert single byte of hexadecimal to the decimal value

-(int)hex2dec :(NSString *)str
{
    unsigned int result1=0;
    int output;
    NSScanner *scanner=[NSScanner scannerWithString:str];
    [scanner scanHexInt:&result1]; // used to get the int fro hexa value
    return  output=result1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.dc
}

@end
