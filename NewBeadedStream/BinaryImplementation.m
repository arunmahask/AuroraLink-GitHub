//
//  BinaryImplementation.m
//  AuroraLink
//
//  Created by dev13 on 17/03/14.
//  Copyright (c) 2014 fsp. All rights reserved.
//

#import "BinaryImplementation.h"

@interface BinaryImplementation ()

@end

@implementation BinaryImplementation
@synthesize referenceKeyword,brspObject;
@synthesize calledClass;

bool airSet, dateSet, tacSet, snowSet, sensorOut, tacCalib,dateValid,tacValid;
int portConnect, nft;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // only 4 tac are there so have to intialize the 4 tac id
        
        tacId1 =[NSMutableString stringWithString:@""];
        tacId2 =[NSMutableString stringWithString:@""];
        tacId3 =[NSMutableString stringWithString:@""];
        tacId4 =[NSMutableString stringWithString:@""];
    
        
        tempArray=[[NSMutableArray alloc]init];
        dataArray=[[NSMutableArray alloc]init];
        
        outputString=[[NSMutableString alloc]init];
        baseString=[[NSString alloc]init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//The below code show the conversion process of binary to ASCII format, with the input of the number of rows and processed array of bytes

-(NSMutableString *)process:(NSMutableArray *)outOflogger Records:(int)numberOfRecords{
    numberOfRecord = numberOfRecords;
    NSLog(@"Number of Records = %d",numberOfRecord);
    
    dataArray = [outOflogger mutableCopy];
    
    int remainingLength=0;
    int index=-1;
    
    for(int nfr=1;nfr<=numberOfRecord;nfr++){  //loop continue upto the available records from the logger
            remainingLength = [self payLoadLength:dataArray[++index] Byte:dataArray[++index]]; //Calculate the payload length of the row
        
            if((remainingLength-=1)<0)
                return NULL;
               payloadType= [self payLoadType:dataArray[++index]]; // Calculate the payload type of the row
            [outputString appendString:[NSString stringWithFormat:@"%d,",payloadType]];
            
            if((remainingLength-=2)<0)
                return NULL;
                recordNumber= [self rowNumber:dataArray[++index] Byte:dataArray[++index]]; // Calculate the record number of the row
            [outputString appendString:[NSString stringWithFormat:@"   %d,",recordNumber]];
            
            if((remainingLength-=1)<0)
                return NULL;
                [self findFlags:dataArray[++index]];   // Invoke the method to set the bit of the flag
        
            if(dateSet==1 && dateValid==1){
                if((remainingLength-=3)<0)
                    return NULL;
                dateCombine = [self date:dataArray[++index] Month:dataArray[++index] Date:dataArray[++index]];  // Invoke the method to get the new date information
                [outputString appendString:[NSString stringWithFormat:@"   %@,",dateCombine]];
            }
            else{
                [outputString appendString:[NSString stringWithFormat:@"   %@,",dateCombine]]; // there is no date byte use the previous date value, by flag settings
            }
        
            if((remainingLength-=2)<0)
                return NULL;
            timeCombine = [self time:dataArray[++index] Minute:dataArray[++index]]; // Invoke the method to get the new time information for every row
            [outputString appendString:[NSString stringWithFormat:@"   %@,",timeCombine]];
            
            if((remainingLength-=2)<0)
                return NULL;
                interTemp=[self interTemp:dataArray[++index] NextValue:dataArray[++index]]; //invoke the method to get the new internal temperature for every row
                [outputString appendString:[NSString stringWithFormat:@"   %.2f,",interTemp]];
            
            if((remainingLength-=2)<0)
                return NULL;
                batteryVoltage=[self batterVoltage:dataArray[++index] NextValue:dataArray[++index]]; //invoke the method to get the new battery voltage for every row
                [outputString appendString:[NSString stringWithFormat:@"   %.3f,",batteryVoltage]];
           
            if(airSet==1 && snowSet==1){                    //baesd on the flag bit setting get the both value of Air temperature and Snow Depth
                if((remainingLength-=4)<0)
                    return NULL;
                airSnowCombine= [self airAndsnowset:dataArray[++index] NextValue2:dataArray[++index] NextValue3:dataArray[++index] NextValue4:dataArray[++index]];
                [outputString appendString:[NSString stringWithFormat:@"   %@,",airSnowCombine]];
            }
        
            if(airSet==1){                                              //based on the flag bit setting get the value of Air temperature alone
                if((remainingLength-=2)<0)
                    return NULL;
                airValue= [self airSetProcess:dataArray[++index] NextValue:dataArray[++index]];
                [outputString appendString:[NSString stringWithFormat:@"   %f,",airValue]];
            }
        
            if(snowSet==1){                                         //based on the flag bit setting get the value of Snow Depth alone
                if((remainingLength-=2)<0)
                    return NULL;
               snowValue= [self snowSetProcess:dataArray[++index] NextValue:dataArray[++index]];
                [outputString appendString:[NSString stringWithFormat:@"   %u,",snowValue]];
            }
        
            if(tacSet==1 && tacValid==1)   // code to get the TAC id based on the idcount, idcount is number of tac id, so each tac have 7 byte so idcount *7
            {
                NSLog(@"Number of TAC = %d",idcount);
                if((remainingLength-=(idcount*7))<0)
                    return NULL;
                
                if([tacId1 isEqualToString:@""] && [tacId2 isEqualToString:@""] && [tacId3 isEqualToString:@""] && [tacId4 isEqualToString:@""])
                {
                    for(int r1=1;r1<=idcount*7;r1++)
                    {
                        if(r1>=1 && r1<=7)
                        {
                            [tacId1 appendString:dataArray[++index]];
                            [tacId1 appendString:@" "];
                        }
                        else if(r1>=8 && r1<=14)
                        {
                            [tacId2 appendString:dataArray[++index]];
                            [tacId2 appendString:@" "];
                        }
                        else if(r1>=15 && r1<=21)
                        {
                            [tacId3 appendString:dataArray[++index]];
                            [tacId3 appendString:@" "];
                        }
                        else if(r1>=22 && r1<=28)
                        {
                            [tacId4 appendString:dataArray[++index]];
                            [tacId4 appendString:@" "];
                        }
                    }
                }
                else
                {
                    for(int r1=1;r1<=idcount*7;r1++)
                    {
                        [dataArray removeObjectAtIndex:++index];
                    }
                }
                
                NSLog(@"TAC 1 = %@ ,TAC 2 = %@ ,TAC 3 = %@ ,TAC 4 = %@",tacId1,tacId2,tacId3,tacId4);
                
                /*if(idcount==1)
                    [outputString appendString:[NSString stringWithFormat:@"   %@,",tacId1]];
               else if(idcount==2)
                    [outputString appendString:[NSString stringWithFormat:@"   %@,   %@,",tacId1,tacId2]];
                else if(idcount==3)
                    [outputString appendString:[NSString stringWithFormat:@"   %@,   %@,   %@,",tacId1,tacId2,tacId3]];
                else if(idcount==4)
                    [outputString appendString:[NSString stringWithFormat:@"   %@,   %@,   %@,    %@,",tacId1,tacId2,tacId3,tacId4]];*/
            }
            else{
               /* if(idcount==1)
                    [outputString appendString:[NSString stringWithFormat:@"   %@,",tacId1]];
                else if(idcount==2)
                    [outputString appendString:[NSString stringWithFormat:@"   %@,   %@,",tacId1,tacId2]];
                else if(idcount==3)
                    [outputString appendString:[NSString stringWithFormat:@"   %@,   %@,   %@,",tacId1,tacId2,tacId3]];
                else if(idcount==4)
                    [outputString appendString:[NSString stringWithFormat:@"   %@,   %@,   %@,    %@,",tacId1,tacId2,tacId3,tacId4]];*/
            }
        
    /* Every outputString appending process is to 
        add a new data to the exiting converted data to display in to console and copy to the file */
        
        NSMutableArray *tacArray = [[NSMutableArray alloc]initWithObjects:tacId1,tacId2,tacId3,tacId4, nil];
    
        
        /* Following loop contine up to the idcount for each row, because each row have to 
            possibilty of having 1 or 2 or 3 or 4 id's itself, then have to identify the number of sensor and convert the hexa decimal to the temperature */
        
        
                for(nft=1;nft<=idcount;nft++)
                {
                    if((remainingLength-=1)<0)
                        return NULL;
                    
                    [outputString appendString:[NSString stringWithFormat:@"  %@ ",[tacArray objectAtIndex:nft-1]]];
                    
                    numberOfSensor=[self hex2dec:dataArray[++index]];       // convert the sensor hexbyte to decimal value
                    
//                    NSLog(@"Number of Sensor = %d",numberOfSensor);
                    
                    if((remainingLength-=(numberOfSensor*2))<0)
                        return NULL;
                    
                        for(int nfs=1;nfs<=numberOfSensor;nfs++)
                        {
                            p1=dataArray[++index];
                            p2=dataArray[++index];
                            baseString=[NSString stringWithFormat:@"%@.%@",p2,p1]; // have to make the swaping for every byte
                            degree=[self makeShort:baseString]*0.01;            // Method to get the temperature in decimal format
                            [outputString appendString:[NSString stringWithFormat:@"  %.2f,",degree]];
//                            NSLog(@"P1 = %@   P2 = %@  Degree = %.2f",p1,p2,degree);
                        }
                    }
        // The below 2 statements are used to get the CRC values
        
         NSString *crc1 = dataArray[++index];
         NSString *crc2 = dataArray[++index];
        
        if(remainingLength==0){
            NSLog(@"Remaining Length become zero = %d  CRC1 = %@ ,   CRC2 = %@ ",remainingLength,crc1,crc2);
        }
        
        NSMutableString *refOut = [[outputString substringToIndex:outputString.length-1] mutableCopy];
        outputString = refOut;
        [outputString appendString:@"\n"];          // add a carriage retrun for the next line generation
    }
//    NSLog(@"%@",outputString);
    return outputString;
}

-(void)findFlags:(NSMutableString *)flagVal
{
    dateValid=0;
    tacValid=0;
    
    NSMutableString *FlagValue =flagVal;
    
//    NSLog(@"Flag Value = %@",FlagValue);
    
    int flag1 = [self hex2dec:FlagValue];
    
//    NSLog(@"int value = %d",flag1);
    
    NSString *subString;
    
    NSArray * cnstinter = [[NSArray alloc] initWithObjects:@"32",@"8",@"7",@"16", nil];
    
    //32 = 0x20 -> Check Air Temp include or not
    //8   = 0x08 -> Check Date Include or not
    //7   = 0x07 -> Check TAC info include or not
    //16 = 0x10 -> Check Snow Depth include or not
    
    
    /* have to perform the AND operation using flag byte and each elements fo the cnstinter array
        to find the bit set for the above conversion process */
    
    for (int c=0; c<[cnstinter count]; c++)
    {
        unsigned int b = [[cnstinter objectAtIndex:c] intValue];
        conv = 0;
        conv = flag1 & b;
        
//        NSLog(@"B = %d, flag =%d, C = %d , Operation = %d",b,flag1, c ,conv);
        
        if((c==0) && (conv != 0))
        {
            airSet=1;
        }
        if((c==1 ) && (conv!=0))
        {
            dateSet=1;
            dateValid=1;
        }
        if((c==2) && (conv!=0))
        {
            tacSet=1;
            tacValid=1;
            tacId1 =[NSMutableString stringWithString:@""];
            tacId2 =[NSMutableString stringWithString:@""];
            tacId3 =[NSMutableString stringWithString:@""];
            tacId4 =[NSMutableString stringWithString:@""];
        }
        if((c==3 )&& (conv!=0))
        {
            snowSet=1;
        }
    }
    
    /* The below code is used to convert the hexadecimal to binary value (0's and 1's), 
     here the hexa decimal values are stored as a string*/
    
    NSInteger number=flag1;
    
//    NSString *str = [self toBinary:number];
    
    NSMutableString *str=[NSMutableString string];
    
    for(NSInteger numberData=number;numberData>0;numberData>>=1)
    {
        [str insertString:((numberData & 1) ?@"1":@"0") atIndex:0];
    }
    
    if(str.length <4)
    {
        int len = str.length;
        if(len==3)
            str = [NSMutableString stringWithFormat:@"0%@",str];
        else if(len==2)
            str = [NSMutableString stringWithFormat:@"00%@",str];
        else if(len==1)
            str = [NSMutableString stringWithFormat:@"000%@",str];
        else if(len==0)
            str = [NSMutableString stringWithFormat:@"0000"];
        
    }

    if([str isEqualToString:@""])
    {
//        NSLog(@"No Flag value");
    }
    else
    {
        subString = [str substringWithRange:NSMakeRange(1, 3)]; // take the LSB 3 bits of the binary data for get the TAC id count
        
        /* if the LSB 3 bits 
         001 - 1 TACId
         010 - 2 TACId
         011 - 3 TACId
         100 - 4 TACId
         */
        
        if([subString isEqualToString:@"001"])
            idcount=1;
        else if([subString isEqualToString:@"010"])
            idcount=2;
        else if([subString isEqualToString:@"011"])
            idcount=3;
        else if([subString isEqualToString:@"100"])
            idcount=4;
        
        if (([subString isEqualToString:@"000"] && payloadLength == 10) || ([subString isEqualToString:@"000"] && payloadLength == 13))
            idcount=0;
    }
    
//    NSLog(@"Flag Bit Binary = %@ Number of TAC = %d",str,idcount);
    
    NSLog(@" %d, %d, %d, %d",airSet,dateSet,tacSet,snowSet);
    
   // [self tacFlagChek:flagVal];
    
}

-(void)tacFlagChek:(NSMutableString *)flagVal1
{
    int flagp1=[self hex2dec:flagVal1];
    
    NSString *subString;
    
//    NSLog(@"int value = %d",flagp1);
    NSArray * cnstinter = [[NSArray alloc] initWithObjects:@"8",@"4",@"3", nil];
    
    //8   = 0x08 -> Check Sensor out of Sequence
    //4   = 0x04 -> Check TAC calibrated
    //16 = 0x10 -> Check port TAC is connected to (0..3 = TAC port 1..4)
    
    for (int c=0; c<[cnstinter count]; c++)
    {
        unsigned int b = [[cnstinter objectAtIndex:c] intValue];
        conv = 0;
        conv = flagp1 & b;
        
//        NSLog(@"B = %d, flag =%d, C = %d , Operation = %d",b,flagp1, c ,conv);
        
        if((c==0) && (conv != 0))
        {
            sensorOut=1;
        }
        if((c==1 ) && (conv!=0))
        {
            tacCalib=1;
        }
        if(c==2)
        {
            conv+=1;
//            NSLog(@"After adding one = %d",conv);
            NSInteger number=conv;
            NSMutableString *str=[NSMutableString string];
            for(NSInteger numberData=number;numberData>0;numberData>>=1)
            {
                [str insertString:((numberData & 1) ?@"1":@"0") atIndex:0];
            }
            
            if([str isEqualToString:@""])
            {
                //        NSLog(@"No Flag value");
            }
            else
            {
                subString = [str substringWithRange:NSMakeRange(1, 3)]; // take the LSB 3 bits of the binary data for get the TAC id information
                
                /* if the LSB 3 bits
                 00 - 1 port 1
                 01 - 2 port 2
                 10 - 3 port 3
                 11 - 4 port 4
                 */
                
                if([subString isEqualToString:@"00"])
                    port=1;
                else if([subString isEqualToString:@"01"])
                    port=2;
                else if([subString isEqualToString:@"10"])
                    port=3;
                else if([subString isEqualToString:@"11"])
                    port=4;
            }
            NSLog(@"Flag Bit Binary = %@ Port number = %d",str,port);
       }
    }
    
    idcount=1;
    
   //[self findFlagPayloadLengthDateTime:dataArray PacketSize:packetSize]; // invoke a method to calculate the flag and payload length
}

//Method to find the Payload Length of each row

-(int)payLoadLength:(NSString *)byte1 Byte:(NSString *)byte2
{
    p1=byte1;
    p2=byte2;
    baseString =[NSString stringWithFormat:@"%@%@",p2,p1];
    //NSLog(@"P1= %@, P2= %@",p1,p2);
    payloadLength=[self hex2dec:baseString];
//    NSLog(@"P1= %@, P2= %@ Payload length = %d",p1,p2,payloadLength);
    return payloadLength;
}

//Method to find the Payload Type of each row

-(int)payLoadType:(NSString *)byte1
{
    payloadType=[self hex2dec:byte1];
//    NSLog(@"Payload Type = %d",payloadType);
    return payloadType;
}


//Method to get the row number

-(int)rowNumber:(NSString *)byte1 Byte:(NSString *)byte2
{
    p1=byte1;
    p2=byte2;
    baseString = [NSString stringWithFormat:@"%@%@",p2,p1];
    recordNumber=[self hex2dec:baseString];
//    NSLog(@"P1= %@, P2= %@ Record Number = %d",p1,p2,recordNumber);
    return recordNumber;
}

//Method to get the year/month/date format

-(NSString *)date:(NSString *)year1 Month:(NSString *)month1 Date:(NSString *)date1
{
    year=[self hex2dec:year1]+2000; // add 2000 to get the year
    month=[self hex2dec:month1];
    date=[self hex2dec:date1];
//    NSLog(@"%d/%d/%d",year,month,date);
    dateCombine=[NSString stringWithFormat:@"%d/%02d/%02d",year,month,date];
    return dateCombine;
}

//Method to get the hour:minute:second

-(NSString *)time:(NSString *)byte1 Minute:(NSString *)byte2
{
    hour=[self hex2dec:byte1];
    minute=[self hex2dec:byte2];
//    NSLog(@"%d:%d",hour,minute);
    timeCombine=[NSString stringWithFormat:@"%02d:%02d",hour,minute];
    return timeCombine;
}

//Method to get the internal temperature

-(CGFloat)interTemp:(NSString *)byte1 NextValue:(NSString *)byte2
{
    p1=byte1;
    p2=byte2;
    baseString = [NSString stringWithFormat:@"%@.%@",p2,p1];
    interTemp = [self makeShort:baseString]*0.01;
//    NSLog(@"P1= %@, P2= %@ Inter Temp = %.2f",p1,p2,interTemp);
    return interTemp;
}

//Method to get the battery voltage

-(CGFloat)batterVoltage:(NSString *)byte1 NextValue:(NSString *)byte2
{
    p1=byte1;
    p2=byte2;
    baseString=[NSString stringWithFormat:@"%@.%@",p2,p1];
    batteryVoltage=[self makeShort:baseString]*0.001;
//    NSLog(@"P1= %@, P2= %@ Battery Voltage = %.3f",p1,p2,batteryVoltage);
    return batteryVoltage;
}

//Method to get the Air temperature and Snow Depth combined if the both value are set

-(NSString *)airAndsnowset:(NSString *)byte1 NextValue2:(NSString *)byte2 NextValue3:(NSString *)byte3 NextValue4:(NSString *)byte4
{
    p1=byte1;
    p2=byte2;
    baseString=[NSString stringWithFormat:@"%@.%@",p2,p1];
    airValue=[self makeShort:baseString];
//    NSLog(@"P1= %@, P2= %@ Air Value = %f",p1,p2,airValue);

    p1=byte3;
    p1=byte4;
    baseString=[NSString stringWithFormat:@"%@%@",p2,p1];
    snowValue=[self hex2dec:baseString];
//   NSLog(@"P1= %@, P2= %@ Air Value = %d",p1,p2,snowValue);
    
    airSnowCombine=[NSString stringWithFormat:@"%f   %d",airValue,snowValue];
    
    return airSnowCombine;
}

//Method to get the Air temperature if the air temperature alone

-(int)airSetProcess:(NSString *)byte1 NextValue:(NSString *)byte2
{
    p1=byte1;
    p2=byte2;
    baseString=[NSString stringWithFormat:@"%@.%@",p2,p1];
    airValue=[self makeShort:baseString];
//    NSLog(@"P1= %@, P2= %@ Air Value = %f",p1,p2,airValue);
    return airValue;
}

//Method to get the Snow depth vlaue alone

-(int)snowSetProcess:(NSString *)byte1 NextValue:(NSString *)byte2
{
    p1=byte1;
    p1=byte2;
    baseString=[NSString stringWithFormat:@"%@%@",p2,p1];
    snowValue=[self hex2dec:baseString];
//    NSLog(@"P1= %@, P2= %@ Snow Value = %d",p1,p2,snowValue);
    return snowValue;
}


// Method used to create the whole number decimal value for the hexadecimal value

-(int)hex2dec :(NSString *)str
{
    unsigned int result1=0;
    int output;
    NSScanner *scanner=[NSScanner scannerWithString:str];
    [scanner scanHexInt:&result1]; // used to get the int fro hexa value
    return  output=result1;
}

//Method used to create the degree value both negative and positive value

-(int)makeShort:(NSString *)hexval
{
    NSArray *arr=[hexval componentsSeparatedByString:@"."];
    int a,b,c,d,lsb,msb;
    a=[self calculateLeftValue:[arr firstObject]];
    b=[self calculateLeftValue:[arr lastObject]];
    //NSLog(@"Value of A = %@ Value of B = %@",[arr firstObject],[arr lastObject]);
    lsb=(0xff & b);
    msb=(a<<8);
    c=lsb | msb;
    if(msb>=32768)
        d=c-65536;
    else
        d=c;
    //NSLog(@"Out of Process = %d  MSB = %d  LSB = %d",d,(0xff & b),(a<<8));
    return d;
}

// Method used to create the fractional decimal value for hexadecimal value

- (double)conversionHextoDec:(NSString *)hexval
{
    NSArray *arr = [hexval componentsSeparatedByString:@"."];
    NSString *leftstr = [arr firstObject];
    NSString *rightstr = [arr lastObject];
    double lv = [self calculateLeftValue:leftstr];
    double rv = [self calculateRightValue:rightstr];
    double tv = lv+rv;
    return tv;
    NSLog(@"result :%f",tv);
}

//Method to calculte the left value for the fractional hexadecimal

- (double)calculateLeftValue:(NSString *)value{
    NSString *hexval = value;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=hexval.length; i>0; i--){
        NSRange range = {i-1,1};
        NSString *subword = [self hexfromAlphabet:[hexval substringWithRange:range]];
        [arr addObject:subword];
    }
    double dec = 0;
    
    for (int j=0; j<[arr count]; j++){
        int pow = 1;
        for (int i = 1; i<=j; i++){
            pow = 16*pow;
        }
        int sum = [[arr objectAtIndex:j] intValue];
        int curval = sum * pow;
        dec = dec + curval;
    }
    return dec;
}

//Method to calculate the right vlaue for the fractional hexadecimal

- (double)calculateRightValue:(NSString *)value{
    NSString *hexval = value;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=1; i<=hexval.length; i++) {
        NSRange range = {i-1,1};
        NSString *subword = [self hexfromAlphabet:[hexval substringWithRange:range]];
        [arr addObject:subword];
    }
    NSLog(@"arr = %@",arr);
    double dec = 0;
    
    for (int j=0; j<[arr count]; j++) {
        double pow = 16;
        for (double i=1; i<=j; i++) {
            pow = 16*pow;
        }
        
        double invpow = (1/pow);
        int sum = [[arr objectAtIndex:j] intValue];
        double curval = sum * invpow;
        dec = dec + curval;
    }
    return dec;
}

//Method to create the decimal value for the hexadecimal for (A, B, C, D , E, F)

- (NSString *)hexfromAlphabet:(NSString *)str {
    
    NSString *getstr = str;
    str = [str uppercaseString];
    if ([str isEqualToString:@"A"]) {
        str = @"10";
    }
    else if ([str isEqualToString:@"B"]) {
        str = @"11";
    }
    else if ([str isEqualToString:@"C"]) {
        str = @"12";
    }
    else if ([str isEqualToString:@"D"]) {
        str = @"13";
    }
    else if ([str isEqualToString:@"E"]) {
        str = @"14";
    }
    else if ([str isEqualToString:@"F"]) {
        str = @"15";
    }else{
        str = getstr;
    }
    return str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
