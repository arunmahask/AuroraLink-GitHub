//
//  ScanDevice.h
//  NewBeadedStream
//
//  Created by fsp on 6/14/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "ViewData.h"
#import "LoggerData.h"
#import "LoggerDetail.h"
#import "HistroyView.h"
#import "Brsp.h"
#import "MBProgressHUD.h"
#import "DataBaseControl.h"
#import "DataSource_1.h"
#import "CustomIOS7AlertView.h"
#import "InfoView.h"
#import "EmulatorView.h"


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//***** Class used to scan the available logger with in the range *****//

@interface ScanDevice : UIViewController<UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate,DeviceConnectorDelegate,UIAlertViewDelegate,CustomIOS7AlertViewDelegate>
{
    
//TableView object Declaration
    UITableView *loggerview;
    
//Animator object declaration
    MBProgressHUD *lAnimate,*lAnimate1;

//Array Object declaration
    NSMutableArray *dataFromSensorSet;
    NSMutableArray *peripheralArray;
    
//String Object declaration
    NSString *content,*LoggerName,*time,*date;
    
//Timer object declaration
    NSTimer *timer1,*timer2,*dynamic_timer;

//AlertView object declaration
    UIAlertView *noDa, *alert16,*databaseop,*alert17;
    
    UIView *messageView,*backgroundImage;
    
    UILabel *l1,*l2,*l3,*l4,*l5;
    
    NSString *logforConnection;
    
    DataBaseControl *dbc;
    
    DeviceConnector *dvc;
    
    NSDate *currentdate,*date1;
    
    NSDateFormatter *dateFormatter,*dateFormat,*dateFormat1;
    
    IBOutlet UIImageView * loggerSelect;
    
    CGRect frame1;
    
    UIButton *cancelButton;
    
    UIBarButtonItem * barButton,*barButton1;
    
    CustomIOS7AlertView *custm;
    
    UIImage *buttonImage,*buttonImage1;
    
    UILabel *scan;
    
    NSArray *n1;
    

}

#define degreesToRadians(x) (M_PI * x / 180.0)

//****** Object delcaration for the class *****//
@property (strong, nonatomic)  NSString *LoggerName;
@property (strong, nonatomic)  NSString *date;
@property (strong, nonatomic)  NSString *time;

@property (strong, nonatomic)  UITableView *loggerview;
@property (strong, nonatomic) NSMutableArray *peripheralArray;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) CBPeripheral * displayPerip;

@property (strong, nonatomic) UIButton *settings;
@property (strong, nonatomic) UIButton *refresh;
@property (strong, nonatomic) UIButton *history;

@property (strong, nonatomic) DeviceConnector *connectDevice;

@property (nonatomic, assign) BOOL isNoData;
@property (nonatomic, assign) BOOL isData;

@property (nonatomic, assign) BOOL fromData;


-(void)infoView;
-(void)showData;

-(void)refreshTable;

-(void)startScan;
-(void)Accessoption;
-(void)hideview;

@end
