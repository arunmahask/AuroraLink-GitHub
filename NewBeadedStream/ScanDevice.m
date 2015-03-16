//
//  ScanDevice.m
//  NewBeadedStream
//
//  Created by fsp on 6/14/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "ScanDevice.h"
#import "AppDelegate.h"
#import "LoggerCell.h"
#import "LoggerData.h"
#import "CustomIOS7AlertView.h"

@interface ScanDevice ()
@end

@implementation ScanDevice

bool isData;
int i=0;

@synthesize loggerview,LoggerName,time,date;
@synthesize peripheralArray;
@synthesize peripheral;
@synthesize settings;
@synthesize refresh;
@synthesize history;

@synthesize connectDevice,isNoData,isData;



- (id)initWithStyle:(UITableViewStyle)style
{
    //self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)receivingData:(Brsp *)brspObject result:(NSString *)DataStr
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self Accessoption];
    
    dbc=[[DataBaseControl alloc]init];
    frame1=[[UIScreen mainScreen]bounds];
    //peripheralArray=[NSMutableArray new];
    
    n1=[[NSArray alloc]init];
    peripheralArray=[[NSMutableArray alloc]initWithArray:n1];

    
    //Date object declaration for the whole application
    
    currentdate=[NSDate date];
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    date=[dateFormatter stringFromDate:currentdate];
    [dateFormatter setDateFormat:@"hh:mm a"];
    time=[dateFormatter stringFromDate:currentdate];
    
    //******************NavigationBar Settings********************//
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton=YES;
    
    settings = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //****** Table to display the logger*****//
    
    loggerview=[[UITableView alloc]initWithFrame:CGRectMake(0.0,0.0,frame1.size.width,frame1.size.height - 128) style:UITableViewStylePlain];
    loggerview.dataSource=self;
    loggerview.separatorStyle=UITableViewCellSelectionStyleNone;
    loggerview.delegate=self;
    loggerview.backgroundColor=[UIColor clearColor];
    
    [AppDelegate app].cManager=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
    logforConnection=[NSString stringWithFormat:@"Start Scan Occured on %@ at %@",date,time];
    [dbc logfile:logforConnection];

    //******* Tabbar button to switch to Histroy Page *********//
    
    history=[UIButton buttonWithType:UIButtonTypeCustom];
    [history addTarget:self action:@selector(backToHistory) forControlEvents:UIControlEventTouchUpInside];
    
    //************Loading indicator for scanning device***************//
    
    lAnimate = [[MBProgressHUD alloc] initWithFrame:self.view.frame];
    lAnimate.labelText = @"Scanning for devices";
    [lAnimate setMode:MBProgressHUDAnimationFade];
    [lAnimate removeFromSuperViewOnHide];
    [lAnimate setOpacity:0.4];

    messageView=[[UIView alloc]init];
    messageView.backgroundColor=[UIColor clearColor];
    messageView.alpha=0.0;
    
    l1=[[UILabel alloc]initWithFrame:CGRectMake(8.0, 40.0, 260,20)];
    l1.text=@"No Loggers Detected:";
    l1.backgroundColor=[UIColor clearColor];
    [l1 setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:15.0]];
    
    l2=[[UILabel alloc]initWithFrame:CGRectMake(10.0, 55.0, 260,30)];
    l2.text=@"# Make sure you have a line of site to the Logger";
    l2.backgroundColor=[UIColor clearColor];
    [l2 setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:12.0]];
    
    l5=[[UILabel alloc]initWithFrame:CGRectMake(18.0, 70.0, 260,30)];
    l5.text=@"and are within 15 ft";
    l5.backgroundColor=[UIColor clearColor];
    [l5 setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:12.0]];

    l3=[[UILabel alloc]initWithFrame:CGRectMake(10.0, 85.0, 260,30)];
    l3.text=@"# No other users are connected";
    l3.backgroundColor=[UIColor clearColor];
    [l3 setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:12.0]];
    
    l4=[[UILabel alloc]initWithFrame:CGRectMake(10.0, 100.0, 260,30)];
    l4.text=@"# Wait 30 seconds and attempt to connect again";
    l4.backgroundColor=[UIColor clearColor];
    [l4 setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:12.0]];
    
    [messageView addSubview:l1];
    [messageView addSubview:l2];
    [messageView addSubview:l3];
    [messageView addSubview:l4];
    [messageView addSubview:l5];
    
    dvc=[[DeviceConnector alloc]init];
    
    loggerSelect = [[UIImageView alloc] init];
    
    scan=[[UILabel alloc]init];
    scan.textColor=[UIColor whiteColor];
    scan.backgroundColor=[UIColor clearColor];
    
    custm=[[CustomIOS7AlertView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    
    [custm setContainerView:messageView];
    [custm setButtonTitles:[NSArray arrayWithObject:@"OK"]];
    [custm setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [custm setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex)
    {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
        [alertView close];
    }];
    
    [custm setUseMotionEffects:true];
    
    timer2=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refreshTable) userInfo:nil repeats:YES];
    
    [lAnimate setOpacity:0.4];

}

-(void)hideview
{
    self.history.enabled=NO;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    self.navigationItem.leftBarButtonItem.enabled=NO;
    barButton.enabled=NO;
    barButton1.enabled=NO;
}

-(void)Accessoption
{
    self.history.enabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    self.navigationItem.leftBarButtonItem.enabled=YES;
    barButton.enabled=YES;
    barButton1.enabled=YES;
}

//***** Method used to scan the avaible device with in range *****//

-(void)startScan
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[AppDelegate app].cManager scanForPeripheralsWithServices:[NSArray arrayWithObject:[Brsp brspServiceUUID]] options:nil];
    //NSLog(@"Step 1");
}

#pragma mark - delegates of view controller

- (void)viewWillAppear:(BOOL)animated
{
    [AppDelegate app].cManager.delegate = self;
    [AppDelegate app].activePeripheral=nil;
    
    [super viewWillAppear:animated];
    
     NSLog(@"From Logger in range %@",[[self navigationController]viewControllers]);
    
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
                buttonImage=[UIImage imageNamed:@"info.png"];
                buttonImage1=[UIImage imageNamed:@"resetBtn.png"];
        
                [settings setBackgroundImage:buttonImage forState:UIControlStateNormal];
                settings.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 30, 30);
                [settings addTarget:self action:@selector(infoView) forControlEvents:UIControlEventTouchUpInside];
                barButton = [[UIBarButtonItem alloc] initWithCustomView:settings];
        
                backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
                loggerSelect.image  =[UIImage imageNamed:@"loggerSelect.png"];
        
                scan.frame=CGRectMake(80, 200, 300, 40);
        
                [scan setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
                scan.text=@"Scanning For Device";

                if([[UIScreen mainScreen] bounds].size.height == 568 )
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                                loggerSelect.frame = CGRectMake(0, 504, 320, 64);
                                loggerview.frame   =CGRectMake(7,68.0,frame1.size.width-15,frame1.size.height - 128);
                                history.frame=CGRectMake(160.0,frame1.size.height - 58,frame1.size.width - 160,63.0);
                                messageView.frame=CGRectMake(15, -35, 280, 90);
            
                                l1.textColor=[UIColor blackColor];
                                l2.textColor=[UIColor blackColor];
                                l3.textColor=[UIColor blackColor];
                                l4.textColor=[UIColor blackColor];
                                l5.textColor=[UIColor blackColor];
            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"loggerNav7.png"] forBarMetrics:UIBarMetricsDefault];
                                    self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0, 320.0, 65.0);
                                }
                        }
                        else
                        {
                                loggerSelect.frame = CGRectMake(0, 440, 320, 64);
                                loggerview.frame   =CGRectMake(7,1,frame1.size.width-15,frame1.size.height - 128);
                                history.frame=CGRectMake(160.0,frame1.size.height - 120,frame1.size.width - 160,63.0);
                                messageView.frame=CGRectMake(20, 10, 280, 90);
            
                                l1.textColor=[UIColor whiteColor];
                                l2.textColor=[UIColor whiteColor];
                                l3.textColor=[UIColor whiteColor];
                                l4.textColor=[UIColor whiteColor];
                                l5.textColor=[UIColor whiteColor];

                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitle.png"] forBarMetrics:UIBarMetricsDefault];
                                }
                        }
                }
                else if([[UIScreen mainScreen] bounds].size.height == 480)
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                                loggerSelect.frame = CGRectMake(0, frame1.size.height-64, frame1.size.width, 64);
                                history.frame=CGRectMake(160.0,frame1.size.height - 57,frame1.size.width - 160,63.0);
                                loggerview.frame   =CGRectMake(0.0,65.0,frame1.size.width,frame1.size.height - 64);
                                loggerview.backgroundColor=[UIColor clearColor];
                                messageView.frame=CGRectMake(20, 74, 280, 90);
            
                                l1.textColor=[UIColor blackColor];
                                l2.textColor=[UIColor blackColor];
                                l3.textColor=[UIColor blackColor];
                                l4.textColor=[UIColor blackColor];
                                l5.textColor=[UIColor blackColor];
            
                            if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                            {
                                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"loggerNav7.png"] forBarMetrics:UIBarMetricsDefault];
                            }
                        }
                        else
                        {
                                loggerSelect.frame = CGRectMake(0, 352, 320, 64);
                                history.frame=CGRectMake(160.0,frame1.size.height - 120,frame1.size.width - 160,63.0);
                                loggerview.frame   =CGRectMake(0.0,0.0,frame1.size.width,frame1.size.height - 120);
                                messageView.frame=CGRectMake(20, 10, 280, 90);
                            
                                l1.textColor=[UIColor whiteColor];
                                l2.textColor=[UIColor whiteColor];
                                l3.textColor=[UIColor whiteColor];
                                l4.textColor=[UIColor whiteColor];
                                l5.textColor=[UIColor whiteColor];
            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitle.png"] forBarMetrics:UIBarMetricsDefault];
                                }
                        }
                }
        }
    
//******* iPad Design *******//
    
        else
        {
                if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                {
                        buttonImage=[UIImage imageNamed:@"info~ipad.png"];
                        buttonImage1=[UIImage imageNamed:@"resetBtn~ipad.png"];
                    
                        [settings setBackgroundImage:buttonImage forState:UIControlStateNormal];
                        settings.frame = CGRectMake(0,0,38, 38);
                        [settings addTarget:self action:@selector(infoView) forControlEvents:UIControlEventTouchUpInside];
                        barButton = [[UIBarButtonItem alloc] initWithCustomView:settings];
                    
                        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background~ipad.png"]];
            
                        [loggerSelect setImage:[UIImage imageNamed:@"LoggerSelect~ipad.png"]];
                        loggerSelect.frame = CGRectMake(0, frame1.size.height-107,frame1.size.width, 107);
                        history.frame=CGRectMake(384.0,frame1.size.height - 102,frame1.size.width - 384,102.0);
                        loggerview.frame   =CGRectMake(15.0,81.0,frame1.size.width-30,frame1.size.height - 120);
            
                        messageView.frame=CGRectMake(12, -35, 280, 90);
                    
                        scan.frame=CGRectMake(200, 550, 300, 40);
                        [scan setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
                        scan.text=@"Scanning For Device";
            
                        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                        {
                                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitle~ipad.png"] forBarMetrics:UIBarMetricsDefault];
                                self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0,frame1.size.width, 78.0);
                        }
                }
        }
    
        self.navigationItem.rightBarButtonItem=barButton;
    
        [self.view addSubview:loggerview];
    
        [self.view addSubview:backgroundImage];
        [self.view sendSubviewToBack:backgroundImage];

        [self.view addSubview:loggerSelect];
        [self.view addSubview:history];
    
        [self.loggerview addSubview:scan];
    
        scan.alpha=0.0;
    
        [self startScan];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Method - switch to Histroy Page

-(void)backToHistory
{
    HistroyView *hv=[[HistroyView alloc]init];
    [self.navigationController pushViewController:hv animated:NO];
    
    NSMutableArray *viewcont=[[NSMutableArray alloc]initWithArray:[[self navigationController]viewControllers]];
    
    NSLog(@"Before %@",[[self navigationController]viewControllers]);
    
    for( int i=0;i<[ viewcont count];i++)
    {
        id obj=[viewcont objectAtIndex:i];
        if([obj isKindOfClass:[ScanDevice class]])
        {
            [viewcont removeObjectAtIndex:i];
        }
        
        NSLog(@"From scan %@",self.navigationController.viewControllers);
    }
    self.navigationController.viewControllers=viewcont;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [peripheralArray count];
}

//***** Method used to set the available device list in to the table with option to select the buttons *****//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"The Available device in the range ---- %@",peripheralArray);
   // [self Accessoption];
    
    date1=[NSDate date];
    dateFormat1=[[NSDateFormatter alloc]init];
    [dateFormat1 setDateFormat:@"MM-dd-yyyy hh:mm a"];
    
    static NSString *CellIdentifier = @"Cell";
    LoggerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell=[[LoggerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
        cell.backgroundColor=[UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
        if(peripheralArray)
        {
            NSLog(@"Number of elements in an Array %d", [peripheralArray count]);
            peripheral =[peripheralArray objectAtIndex:indexPath.row];
    
            //***** Cell to display the avilable logger in Range ********//
    
            if(peripheral.name==NULL)
            {
                cell.loggerName.text=@"BlueRadios....";
                [self performSelector:@selector(selfreload) withObject:nil afterDelay:0.3];
            }
            else
            {
                NSString *l11=[NSString stringWithFormat:@"%@",peripheral.name];
                NSString *afterTrim=[l11 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                cell.loggerName.text=peripheral.name;
                cell.description.text=@"Last Download:";
        
                NSString *stringLoggerUpdatetime=[dbc getTime:[NSString stringWithFormat:@"%@",afterTrim]];
        
                NSLog(@"Last updated time %@",stringLoggerUpdatetime);
                if([stringLoggerUpdatetime rangeOfString:@"(null) (null)"].location==NSNotFound)
                {
                    cell.dateTime.text=stringLoggerUpdatetime;
                }
                else
                {
                    //cell.dateTime.text=[dateFormat1 stringFromDate:date1];
                    cell.dateTime.text=@"N/A";
                }
            }
        }

    return cell;
}

-(void)selfreload
{
    [self.loggerview reloadData];
}

//****** Method used to set the size of the table row ******//

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
        return 65.0;
    }
    else
    {
        return 135.0;
    }
}

//****** Method used to select the table row and move to the logger detail page to show the logger data *****//

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        [AppDelegate app].activePeripheral=(CBPeripheral *)[peripheralArray objectAtIndex:indexPath.row];
    
    
        NSString *l11=[NSString stringWithFormat:@"%@",[AppDelegate app].activePeripheral.name];
        NSString *afterTrim=[l11 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
        [[NSUserDefaults standardUserDefaults] setValue:afterTrim forKey:@"Navtitle"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        LoggerData *ld=[[LoggerData alloc]init];
        ld.isLoggerInrange=YES;
    
        logforConnection=[NSString stringWithFormat:@"Connected to the device %@ at %@",_displayPerip.name,date];
        [dbc logfile:logforConnection];
    
         [self.navigationController pushViewController:ld animated:YES];
    
        [self showData];
    
}

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
    NSLog(@"deviceConnected, command platfrom");
    //[connectDevice sendCommand:@"log_p"];
}

-(void)requestStarted{
    NSLog(@"requestStarted on");
}

-(void)deviceConnected
{
    NSLog(@"deviceConnected, command platfrom");
    //[connectDevice sendCommand:@"log_p"];
}

-(void)requestCompleted:(Brsp *)brspObject result:(NSString *)str
{
    NSLog(@"Output of after Connect - %@",str);
}

//***** Method used to stop the download and scanning process *****//

-(void)infoView
{
    InfoView *iv=[[InfoView alloc]init];
    [self.navigationController pushViewController:iv animated:YES];
}

#pragma mark - CBCentralManagerDelegate


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral1 advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Step 2");
    
    [lAnimate hide:YES];
    scan.alpha=0.0;
    
    if(![peripheralArray containsObject:peripheral1])
    {
        [peripheralArray addObject:peripheral1];
        [self.loggerview reloadData];
    }
    
    NSLog(@"Array Data %@ Service %@",peripheralArray, [peripheral1 services]);
    
}

-(void)refreshTable
{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    
    [[AppDelegate app].cManager stopScan];
    if([peripheralArray count]!=0)
    {
        NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0 ];

        [peripheralArray removeObjectAtIndex:0];
        [tempArray addObjectsFromArray:peripheralArray];
        [peripheralArray removeAllObjects];
        [peripheralArray addObjectsFromArray:tempArray];
        [loggerview deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self startScan];
}

-(void)retrieveConnectedPeripherals
{
    
}

-(void)requestCompleted2:(NSString *)rowNumber
{
    
}

-(void)requestCompleted1:(NSMutableString*)output NumbeofRow:(NSString *)numberOfRow
{
    
}

-(void)createFile:(NSMutableString *)receivedData
{
    
}

-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    printf("Status of CoreBluetooth central manager changed %d \r\n",central.state);
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
