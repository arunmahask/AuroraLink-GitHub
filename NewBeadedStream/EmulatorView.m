//
//  EmulatorView.m
//  NewBeadedStream
//
//  Created by fsp on 6/22/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "EmulatorView.h"
#import "ScanDevice.h"
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface EmulatorView ()
{
    int count;
}
@end

@implementation EmulatorView

@synthesize backButton=_backButton;
@synthesize settings=_settings;
@synthesize data=_data;
@synthesize basic=_basic;

@synthesize devName=_devName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

//***** Method used to load the command terminal and hiddenfield *****//

-(void)loadView{
    
    [super loadView];
    
    hiddenFieldForCommand = [[UITextField alloc] init];
    hiddenFieldForCommand.text = @"";
//    hiddenFieldForCommand.background = [UIColor redColor];
    hiddenFieldForCommand.hidden = YES;
    hiddenFieldForCommand.delegate = self;
    hiddenFieldForCommand.spellCheckingType = UITextSpellCheckingTypeNo;
    hiddenFieldForCommand.autocorrectionType = UITextAutocorrectionTypeNo;
    hiddenFieldForCommand.autocapitalizationType = UITextAutocapitalizationTypeNone;
    hiddenFieldForCommand.returnKeyType = UIReturnKeySend;
    
    [self.view addSubview:hiddenFieldForCommand];
    
    frame2=[[UIScreen mainScreen]bounds];
    
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
        if(frame2.size.height==568)
        {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                promptFrame = CGRectMake(5, 14, 310, self.view.frame.size.height - 150);
            }
            else
            {
                promptFrame = CGRectMake(5, 10, 310, self.view.frame.size.height - 130);
            }
        }
        else if(frame2.size.height==480)
        {
            promptFrame = CGRectMake(5, 10, 310, self.view.frame.size.height - 205);
        }
    }
    else
    {
        promptFrame = CGRectMake(20,90, 733,800);
    }
    
//    commandPromptView = [[UITextView alloc] initWithFrame:promptFrame];
    
     // ios7 bug fix
     // check if the device is running iOS 7.0 or later
     
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
         NSTextStorage* textStorage = [[NSTextStorage alloc] init];
         NSLayoutManager* layoutManager = [NSLayoutManager new];
         [textStorage addLayoutManager:layoutManager];
         NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.view.bounds.size];
         [layoutManager addTextContainer:textContainer];
         commandPromptView = [[UITextView alloc] initWithFrame:promptFrame
         textContainer:textContainer];
     }
     else{
         commandPromptView = [[UITextView alloc] initWithFrame:promptFrame];
     }
    
    commandPromptView.text = @"Type command \r >";
    commandPromptView.scrollEnabled = YES;
    commandPromptView.backgroundColor = [UIColor blackColor];
    commandPromptView.textColor = [UIColor whiteColor];
    commandPromptView.delegate = self;
    
    [self.view addSubview:commandPromptView];
    
}

//****** Design to show the emulator page ******//

- (void)viewDidLoad{
    
    [super viewDidLoad];
    frame1=[[UIScreen mainScreen]bounds];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Navtitle" ];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settings = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //******** Tabbar control setting ********//
    
    _data=[UIButton buttonWithType:UIButtonTypeCustom];
    //_data.backgroundColor=[UIColor whiteColor];
    
    _basic=[UIButton buttonWithType:UIButtonTypeCustom];
   // _basic.backgroundColor=[UIColor whiteColor];
    
    if(self.connectDevice == nil)
    {
        self.connectDevice = [[DeviceConnector alloc] init];
        self.connectDevice.typeCommand = YES;
        self.connectDevice.delegate = self;
    }
    [self.connectDevice connectactivePeripheral];
    
    // Do any additional setup after loading the view from its nib.
    //Show the loading animation util the connection opened
    
    lAnimate = [[MBProgressHUD alloc] initWithFrame:self.view.frame];
    lAnimate.labelText = @"Opening connection...";
    [lAnimate setMode:MBProgressHUDAnimationFade];
    [lAnimate removeFromSuperViewOnHide];
    [lAnimate show:YES];
    [lAnimate setOpacity:0.4];
    [self.view addSubview:lAnimate];
    
    emulatorSelect = [[UIImageView alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
        buttonImage=[UIImage imageNamed:@"info.png"];
        [_settings setBackgroundImage:buttonImage forState:UIControlStateNormal];
        _settings.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 30, 30);
        [_settings addTarget:self action:@selector(infoView:) forControlEvents:UIControlEventTouchUpInside];
        barButton = [[UIBarButtonItem alloc] initWithCustomView:_settings];
        
        buttonImage1=[UIImage imageNamed:@"LoggersBtn.png"];
        [_backButton setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(0, 0, (buttonImage1.size.width / buttonImage1.size.height) * 30, 30);
        [_backButton addTarget:self action:@selector(backProcess:) forControlEvents:UIControlEventTouchUpInside];
        barButton1 = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
        titleLabel.frame=CGRectMake(100.0, 0.0, 200.0, 40.0);
        [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
        
        emulatorSelect.image  =[UIImage imageNamed:@"emulatorSelect.png"] ;
        
        if([[UIScreen mainScreen] bounds].size.height == 568)
        {
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                emulatorSelect.frame = CGRectMake(0, frame1.size.height-128, frame1.size.width, 64);
                
                _data.frame=CGRectMake(frame1.size.width - 214,frame1.size.height-120 ,frame1.size.width - 214.0,60.0);
                _basic.frame=CGRectMake(0.0,frame1.size.height-120,frame1.size.width - 214.0,60.0);
                
                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                {
                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"solidNavBar.png"] forBarMetrics:UIBarMetricsDefault];
                    self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0, 320.0, 64.0);
                }
            }
            else
            {
                emulatorSelect.frame = CGRectMake(0, 440, 320, 64);
                
                _data.frame=CGRectMake(frame1.size.width - 214,frame1.size.height - 120,frame1.size.width - 214.0,63.0);
                _basic.frame=CGRectMake(0.0,frame1.size.height - 120,frame1.size.width - 214.0,63.0);
                
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
                emulatorSelect.frame = CGRectMake(0, frame1.size.height-128, frame1.size.width ,64);
                
                _data.frame=CGRectMake(110, frame1.size.height-128, 106, 60);
                _basic.frame=CGRectMake(2, frame1.size.height-128, 105, 60);
                
                commandPromptView.frame=CGRectMake(10,10, 300, frame1.size.height-135);
                
                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                {
                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"solidNavBar.png"] forBarMetrics:UIBarMetricsDefault];
                }
            }
            else
            {
                emulatorSelect.frame = CGRectMake(0, frame1.size.height-64, frame1.size.width, 64);
                
                _data.frame=CGRectMake(115, frame1.size.height-64, 100, 64);
                _basic.frame=CGRectMake(2, frame1.size.height-64, 105, 63);
                
                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                {
                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"LoggerTitleBG.png"] forBarMetrics:UIBarMetricsDefault];
                }
            }
        }
    }
    
    //****** iPad Deign******//
    else
    {
        [commandPromptView setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:20.0]];
        
        buttonImage=[UIImage imageNamed:@"info~ipad.png"];
        [_settings setBackgroundImage:buttonImage forState:UIControlStateNormal];
        _settings.frame = CGRectMake(0, 0,38,38);
        [_settings addTarget:self action:@selector(infoView:) forControlEvents:UIControlEventTouchUpInside];
        barButton = [[UIBarButtonItem alloc] initWithCustomView:_settings];
        
        buttonImage1=[UIImage imageNamed:@"LoggersBtn~ipad.png"];
        [_backButton setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
        _backButton.frame =CGRectMake(0, 0, (buttonImage1.size.width / buttonImage1.size.height) * 46, 46);
        [_backButton addTarget:self action:@selector(backProcess:) forControlEvents:UIControlEventTouchUpInside];
        barButton1 = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background~ipad.png"]];
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            emulatorSelect.image  =[UIImage imageNamed:@"emulatorSelect~ipad.png"] ;
            
            titleLabel.frame=CGRectMake(150.0, 0.0, 300.0, 40.0);
            [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
            
            emulatorSelect.frame = CGRectMake(0,frame1.size.height-107, frame1.size.width, 107);
            
            _basic.frame=CGRectMake(2, frame1.size.height-95, 253, 107);
            _data.frame=CGRectMake(267, frame1.size.height-95, 240, 100);
            
            if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar~ipad.png"] forBarMetrics:UIBarMetricsDefault];
            }
        }
    }
    
    self.navigationItem.titleView=titleLabel;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton=YES;
    
    self.navigationItem.rightBarButtonItem=barButton;
    self.navigationItem.leftBarButtonItem=barButton1;
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [self.view addSubview:emulatorSelect];
    
    [_data addTarget:self action:@selector(dataView:) forControlEvents:UIControlEventTouchUpInside];
    [_basic addTarget:self action:@selector(basicView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_data];
    [self.view addSubview:_basic];
}

#pragma mark - used to connect and send the command and retrive the result from the device

-(void)deviceAlreadyConnected{
    if(lAnimate != nil)
        [lAnimate hide:YES];
}

-(void)deviceConnected{
    if(lAnimate != nil)
        [lAnimate hide:YES];
}

#pragma mark - Add input and output value to the TextView

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"content content content content content content content %@",textField.text);
}

- (CGFloat)textViewHeight:(UITextView *)textView
{
    return ceilf([textView.layoutManager usedRectForTextContainer:textView.textContainer].size.height +textView.textContainerInset.top +textView.textContainerInset.bottom);
}

- (CGSize)text:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        CGRect frame = [text boundingRectWithSize:size
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        return frame.size;
    }
    else
    {
        return [text sizeWithFont:font constrainedToSize:size];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length != 0)
    {
        commandPromptView.text = [commandPromptView.text stringByAppendingString:string];
        float testH = [self  text:commandPromptView.text sizeWithFont:commandPromptView.font constrainedToSize:CGSizeMake(310, MAXFLOAT)].height;
        NSLog(@"commandPromptView.contentSize.height %f -- %f",commandPromptView.contentSize.height,testH);
        [commandPromptView scrollRectToVisible:CGRectMake(0, testH+200, commandPromptView.frame.size.width,2) animated:NO];
    }
    else
    {
        if(textField.text.length && commandPromptView.text.length > 1)
        {
            NSMutableString *temp = [commandPromptView.text mutableCopy];
            temp = [[temp substringToIndex:[temp length] - 1] mutableCopy];
            commandPromptView.text = temp;
        }
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"shouldChangeTextInRange");
    return YES;
}

//***** method used to send the command to the logger device and execute the command *****//

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    commandPromptView.frame = promptFrame;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    if(textField.text.length == 0){
        commandPromptView.frame = promptFrame;
        return YES;
    }
    
    [commandPromptView resignFirstResponder];
    
    if(self.connectDevice == nil){
        self.connectDevice = [[DeviceConnector alloc] init];
        self.connectDevice.typeCommand = YES;
        self.connectDevice.delegate = self;
    }
    commandPromptView.editable = YES;
    [self.connectDevice sendCommand:textField.text];
    count = 0;
    commandPromptView.text = [commandPromptView.text stringByAppendingString:@"\n"];
    hiddenFieldForCommand.text = @"";
    commandPromptView.frame = promptFrame;
    
    return YES;
}

//***** Method used to set the size of the textView *****//

-(float)getStringWidth:(NSString*)txt withWidth:(float)sizeValue{
    //to get height
    CGSize maximumSize = CGSizeMake(sizeValue,1000);
    CGSize myStringSize = [txt sizeWithFont:commandPromptView.font constrainedToSize:maximumSize lineBreakMode:UILineBreakModeWordWrap];
    
    return myStringSize.height;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    [hiddenFieldForCommand becomeFirstResponder];
    textView.selectedRange = NSMakeRange([textView.text length], 0);
    //[textView setContentOffset:CGPointMake(0, CGRectGetHeight(textView.frame)) animated:YES];
    
    NSLog(@"textViewShouldBeginEditing %f",[self getStringWidth:commandPromptView.text withWidth:310]);
    
    if([self getStringWidth:commandPromptView.text withWidth:310] >= 125)
    {
        //temp = -125;
        commandPromptView.frame = CGRectMake(promptFrame.origin.x, -135, promptFrame.size.width, promptFrame.size.height);
    }
    return NO;
}

-(void)requestStarted
{
    
}

-(void)requestCompleted:(Brsp *)brspObject result:(NSString *)str{
    commandPromptView.editable = YES;
}

//****** Method used to receive the data from the Device connector page ******//

-(void)receivingData:(Brsp *)brspObject result:(NSString *)DataStr
{
    
    if(DataStr)
    {
        commandPromptView.text = [commandPromptView.text stringByAppendingString:DataStr];
        count++;
    }
    
    if([DataStr rangeOfString:@">"].location != NSNotFound || count %5 == 0)
    {
//        NSLog(@"invoke method %d",count);
        [commandPromptView scrollRangeToVisible:NSMakeRange([commandPromptView.text length], 0)];
    }
}

//-(void)eachRow
//{
////    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////        
////        dispatch_async(dispatch_get_main_queue(), ^{
//            [commandPromptView scrollRangeToVisible:NSMakeRange([commandPromptView.text length], 0)];
//        });
//    });
//}

-(void)showAgain
{
    [commandPromptView flashScrollIndicators];
}

//**** method used to switch to other page (logger detail, logger data, setting and back to the previous page ****//

-(IBAction)basicView:(id)sender{
    LoggerDetail *lde=[[LoggerDetail alloc]init];
    lde.procedure=@"live";
    [self.navigationController pushViewController:lde animated:NO];
}

-(IBAction)dataView:(id)sender{
    LoggerData *ld=[[LoggerData alloc]init];
    ld.getLogger=titleLabel.text;
    ld.isLoggerInrange=YES;
    [self.navigationController pushViewController:ld animated:NO];
}

-(IBAction)infoView:(id)sender{
    InfoView *iv=[[InfoView alloc]init];
    [self.navigationController pushViewController:iv animated:YES];
}

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

-(void)requestCompleted2:(NSString *)rowNumber
{
    
}

-(void)requestCompleted1:(NSMutableString*)output NumbeofRow:(NSString *)numberOfRow
{
    
}

-(void)createFile:(NSMutableString *)receivedData
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
