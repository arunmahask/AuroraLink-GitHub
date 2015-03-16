//
//  ViewData.h
//  NewBeadedStream
//
//  Created by fsp on 6/20/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataCell.h"
#import "DeviceConnector.h"
#import "DataBaseControl.h"
#import "DataSource_1.h"
#import "MBProgressHUD.h"
#import "Brsp.h"
#import "CRC16.h"

#import "AppDelegate.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ViewData : UIViewController<UITableViewDataSource,UITableViewDelegate,DeviceConnectorDelegate,CBCentralManagerDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
//Array Object declaration
    NSArray *dataFromSensor;
    NSMutableArray *dataFromSensorSet;

//Animator object declaration
//    MBProgressHUD *lAnimate;
    
    MBProgressHUD *hud;
    
    DeviceConnector *connectDevice;
    UIButton *sesData;
    
//String object declaration
    NSString *filePath,*DateFromHistory,*LLLoggerNameFromHistory;
    
//Timer object declaration
    NSTimer *timer1,*timer3;
    
//AlertView object declaration
    UIAlertView *alert,*databaseop,*noDa;
    
    UIImage *buttonImage;
    
    UIBarButtonItem *barButton;
    
    NSDate *date;
    
    DataSource_1 *ds1,*ds11;
    
    DataBaseControl *dbc;
    
    UIButton *cancelButton;
    
    AppDelegate *theApp;
    
}
//****** Object creation for the view logger senson page *****//

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UITableView *dataView;
@property (strong, nonatomic) UILabel *loggerName;
@property (strong, nonatomic) UILabel *completed;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *rowBackImage;
@property (strong, nonatomic) DeviceConnector *connectDevice;

@property (strong, nonatomic) NSString *devName;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *DateFromHistory;
@property (strong, nonatomic) NSString *LLLoggerNameFromHistroy;

@property (nonatomic, assign) BOOL isVHistory;
@property (nonatomic,retain)Brsp *brspObject;

//****** Mehtod creation to show the data abd back process ******//

-(void)backToLogger:(id)sender;
-(void)showData;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@end
