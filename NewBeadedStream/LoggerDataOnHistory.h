//
//  LoggerDataOnHistory.h
//  AuroraLink
//
//  Created by fsp on 7/29/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "LoggerDetailOnHistory.h"
#import "Reachability.h"
#import "InfoView.h"


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface LoggerDataOnHistory : UIViewController<MFMailComposeViewControllerDelegate>
{
    
//String Variable declaration
    NSString *getLogger,*getDate,*getTime,*getDes,*getDataPath,*stz,*TitleString;
    
    UILabel *titleLabel;
    
//AlertView class object Declaration
    
    UIAlertView *mailConfigAlert,*mailforwardAlert,*clearDataAlert,*mailInfoAlert,*viewMailAlert,*alert1,*alert2;
    
    NSData *noteData;
    NSArray *pathArray;
    NSString *filename;
    
    IBOutlet UIImageView *dataSelect;
    
    IBOutlet UIImageView *spliter;
    
    CGRect frame1;
    
    UIImageView *backgroundImage;
    
    UIImage *buttonImage1,*buttonImage;
    
    UIBarButtonItem * barButton1,*barButton;
    
}
//****** Button in body of the screen ******//
@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@property (strong, nonatomic) IBOutlet UIButton *dataButton;
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
@property (strong, nonatomic) NSMutableArray *existLoggerinfo;


@property (nonatomic, assign) BOOL isldHistory;
@property (nonatomic, assign) BOOL isLoggerInrange;
@property (nonatomic, assign) BOOL isldemhistory;
@property (nonatomic, assign) BOOL fromData;


//****** Navigation bar Methods *******//
-(void)backProcess;
-(void)infoView;

//****** Tabbar Methods ******//
-(void)basicView;

//****** Application body Mehods *******//
-(IBAction)sendEmail;
-(IBAction)viewDetailData;
-(void)composeSheet;

@end
