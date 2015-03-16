//
//  EmulatorView.h
//  NewBeadedStream
//
//  Created by fsp on 6/22/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoggerData.h"
#import "LoggerDetail.h"
#import "DeviceConnector.h"
#import "MBProgressHUD.h"
#import "InfoView.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface EmulatorView : UIViewController<UITextViewDelegate,UITextFieldDelegate,DeviceConnectorDelegate,MBProgressHUDDelegate>
{
//TextField to declaration to display the terminal window
    
    UITextView *commandPromptView;
    UITextField *hiddenFieldForCommand;
    
//Loading animator declaration
    
    MBProgressHUD *lAnimate;
    
//Context Graphich window rectangle object declaration
    
    CGRect promptFrame;
    
//Label Creation
    
    UILabel *titleLabel;
    
    IBOutlet UIImageView *emulatorSelect;
    
    CGRect frame1,frame2;
    
    UIImageView *backgroundImage;
    
    UIImage *buttonImage,*buttonImage1;
    
    UIBarButtonItem * barButton,* barButton1;
}
//******* Variable declaration ********//
@property (strong, nonatomic) DeviceConnector *connectDevice;
@property (strong, nonatomic) NSString *devName;

//******* Naviagation bar control decalartion *******//
@property (strong, nonatomic) UIButton *settings;
@property (strong, nonatomic) UIButton *backButton;

//******* Tabbar control decalaration *********//
@property (strong, nonatomic) UIButton *basic;
@property (strong, nonatomic) UIButton *data;

//******* Method declartion for Navigation ********//
-(IBAction)backProcess:(id)sender;
-(IBAction)infoView:(id)sender;

//******* Method declartion for Tabbar ********//
-(IBAction)basicView:(id)sender;
-(IBAction)dataView:(id)sender;

@end
