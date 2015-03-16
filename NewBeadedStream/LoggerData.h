//
//  LoggerData.h
//  NewBeadedStream
//
//  Created by fsp on 6/18/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"
#import "ScanDevice.h"
#import "ViewData.h"
#import "LoggerDetail.h"
#import "DataBaseControl.h"
#import "DataSource_1.h"
#import "HistroyView.h"
#import "LoggerDetailOnHistory.h"
#import "LoggerDataOnHistory.h"
#import "DeviceConnector.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "DACircularProgressView.h"
#import "BinaryImplementation.h"
#import "Brsp.h"
#import "CRC16.h"

#import "InfoView.h"
#import "AppDelegate.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface LoggerData : UIViewController<UISearchBarDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate,DeviceConnectorDelegate,UIAlertViewDelegate>
{
    
//String Variable Declartion
    NSString *TitleString;
    NSString *getLogger,*getDate,*getTime,*getDes,*getDataPath,*stz;
    NSString *receivedPath,*filename,*date,*time,*filename1;
    NSString *documentDirectory,*databasePath,*last_accessinfo;
    
//Label object Declartion
    
    UILabel *titleLabel;
    
//Timer object Declartion
    
    NSTimer *timer1,*timer2,*timer3,*timer4,*progressTimer;

//Array object Declartion
    
    NSArray *paths,*pathArray;
    
    NSData *noteData;
    
//Animator object Declartion
    
//    MBProgressHUD *lAnimate;
    
    MBProgressHUD *hud;
    
//AlertView object Declartion
    
    UIAlertView *mailConfigAlert,*mailforwardAlert,*clearDataAlert,*clearDataAlert1,*mailInfoAlert,*viewMailAlert,*databaseop,*connetionFail,*noDa;
    
//sqlite database object Declartion
    
    sqlite3 *databaseHandle;
    
    DataBaseControl *dbc;
    
    IBOutlet UIImageView *dataSelect;
    
    IBOutlet UIImageView *spliter;
    
    CGRect frame1;
    
    UIImageView *backgroundImage;
    
    UIBarButtonItem * barButton1,*barButton;
    
    UIImage *buttonImage1,*buttonImage;
    
    DACircularProgressView *circleProgress;
    
    UIStepper *stepper;
    
    AppDelegate *theApp;
    
    MBProgressHUD *lAnimate;

}

@property (strong, nonatomic) DeviceConnector *connectDevice;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UITextField *searchField;

//****** Button in body of the screen ******//

@property (strong, nonatomic) IBOutlet UIButton *dataButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) NSString *devName;

//****** Button in Tabbar  ******//
@property (strong, nonatomic) UIButton *basic;
@property (strong, nonatomic) UIButton *emulator;

//****** Button in Navigation bar ******//
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *settings;

@property (strong, nonatomic) NSString *getLogger;
@property (strong, nonatomic) NSString *getDate;
@property (strong, nonatomic) NSString *getTime;
@property (strong, nonatomic) NSString *getDes;
@property (strong, nonatomic) NSString *getDataPath;

@property (strong, nonatomic) NSString *TitleString;
@property (strong, nonatomic) Brsp *brspObject;

@property (nonatomic, assign) BOOL isldHistory;
@property (nonatomic, assign) BOOL isLoggerInrange;
@property (nonatomic, assign) BOOL isldemhistory;
//@property (nonatomic, retain) MBProgressHUD *lAnimate;

//****** Navigation bar Methods *******//
-(IBAction)backProcess:(id)sender;
-(IBAction)infoView:(id)sender;

//****** Tabbar Methods ******//
-(IBAction)basicView:(id)sender;
-(IBAction)emulatorView:(id)sender;

//****** Application body Mehods *******//
-(IBAction)sendEmail1;
-(IBAction)viewDetailData;
-(IBAction)clearData;

-(void)composeSheet1;
-(void)checkNetwork;

-(void)cancelProcess;

-(void)Accessoption;
-(void)hideview;

-(void)showData;
-(void)showData:(int)starting NumberofRow:(int)rowNeed;

@end
