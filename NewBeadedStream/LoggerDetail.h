//
//  LoggerDetail.h
//  NewBeadedStream
//
//  Created by fsp on 6/21/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoggerData.h"
#import "LoggerSource.h"
#import "EmulatorView.h"
#import "MBProgressHUD.h"
#import "DataSource_1.h"
#import "Brsp.h"
#import "InfoView.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface LoggerDetail : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,BrspDelegate, CBCentralManagerDelegate,MBProgressHUDDelegate,DeviceConnectorDelegate,UIAlertViewDelegate>
{
    
//TextField, Label, AlertView object declartion
    UITextField *_inputText,*activeText;
    UILabel *titleLabel;
    UIAlertView *connetionFail,*alert1,*alert2;
    
//String Variable Declaration
    NSString *str1,*str2,*str3,*str4,*str5;
    NSString *commandwithdata,*procedure,*commandwithdata1,*commandwithdata2;
    NSMutableString *_outputText;//used as string data for textView to make string concatenations more efficient
    
//Array Declaration
    
    NSMutableArray *loggerInfo,*existLoggerInfo;
    NSMutableArray *_commandQueue;  //An array of commands queued for sending
    
    NSTimer *timer2;
    
//Brsp Object creation
    
    BrspMode _lastMode;
    BOOL gotStatus;
    
//NSTimer Object declaration
    MBProgressHUD *lAnimate;
    IBOutlet UIImageView *infoSelect;
    IBOutlet UIImageView *infoImage;
    CGRect frame1;
    
    UIImageView *backgroundImage;
    
    UIImage *buttonImage1,*buttonImage;
    
    UIBarButtonItem * barButton1,*barButton;
    
    UIButton *cancelButton;

    
}
@property (strong, nonatomic) Brsp *brspObject;
@property (strong, nonatomic) NSString *tempResStringFromDevice;
@property (strong, nonatomic) NSMutableString *responseStringFromDevice;
@property (strong, nonatomic) DeviceConnector *connectDevice;

//***** Naviation Bar Button *****//
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *settings;


//***** Tabbar Button ******//
@property (strong, nonatomic) UIButton *data;
@property (strong, nonatomic) UIButton *emulator;
@property (strong, nonatomic) NSString *title1;


//****** Body of the page ******//
@property (strong, nonatomic) IBOutlet UITextField *loggerName;
@property (strong, nonatomic) IBOutlet UITextField *gpscod;
@property (strong, nonatomic) IBOutlet UITextField *voltage;
@property (strong, nonatomic) IBOutlet UITextField *interval;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) IBOutlet UIButton *detail;
@property (strong, nonatomic) IBOutlet UIPickerView *intervalPicker;

@property (strong, nonatomic) NSArray *intervalData;
@property (strong, nonatomic) NSString *devName;
@property (strong, nonatomic) NSString *procedure;
@property (nonatomic, assign) BOOL isldeHistory;
@property (nonatomic, assign) BOOL isldeLoggerInRange;
@property (nonatomic, assign) BOOL isData;
@property (nonatomic, assign) BOOL isldemhistory;

//****** Navigation Method *******//
-(void)infoView;
-(void)backProcess;


//****** Tabbar Method *******//
-(void)dataView;
-(void)emulatoreView;


//****** Body Method *******//
-(IBAction)saveProcess;
-(IBAction)detail:(id)sender;

-(void)hideview;
-(void)Accessoption;

@end
