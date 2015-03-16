//
//  ViewData.m
//  NewBeadedStream
//
//  Created by fsp on 6/20/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "ViewData.h"
#import "AppDelegate.h"
#import "ScanDevice.h"

float d_Width = 0.0;

@interface ViewData ()
{
    CRC16 *crc16;
}
@end

//****** class used to download and view the logger sensor information ******//

@implementation ViewData

@synthesize backButton=_backButton;
@synthesize dataView=_dataView;
@synthesize loggerName=_loggerName;
@synthesize date=_date;
@synthesize completed=_completed;
@synthesize devName=_devName;
@synthesize scrollView=_scrollView;
@synthesize connectDevice;
@synthesize filePath,LLLoggerNameFromHistroy,DateFromHistory,isVHistory;

BOOL isRotationEnabled=NO;

#define degreesToRadians(x) (M_PI * x / 180.0)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        crc16 = [[CRC16 alloc]init];
    }
    return self;
}

-(void)receivingData:(Brsp *)brspObject result:(NSString *)DataStr
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dataFromSensorSet = [[NSMutableArray alloc] init];
    CGRect frame1=[[UIScreen mainScreen]bounds];
    
    ds1=[[DataSource_1 alloc]init];
    dbc=[[DataBaseControl alloc]init];
    
    theApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //***********read data from file**************//
    
    if(isVHistory)
    {
        NSString *filecontent=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
//        NSLog(@"\r**********************File Content*******************\r%@",filecontent);
        dataFromSensorSet = [[filecontent componentsSeparatedByString:@"\n"] mutableCopy];
        
    }
    else
    {
        //******* Used to show the loading process til the completion of the downloading data *****//
//        lAnimate=[[MBProgressHUD alloc]initWithFrame:self.view.frame];
        
         hud = [MBProgressHUD showHUDAddedTo:theApp.window animated:YES];
        hud.labelText=@"Downloading Data...";
        [hud setMode:MBProgressHUDAnimationFade];
        [hud removeFromSuperViewOnHide];
        [hud show:YES];
        [hud setOpacity:0.4];
        
    }
    
    NSLog(@"Logger Name : %@",LLLoggerNameFromHistory);
    NSLog(@"Date :%@",DateFromHistory);
    
    //**** Set the scroll view to scroll the page horizontally *****//
    
    _scrollView=[[UIScrollView alloc]init] ;
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    NSLog(@"dataFromSensorSet %@",dataFromSensorSet);
    
    //******* Navigation Bar Settings ********//
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton=YES;
    
    UINavigationBar *navBar=[[UINavigationBar alloc]init];

    UINavigationItem *navItem=[[UINavigationItem alloc]initWithTitle:nil];
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [navBar setItems:[NSArray arrayWithObject:navItem]];
    [navBar setBackgroundImage:[UIImage imageNamed:@"ViewLoggerDataTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
    
    _loggerName=[[UILabel alloc]init];
    _loggerName.backgroundColor=[UIColor clearColor];
    _loggerName.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle" ];
    _loggerName.textColor=[UIColor whiteColor];
    
    _date=[[UILabel alloc]init];
    _date.backgroundColor=[UIColor clearColor];
    
    if(isVHistory)
    {
        _date.text=DateFromHistory;
    }
    else
    {
        NSDate *currentdate=[NSDate date];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString *date1=[dateFormatter stringFromDate:currentdate];
        _date.text=date1;
    }
    
    _date.textColor=[UIColor yellowColor];
    
    _completed=[[UILabel alloc]init];
    _completed.backgroundColor=[UIColor clearColor];
    _completed.text=@"COLLECTED :";
    _completed.textColor=[UIColor whiteColor];
    
    _dataView=[[UITableView alloc]init];
    _dataView.dataSource=self;
    _dataView.delegate=self;
    _dataView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _dataView.backgroundColor=[UIColor clearColor];
    
    
    cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelProcess) forControlEvents:UIControlEventTouchUpInside];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
                [_date setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:15.0]];
                [_completed setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:15.0]];
                [_loggerName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:22.0]];
        
                _scrollView.frame=CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-48);
                _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
        
                _dataView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [_dataView setContentSize:CGSizeMake(_dataView.frame.size.width, _dataView.frame.size.height)];
        
                buttonImage=[UIImage imageNamed:@"SettingsBack.png"];
                [_backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
                _backButton.frame = CGRectMake(0, 25.0, (buttonImage.size.width / buttonImage.size.height) * 30, 30);
                [_backButton addTarget:self action:@selector(backToLogger:) forControlEvents:UIControlEventTouchUpInside];
                barButton=[[UIBarButtonItem alloc]initWithCustomView:_backButton];
        
                if([[UIScreen mainScreen] bounds].size.height == 568 )
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                                _loggerName.frame=CGRectMake(170.0, 28.0, 200.0, 30.0);
                                _date.frame=CGRectMake(490.0, 28.0, 100.0, 30.0);
                                _completed.frame=CGRectMake(400.0, 28.0, 100.0, 30.0);
                            
                                cancelButton.frame=CGRectMake(53, 320, 208, 30);
                            
                                [navBar setBackgroundImage:[UIImage imageNamed:@"Landnav7.png"] forBarMetrics:UIBarMetricsDefault];
                                navBar.frame=CGRectMake(0, 0, frame1.size.height, 65.0);
                            
                                if(isVHistory)
                                    [self loadPageContent];
                        }
                        else
                        {
                                _loggerName.frame=CGRectMake(170.0, 35.0, 200.0, 30.0);
                                _date.frame=CGRectMake(490.0, 35.0, 100.0, 30.0);
                                _completed.frame=CGRectMake(400.0, 35.0, 100.0, 30.0);
                            
                                cancelButton.frame=CGRectMake(45, 320, 208, 30);
                            
                                [navBar setBackgroundImage:[UIImage imageNamed:@"ViewLoggerDataTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                                navBar.frame=CGRectMake(0, 20, frame1.size.height, 44.0);
                            
                                if(isVHistory)
                                    [self loadPageContent];
                        }
                }
                else
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                                _loggerName.frame=CGRectMake(120.0, 35.0, 200.0, 30.0);
                                _date.frame=CGRectMake(400.0, 32.0, 100.0, 30.0);
                                _completed.frame=CGRectMake(300.0, 32.0, 100.0, 30.0);
                            
                                cancelButton.frame=CGRectMake(53, 280, 208, 30);
                            
                                [navBar setBackgroundImage:[UIImage imageNamed:@"Landnav7.png"] forBarMetrics:UIBarMetricsDefault];
                                navBar.frame=CGRectMake(0, 0, frame1.size.height, 65.0);
                            
                                if(isVHistory)
                                    [self loadPageContent];
                        }
                        else
                        {
                                _loggerName.frame=CGRectMake(120.0, 35.0, 200.0, 30.0);
                                _date.frame=CGRectMake(400.0, 35.0, 100.0, 30.0);
                                _completed.frame=CGRectMake(400.0, 35.0, 100.0, 30.0);
                            
                                cancelButton.frame=CGRectMake(45, 320, 208, 30);
                            
                                [navBar setBackgroundImage:[UIImage imageNamed:@"ViewLoggerDataTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                                navBar.frame=CGRectMake(0, 20, frame1.size.height, 44.0);
                            
                                if(isVHistory)
                                    [self loadPageContent];
                        }
                }
    }
//****** iPad Design *******//
    else
    {
                [_date setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
                [_completed setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
                [_loggerName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
        
                buttonImage=[UIImage imageNamed:@"SettingsBack~ipad.png"];
                [_backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
                _backButton.frame = CGRectMake(15, 23, 89, 46);
                [_backButton addTarget:self action:@selector(backToLogger:) forControlEvents:UIControlEventTouchUpInside];
        
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                {
                        navBar.frame=CGRectMake(0, 0, frame1.size.height, 80.0);
                        [navBar setBackgroundImage:[UIImage imageNamed:@"ViewLoggerDataTitleBG~ipad.png"] forBarMetrics:UIBarMetricsDefault];
            
                        _scrollView.frame=CGRectMake(0, 80, frame1.size.height,frame1.size.width-20);
                        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.height, _scrollView.frame.size.width);
                    
                        if(isVHistory)
                            [self loadPageContent];
                    
                        _dataView.frame=CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
                        _dataView.contentSize=CGSizeMake(_scrollView.frame.size.width, _dataView.frame.size.height);
                    
                        NSLog(@"Scroll View frame %f %f", frame1.size.height,frame1.size.width-20);
                        NSLog(@"Table frame %f %f", _scrollView.frame.size.width,_scrollView.frame.size.height);
            
                        _loggerName.frame=CGRectMake(400.0, 30.0, 300.0, 30.0);
                        _completed.frame=CGRectMake(775.0, 30.0, 200.0, 30.0);
                        _date.frame=CGRectMake(890.0, 30.0, 200.0, 30.0);
                    
                        cancelButton.frame=CGRectMake(280, 545, 208, 30);
                    
                }
    }
    
//    [_scrollView addSubview:_dataView];
    
//     _scrollView.contentSize=CGSizeMake(d_Width, _contentLabel.frame.size.height *([dataFromSensorSet count]+1));
    

    [self.view addSubview:_scrollView];
    [self.view addSubview:navBar];
    [self.view addSubview:_backButton];
    [self.view addSubview:hud];
    _backButton.enabled=NO;
    [self.view addSubview:_loggerName];
    [self.view addSubview:_completed];
    [self.view addSubview:_date];
    navItem.leftBarButtonItem=barButton;
    
    [hud addSubview:cancelButton];
    
    cancelButton.enabled = NO;
    
    if(!isVHistory)
    {
        [self showData];
    }
    else{
        _backButton.enabled=YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadError:) name:@"downloaderror1"
                                               object:nil];
}

- (void)downloadError:(NSNotification *)notification{
    if ([notification.name isEqualToString:@"downloaderror1"]) {
        //cancel
        cancelButton.enabled = YES;
    }
}

-(void)showData
{
    sesData.enabled = NO;
    if(connectDevice == nil)
    {
        connectDevice = [[DeviceConnector alloc] init];
        connectDevice.delegate = self;
    }
    [connectDevice connectactivePeripheral];
}

// ****** send DATA command to execute the command and receive the output from the logger device *****//

-(void)deviceAlreadyConnected
{
    [connectDevice sendCommand:@"flash-txfr-binary"];
    timer3 = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(callRcommand) userInfo:nil repeats:NO];
}

-(void)callRcommand
{
    [timer3 invalidate];
    [self.connectDevice sendCommand:@"r"];
}
-(void)requestStarted
{
    NSLog(@"requestStarted on");
}

-(void)deviceConnected
{
    NSLog(@"deviceConnected");
    [connectDevice sendCommand:@"flash-txfr-binary"];
}

-(void)requestCompleted2:(NSString *)rowNumber
{
    int numberOfRow=[rowNumber intValue];
    [self.connectDevice sendCommand:[NSString stringWithFormat:@"t%d",numberOfRow]];
}

-(void)requestCompleted1:(NSMutableString*)output NumbeofRow:(NSString *)numberOfRow
{
    NSMutableString *output1=[[NSMutableString alloc]initWithString:output];
    
//    CRC16 *crc16=[[CRC16 alloc]init];
   
    if([numberOfRow integerValue]==0)
    {
        [self requestCompleted:_brspObject result:@"NO"];
    }
    else if([numberOfRow integerValue]>0)
    {
        [crc16 setCalledClass:self];
        crc16.referenceKeyword=@"ViewData";
        [crc16 startProcess:output1 NumberofRow:[numberOfRow intValue]];
    }
}

-(void)createFile:(NSMutableString *)receivedData
{
    
}

-(void)requestCompleted:(Brsp *)brspObject result:(NSString *)str
{
    NSLog(@"Str value from View data %@",str);
    sesData.enabled = YES;
    
    if(dataFromSensorSet == nil)
    {
        dataFromSensorSet = [[NSMutableArray alloc] init];
    }
    
    if(![str isEqualToString:@"NO"])
    {
        dataFromSensorSet = [[str componentsSeparatedByString:@"\n"] mutableCopy];
        
//        [_dataView reloadData];
        
        
        [self loadPageContent];
        
        //NSString *loggerName=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle" ];
        NSDate *currentdate=[NSDate date];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString *date12=[dateFormatter stringFromDate:currentdate];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString  *time=[dateFormatter stringFromDate:currentdate];
        
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectroy=[path objectAtIndex:0];
        
        NSString *fileName=[NSString stringWithFormat:@"%@%@%@.txt",[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"],date12,time];
        filePath=[documentsDirectroy stringByAppendingPathComponent:fileName];
        
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        NSFileHandle *output=[NSFileHandle fileHandleForReadingAtPath:filePath];
        [output seekToFileOffset:0];
        
        NSString *filecontent=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
//        NSLog(@"\r**********************File Content*******************\r%@",filecontent);
        
        if([filecontent length]>=10)
        {
            ds11=[[DataSource_1 alloc]initWithLoggerName:[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"] Date:date12 Time:time Description:@"Downloaded from logger from View Data" Data:filePath];
            
            [dbc initDatabase];
            [dbc insertDataforDetail:ds11];
            
            if(![hud isHidden])
                [hud hide:YES];
            
            _backButton.enabled=YES;
            
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            date12=[dateFormatter stringFromDate:currentdate];
            
            NSString *logforConnection=[NSString stringWithFormat:@"Downloaded sensor data from %@ at %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"],date12];
            
            [dbc logfile:logforConnection];
        }
    }
    else
    {
        if(![hud isHidden])
            [hud hide:YES];
        
        _backButton.enabled=YES;
        
        noDa = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data saved for this logger" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        noDa.tag=1440;
        noDa.delegate=self;
        [noDa show];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if((alertView.tag==1440) && buttonIndex==0)
    {
        [self.connectDevice sendCommand:@"X"];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGAffineTransform cgCTM = CGAffineTransformMakeRotation(degreesToRadians(90));
    self.navigationController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height + 20);
    self.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width - 20.0);
    self.view.transform = cgCTM;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    _loggerName.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle" ];
    [self.view setAlpha:1];
}


-(void)viewWillDisappear:(BOOL)animated
{
    CGRect frame = [[UIScreen mainScreen] bounds];
   
        if([[UIScreen mainScreen] bounds].size.height == 568 )
        {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                {
                    self.navigationController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height + 20.0);
                }
                else
                {
                    self.navigationController.view.frame = CGRectMake(0, 20, frame.size.width, frame.size.height - 20.0);
                }
        }
        else
        {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                {
                    self.navigationController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height + 20.0);
                }
                else
                {
                    self.navigationController.view.frame = CGRectMake(0, 20, frame.size.width, frame.size.height - 20.0);
                }
        }
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    [self.view setAlpha:0];
    
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
}

#pragma mark - table to populate the data

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataFromSensorSet count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//***** Method used to align the received logger sensor data in to the table, on the view data page *****//

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    DataCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if(cell==nil)
        {
            cell=[[DataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor clearColor];
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
        float labWidth = [self getSizeOffLabel:[dataFromSensorSet objectAtIndex:indexPath.row]].width+30;
        NSLog(@"index content = %@, width = %f",[dataFromSensorSet objectAtIndex:indexPath.row],labWidth);
    
        if(tableView.frame.size.width < labWidth)
        {
            tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.x, labWidth, tableView.frame.size.height);
        }
    
        if(_scrollView.contentSize.width < labWidth)
        {
            _scrollView.contentSize=CGSizeMake(labWidth-20, _scrollView.frame.size.height+100);
        }
    
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            ((UILabel*)[cell viewWithTag:1111]).frame = CGRectMake(0, 8, labWidth, 30);
            ((UILabel*)[cell viewWithTag:1111]).text = [dataFromSensorSet objectAtIndex:indexPath.row];
            [((UILabel*)[cell viewWithTag:1111]) setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:17.0]];
        }
        else
        {
            ((UILabel*)[cell viewWithTag:1111]).frame = CGRectMake(0, 8, labWidth, 30);
            ((UILabel*)[cell viewWithTag:1111]).text = [dataFromSensorSet objectAtIndex:indexPath.row];
            [((UILabel*)[cell viewWithTag:1111]) setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
        }
    return cell;
}


-(CGSize)getSizeOffLabel: (NSString *)str
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        CGSize labelStringSize = [str sizeWithFont: [UIFont fontWithName:@"MyriadPro-Semibold" size:17.0]
                                        constrainedToSize:CGSizeMake(INFINITY, 30)
                                        lineBreakMode:0];
        return labelStringSize;
    }
    else
    {
        CGSize labelStringSize = [str sizeWithFont: [UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]
                                        constrainedToSize:CGSizeMake(INFINITY, 30)
                                        lineBreakMode:0];
        return labelStringSize;
    }
  }

#pragma mark - Methods on Navigation and Tabbar

-(void)backToLogger:(id)sender
{
    NSLog(@"[AppDelegate app].activePeripheral %@",[AppDelegate app].activePeripheral);
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    if(!isVHistory)
    {
        [self.connectDevice sendCommand:@"X"];
        for( int i=0;i<[ viewContrlls count];i++)
        {
            id obj=[viewContrlls objectAtIndex:i];
            if([obj isKindOfClass:[LoggerData class]] )
            {
                [[self navigationController] popToViewController:obj animated:YES];
                return;
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)cancelProcess
{
    NSLog(@"Animation %@",hud);
    
    if(![hud isHidden])
    {
        [hud hide:YES];
    }
    
    [self.connectDevice sendCommand:@"x"];
    _backButton.enabled=YES;
}

#pragma mark - delegate for CBCentralManager

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    for( int i=0;i<[ viewContrlls count];i++)
    {
        id obj=[viewContrlls objectAtIndex:i];
        if([obj isKindOfClass:[ScanDevice class]] )
        {
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        self.scrollView=nil;
    }
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return 0;
}

- (CGFloat)heightOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize
{
    // iOS7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGSize sizeOfText = [aString boundingRectWithSize: aSize
                                                  options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes: [NSDictionary dictionaryWithObject:aFont
                                                                                       forKey:NSFontAttributeName]
                                                  context: nil].size;
        
        return ceilf(sizeOfText.height);
    }
    
    // iOS6
    CGSize textSize = [aString sizeWithFont:aFont
                          constrainedToSize:aSize
                              lineBreakMode:NSLineBreakByWordWrapping];
    return ceilf(textSize.height);
}


-(void)loadPageContent
{
    for (int i=0 ; i< [dataFromSensorSet count]; i++)
    {
        _contentLabel=[[UILabel alloc]init];
        
        _contentLabel.font=[UIFont fontWithName:@"MyriadPro-Semibold" size:17.0];
        
        _contentLabel.textColor=[UIColor whiteColor];
        
        _contentLabel.backgroundColor=[UIColor clearColor];
        
        _contentLabel.text=[dataFromSensorSet objectAtIndex:i];
        
        CGSize sizeToMakeLabel = [_contentLabel.text sizeWithFont:_contentLabel.font];
        
        if(i==0)
            _contentLabel.frame=CGRectMake(0, 0, sizeToMakeLabel.width, 40);
        else
            _contentLabel.frame=CGRectMake(0, i*40, sizeToMakeLabel.width, 40);
        
        d_Width = (d_Width > sizeToMakeLabel.width) ? d_Width : sizeToMakeLabel.width;
        
        _rowBackImage=[[UIImageView alloc]init];
        
        _rowBackImage.frame=CGRectMake(0, 0, d_Width, 40);
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            _rowBackImage.image = [UIImage imageNamed:@""];
        }
        else
        {
            _rowBackImage.image = [UIImage imageNamed:@""];
        }
        
        [_scrollView addSubview:_rowBackImage];
        [_scrollView addSubview:_contentLabel];
    }
    _scrollView.contentSize=CGSizeMake(d_Width, _contentLabel.frame.size.height *([dataFromSensorSet count]+1));
}


@end
