//
//  LoggerData.m
//  NewBeadedStream
//
//  Created by fsp on 6/18/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "LoggerData.h"
#import "ScanDevice.h"

@interface LoggerData (){
    CRC16 *crc16;
}

@end

int process,startRow,needRow;
BOOL isConnected,isData;

@implementation LoggerData

@synthesize emailButton=_emailButton;
@synthesize dataButton=_dataButton;
@synthesize clearButton=_clearButton;
@synthesize searchBar=_searchBar;
@synthesize searchField=_searchField;
@synthesize backButton=_backButton;

@synthesize basic=_basic;
@synthesize emulator=_emulator;

@synthesize settings=_settings;
@synthesize brspObject=_brspObject;

@synthesize devName=_devName;
@synthesize getLogger,getDate,getTime,getDataPath,getDes,TitleString,isldHistory,isLoggerInrange,isldemhistory;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        crc16 = [[CRC16 alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
   
    TitleString=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"];
    
    frame1=[[UIScreen mainScreen]bounds];
    
    //******* Navigation Bar settings *******//
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    
    theApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //******* Navigation Bar Button Allocation ******//
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settings = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //******* Tabbar Button Allocation ********//
    
    _basic=[UIButton buttonWithType:UIButtonTypeCustom];
    _emulator=[UIButton buttonWithType:UIButtonTypeCustom];

    [self setNetworkNotification];
    
    dbc=[[DataBaseControl alloc]init];
    
    dataSelect = [[UIImageView alloc] init];
    dataSelect.image  =[UIImage imageNamed:@"dataSelect.png"] ;
    
    _emailButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_emailButton addTarget:self action:@selector(sendEmail1) forControlEvents:UIControlEventTouchUpInside];
    
    _dataButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_dataButton addTarget:self action:@selector(viewDetailData) forControlEvents:UIControlEventTouchUpInside];
    
    _clearButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_clearButton addTarget:self action:@selector(clearData) forControlEvents:UIControlEventTouchUpInside];
    
    spliter=[[UIImageView alloc]init];
    spliter.image=[UIImage imageNamed:@"Splitter.png"];
    
    circleProgress=[[DACircularProgressView alloc]init];
    circleProgress.roundedCorners=YES;
    circleProgress.trackTintColor=[UIColor yellowColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadError:) name:@"downloaderror"
                                               object:nil];
    
}

- (void)downloadError:(NSNotification *)notification{
    if ([notification.name isEqualToString:@"downloaderror"]) {
        //cancel
        _cancelButton.enabled = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    titleLabel.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"];
    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
                buttonImage1=[UIImage imageNamed:@"info.png"];
                [_settings setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
                _settings.frame = CGRectMake(0, 0, (buttonImage1.size.width / buttonImage1.size.height) * 30, 30);
                [_settings addTarget:self action:@selector(infoView:) forControlEvents:UIControlEventTouchUpInside];
                 barButton1 = [[UIBarButtonItem alloc] initWithCustomView:_settings];
        
                buttonImage=[UIImage imageNamed:@"LoggersBtn.png"];
                [_backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
                _backButton.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 30, 30);
                [_backButton addTarget:self action:@selector(backProcess:) forControlEvents:UIControlEventTouchUpInside];
                barButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
        
                [_emailButton setBackgroundImage:[UIImage imageNamed:@"DownEmailBtn.png"] forState:UIControlStateNormal];
                [_dataButton setBackgroundImage:[UIImage imageNamed:@"ViewData.png"] forState:UIControlStateNormal];
                [_clearButton setBackgroundImage:[UIImage imageNamed:@"ClearDataBtn.png"] forState:UIControlStateNormal];
        
                titleLabel.frame=CGRectMake(100.0, 0.0, 200.0, 40.0);
                [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
        
                circleProgress.frame=CGRectMake(140, 150, 40, 40);
        
                if([[UIScreen mainScreen] bounds].size.height == 568 )
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                                dataSelect.frame = CGRectMake(0, frame1.size.height-128, frame1.size.width, 64);
            
                                _emailButton.frame=CGRectMake(10, 57, 301, 35);
                                spliter.frame=CGRectMake(10, 132, 301, 2);
                                _dataButton.frame=CGRectMake(10, 172, 301, 35);
                                _clearButton.frame=CGRectMake(10, 237, 301, 35);
            
                                _basic.frame=CGRectMake(0.0,frame1.size.height - 128,frame1.size.width - 214.0,60.0);
                                _emulator.frame=CGRectMake(frame1.size.width - 107.0,frame1.size.height - 128,frame1.size.width - 214.0,60.0);
            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"solidNavBar.png"] forBarMetrics:UIBarMetricsDefault];
                                        self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0, 320.0, 64.0);
                                }
                        }
                        else
                        {
                                dataSelect.frame = CGRectMake(0, 440, 320, 64);
    
                                _emailButton.frame=CGRectMake(10, 85, 301, 35);
                                spliter.frame=CGRectMake(10, 161, 301, 2);
                                _dataButton.frame=CGRectMake(10, 201, 301, 35);
                                _clearButton.frame=CGRectMake(10, 285, 301, 35);
                            
                                _basic.frame=CGRectMake(0.0,frame1.size.height - 120,frame1.size.width - 214.0,63.0);
                                _emulator.frame=CGRectMake(frame1.size.width - 107.0,frame1.size.height - 120,frame1.size.width - 214.0,63.0);

                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                                }
                        }
                }
                else if([[UIScreen mainScreen]bounds].size.height==480)
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                                dataSelect.frame = CGRectMake(0, frame1.size.height-128, frame1.size.width, 64);
            
                                _emailButton.frame=CGRectMake(10, 57, 301, 35);
                                spliter.frame=CGRectMake(10, 132, 301, 2);
                                _dataButton.frame=CGRectMake(10, 172, 301, 35);
                                _clearButton.frame=CGRectMake(10, 237, 301, 35);
            
                            if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                            {
                                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"solidNavBar.png"] forBarMetrics:UIBarMetricsDefault];
                            }
            
                                _basic.frame=CGRectMake(2, frame1.size.height-128, 105, 60);
                                _emulator.frame=CGRectMake(219,frame1.size.height-128, 106, 60);
                        }
                        else
                        {
                                dataSelect.frame = CGRectMake(0, 352, 320, 64);
            
                                _emailButton.frame=CGRectMake(10, 65, 301, 35);
                                _dataButton.frame=CGRectMake(10, 180, 301, 35);
                                _clearButton.frame=CGRectMake(10, 250, 301, 35);
            
                                spliter.frame=CGRectMake(10, 135, 301, 2);
            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                                }
                                _basic.frame=CGRectMake(2, 356, 105, 63);
                                _emulator.frame=CGRectMake(219, 356, 105, 63);
                        }
                }
    }
    
    //******* iPad Design *******//
    else
    {
                buttonImage1=[UIImage imageNamed:@"info~ipad.png"];
                [_settings setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
                _settings.frame = CGRectMake(0, 0, 38, 38);
                [_settings addTarget:self action:@selector(infoView:) forControlEvents:UIControlEventTouchUpInside];
                barButton1 = [[UIBarButtonItem alloc] initWithCustomView:_settings];
        
                buttonImage=[UIImage imageNamed:@"LoggersBtn~ipad.png"];
                [_backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
                _backButton.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 46, 46);
                [_backButton addTarget:self action:@selector(backProcess:) forControlEvents:UIControlEventTouchUpInside];
                barButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
        
                backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background~ipad.png"]];
    
                [_emailButton setBackgroundImage:[UIImage imageNamed:@"DownEmailBtn~ipad.png"] forState:UIControlStateNormal];
                [_dataButton setBackgroundImage:[UIImage imageNamed:@"ViewData~ipad.png"] forState:UIControlStateNormal];
                [_clearButton setBackgroundImage:[UIImage imageNamed:@"ClearDataBtn~ipad.png"] forState:UIControlStateNormal];
        
                circleProgress.frame=CGRectMake(350, 400, 40, 40);
    
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                {
                        dataSelect.frame = CGRectMake(0, frame1.size.height-107, frame1.size.width, 107);
                    
                        titleLabel.frame=CGRectMake(150.0, 0.0, 300.0, 40.0);
                        [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
        
                        _emailButton.frame=CGRectMake(20, 200, 733, 64);
                        spliter.frame=CGRectMake(10, 350, 733, 2);
                        _dataButton.frame=CGRectMake(20, 435, 733, 64);
                        _clearButton.frame=CGRectMake(20, 600, 733, 64);
        
                        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                        {
                                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar~ipad.png"] forBarMetrics:UIBarMetricsDefault];
                        }
        
                        _basic.frame=CGRectMake(2, frame1.size.height-95, 250, 107);
                        _emulator.frame=CGRectMake(510, frame1.size.height-95, 250, 107);
                }
    }

    [_basic addTarget:self action:@selector(basicView:) forControlEvents:UIControlEventTouchUpInside];
    [_emulator addTarget:self action:@selector(emulatorView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView=titleLabel;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton=YES;
    
    self.navigationItem.rightBarButtonItem=barButton1;
    self.navigationItem.leftBarButtonItem=barButton;
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [self.view addSubview:dataSelect];
    [self.view addSubview:spliter];
    [self.view addSubview:_emailButton];
    [self.view addSubview:_dataButton];
    [self.view addSubview:_clearButton];
    
    [self.view addSubview:_basic];
    [self.view addSubview:_emulator];
    
    [self.view addSubview:circleProgress];
    circleProgress.alpha=0.0;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    //
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setDataButton:nil];
    [self setClearButton:nil];
    [self setEmailButton:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

#pragma mark - Methods of Navigation Bar

-(IBAction)backProcess:(id)sender
{
    if([AppDelegate app].activePeripheral.isConnected)
    {
        NSLog(@"device dis connected");
        [[AppDelegate app].cManager cancelPeripheralConnection:[AppDelegate app].activePeripheral];
    }
    
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
    titleLabel.frame=CGRectMake(0.0, 0.0, 0.0, 0.0);
}

-(IBAction)infoView:(id)sender
{
    InfoView *iv=[[InfoView alloc]init];
    [self.navigationController pushViewController:iv animated:YES];
}

#pragma mark - Methods of Tabbar

-(IBAction)basicView:(id)sender
{
    LoggerDetail *lde=[[LoggerDetail alloc]init];
    lde.title1=titleLabel.text;
    lde.procedure=@"live";
    [self.navigationController pushViewController:lde animated:NO];
}

-(IBAction)emulatorView:(id)sender
{
    EmulatorView *ev=[[EmulatorView alloc]init];
    [self.navigationController pushViewController:ev animated:NO];
}

#pragma mark - Method of the Body content

-(IBAction)sendEmail1
{
    _cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelProcess) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"Value of the Rect Frame = %@",NSStringFromCGRect( self.view.frame));
    
    hud = [MBProgressHUD showHUDAddedTo:theApp.window animated:YES];
    hud.labelText=@"Downloading Data...";
    [hud setMode:MBProgressHUDAnimationFade];
    [hud setOpacity:0.6];
    
    
    lAnimate = [[MBProgressHUD alloc] initWithFrame:self.view.frame];
    lAnimate.labelText = @"";
    [lAnimate setMode:MBProgressHUDAnimationFade];
    [lAnimate removeFromSuperViewOnHide];
    [lAnimate hide:YES];
    [lAnimate setOpacity:0.4];
    [self.view addSubview:lAnimate];
    
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
        if([[UIScreen mainScreen]bounds].size.height==568)
        {
                if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                {
                        hud.frame=CGRectMake(60, 100, 200, 200);
                        _cancelButton.frame=CGRectMake(2, 135, 208, 30);
                }
                else
                {
                        hud.frame=self.view.frame;
                        _cancelButton.frame=CGRectMake(58, 285, 208, 30);
                }
        }
        else if([[UIScreen mainScreen]bounds].size.height==480)
        {
                if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                {
                        hud.frame=CGRectMake(30, 80, 250, 250);
                        _cancelButton.frame=CGRectMake(25, 150, 208, 30);
                }
                else
                {
                        hud.frame=self.view.frame;
                        _cancelButton.frame=CGRectMake(58, 285, 208, 30);
                }
        }
    }
    else{
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            hud.frame=self.view.frame;
            _cancelButton.frame=CGRectMake(280, 555, 208, 30);
        }
    }
    
    [hud addSubview:_cancelButton];
    _cancelButton.enabled = NO;
    [self hideview];
    [hud show:YES];
    [self.view addSubview:hud];
    process=1;
    [self showData];
}

-(void)cancelProcess
{
    NSLog(@"Animation from logger data = %@ Cancel = %@",hud,_cancelButton);
    
    if(![hud isHidden])
    {
        [hud hide:YES];
    }
    
    [self Accessoption];
    
    [self.connectDevice sendCommand:@"x"];
}

-(void)hideview
{
    self.navigationItem.rightBarButtonItem.enabled=NO;
    self.navigationItem.leftBarButtonItem.enabled=NO;
    
    _emailButton.enabled=NO;
    _dataButton.enabled=NO;
    _clearButton.enabled=NO;
}

-(void)Accessoption
{
    self.navigationItem.rightBarButtonItem.enabled=YES;
    self.navigationItem.leftBarButtonItem.enabled=YES;
    
    _emailButton.enabled=YES;
    _dataButton.enabled=YES;
    _clearButton.enabled=YES;
}

-(void)receivingData:(Brsp *)brspObject result:(NSString *)DataStr
{
    
}

//***** method used to get the file and location of the file to attached in to the mail *****//

-(NSString *)getFile
{
    //code to create a connection to the sqlite database
    
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectory=[paths objectAtIndex:0];
    databasePath=[documentDirectory stringByAppendingPathComponent:@"BeadedStream.db"];
    
    sqlite3_stmt *statement;
    NSString *selectQuery=@"select data from detail_data where id=(select max(id) from detail_data)";
    if(sqlite3_open([databasePath UTF8String], &databaseHandle)==SQLITE_OK)
    {
        if(sqlite3_prepare_v2(databaseHandle, [selectQuery UTF8String], -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                receivedPath=[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 0)];
            }
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(databaseHandle);
    
    noteData=[NSData dataWithContentsOfFile:receivedPath];
    pathArray=[receivedPath componentsSeparatedByString:@"/"];
    filename1=[pathArray lastObject];
    
    NSFileHandle *output=[NSFileHandle fileHandleForReadingAtPath:receivedPath];
    [output seekToFileOffset:0];
    
    NSString *filecontent=[NSString stringWithContentsOfFile:receivedPath encoding:NSUTF8StringEncoding error:NULL];
//    NSLog(@"\r**********************File Content*******************\r%@",filecontent);
    
    return filename1;
    
}

-(void)checkNetwork
{
    if (isConnected)
    {
          Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        
            if (mailClass != nil){
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail]){
                    //[self composeSheet1];
                    [self performSelector:@selector(composeSheet1) withObject:nil afterDelay:2.0];
                }
                else{
                    mailConfigAlert=[[UIAlertView alloc]initWithTitle:@"Setting Alert" message:@"Before an email can be sent, you need to save an email address in settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    mailConfigAlert.tag=11;
                    [mailConfigAlert show];
                }
        }
        else
        {
            mailforwardAlert=[[UIAlertView alloc]initWithTitle:@"Process Flow" message:@"After download the data, select the file from history" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            mailforwardAlert.tag=10;
            [mailforwardAlert show];
            //[self composeSheet1];
            [self performSelector:@selector(composeSheet1) withObject:nil afterDelay:2.0];
        }
    }
    else
    {
        mailforwardAlert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please check your internet connection and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        mailforwardAlert.tag=101;
        [mailforwardAlert show];
    }
}

#pragma mark - Methods used to show the mail composer

-(void)composeSheet1
{
    
    NSArray *bccList=[[NSArray alloc]initWithObjects:@"", nil];
    MFMailComposeViewController *mcomposer=[[MFMailComposeViewController alloc]init];
    mcomposer.mailComposeDelegate=self;
    [mcomposer setSubject:@"Logger Data"];
    [mcomposer setBccRecipients:bccList];
    [mcomposer setMessageBody:@"DATA DOWNLOADED FROM THE LOGGER DEVICE IS ATTACHED" isHTML:NO];
    
    noteData=[NSData dataWithContentsOfFile:receivedPath];
    
    NSString *originalfile=[self getFile];
    
    [mcomposer addAttachmentData:noteData mimeType:@"text/plain" fileName:originalfile];
    
    [self presentViewController:mcomposer animated:YES completion:nil];
    
    [self.connectDevice sendCommand:@"X"];
    
}


//****** Method to show the message, based on the mail process *****//

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    // show alert to users about errors associated with the interface
    
    NSString *message;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            message=@"Cancelled";
            break;
            
        case MFMailComposeResultSaved:
            message=@"Saved";
            break;
            
        case MFMailComposeResultSent:
        {
            message=@"Sent";
            NSString *loggerName=TitleString;
            NSDate *currentdate=[NSDate date];
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            date=[dateFormatter stringFromDate:currentdate];
            [dateFormatter setDateFormat:@"hh:mm a"];
            time=[dateFormatter stringFromDate:currentdate];
            DataSource_1 *ds1=[[DataSource_1 alloc]initWithLoggerName:loggerName Date:date Time:time Description:@"Email Sent" Data:@" "];
            [dbc initDatabase];
            [dbc insertDataforDetail:ds1];
        }
            break;
            
        case MFMailComposeResultFailed:
            message=@"Failed";
            break;
            
        default:
            message=@"Not sent";
            break;
            
    }
    mailInfoAlert=[[UIAlertView alloc]initWithTitle:@"Mail Info" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [mailInfoAlert show];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)viewDetailData{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        ViewData *vd=[[ViewData alloc]initWithNibName:@"ViewData" bundle:nil];
        [self.navigationController pushViewController:vd animated:YES];
    }
    else
    {
        ViewData *vd=[[ViewData alloc]initWithNibName:@"ViewData_iPad" bundle:nil];
        [self.navigationController pushViewController:vd animated:YES];
    }
}

//****** Method used to clear the logger information ******//

-(IBAction)clearData
{
    process=2;
    
    [lAnimate show:YES];
    
    [self showData];

    last_accessinfo=[dbc getTime:[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"]];
    
    NSLog(@"Last Email date %@",last_accessinfo);
    
    if([last_accessinfo rangeOfString:@"-"].location!=NSNotFound)
    {
        [self performSelector:@selector(selfclear) withObject:nil afterDelay:0.7];
    }
    else
    {
        [self performSelector:@selector(noDownloadClear) withObject:nil afterDelay:0.7];
    }
}

-(void)noDownloadClear
{
    [lAnimate hide:YES];
    clearDataAlert1=[[UIAlertView alloc]initWithTitle:@"Clear Data" message:@"If you clear the data, It is permanently deleted from the logger" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clear", nil];
    clearDataAlert1.tag=132;
    [clearDataAlert1 show];
}

-(void)selfclear
{
    [lAnimate hide:YES];
    clearDataAlert=[[UIAlertView alloc]initWithTitle:@"Clear Data" message:[NSString stringWithFormat:@"Last time data has been downloaded to this iOS device:\r%@. Would you like to clear the Data from the Logger?",last_accessinfo] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clear", nil];
    clearDataAlert.tag=131;
    [clearDataAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if((alertView.tag==131) && buttonIndex==1)
    {
        NSLog(@"continue pressed");
        [self.connectDevice sendCommand:@"y"];
    }
    
    else if((alertView.tag==132) && buttonIndex==1)
    {
        [self.connectDevice sendCommand:@"y"];
    }
    
    else if((alertView.tag==131) && buttonIndex==0)
    {
        NSLog(@"Cancel pressed");
        [self.connectDevice sendCommand:@"n"];
    }
    
    else if((alertView.tag==132) && buttonIndex==0)
    {
        NSLog(@"Cancel pressed");
        [self.connectDevice sendCommand:@"n"];
    }
    else if(!(alertView.tag==131) && buttonIndex==1)
    {
        [self checkNetwork];
    }
    else if((alertView.tag==1340) && buttonIndex==0)
    {
        [self.connectDevice sendCommand:@"X"];
    }
    else if((alertView.tag==201) && buttonIndex==0)
    {
        [self.connectDevice sendCommand:@"X"];
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma  mark - methods used to check the availability of the internet connection

-(void)setNetworkNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
    
    Reachability * internetReach = [Reachability reachabilityForInternetConnection];
    
    [internetReach startNotifier];
    
    [self updateReachabilityStatus:internetReach];
    
    internetReach = nil;
}

-(void)reachabilityChanged: (NSNotification* )note
{
    Reachability  *curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    [self updateReachabilityStatus:curReach];
}

-(void)updateReachabilityStatus:(Reachability*)reach
{
    NetworkStatus networkStatus = [reach currentReachabilityStatus];
    isConnected = (networkStatus == NotReachable)?NO:YES;
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

#pragma mark - Logger process

-(void)showData
{
    if(self.connectDevice == nil)
    {
        self.connectDevice = [[DeviceConnector alloc] init];
        self.connectDevice.delegate = self;
    }
    [self.connectDevice connectactivePeripheral];
}


-(void)showData:(int)starting NumberofRow:(int)rowNeed
{
    process=4;
    startRow=starting;
    needRow=rowNeed;
    
    if(self.connectDevice == nil)
    {
        self.connectDevice = [[DeviceConnector alloc] init];
        self.connectDevice.delegate = self;
    }
    [self.connectDevice connectactivePeripheral];
    
}

-(void)deviceAlreadyConnected
{
    NSLog(@"Already Connected");
    if(process==1)
    {
        [self.connectDevice sendCommand:@"flash-txfr-binary"];
        timer3=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(callRcommand) userInfo:nil repeats:NO];
    }
    else if(process==2)
    {
        [self.connectDevice sendCommand:@"clear"];
    }
    else if(process==3)
    {
        [self.connectDevice sendCommand:@"log_p"];
    }
    else if(process==4)
    {
        NSLog(@"Resend Data");
        [self callCommand];
    }
}

-(void)deviceConnected
{
    NSLog(@"device Connected");
    
    if(process==1)
    {
        [self.connectDevice sendCommand:@"flash-txfr-binary"];
        timer3=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(callRcommand) userInfo:nil repeats:NO];
    }
    else if(process==2)
    {
        [self.connectDevice sendCommand:@"clear"];
    }
    else if(process==3)
    {
        [self.connectDevice sendCommand:@"log_p"];
    }
    else if(process==4)
    {
        NSLog(@"Resend Data");
        [self callCommand];
    }
}

-(void)callRcommand
{
    [timer3 invalidate];
    [self.connectDevice sendCommand:@"r"];
}

-(void)callCommand
{
    [self.connectDevice sendCommand:[NSString stringWithFormat:@"t%d,%d",needRow,startRow]];
}

-(void)requestStarted
{
    NSLog(@"requestStarted on");
}

-(void)requestCompleted2:(NSString *)rowNumber
{
    int numberOfRow=[rowNumber intValue];
    [self.connectDevice sendCommand:[NSString stringWithFormat:@"t%d",numberOfRow]];
    
}

-(void)requestCompleted1:(NSMutableString*)output NumbeofRow:(NSString *)numberOfRow
{
    _cancelButton.enabled = YES;
    
    NSLog(@"Inside the request completed 1");
    
    if([numberOfRow isEqualToString:@"0"])
    {
        if(![hud isHidden])
        {
            [hud hide:YES];
        }
        
       noDa = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data saved for this logger" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        noDa.tag=201;
        noDa.delegate=self;
        [noDa show];
        
        [self Accessoption];
    }
    else
    {
        NSMutableString *output1=[[NSMutableString alloc]initWithString:output];
//         CRC16 *crc16=[[CRC16 alloc]init];
        [crc16 setCalledClass:self];
        crc16.referenceKeyword=@"LoggerData";
        [crc16 startProcess:output1 NumberofRow:[numberOfRow intValue]];
    }
}


-(void) createFile:(NSMutableString *)receivedData
{
    if([receivedData length]>20)
    {
        [self requestCompleted:_brspObject result:receivedData];
    }
}

-(void)requestCompleted:(Brsp *)brspObject result:(NSString *)str
{
    [self Accessoption];
    
    NSLog(@"Value of received data  %@",str);
    
   if(![str isEqualToString:@"NO"])
    {
        if(![str isEqualToString:@"ERASE"])
        {
            if([str length]>15)
            {
                NSLog(@"Out put data%@",str);
                isData=YES;
                
                NSLog(@"Animation :%@ Cancel = %@", hud,_cancelButton);
        
         
                NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectroy=[path objectAtIndex:0];
                
                NSDate *currentdate=[NSDate date];
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                date=[dateFormatter stringFromDate:currentdate];
                [dateFormatter setDateFormat:@"hh:mm a"];
                time=[dateFormatter stringFromDate:currentdate];
        
                NSString *fileName=[NSString stringWithFormat:@"%@%@%@.txt",[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"],date,time];
                NSString *filePath=[documentsDirectroy stringByAppendingPathComponent:fileName];
        
                [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
                NSFileHandle *output=[NSFileHandle fileHandleForReadingAtPath:filePath];
                [output seekToFileOffset:0];
        
                NSString *filecontent=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
//                NSLog(@"\r**********************File Content*******************\r%@",filecontent);
                
                    if([filecontent length]>=10)
                    {
                        DataSource_1 *ds1=[[DataSource_1 alloc]initWithLoggerName:[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"] Date:date Time:time Description:@"Downloaded from logger" Data:filePath];

                        [dbc initDatabase];
                        [dbc insertDataforDetail:ds1];
        
                        databaseop = [[UIAlertView alloc] initWithTitle:@"Database operation" message:@"Data copied to handheld device. Do you want to send mail" delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                        NSLog(@"Alert :%@", databaseop);
                        databaseop.tag=1340;
                        databaseop.delegate=self;
                        [databaseop forwardingTargetForSelector:@selector(composeSheet1)];
                        NSLog(@"asfasdfasdf");
            
                        [databaseop show];
        
                        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                        date=[dateFormatter stringFromDate:currentdate];
        
                        NSString *logforConnection=[NSString stringWithFormat:@"Downloaded sensor data from %@ at %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"],date];
        
                        [dbc logfile:logforConnection];
                    }
                }
            }
            if(![hud isHidden])
            {
                [hud setHidden:YES];
            }
        }
    
   else if([str isEqualToString:@"NO"] && process==1)
   {
       isData=YES;
       
       if(![hud isHidden])
       {
           [hud hide:YES];
       }
       //            noDa = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No Data Saved For This Logger" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
       //            noDa.tag=192;
       //            noDa.delegate=self;
       //            [noDa show];
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

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
