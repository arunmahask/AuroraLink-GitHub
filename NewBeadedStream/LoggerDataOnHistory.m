//
//  LoggerDataOnHistory.m
//  AuroraLink
//
//  Created by fsp on 7/29/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "LoggerDataOnHistory.h"

@interface LoggerDataOnHistory ()

@end

bool isConnected;

@implementation LoggerDataOnHistory

@synthesize emailButton,dataButton,backButton,settings,basic;
@synthesize getLogger,getDate,getTime,getDataPath,getDes,existLoggerinfo,fromData;

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
    
    TitleString=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"];
    
    frame1=[[UIScreen mainScreen]bounds];
    
    //******* Navigation Bar settings *******//
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    
    
    existLoggerinfo=[[NSMutableArray alloc]init];

    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    settings = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //******* Tabbar Button Allocation ********//
    
    basic=[UIButton buttonWithType:UIButtonTypeCustom];

    [self setNetworkNotification];
    
    dataSelect=[[UIImageView alloc]init];
    
    emailButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [emailButton setBackgroundImage:[UIImage imageNamed:@"SendEmail.png"] forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    
    dataButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [dataButton setBackgroundImage:[UIImage imageNamed:@"ViewData.png"] forState:UIControlStateNormal];
    [dataButton addTarget:self action:@selector(viewDetailData) forControlEvents:UIControlEventTouchUpInside];
    

    spliter=[[UIImageView alloc]init];
    spliter.image=[UIImage imageNamed:@"Splitter.png"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    titleLabel.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle"];
    NSLog(@"Get Des = %@",getDes);
    
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
        buttonImage1=[UIImage imageNamed:@"info.png"];
        [settings setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
        settings.frame = CGRectMake(0, 0, (buttonImage1.size.width / buttonImage1.size.height) * 30, 30);
        [settings addTarget:self action:@selector(infoView) forControlEvents:UIControlEventTouchUpInside];
        barButton1 = [[UIBarButtonItem alloc] initWithCustomView:settings];
        
        buttonImage=[UIImage imageNamed:@"historyBtn.png"];
        [backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 30, 30);
        [backButton addTarget:self action:@selector(backProcess) forControlEvents:UIControlEventTouchUpInside];
        barButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
        
        [emailButton setBackgroundImage:[UIImage imageNamed:@"SendEmail.png"] forState:UIControlStateNormal];
        [dataButton setBackgroundImage:[UIImage imageNamed:@"ViewData.png"] forState:UIControlStateNormal];
        
        titleLabel.frame=CGRectMake(100.0, 0.0, 200.0, 40.0);
        [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
        
        dataSelect.image=[UIImage imageNamed:@"dataSelect_His.png"];
        
    if([[UIScreen mainScreen] bounds].size.height == 568 )
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            dataSelect.frame = CGRectMake(0, frame1.size.height-128, frame1.size.width, 64);
            
            emailButton.frame=CGRectMake(10, 57, 301, 35);
            spliter.frame=CGRectMake(10, 132, 301, 2);
            dataButton.frame=CGRectMake(10, 172, 301, 35);
           
            
            basic.frame=CGRectMake(0.0,frame1.size.height - 128,frame1.size.width - 160.0,60.0);
            
            if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"solidNavBar.png"] forBarMetrics:UIBarMetricsDefault];
                self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0, 320.0, 65.0);
            }
        }
        else
        {
            dataSelect.frame = CGRectMake(0, 440, 320, 64);
            
            emailButton.frame=CGRectMake(10, 85, 301, 35);
            dataButton.frame=CGRectMake(10, 201, 301, 35);
            
            spliter.frame=CGRectMake(10, 161, 301, 2);
            
            if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
            }
            
            basic.frame=CGRectMake(0.0,frame1.size.height - 120,frame1.size.width - 160.0,63.0);
        }
    }
    else if([[UIScreen mainScreen]bounds].size.height==480)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            dataSelect.frame = CGRectMake(0, frame1.size.height-128,frame1.size.width, 64);
            
            emailButton.frame=CGRectMake(10, 57, 301, 35);
            spliter.frame=CGRectMake(10, 132, 301, 2);
            dataButton.frame=CGRectMake(10, 172, 301, 35);
            
            if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"solidNavBar.png"] forBarMetrics:UIBarMetricsDefault];
            }
            
            basic.frame=CGRectMake(2, frame1.size.height-125, frame1.size.width-160, 63.0);
            
        }
        else
        {
            dataSelect.frame = CGRectMake(0, 352, 320, 64);
            
            emailButton.frame=CGRectMake(10, 65, 301, 35);
            dataButton.frame=CGRectMake(10, 180, 301, 35);
            
            spliter.frame=CGRectMake(10, 135, 301, 2);
            
            if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
            }
            
            basic.frame=CGRectMake(2, frame1.size.height-64,frame1.size.width-160, 63);
        }
    }
}
    
//****** iPad Design ******//
    else
    {
        buttonImage1=[UIImage imageNamed:@"info~ipad.png"];
        [settings setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
        settings.frame = CGRectMake(0, 0, 38, 38);
        [settings addTarget:self action:@selector(infoView) forControlEvents:UIControlEventTouchUpInside];
        barButton1 = [[UIBarButtonItem alloc] initWithCustomView:settings];
        
        buttonImage=[UIImage imageNamed:@"historyBtn~ipad.png"];
        [backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 46, 46);
        [backButton addTarget:self action:@selector(backProcess) forControlEvents:UIControlEventTouchUpInside];
        barButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background~ipad.png"]];
        
        dataSelect.image=[UIImage imageNamed:@"dataSelect_His~ipad.png"];
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            titleLabel.frame=CGRectMake(150.0, 0.0, 300.0, 40.0);
            [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
            
            [emailButton setBackgroundImage:[UIImage imageNamed:@"SendEmail~ipad.png"] forState:UIControlStateNormal];
            [dataButton setBackgroundImage:[UIImage imageNamed:@"ViewData~ipad.png"] forState:UIControlStateNormal];
          
            
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                dataSelect.frame = CGRectMake(0, frame1.size.height-107, frame1.size.width, 107);
                
                emailButton.frame=CGRectMake(20, 200, 733, 64);
                spliter.frame=CGRectMake(10, 350, 733, 2);
                dataButton.frame=CGRectMake(20, 435, 733, 64);
                
                
                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                {
                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar~ipad.png"] forBarMetrics:UIBarMetricsDefault];
                    self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0,frame1.size.width, 78.0);
                }
                
                basic.frame=CGRectMake(2, frame1.size.height-95, 375, 107);

            }

        }
    }
    
    [basic addTarget:self action:@selector(basicView) forControlEvents:UIControlEventTouchUpInside];
   
    
    self.navigationItem.rightBarButtonItem=barButton1;
    self.navigationItem.leftBarButtonItem=barButton;
    
    self.navigationItem.titleView=titleLabel;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton=YES;
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];

     [self.view addSubview:dataSelect];
    
    [self.view addSubview:emailButton];
    [self.view addSubview:spliter];
    [self.view addSubview:dataButton];
    
    [self.view addSubview:basic];
    
}

-(void)backProcess
{
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    
    NSLog(@"ViewController list --- %@",viewContrlls);
        for( int i=0;i<[ viewContrlls count];i++)
        {
            id obj=[viewContrlls objectAtIndex:i];
            if([obj isKindOfClass:[HistroyView class]])
            {
                [[self navigationController] popToViewController:obj animated:YES];
                return;
            }
        }
    
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)infoView
{
    InfoView *iv=[[InfoView alloc]init];
    [self.navigationController pushViewController:iv animated:YES];
}

//****** method to check the availability of the logger information in the database *****//

-(void)basicView
{
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    
    int i=[viewContrlls count];
    
    NSLog(@"ViewControllers list - %@   count - %d",viewContrlls,i);
    
    NSLog(@"TITLE Lable = %@",titleLabel.text);
    
    DataBaseControl *dbc=[[DataBaseControl alloc]init];
    
    NSString *content=titleLabel.text;
    
    [dbc initDatabase];
    
    existLoggerinfo=[[dbc getLoggerDetail:content]mutableCopy];
    
    NSLog(@"content = %@",content);
    
    NSLog(@"Exist Logger info = %@",existLoggerinfo);
    
    if(existLoggerinfo.count > 0)
    {
        LoggerDetailOnHistory *ldoh=[[LoggerDetailOnHistory alloc]init];
        ldoh.title1=titleLabel.text;
        ldoh.description=getDes;
        ldoh.date=getDate;
        ldoh.time=getTime;
        ldoh.path=getDataPath;
        ldoh.loggerInfo=[[dbc getLoggerDetail:content]mutableCopy];
        [self.navigationController pushViewController:ldoh animated:NO];
        
    }
    else{
        alert2=[[UIAlertView alloc]initWithTitle:@"Warning!" message:@"This logger info was not retrieved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert2 show];
    }
}


#pragma mark - Method of the Body content
//****** show the mail composer to send a mail ******//
-(IBAction)sendEmail
{
    if (isConnected)
    {
        if(([getDes rangeOfString:@"Downloaded from logger"].location != NSNotFound) || ([getDes rangeOfString:@"Downloaded from logger from View Data"].location != NSNotFound))
        {
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass != nil){
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail]){
                    [self composeSheet];
                }
                else
                {
                    mailConfigAlert=[[UIAlertView alloc]initWithTitle:@"Setting Alert" message:@"Before an email can be sent, you need to save an email address in settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    mailConfigAlert.tag=11;
                    [mailConfigAlert show];
                }
            }
        }
        else{
            mailforwardAlert=[[UIAlertView alloc]initWithTitle:@"Process Flow" message:@"After download the data, select the file from history" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            mailforwardAlert.tag=10;
            [mailforwardAlert show];
        }
        
    }

    else{
        mailforwardAlert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please check your internet connection and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        mailforwardAlert.tag=101;
        [mailforwardAlert show];
        [self composeSheet];
    }
}

-(void)composeSheet{
    
    NSArray *bccList=[[NSArray alloc]initWithObjects:@"", nil];
    MFMailComposeViewController *mcomposer=[[MFMailComposeViewController alloc]init];
    [mcomposer.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
    mcomposer.mailComposeDelegate=self;
    [mcomposer setSubject:@"Logger Data"];
    [mcomposer setBccRecipients:bccList];
    [mcomposer setMessageBody:@"DATA DOWNLOADED FROM THE LOGGER DEVICE IS ATTACHED" isHTML:NO];
    
    noteData=[NSData dataWithContentsOfFile:getDataPath];
    pathArray=[getDataPath componentsSeparatedByString:@"/"];
    filename=[pathArray lastObject];

    [mcomposer addAttachmentData:noteData mimeType:@"text/plain" fileName:filename];
    
     if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
     {
         [self presentViewController:mcomposer animated:YES completion:nil];
     }
     else
     {
         [self presentModalViewController:mcomposer animated:YES];
     }
    
}


//****** Method to show the message, based on the mail process *****//

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    // show alert to users about errors associated with the interface
    NSString *message;
    switch (result){
        case MFMailComposeResultCancelled:
            message=@"Cancelled";
            break;
            
        case MFMailComposeResultSaved:
            message=@"Saved";
            break;
            
        case MFMailComposeResultSent:{
            message=@"Sent";
            NSString *loggerName=TitleString;
            NSDate *currentdate=[NSDate date];
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            NSString *date=[dateFormatter stringFromDate:currentdate];
            [dateFormatter setDateFormat:@"hh:mm a"];
            NSString *time=[dateFormatter stringFromDate:currentdate];
            DataSource_1 *ds1=[[DataSource_1 alloc]initWithLoggerName:loggerName Date:date Time:time Description:@"Email Sent" Data:@" "];
            DataBaseControl *dbc=[[DataBaseControl alloc]init];
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
    mailInfoAlert.tag=12;
    [mailInfoAlert show];
    
    [self dismissModalViewControllerAnimated:YES];
}

//***** used to view the downloaded logger view *****//

-(IBAction)viewDetailData{
    ViewData *vd=[[ViewData alloc]init];
    if([getDes rangeOfString:@"Email Sent"].location != NSNotFound ||[getDes rangeOfString:@"Imported Data From"].location != NSNotFound){
        viewMailAlert=[[UIAlertView alloc]initWithTitle:@"Process Flow " message:@"Please select the downloaded history" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        viewMailAlert.tag=14;
        [viewMailAlert show];
    }
    else{
    vd.isVHistory=YES;
    vd.filePath=getDataPath;
    vd.DateFromHistory=getDate;
    vd.LLLoggerNameFromHistroy=getLogger;
    [self.navigationController pushViewController:vd animated:YES];
    }
}

//****** Clear the logger sensor information ******//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        Reachability * curReach = [note object];
        
        NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
        
        [self updateReachabilityStatus:curReach];
}
                                                                              
-(void)updateReachabilityStatus:(Reachability*)reach
{
    NetworkStatus networkStatus = [reach currentReachabilityStatus];
        
    isConnected = (networkStatus == NotReachable)?NO:YES;
}

@end
