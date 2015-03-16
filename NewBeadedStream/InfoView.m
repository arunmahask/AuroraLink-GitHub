//
//  InfoView.m
//  AuroraLink
//
//  Created by fsp on 7/20/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "InfoView.h"

@interface InfoView ()

@end

@implementation InfoView

@synthesize infoBackground,infoImage,backButton,contactButton,youtubeButton,titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

//***** Method used to design the page *****//

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor= [UIColor whiteColor];
    frame1=[[UIScreen mainScreen]bounds];
    
    //****** Naviagation Bar ******//
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.text=@"APP INFO";
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton=YES;
    
    infoBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame1.size.width, frame1.size.height)];
    
    infoImage=[[UIImageView alloc]init];
    
    
    //************ Body Content *************//
    
    contactButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [contactButton addTarget:self action:@selector(contactProcess) forControlEvents:UIControlEventTouchUpInside];
    
    youtubeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [youtubeButton addTarget:self action:@selector(youtubeProcess) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    _phoneButton.backgroundColor=[UIColor redColor];
    [_phoneButton addTarget:self action:@selector(phoneProcess) forControlEvents:UIControlEventTouchUpInside];
    
    versionDate=[[UILabel alloc]init];
    
    versionString=[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [versionDate setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:13.0]];
    versionDate.backgroundColor=[UIColor clearColor];
    versionDate.textColor=[UIColor whiteColor];
//    versionDate.text = @"App Version 2.1";
//    versionDate.textAlignment = NSTextAlignmentCenter;
    versionDate.text=[NSString stringWithFormat:@"App Version %@",versionString];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
        
        UIImage *buttonImage=[UIImage imageNamed:@"SettingsBack.png"];
        [backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 30, 30);
        
        [versionDate setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:15.0]];
        [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:22.0]];
        
        infoImage.image=[UIImage imageNamed:@"infoImg.png"];
        titleLabel.frame=CGRectMake(117.0, 8.0, 100.0, 40.0);
        
        if([[UIScreen mainScreen] bounds].size.height == 568)
        {
            infoBackground.image=[UIImage imageNamed:@"infobg-568h@2x.png"];
            
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                {
                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"emptyNav7.png"] forBarMetrics:UIBarMetricsDefault];
                    self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0, 320.0, 65.0);
                }
                
                infoImage.frame=CGRectMake(30.0, 110.0, 252, 272);
                versionDate.frame=CGRectMake(108, 270, 270, 30);
//                versionDate.frame=CGRectMake(50, 270, 270, 30);
                contactButton.frame=CGRectMake(30, 310, 255, 30);
                
                _phoneButton.frame=CGRectMake(85, 360, 140, 40);
            
            }
            else
            {
                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                {
                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                }
                
                infoImage.frame=CGRectMake(35.0, 55.0, 252, 272);
                versionDate.frame=CGRectMake(108, 220, 270, 30);
//                versionDate.frame=CGRectMake(50, 220, 270, 30);
                contactButton.frame=CGRectMake(30, 250, 259, 30);
    
                _phoneButton.frame=CGRectMake(85, 310, 140, 40);
            }
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            infoBackground.image=[UIImage imageNamed:@"infobg.png"];
            
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                {
                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"emptyNav7.png"] forBarMetrics:UIBarMetricsDefault];
                    self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0, 320.0, 65.0);
                }
                
                infoImage.frame=CGRectMake(30.0, 110.0, 252, 272);
                versionDate.frame=CGRectMake(108, 270, 270, 30);
//                versionDate.frame=CGRectMake(50, 220, 270, 30);
                contactButton.frame=CGRectMake(30, 310, 255, 30);
                
                _phoneButton.frame=CGRectMake(85, 360, 140, 40);
            }
            else
            {
                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                {
                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                }
                
                infoImage.frame=CGRectMake(30.0, 50.0, 252, 272);
                versionDate.frame=CGRectMake(108, 270, 270, 30);
//                versionDate.frame=CGRectMake(50, 220, 270, 30);
                contactButton.frame=CGRectMake(30, 260, 259, 30);
                
                _phoneButton.frame=CGRectMake(85, 320, 140, 40);
        }
        }
    }
    
    //******* iPad Design *******//
    
    else
    {
        titleLabel.frame=CGRectMake(250.0, 8.0, 100.0, 40.0);
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            
            UIImage *buttonImage=[UIImage imageNamed:@"SettingsBack~ipad.png"];
            [backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
            backButton.frame = CGRectMake(0, -5, (buttonImage.size.width / buttonImage.size.height) * 40, 40);
            
            infoBackground.image=[UIImage imageNamed:@"infoBg~ipad"];
            infoImage.image=[UIImage imageNamed:@"infoImg~ipad.png"];
            titleLabel.frame=CGRectMake(117.0, 8.0, 100.0, 40.0);
            
            [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
            [versionDate setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
            
            if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar~ipad.png"] forBarMetrics:UIBarMetricsDefault];
                self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0,self.view.frame.size.width, 78.0);
            }
            
            infoImage.frame=CGRectMake(130.0, 200.0, 504, 522);
            versionDate.frame=CGRectMake(300, 550, 270, 30);
//            versionDate.frame=CGRectMake(200, 550, 550, 30);
            contactButton.frame=CGRectMake(125, 630, 515, 30);
            
            _phoneButton.frame=CGRectMake(250, 690, 300, 40);
        }
    }
    
    [backButton addTarget:self action:@selector(backProcess) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=barButton;
    
    self.navigationItem.titleView=titleLabel;
    [self.view addSubview:infoBackground];
    [self.view addSubview:infoImage];
    [self.view addSubview:contactButton];
    [self.view addSubview:_phoneButton];
    [self.view addSubview:versionDate];
    
}

#pragma  mark - Methods of Navigation 

-(void)backProcess
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Method of contant mail composer and youtube link

-(void)contactProcess
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self composeSheet];
        }
        else
        {
            mailConfigAlert=[[UIAlertView alloc]initWithTitle:@"Setting Alert" message:@"You have no mail account.please set via your settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            mailConfigAlert.tag=11;
            [mailConfigAlert show];
        }
    }
}

//*********** to display the mail composer Screen *******//

-(void)composeSheet
{
    
    NSLog(@"12345");

    NSArray *recList=[[NSArray alloc]initWithObjects:@"contact@beadedstream.com", nil];
    MFMailComposeViewController *mcomposer=[[MFMailComposeViewController alloc]init];
    mcomposer.mailComposeDelegate=self;
    [mcomposer setToRecipients:recList];
    [self presentViewController:mcomposer animated:YES completion:nil];
}

//*********** Result about the mail compossing process*********//

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // show alert to users about errors associated with the interface
    
    switch (result){
        case MFMailComposeResultCancelled:
            message=@"Cancelled";
            break;
            
        case MFMailComposeResultSaved:
            message=@"Saved";
            break;
            
        case MFMailComposeResultSent:
            message=@"Sent";
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

//********Code to redirect from the Auroralink app to You tube link via safari******//

-(void)youtubeProcess{
    NSString *URLString=@"http://www.youtube.com";
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URLString]];
}

-(void)phoneProcess
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://1-907-227-9769"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://1-907-227-9769"]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
