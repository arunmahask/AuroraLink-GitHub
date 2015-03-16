//
//  LoggerDetail.m
//  NewBeadedStream
//
//  Created by fsp on 6/21/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "LoggerDetail.h"
#import "ScanDevice.h"

@interface LoggerDetail ()
@end

@implementation LoggerDetail

@synthesize backButton=_backButton;
@synthesize settings=_settings;
@synthesize data=_data;
@synthesize emulator=_emulator;
@synthesize loggerName=_loggerName;
@synthesize gpscod=_gpscod;
@synthesize voltage=_voltage;
@synthesize interval=_interval;
@synthesize saveButton=_saveButton;
@synthesize intervalPicker=_intervalPicker;

@synthesize intervalData=_intervalData;
@synthesize detail=_detail;
@synthesize devName=_devName;

@synthesize brspObject;
@synthesize isldeHistory,title1,isData,isldemhistory;

@synthesize connectDevice,procedure;

-(void)receivingData:(Brsp *)brspObject result:(NSString *)DataSr{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)callCmd{
    NSLog(@"Buff 1 %d",[brspObject outputBufferCount]);
    [self sendCommand:@"status"];
}

#pragma mark BrspDelegate - used to send the all commands to the brsp library

- (void)brsp:(Brsp*)brsp OpenStatusChanged:(BOOL)isOpen
{
    if (isOpen)
    {
//The BRSP object is ready to be used
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
//Print the security level of the brsp service to console
        
        NSLog(@"BRSP Security Level is %d", brspObject.securityLevel);
        [self performSelector:@selector(sendCommand:) withObject:@"STATUS" afterDelay:1.5];
        
        NSDate *currentdate=[NSDate date];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString *date=[dateFormatter stringFromDate:currentdate];
        NSString *logforConnection=[NSString stringWithFormat:@"Send Status command to logger device %@ at %@",[AppDelegate app].activePeripheral.name,date];
        
        NSLog(@"%@",logforConnection);
        
        DataBaseControl *db=[[DataBaseControl alloc]init];
        [db logfile:logforConnection];
    }
    else
    {
//brsp object has been closed
        NSLog(@"NOT OPENED");
    }
}

- (void)brsp:(Brsp*)brsp SendingStatusChanged:(BOOL)isSending
{
//This is a good place to change BRSP mode
//If we are on the last command in the queue and we are no longer sending, change the mode back to previous value
    if (isSending == NO && _commandQueue.count == 1)
    {
        if (_lastMode == brspObject.brspMode)
            return;  //Nothing to do here
//Change mode back to previous setting
        NSError *error = [brspObject changeBrspMode:_lastMode];
        if (error)
            NSLog(@"%@", error);
    }
}

- (void)brspDataReceived:(Brsp*)brsp
{
//If there are items in the _commandQueue array, assume this data is part of a command response
    
    _tempResStringFromDevice = [[brspObject readString] mutableCopy];
    _responseStringFromDevice = [[_responseStringFromDevice stringByAppendingFormat:@"%@",_tempResStringFromDevice] mutableCopy];
    
    if([_tempResStringFromDevice rangeOfString:@">"].location != NSNotFound)
    {
        isData=YES;
        NSLog(@"Found >  %@,     %d",_responseStringFromDevice,isData);
        
            if(([_responseStringFromDevice rangeOfString:@"ERROR: command \"BRSP,0,1\" not recognized"].location != NSNotFound) && (gotStatus == NO))
            {
                gotStatus = YES;
                _responseStringFromDevice = nil;
                _responseStringFromDevice = [[NSMutableString alloc] init];
                lAnimate.labelText = @"Requesting for device status...";
            }
        
            else
            {
                NSRange delLocation = [_responseStringFromDevice rangeOfString:@">"];
                [_responseStringFromDevice deleteCharactersInRange:delLocation];
            
                NSLog(@"Final result: %@",_responseStringFromDevice);
            
                NSLog(@"OMG %@",[_responseStringFromDevice componentsSeparatedByString:@"\n"]);
            
                NSMutableArray *res = [[_responseStringFromDevice componentsSeparatedByString:@"\n"] mutableCopy];
                NSMutableDictionary *status = [[NSMutableDictionary alloc] init];
            
                    for (id val in res)
                    {
                        if([val rangeOfString:@":"].location != NSNotFound)
                        {
                            NSRange loc = [val rangeOfString:@":"];
                            [status setObject:[val substringFromIndex:NSMaxRange(loc)] forKey:[val substringToIndex:NSMaxRange(loc)]];
                        }
                    }
            
                [res removeAllObjects];
                res = [status mutableCopy];
            
//               _loggerName.text = [AppDelegate app].activePeripheral.name;
                
                NSString *l1=[res valueForKey:@" Serial number    :"];
                NSString *l2= [l1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                if([res valueForKey:@" Serial number    :"])
                    _loggerName.text = l2;
            
                if([res valueForKey:@" GPS description  :"])
                    _gpscod.text = [res valueForKey:@" GPS description  :"];
            
                if([res valueForKey:@" Battery voltage  :"])
                    _voltage.text = [res  valueForKey:@" Battery voltage  :"];
            
                if([res valueForKey:@" Logging  period  :"])
                    _interval.text = [res valueForKey:@" Logging  period  :"];
            
                _responseStringFromDevice = nil;
                _responseStringFromDevice = [[NSMutableString alloc] init];
            
                if ([_interval.text length] && (![lAnimate isHidden]))
                {
                    NSLog(@"interval.value   %@",_interval.text);
                    [self saveProcess1];  //Here store the logger detail while on the first search
                    if(![lAnimate isHidden])
                        lAnimate.hidden = YES;
                    [self Accessoption];
                }
            
                NSDate *currentdate=[NSDate date];
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                NSString *date=[dateFormatter stringFromDate:currentdate];
                NSString *logforConnection=[NSString stringWithFormat:@"Data Received from the logger device %@ at %@",[AppDelegate app].activePeripheral.name,date];
            
                NSLog(@"%@",logforConnection);
            
                DataBaseControl *db=[[DataBaseControl alloc]init];
                [db logfile:logforConnection];
            }
    }
}

- (void)brsp:(Brsp*)brsp ErrorReceived:(NSError*)error
{
    NSLog(@"ErrorReceived %@", error.description);
}

- (void)brspModeChanged:(Brsp*)brsp BRSPMode:(BrspMode)mode
{
    NSLog(@"BRSP Mode changed to %d", mode);
}

#pragma mark CBCentralManagerDelegate - delegates used for central manager framework for bluetooth connection

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState");
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
//call the open function to prepare the brsp service
    NSLog(@"INSIDE THE DIDCONNECT");
    
    [self.brspObject open];
    
    if(peripheral.isConnected && [self.brspObject isOpen])
    {
        NSLog(@"S centralManagerDidUpdateState");
    }
    else
    {
        NSLog(@"N centralManagerDidUpdateState");
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.brspObject close];
    NSLog(@"Connection terminate");
    [AppDelegate app].activePeripheral = nil;
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didFailToConnectPeripheral");
}


//***** Method used design the logger detail page ******//

- (void)viewDidLoad
{
        [super viewDidLoad];
    
        frame1=[[UIScreen mainScreen]bounds];
        loggerInfo=[[NSMutableArray alloc]init];
    
        isData=NO;
    
    //***** Navigation Bar Settings *******//
    
            titleLabel = [[UILabel alloc]init];
            titleLabel.textAlignment=UITextAlignmentCenter;
            titleLabel.text=[AppDelegate app].activePeripheral.name;
            titleLabel.backgroundColor=[UIColor clearColor];
            titleLabel.textColor=[UIColor whiteColor];
    
            _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _settings = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //***** Body content element allocation ******//
    
            _loggerName=[[UITextField alloc]init];
            _gpscod=[[UITextField alloc]init];
            _voltage=[[UITextField alloc]init];
            _interval=[[UITextField alloc]init];
            _interval.tag=1212;
    
            _saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
            _detail=[UIButton buttonWithType:UIButtonTypeCustom ];

    //***** Element for Alert View ******//
    
            _loggerName.backgroundColor=[UIColor clearColor];
            _loggerName.textColor=[UIColor whiteColor];
            _loggerName.placeholder=@"Logger Name";
            _loggerName.delegate=self;
    
            _gpscod.backgroundColor=[UIColor clearColor];
            _gpscod.textColor=[UIColor whiteColor];
            _gpscod.placeholder=@"GPS Coordinate";
            _gpscod.delegate=self;
    
            _voltage.backgroundColor=[UIColor clearColor];
            _voltage.textColor=[UIColor whiteColor];
            _voltage.placeholder=@"Voltage";
            _voltage.delegate=self;
    
            _interval.backgroundColor=[UIColor clearColor];
            _interval.textColor=[UIColor whiteColor];
            _interval.placeholder=@"Interval";
            _interval.delegate=self;
    

            [_saveButton addTarget:self action:@selector(saveProcess) forControlEvents:UIControlEventTouchUpInside];
            [_detail addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //***** Drop down list creation *****//
    
            self.intervalData=[[NSArray alloc]initWithObjects:@"01:00",@"02:00",@"03:00",@"04:00",@"06:00",@"12:00", nil];
    
            _intervalPicker=[[UIPickerView alloc]init];
            [_intervalPicker setDelegate:self];
            [_intervalPicker setDataSource:self];
            _intervalPicker.showsSelectionIndicator=YES;
            [_intervalPicker selectRow:3 inComponent:0 animated:YES];

    
    //****** Tabbar Button Allocation *******//
    
            infoSelect = [[UIImageView alloc] init];
            infoImage=[[UIImageView alloc]init];
    
            _data=[UIButton buttonWithType:UIButtonTypeCustom];
            _emulator=[UIButton buttonWithType:UIButtonTypeCustom];
    
            NSLog(@"self.brspObject %@ %d",[NSString stringWithFormat:@"%@",self.brspObject],self.brspObject.isOpen);
            _responseStringFromDevice = [[NSMutableString alloc] init];
    
            [self Accessoption];
    
}

-(void)hideview
{
            self.navigationItem.leftBarButtonItem.enabled = NO;
            self.navigationItem.rightBarButtonItem.enabled = NO;
            self.data.enabled = NO;
            self.emulator.enabled = NO;
            self.saveButton.enabled = NO;
}

-(void)Accessoption
{
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.data.enabled = YES;
            self.emulator.enabled = YES;
            self.saveButton.enabled = YES;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeText=textField;
    if(activeText.tag==1212)
    {
        [textField resignFirstResponder];
    }
    _intervalPicker.hidden=YES;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"EndEditing");
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- Delegate for PickerView

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_intervalData count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_intervalData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _interval.text=[_intervalData objectAtIndex:row];
    NSLog(@"Picker value ---------- %@",[_intervalData objectAtIndex:row]);
    self.intervalPicker.hidden=YES;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(void)viewWillAppear:(BOOL)animated
{
        _loggerName.text=@"";
        _gpscod.text=@"";
        _voltage.text=@"";
        _interval.text=@"";
    
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"]);
    
        if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
        {
                    buttonImage1=[UIImage imageNamed:@"info.png"];
                    [_settings setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
                    _settings.frame = CGRectMake(0, 0, (buttonImage1.size.width / buttonImage1.size.height) * 30, 30);
                    [_settings addTarget:self action:@selector(infoView) forControlEvents:UIControlEventTouchUpInside];
                    barButton1 = [[UIBarButtonItem alloc] initWithCustomView:_settings];
        
                    buttonImage=[UIImage imageNamed:@"LoggersBtn.png"];
                    [_backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
                    _backButton.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 30, 30);
                    [_backButton addTarget:self action:@selector(backProcess) forControlEvents:UIControlEventTouchUpInside];
                    barButton  = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
        
                    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
        
                    titleLabel.frame=CGRectMake(105.0, 0.0, 200.0, 40.0);
                    [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
        
                    infoSelect.image  =[UIImage imageNamed:@"infoSelect.png"] ;
                    infoImage.image=[UIImage imageNamed:@"BasicLayer.png"];
        
                    [_loggerName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0]];
                    [_gpscod setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0]];
                    [_voltage setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0]];
                    [_interval setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0]];
            
                    if([[UIScreen mainScreen] bounds].size.height == 568 )
                    {
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                        infoSelect.frame = CGRectMake(0, frame1.size.height-128, 320, 64);
                                        infoImage.frame=CGRectMake(7, 20, 306, 226);
            
                                        _data.frame=CGRectMake(frame1.size.width - 214,frame1.size.height - 128,frame1.size.width - 214.0,60.0);
                                        _emulator.frame=CGRectMake(frame1.size.width - 107.0,frame1.size.height - 128,frame1.size.width - 214.0,60.0);
            
                                        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                        {
                                                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"solidNavBar.png"] forBarMetrics:UIBarMetricsDefault];
                                                self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0, 320.0, 65.0);
                                        }
            
                                        [_intervalPicker setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f]];
                                        _intervalPicker.frame=CGRectMake(110, 270, 100, 100);
            
                                        _loggerName.frame=CGRectMake(14, 30, 295, 30);
                                        _gpscod.frame=CGRectMake(14, 74, 295, 30);
                                        _voltage.frame=CGRectMake(14, 120, 295, 30);
                                        _interval.frame=CGRectMake(14, 165, 295, 30);
            
                                        _saveButton.frame=CGRectMake(7, 211, 295, 36);
                                        _detail.frame=CGRectMake(268, 163, 40, 31);
                            }
                            else
                            {
                                        infoSelect.frame = CGRectMake(0, 440, 320, 64);
                                        infoImage.frame=CGRectMake(7, 19, 306, 226);
            
                                        _data.frame=CGRectMake(frame1.size.width - 214,frame1.size.height - 120,frame1.size.width - 214.0,63.0);
                                        _emulator.frame=CGRectMake(frame1.size.width - 107.0,frame1.size.height - 120,frame1.size.width - 214.0,63.0);
            
            
                                        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                        {
                                            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                                        }
            
                                        _intervalPicker.frame=CGRectMake(110, 270, 100, 100);
            
                                        _loggerName.frame=CGRectMake(14, 32, 295, 30);
                                        _gpscod.frame=CGRectMake(14, 77, 295, 30);
                                        _voltage.frame=CGRectMake(14, 123, 295, 30);
                                        _interval.frame=CGRectMake(14, 168, 295, 30);
            
                                        _saveButton.frame=CGRectMake(7, 210, 295, 36);
                                        _detail.frame=CGRectMake(268, 162, 40, 31);
            
                                }
                    }
                    else if([[UIScreen mainScreen] bounds].size.height == 480)
                    {
                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                        infoSelect.frame = CGRectMake(0, frame1.size.height-128, frame1.size.width, 64);
                                        infoImage.frame=CGRectMake(7, 20, 306, 226);
            
                                        _data.frame=CGRectMake(110, frame1.size.height-128, 106, 60);
                                        _emulator.frame=CGRectMake(219, frame1.size.height-128, 106, 60);
            
                                        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                        {
                                                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"solidNavBar.png"] forBarMetrics:UIBarMetricsDefault];
                                        }
            
                                        [_intervalPicker setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f]];
                                        _intervalPicker.frame=CGRectMake(110, 270, 100, 100);
        
                                        _loggerName.frame=CGRectMake(14, 30, 295, 30);
                                        _gpscod.frame=CGRectMake(14, 74, 295, 30);
                                        _voltage.frame=CGRectMake(14, 120, 295, 30);
                                        _interval.frame=CGRectMake(14, 165, 295, 30);
            
                                        _saveButton.frame=CGRectMake(10, 211, 295, 32);
                                        _detail.frame=CGRectMake(260,155, 40, 31);
                            }
                            else
                            {
                                        infoSelect.frame = CGRectMake(0, 352, 320, 64);
                                        infoImage.frame=CGRectMake(7, 19, 306, 226);
            
                                        _data.frame=CGRectMake(115, 356, 100, 64);
                                        _emulator.frame=CGRectMake(219, 356, 100, 64);
            
                                        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                        {
                                            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                                        }
            
                                        _intervalPicker.frame=CGRectMake(110, 270, 100, 100);
            
                                        _loggerName.frame=CGRectMake(14, 30, 295, 30);
                                        _gpscod.frame=CGRectMake(14, 77, 295, 30);
                                        _voltage.frame=CGRectMake(14, 123, 295, 30);
                                        _interval.frame=CGRectMake(14, 168, 295, 30);
            
                                        _saveButton.frame=CGRectMake(13, 210, 295, 36);
                                        _detail.frame=CGRectMake(268, 162, 40, 31);
                            }
                    }
        }
    //****** For iPad Design ******//
        else
        {
                    buttonImage1=[UIImage imageNamed:@"info~ipad.png"];
                    [_settings setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
                    _settings.frame = CGRectMake(0, 0,38, 38);
                    [_settings addTarget:self action:@selector(infoView) forControlEvents:UIControlEventTouchUpInside];
                    barButton1 = [[UIBarButtonItem alloc] initWithCustomView:_settings];
        
                    buttonImage=[UIImage imageNamed:@"LoggersBtn~ipad.png"];
                    [_backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
                    _backButton.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 46, 46);
                    [_backButton addTarget:self action:@selector(backProcess) forControlEvents:UIControlEventTouchUpInside];
                    barButton  = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
        
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                    {
                                backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background~ipad.png"]];
                    
                                titleLabel.frame=CGRectMake(150.0, 0.0, 300.0, 40.0);
                                [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
                    
                                infoSelect.image  =[UIImage imageNamed:@"infoSelect~ipad.png"] ;
                                infoImage.image=[UIImage imageNamed:@"BasicLayer~ipad.png"];
                    
                                [_loggerName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
                                [_gpscod setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
                                [_voltage setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
                                [_interval setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
            
                                infoSelect.frame = CGRectMake(0,frame1.size.height-107,frame1.size.width, 107);
                                infoImage.frame=CGRectMake(18, 120, 733, 421);
            
                                _data.frame=CGRectMake(260, frame1.size.height-95, 245, 100);
                                _emulator.frame=CGRectMake(510, frame1.size.height-95, 255, 100);
            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar~ipad.png"] forBarMetrics:UIBarMetricsDefault];
                                }
            
                                [_intervalPicker setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f]];
                                _intervalPicker.frame=CGRectMake(300, 600, 200, 200);
            
                                _loggerName.frame=CGRectMake(30, 143, 730, 30);
                                _gpscod.frame=CGRectMake(30, 230, 730, 30);
                                _voltage.frame=CGRectMake(30, 315, 730, 30);
                                _interval.frame=CGRectMake(30, 400, 730, 30);
            
                                _saveButton.frame=CGRectMake(18, 482, 725, 68);
                                _detail.frame=CGRectMake(685, 390, 50, 45);
                    }
        }
    
    [_data addTarget:self action:@selector(dataView) forControlEvents:UIControlEventTouchUpInside];
    [_emulator addTarget:self action:@selector(emulatoreView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView=titleLabel;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton=YES;
    
    self.navigationItem.rightBarButtonItem=barButton1;
    self.navigationItem.leftBarButtonItem=barButton;
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [self.view addSubview:infoSelect];
    [self.view addSubview:infoImage];
    
    [self.view addSubview:_loggerName];
    [self.view addSubview:_gpscod];
    [self.view addSubview:_voltage];
    [self.view addSubview:_interval];
    [self.view addSubview:_intervalPicker];
    
    [self.view addSubview:_data];
    [self.view addSubview:_emulator];
    
    [self.view addSubview:_saveButton];
    [self.view addSubview:_detail];
    
    _intervalPicker.hidden=YES;
    
    //***** used to check the
//                        if(![procedure isEqualToString:@"live"])
//                        {
                                    timer2=[NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(stopProcess) userInfo:nil repeats:NO];
                                    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
                                    {
                                        if([[UIScreen mainScreen] bounds].size.height == 568 )
                                        {
                                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                                            {
                                                lAnimate = [[MBProgressHUD alloc] initWithFrame:CGRectMake(40, 100, 250, 250)];
                                            }
                                            else
                                            {
                                                lAnimate = [[MBProgressHUD alloc] initWithFrame:CGRectMake(40, 100, 250, 250)];
                                            }
                                        }
                                        else
                                        {
                                            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                                            {
                                                lAnimate = [[MBProgressHUD alloc] initWithFrame:CGRectMake(40, 100, 250, 250)];
                                            }
                                            else
                                            {
                                                lAnimate = [[MBProgressHUD alloc] initWithFrame:CGRectMake(40, 100, 250, 250)];
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                                        {
                                            lAnimate = [[MBProgressHUD alloc] initWithFrame:self.view.frame];
                                        }
                                    }

                                    lAnimate.labelText = @"Connecting to device";
                                    [lAnimate setMode:MBProgressHUDAnimationFade];
                                    [self hideview];
                                    [lAnimate setOpacity:0.4];
                                    [self.view addSubview:lAnimate];
                                    [lAnimate show:YES];
        
                                    if([[AppDelegate app].activePeripheral isConnected])
                                    {
                                            lAnimate.labelText = @"Opening connection...";
                                            [AppDelegate app].cManager.delegate = self;
                                            self.brspObject = [[Brsp alloc] initWithPeripheral:[AppDelegate app].activePeripheral InputBufferSize:512 OutputBufferSize:512];
                                            NSLog(@"self.brspObject.isOpen %d",self.brspObject.isOpen);
            
                                        //It is important to set this delegate before calling [Brsp open]
                                            self.brspObject.delegate = self;
                                            [self.brspObject open];
                                    }
                                    else
                                    {
                                            NSLog(@"self.brspObject.isOpen %d",self.brspObject.isOpen);
                                            NSLog(@"ACTIVE PERIPHERAL ----------- %@", [AppDelegate app].activePeripheral.name);
                                            [AppDelegate app].cManager.delegate = self;
        
                                            self.brspObject = [[Brsp alloc] initWithPeripheral:[AppDelegate app].activePeripheral InputBufferSize:1024 OutputBufferSize:1024];
                                            NSLog(@"BRSP OBJECT NAME-----------%@",[NSString stringWithFormat:@"%@",self.brspObject]);
                                            //It is important to set this delegate before calling [Brsp open]
                                            self.brspObject.delegate = self;
    
                                            //Use CBCentral Manager to connect this peripheral
                                            [[AppDelegate app].cManager connectPeripheral:[AppDelegate app].activePeripheral options:nil];
                                    }
//                        }
//                        else
//                        {
//                                    DataBaseControl *dbc=[[DataBaseControl alloc]init];
//                                    NSString *content=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle" ];;
//                                    [dbc initDatabase];
//                                    existLoggerInfo=[[dbc getLoggerDetail:content]mutableCopy];
//                            
//                                    if(existLoggerInfo.count > 0)
//                                    {
//                                            NSLog(@"existLoggerinfo :%@",existLoggerInfo);
//            
//                                            titleLabel.text=[[existLoggerInfo objectAtIndex:0] valueForKey:@"loggerName"];
//                                            _loggerName.text=[[existLoggerInfo objectAtIndex:0] valueForKey:@"loggerName"];
//                                            _gpscod.text=[[existLoggerInfo objectAtIndex:0] valueForKey:@"gpscode"];
//                                            _voltage.text=[[existLoggerInfo objectAtIndex:0] valueForKey:@"voltage"];
//                                            _interval.text=[[existLoggerInfo objectAtIndex:0] valueForKey:@"interval"];
//                                    }
//                                    else
//                                    {
//                                            alert2=[[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Data About the Logger Is Not Exist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                            [alert2 show];
//                                    }
//                        }
    
}


- (void)viewDidUnload
{
    [self setLoggerName:nil];
    [self setGpscod:nil];
    [self setVoltage:nil];
    [self setInterval:nil];
    [self setSaveButton:nil];
    [self setDetail:nil];
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

#pragma mark - Method of Navigation bar

-(void)infoView{    
    InfoView *iv=[[InfoView alloc]init];
    [self.navigationController pushViewController:iv animated:YES];
}

-(void)backProcess
{
        gotStatus = NO;
    
    [_loggerName resignFirstResponder];
    [_gpscod resignFirstResponder];
    [_voltage resignFirstResponder];

    
        if([AppDelegate app].activePeripheral.isConnected)
        {
                NSLog(@"Farshore");
                [[AppDelegate app].cManager cancelPeripheralConnection:[AppDelegate app].activePeripheral];
                [AppDelegate app].activePeripheral=nil;
        }
    
        titleLabel.frame=CGRectMake(0.0, 0.0, 0.0, 0.0);
        NSArray *viewContrlls=[[self navigationController] viewControllers];
    
        for( int i=0;i<[ viewContrlls count];i++)
        {
                id obj=[viewContrlls objectAtIndex:i];
            
                if([obj isKindOfClass:[ScanDevice class]])
                {
                        [[self navigationController] popToViewController:obj animated:YES];
                        return;
                }
        }
}

//data parse
//Returns the full command string or nil.  (Up to and including the 4th "\r\n")

-(NSString*)parseFullCommandResponse
{
    
//Peek at the entire brsp input buffer and see if it contains a full AT command response
        NSString *tmp = [brspObject peekString];
 
        NSUInteger crlfcount = 0, length = [tmp length];
        NSRange range = NSMakeRange(0, length);
    
        while(range.location != NSNotFound && crlfcount != 4)
        {
                range = [tmp rangeOfString: @"\r\n" options:0 range:range];
                if(range.location != NSNotFound)
                {
                        range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                        crlfcount++;
                }
        }
    
        if (crlfcount==4)
        {
                return [tmp substringWithRange:NSMakeRange(0, range.location)];
        }
        else
        {
                return nil;
        }
}

//Returns the data portion from a command response string.  (String between the 3rd and 4th "\r\n"

-(NSString*)parseCommandData:(NSString*)fullCommandResponse
{
        NSArray *array = [fullCommandResponse componentsSeparatedByString:@"\r\n"];
    
        if (array && array.count > 3)
            return [array objectAtIndex:3];
        else
            return @"";
}

-(void)sendCommand:(NSString *)str
{
        NSLog(@"*** sendCommand ***");
        lAnimate.labelText = @"Requesting data...";
    
        if (![[str substringFromIndex:str.length-1] isEqualToString:@"\r"])
            str = [NSString stringWithFormat:@"%@\r", str];  //Append a carriage return
            //Write as string
            NSError *writeError = [self.brspObject writeString:str];
    
        if (writeError)
        NSLog(@"%@", writeError.description);
}

#pragma mark - Method of Tabbar

-(void)dataView{
    LoggerData *ld=[[LoggerData alloc]init];
    ld.isLoggerInrange=YES;
    [self.navigationController pushViewController:ld animated:NO];
}

-(void)emulatoreView{
    if(!isldeHistory && !isldemhistory){
        EmulatorView *ev=[[EmulatorView alloc]init];
        [self.navigationController pushViewController:ev animated:NO];
    }
    else{
        alert1=[[UIAlertView alloc]initWithTitle:@"Process Flow" message:@"Emulator process not allow, because you are from history!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert1.tag=123456;
        [alert1 show];
    }
}

//***** Method used to show the drop down list, when click the drop down button *****//

-(IBAction)detail:(id)sender
{
        self.intervalPicker.hidden=NO;
        [_loggerName resignFirstResponder];
        [_gpscod resignFirstResponder];
        [_voltage resignFirstResponder];
        [_interval resignFirstResponder];
}

//****** Method used to show the timeout alert, when timeout occurs, after execute the status command *****//

-(void)stopProcess
{
        if(!isData)
        {
                connetionFail=[[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Task timed out, Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                connetionFail.tag=1034;
                [connetionFail show];
                [timer2 invalidate];
            
                if(![lAnimate isHidden])
                {
                    [self Accessoption];
                    [lAnimate hide:YES];
                }
                [AppDelegate app].activePeripheral = nil;
                [brspObject close];
        }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!isldeHistory)
    {
        if([AppDelegate app].activePeripheral.isConnected)
        {
            NSLog(@"Farshore");
            [[AppDelegate app].cManager cancelPeripheralConnection:[AppDelegate app].activePeripheral];
            [AppDelegate app].activePeripheral=nil;
        }
        
        ScanDevice *sd=[[ScanDevice alloc]init];
        [self.navigationController pushViewController:sd animated:YES];
    }
}


//***** Method used to store the inforrmation about the loggers in hand held device *****//

-(IBAction)saveProcess
{
        [activeText resignFirstResponder];
    
        _intervalPicker.hidden=YES;
    
        DataBaseControl *dbc=[[DataBaseControl alloc]init];
    
        str1=_loggerName.text;
        str2=_gpscod.text;
        str3=_voltage.text;
        str4=_interval.text;
        str5=str4;
    
        if([str5 isEqualToString:@"01:00"])
        {
            str4=@"1:00";
        }
        else if([str5 isEqualToString:@"02:00"])
        {
            str4=@"2:00";
        }
        else if([str5 isEqualToString:@"03:00"])
        {
            str4=@"3:00";
        }
        else if([str5 isEqualToString:@"04:00"])
        {
            str4=@"4:00";
        }
        else if([str5 isEqualToString:@"06:00"])
        {
            str4=@"6:00";
        }
        else if([str5 isEqualToString:@"12:00"])
        {
            str4=@"12:00";
        }
        
            if([str1 isEqualToString:@""] || [str2 isEqualToString:@""] || [str3 isEqualToString:@""] || [str4 isEqualToString:@""])
            {
                    UIAlertView *wip = [[UIAlertView alloc] initWithTitle:@"Invalid Operation" message:@"Empty values are not allowed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [wip show];
            }
            else
            {
                    NSLog(@" %@\r  %@\r   %@\r   %@\r",str1,str2,str3,str4);
                    NSDate *currentdate=[NSDate date];
                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                    NSString *date=[dateFormatter stringFromDate:currentdate];
                    [dateFormatter setDateFormat:@"hh:mm a"];
                    NSString *time=[dateFormatter stringFromDate:currentdate];
                
                    [dbc initDatabase];
                
                    DataSource_1 *ds1=[[DataSource_1 alloc]initWithLoggerName:[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"] Date:date Time:time Description:[NSString stringWithFormat:@"Imported Data From %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"]] Data:@""];
                
                    [dbc insertDataforDetail:ds1];
                
                    LoggerSource *ls1=[[LoggerSource alloc]initWithLoggerName:str1 GPS:str2 Voltage:str3 Interval:str4];
                
                    [dbc insertDataforLogger:ls1];
                
            
                    UIAlertView *databaseop = [[UIAlertView alloc] initWithTitle:@"Database operation" message:@"Data copied to handheld device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [databaseop show];
            }
    
    //***** invoking a method to show the detail of the loggers in correspoding textField by exectuing the status command *****//
    
        [self showData];
}

-(void)saveProcess1
{
    
        NSLog(@"Automatically Save the recored");
    
        DataBaseControl *dbc=[[DataBaseControl alloc]init];
    
        str1=_loggerName.text;
        str2=_gpscod.text;
        str3=_voltage.text;
        str4=_interval.text;
    
       // LoggerSource *ls1=[[LoggerSource alloc]initWithLoggerName:_loggerName.text GPS:_gpscod.text Voltage:_voltage.text Interval:_interval.text];
    
        LoggerSource *ls1=[[LoggerSource alloc]initWithLoggerName:str1 GPS:str2 Voltage:str3 Interval:str4];
    
        [dbc initDatabase];
        [dbc insertDataforLogger:ls1];
}

-(void)wip
{
    UIAlertView *wip = [[UIAlertView alloc] initWithTitle:@"Work in progress..." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [wip show];
}

#pragma mark - The below method used to send a command and receives the output from and to the logger device

-(void)showData
{
        if(connectDevice == nil)
        {
                connectDevice = [[DeviceConnector alloc] init];
                connectDevice.delegate = self;
        }
        [connectDevice connectactivePeripheral];
}

-(void)deviceAlreadyConnected
{
        NSString *command=@"log_p ";
        NSString *command1=@"serial ";
        NSString *command2=@"transmit_p ";
    
        commandwithdata=[command stringByAppendingString:str4];
        commandwithdata1=[command1 stringByAppendingString:str1];
        commandwithdata2=[command2 stringByAppendingString:str4];
    
        [connectDevice sendCommand:commandwithdata];
        [connectDevice sendCommand:commandwithdata1];
        [connectDevice sendCommand:commandwithdata2];
}

-(void)requestStarted{
    NSLog(@"requestStarted on");
}

-(void)deviceConnected
{
    NSLog(@"deviceConnected");
    
    [connectDevice sendCommand:commandwithdata];
    [connectDevice sendCommand:commandwithdata1];
    [connectDevice sendCommand:commandwithdata2];
}

-(void)requestCompleted:(Brsp *)brspObject result:(NSString *)str{
    
}

-(void)requestCompleted1:(NSMutableString*)output NumbeofRow:(NSString *)numberOfRow
{
    
}


-(void)requestCompleted2:(NSString *)rowNumber
{
    
}

-(void)createFile:(NSMutableString *)receivedData
{
    
}

@end
