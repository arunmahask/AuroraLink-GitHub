//
//  ViewController.m
//  NewBeadedStream
//
//  Created by fsp on 6/14/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "ViewController.h"
#import "ScanDevice.h"
#import "HistroyView.h"


@implementation UINavigationController (autorotation)

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end

@interface ViewController ()

@end

@implementation ViewController

BOOL unlock=NO;
int x =0;

- (void)viewDidLoad
{
        [super viewDidLoad];
    
        dbc=[[DataBaseControl alloc]init];
        [dbc initDatabase];
    
        frame1=[[UIScreen mainScreen]bounds];
    
        historyContain=[[UIImageView alloc]init];
        loggerContain=[[UIImageView alloc]init];
    
        histroySlide=[[UISlider alloc]init];
        histroySlide.minimumValue=0.0f;
        histroySlide.maximumValue=100.0f;
        histroySlide.userInteractionEnabled=YES;
        histroySlide.value=100.0f;
        histroySlide.continuous=YES;
    
        loggerSlide=[[UISlider alloc]init];
        loggerSlide.minimumValue=0.0f;
        loggerSlide.maximumValue=100.0f;
        loggerSlide.userInteractionEnabled=YES;
        loggerSlide.value=0.1f;
        loggerSlide.continuous=YES;

    
        infoButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [infoButton addTarget:self action:@selector(viewInfo:) forControlEvents:UIControlEventTouchUpInside];
    
        homeBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame1.size.width,frame1.size.height)];
    
    
    //**** Code to display the splash screen while the application start up *****//
    
        splashView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        Mytime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loadAnimation) userInfo:nil repeats:YES];
    
        [self animate];
        [splashView startAnimating];
    
        self.navigationController.navigationBarHidden = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
    
        //homeBackground.frame=CGRectMake(0, 0, frame1.size.width, frame1.size.height);
    
        if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
        {
            if(frame1.size.height==568)
            {
                homeBackground.image=[UIImage imageNamed:@"HomeScreen~568h@2x.png"];
            }
            else if(frame1.size.height==480)
            {
                homeBackground.image=[UIImage imageNamed:@"HomeScreen.png"];
            }
        }
        else
        {
            if(frame1.size.height==2048)
            {
                homeBackground.image=[UIImage imageNamed:@"HomeScreen@2x~ipad.png"];
            }
            else if(frame1.size.height==1024)
            {
                homeBackground.image=[UIImage imageNamed:@"HomeScreen~ipad.png"];
            }
        }
    

    //***** code to swipe the object in the landing page ******//
    
    
            if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
            {
                [infoButton setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
                
                [historyContain setImage:[UIImage imageNamed:@"History.png"]];
                [loggerContain setImage:[UIImage imageNamed:@"Loggers.png"]];
                
                UIImage *leftTrack=[[UIImage imageNamed:@"Nothing.png"] stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
                UIImage *rightTrack=[[UIImage imageNamed:@"Nothing.png"] stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
                
                [histroySlide setThumbImage:[UIImage imageNamed:@"historySlideBtn.png"] forState:UIControlStateNormal];
                [histroySlide setThumbImage:[UIImage imageNamed:@"historySlideBtn.png"] forState:UIControlStateHighlighted];
                [histroySlide setMinimumTrackImage:leftTrack forState:UIControlStateNormal];
                [histroySlide setMaximumTrackImage:rightTrack forState:UIControlStateNormal];
                [histroySlide addTarget:self action:@selector(viewHistory) forControlEvents:UIControlEventValueChanged];
                
                [loggerSlide setThumbImage:[UIImage imageNamed:@"loggerSlideBtn.png"] forState:UIControlStateNormal];
                [loggerSlide setThumbImage:[UIImage imageNamed:@"loggerSlideBtn.png"] forState:UIControlStateHighlighted];
                [loggerSlide setMinimumTrackImage:rightTrack forState:UIControlStateNormal];
                [loggerSlide setMaximumTrackImage:leftTrack forState:UIControlStateNormal];
                [loggerSlide addTarget:self action:@selector(viewLogger) forControlEvents:UIControlEventValueChanged];
                
                if([[UIScreen mainScreen] bounds].size.height == 568 )
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                            infoButton.frame = CGRectMake(270, 29, 34, 34);
                            historyContain.frame = CGRectMake(8, 394, 304, 76);
                            loggerContain.frame =CGRectMake(8,477 , 304, 76);
                            histroySlide.frame = CGRectMake(8, 422, 304, 23);
                            loggerSlide.frame =CGRectMake(8,503 , 304, 23);
                        }
                        else
                        {
                            infoButton.frame = CGRectMake(270, 15, 34, 34);
                            historyContain.frame = CGRectMake(8, 370, 304, 76);
                            loggerContain.frame =CGRectMake(8,455 , 304, 76);
                            histroySlide.frame = CGRectMake(8, 397, 304, 23);
                            loggerSlide.frame =CGRectMake(8,483 , 304, 23);
                        }
                }
    
                else if([[UIScreen mainScreen]bounds].size.height==480)
                {
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                    {
                        infoButton.frame = CGRectMake(270, 20, 34, 34);
                        historyContain.frame = CGRectMake(8, 270, 304, 76);
                        loggerContain.frame =CGRectMake(8,370 , 304, 76);
                        histroySlide.frame = CGRectMake(8, 296, 304, 23);
                        loggerSlide.frame =CGRectMake(8, 396, 304, 23);
                    }
                    else
                    {
                        infoButton.frame = CGRectMake(270, 20, 34, 34);
                        historyContain.frame = CGRectMake(8, 270, 304, 76);
                        loggerContain.frame =CGRectMake(8,370 , 304, 76);
                        histroySlide.frame = CGRectMake(8, 298, 304, 23);
                        loggerSlide.frame =CGRectMake(8, 398, 304, 23);
                    }
                }
            }
    
            else
            {
                [infoButton setImage:[UIImage imageNamed:@"info~ipad.png"] forState:UIControlStateNormal];
                
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                    {
                        infoButton.frame=CGRectMake(720, 35.0, 38, 38);
                        
                        [historyContain setImage:[UIImage imageNamed:@"History~ipad.png"]];
                        [loggerContain setImage:[UIImage imageNamed:@"Loggers~ipad.png"]];
                        
                        historyContain.frame=CGRectMake(15, 650, 737, 141);
                        loggerContain.frame=CGRectMake(15, 830, 737, 141);
                        
                        UIImage *leftTrack=[[UIImage imageNamed:@"Nothing.png"] stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
                        UIImage *rightTrack=[[UIImage imageNamed:@"Nothing.png"] stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];

                        histroySlide.frame = CGRectMake(13, 710, 737, 20);
                        [histroySlide setThumbImage:[UIImage imageNamed:@"historySlideBtn~ipad.png"] forState:UIControlStateNormal];
                        [histroySlide setThumbImage:[UIImage imageNamed:@"historySlideBtn~ipad.png"] forState:UIControlStateHighlighted];
                        [histroySlide setMinimumTrackImage:leftTrack forState:UIControlStateNormal];
                        [histroySlide setMaximumTrackImage:rightTrack forState:UIControlStateNormal];
                        [histroySlide addTarget:self action:@selector(viewHistory) forControlEvents:UIControlEventValueChanged];
                        
                        loggerSlide.frame =CGRectMake(13, 890, 737, 20);
                        [loggerSlide setThumbImage:[UIImage imageNamed:@"loggerSlideBtn~ipad.png"] forState:UIControlStateNormal];
                        [loggerSlide setThumbImage:[UIImage imageNamed:@"loggerSlideBtn~ipad.png"] forState:UIControlStateHighlighted];
                        [loggerSlide setMinimumTrackImage:rightTrack forState:UIControlStateNormal];
                        [loggerSlide setMaximumTrackImage:leftTrack forState:UIControlStateNormal];
                       [loggerSlide addTarget:self action:@selector(viewLogger) forControlEvents:UIControlEventValueChanged];
                    }
                    else
                    {
                        
                    }
             
            }
    
    [self.view addSubview:homeBackground];
    [self.view addSubview:infoButton];
    
    [self.view addSubview:historyContain];
    [self.view addSubview:loggerContain];
    
    [self.view addSubview:histroySlide];
    [self.view addSubview:loggerSlide];
    
      [self.view addSubview:splashView];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    histroySlide.hidden=NO;
    historyContain.hidden=NO;
    loggerSlide.hidden=NO;
    loggerContain.hidden=NO;
    loggerSlide.value=0.1;
    histroySlide.value=100;
}

//****** Animation process for the Splash Screen ******//

-(void)loadAnimation
{
    x ++;
    if(x == 3)
    {
        [splashView stopAnimating];
        splashView.alpha =0.0;
        [Mytime invalidate];
    }
}

-(void)animate
{
    splashView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
        if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
        {
                if (splashView.frame.size.height != 568)
                            splashView.animationImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"BS_splashScreen_v2_1.png"],[UIImage imageNamed:@"BS_splashScreen_v2_2.png"],[UIImage imageNamed:@"BS_splashScreen_v2_3.png"],nil];
                else
                        splashView.animationImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"BS_splashScreen_v3_1.png"],[UIImage imageNamed:@"BS_splashScreen_v3_2.png"],[UIImage imageNamed:@"BS_splashScreen_v3_3.png"],nil];

                splashView.animationDuration = 1.0;
    }
    else
    {
      if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
          NSLog(@"From Splash");
            splashView.animationImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"BS_splashScreen_v1_1~ipad.png"],[UIImage imageNamed:@"BS_splashScreen_v1_2~ipad.png"],[UIImage imageNamed:@"BS_splashScreen_v1_3~ipad.png"],nil];
        
            splashView.animationDuration = 1.0;
    }
    
    
}

//***** Method to show the logger with in the range ******//

-(void)viewLogger
{
   if(!unlock)
    {
        if(loggerSlide.value==100 )
        {
             loggerSlide.hidden=YES;
            loggerContain.hidden=YES;
            
            ScanDevice *sd=[[ScanDevice alloc]init];
            [self.navigationController pushViewController:sd animated:YES];
            
            unlock=NO;
        }
       if (![loggerSlide isTracking])
        {
            [UIView beginAnimations:@"cancel" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.35];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            loggerSlide.value=0.1;
            
            [UIView commitAnimations];
        }
    }
}


//****** Method to show the History information *****//

-(void)viewHistory
{
     if(!unlock)
    {
        if(histroySlide.value==0)
        {
            histroySlide.hidden=YES;
            historyContain.hidden=YES;
            
            HistroyView *hv=[[HistroyView alloc]init];
            [self.navigationController pushViewController:hv animated:YES];
            
            unlock=NO;
        }
        if ( ! [histroySlide isTracking])
        {
            histroySlide.hidden=NO;
            historyContain.hidden=NO;
            [UIView beginAnimations:@"Cancel" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.35];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            histroySlide.value=100;
            
            [UIView commitAnimations];
        }
    }
}

//***** Method to view the Application information page ******//

-(void)viewInfo:(id)sender
{
    [dbc readLog];
    InfoView *inv=[[InfoView alloc]init];
    [self.navigationController pushViewController:inv animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
        [super viewDidUnload];
}
    @end
