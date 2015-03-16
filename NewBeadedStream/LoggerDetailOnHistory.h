//
//  LoggerDetailOnHistory.h
//  AuroraLink
//
//  Created by fsp on 7/29/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoggerData.h"
#import "DataBaseControl.h"
#import "InfoView.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface LoggerDetailOnHistory : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    
//Label & AlertView object Declaration
    UILabel *titleLabel;
    UIAlertView *alert1;
    NSString *description,*date,*time,*path;
    
    IBOutlet  UIImageView *infoSelect;
    IBOutlet UIImageView *infoImage;
    
    CGRect frame1;
    
    UIImageView *backgroundImage;
    
    UIBarButtonItem * barButton1,*barButton;
    
    UIImage *buttonImage1,*buttonImage;
}

//***** Object creation to show the logger detail page ******//

@property (strong,nonatomic) NSString *title1,*description,*date,*time,*path;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *settings;
@property (strong, nonatomic) UIButton *data;
@property (strong, nonatomic) UIButton *emulator;

@property (strong, nonatomic) IBOutlet UITextField *loggerName;
@property (strong, nonatomic) IBOutlet UITextField *gpscod;
@property (strong, nonatomic) IBOutlet UITextField *voltage;
@property (strong, nonatomic) IBOutlet UITextField *interval;

@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) NSMutableArray *loggerInfo;

//****** Method intializaiton ******//

-(void)infoView;
-(void)backProcess;

-(void)dataView;

@end
