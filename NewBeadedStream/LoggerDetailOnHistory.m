//
//  LoggerDetailOnHistory.m
//  AuroraLink
//
//  Created by fsp on 7/29/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "LoggerDetailOnHistory.h"

@interface LoggerDetailOnHistory ()


@end

//***** Class used to show the stored information about the logger to the user, with out logger in the range *****//
@implementation LoggerDetailOnHistory

@synthesize backButton,settings,description,date,time,path;
@synthesize data;
@synthesize loggerName,gpscod,voltage,interval,saveButton,title1,loggerInfo;


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
    // Do any additional setup after loading the view from its nib.
    
    frame1=[[UIScreen mainScreen]bounds];
   
    //***** Navigation bar element allocation *****//
    titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    settings = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //***** Body content element allocation ******//
    loggerName=[[UITextField alloc]init];
    gpscod=[[UITextField alloc]init];
    voltage=[[UITextField alloc]init];
    interval=[[UITextField alloc]init];
    saveButton=[[UIButton alloc]init];
    
    loggerName.backgroundColor=[UIColor clearColor];
    loggerName.textColor=[UIColor whiteColor];
    loggerName.delegate=self;
    
    gpscod.backgroundColor=[UIColor clearColor];
    gpscod.textColor=[UIColor whiteColor];
    gpscod.delegate=self;
    
    voltage.backgroundColor=[UIColor clearColor];
    voltage.textColor=[UIColor whiteColor];
    voltage.delegate=self;
    
    interval.backgroundColor=[UIColor clearColor];
    interval.textColor=[UIColor whiteColor];
    interval.delegate=self;
    
    saveButton.backgroundColor=[UIColor clearColor];
    
    data=[UIButton buttonWithType:UIButtonTypeCustom];
    
    infoSelect=[[UIImageView alloc]init];
    infoImage=[[UIImageView alloc]init];

}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"From LoggerDeatilOn History");
    
    NSLog(@"From LoggerDetailOnHistory");
    
    NSLog(@"Last value from the logger infor %@",loggerInfo);
    
    NSLog(@"TEST :%@\n \n %@",loggerInfo, [[loggerInfo objectAtIndex:0] valueForKey:@"loggerName"]);
    
    titleLabel.text=[[loggerInfo objectAtIndex:0] valueForKey:@"loggerName"];
    
    loggerName.text=[[loggerInfo objectAtIndex:0] valueForKey:@"loggerName"];
    gpscod.text=[[loggerInfo objectAtIndex:0] valueForKey:@"gpscode"];
    voltage.text=[[loggerInfo objectAtIndex:0] valueForKey:@"voltage"];
    interval.text=[[loggerInfo objectAtIndex:0] valueForKey:@"interval"];
    
    
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
        
            backgroundImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
        
            titleLabel.frame=CGRectMake(105.0, 0.0, 200.0, 40.0);
            [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
        
            infoSelect.image=[UIImage imageNamed:@"infoSelect_His.png"];
            infoImage.image=[UIImage imageNamed:@"BasicLayerWOSave.png"];
        
            [loggerName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0]];
            [gpscod setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0]];
            [voltage setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0]];
            [interval setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:18.0]];
        
                if([[UIScreen mainScreen] bounds].size.height == 568 )
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                            {
                                    infoSelect.frame = CGRectMake(0, frame1.size.height-128, frame1.size.width, 64);
                                    infoImage.frame=CGRectMake(7, 20, 306, 178);
                
                                    data.frame=CGRectMake(160.0,frame1.size.height - 120,frame1.size.width - 160,60.0);
                                
                                    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                    {
                                            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"solidNavBar.png"] forBarMetrics:UIBarMetricsDefault];
                                            self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0, 320.0, 65.0);
                                    }
            
                                    loggerName.frame=CGRectMake(14, 30, 295, 30);
                                    gpscod.frame=CGRectMake(14, 74, 295, 30);
                                    voltage.frame=CGRectMake(14, 120, 295, 30);
                                    interval.frame=CGRectMake(14, 165, 295, 30);
            
                                    saveButton.frame=CGRectMake(7, 274, 295, 36);
                            }
                        else
                        {
                                infoSelect.frame = CGRectMake(0, 440, 320, 64);
                                infoImage.frame=CGRectMake(7, 19, 306, 178);
            
                                data.frame=CGRectMake(160.0,frame1.size.height - 120,frame1.size.width - 160,63.0);
                            
            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                                }
                            
                                loggerName.frame=CGRectMake(14, 32, 295, 30);
                                gpscod.frame=CGRectMake(14, 77, 295, 30);
                                voltage.frame=CGRectMake(14, 123, 295, 30);
                                interval.frame=CGRectMake(14, 168, 295, 30);
                                saveButton.frame=CGRectMake(7, 210, 295, 36);
                        }
                }
                else if([[UIScreen mainScreen] bounds].size.height == 480)
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                                infoSelect.frame=CGRectMake(0, frame1.size.height-128, frame1.size.width, 64);
                            
                                infoImage.frame=CGRectMake(7, 20, 306, 178);
                            
                                data.frame=CGRectMake(160.0,frame1.size.height - 125,frame1.size.width - 160,63.0);
            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"solidNavBar.png"] forBarMetrics:UIBarMetricsDefault];
                                }
                            
                                loggerName.frame=CGRectMake(14, 35, 295, 30);
                                gpscod.frame=CGRectMake(14, 74, 295, 30);
                                voltage.frame=CGRectMake(14, 120, 295, 30);
                                interval.frame=CGRectMake(14, 165, 295, 30);
                        }
                        else
                        {
                                infoSelect.frame = CGRectMake(0, frame1.size.height-64,frame1.size.width, 64);
                                infoImage.frame=CGRectMake(7, 19, 306, 178);
            
                                data.frame=CGRectMake(160.0,frame1.size.height - 57,frame1.size.width - 160,63.0);
                               
            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                                }
            
                                loggerName.frame=CGRectMake(14, 30, 295, 30);
                                gpscod.frame=CGRectMake(14, 77, 295, 30);
                                voltage.frame=CGRectMake(14, 168, 295, 30);
                                interval.frame=CGRectMake(14, 168, 295, 30);
                        }
                }
    }
//*******iPad Design*******//
    else
    {
                    buttonImage1=[UIImage imageNamed:@"info~ipad.png"];
                    [settings setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
                    settings.frame = CGRectMake(0, 0,38, 38);
                    [settings addTarget:self action:@selector(infoView) forControlEvents:UIControlEventTouchUpInside];
                    barButton1 = [[UIBarButtonItem alloc] initWithCustomView:settings];
        
                    buttonImage=[UIImage imageNamed:@"historyBtn~ipad.png"];
                    [backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
                    backButton.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 46, 46);
                    [backButton addTarget:self action:@selector(backProcess) forControlEvents:UIControlEventTouchUpInside];
                    barButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
                    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background~ipad.png"]];
        
                    infoSelect.image  =[UIImage imageNamed:@"infoSelect_His~ipad.png"] ;
                    infoImage.image=[UIImage imageNamed:@"BasicLayerWOSave~ipad.png"];
        
                    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                    {
                            titleLabel.frame=CGRectMake(150.0, 0.0, 300.0, 40.0);
                            [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];

                            [loggerName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
                            [gpscod setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
                            [voltage setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
                            [interval setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
            
                            infoSelect.frame = CGRectMake(0,frame1.size.height-107,frame1.size.width, 107);
                            infoImage.frame=CGRectMake(18, 120, 733, 327);
            
                            data.frame=CGRectMake(383, frame1.size.height-95, 375, 100);
                        
            
                            if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                            {
                                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar~ipad.png"] forBarMetrics:UIBarMetricsDefault];
                                    self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0,frame1.size.width, 78.0);
                            }
                            loggerName.frame=CGRectMake(30, 143, 295, 30);
                            gpscod.frame=CGRectMake(30, 230, 295, 30);
                            voltage.frame=CGRectMake(30, 315, 295, 30);
                            interval.frame=CGRectMake(30, 400, 295, 30);
            }
    }
    
    [data addTarget:self action:@selector(dataView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=barButton1;
    self.navigationItem.leftBarButtonItem=barButton;
    
    self.navigationItem.titleView=titleLabel;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton=YES;
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [self.view addSubview:infoSelect];
    [self.view addSubview:infoImage];
    
    [self.view addSubview:loggerName];
    [self.view addSubview:gpscod];
    [self.view addSubview:voltage];
    [self.view addSubview:interval];
    
    [self.view addSubview:data];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
[textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

//***** Switch to data View page *****//

-(void)dataView
{
    LoggerDataOnHistory *ldoh=[[LoggerDataOnHistory alloc]init];
    ldoh.getDes=description;
    ldoh.getDataPath=path;
    ldoh.getDate=date;
    ldoh.getTime=time;
    [self.navigationController pushViewController:ldoh animated:NO];
}

//***** Switch over to the setting page to insert and update the existing data ******//
-(void)infoView
{
    InfoView *iv=[[InfoView alloc]init];
    [self.navigationController pushViewController:iv animated:YES];
}

-(void)backProcess
{
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    
    for( int i=0;i<[ viewContrlls count];i++)
    {
        id obj=[viewContrlls objectAtIndex:i];
        if([obj isKindOfClass:[HistroyView class]])
        {
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
    
   // [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
