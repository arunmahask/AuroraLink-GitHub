//
//  HistroyView.h
//  NewBeadedStream
//
//  Created by fsp on 6/18/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ScanDevice.h"
#import "HistoryCell.h"
#import "DataBaseControl.h"
#import "LoggerDataOnHistory.h"
#import "InfoView.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface HistroyView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

//Array & String variable declaration
    NSMutableArray *historyInfo;
    NSString *hisLoggerName;
    NSMutableArray *reversed;
    
     IBOutlet UIImageView * historySelect;
    
    UIImageView *backgroundImage;
    
    CGRect frame1;
    
    UIBarButtonItem * barButton;
    
    UIImage *buttonImage;
    
    NSArray *array;
    
    DataBaseControl *dbc;
}

//***** Table to dipslay the History of Logger ******//
@property (strong, nonatomic) UITableView *histroyoflogger;

//***** Navigation controls declaration *******//
@property (strong, nonatomic) UIButton *settings;
@property (strong, nonatomic) UIButton *loggerinrange;

-(IBAction)infoView:(id)sender;
-(IBAction)backToLogger:(id)sender;


@end
