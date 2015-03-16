//
//  InfoView.h
//  AuroraLink
//
//  Created by fsp on 7/20/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <messageUI/MFMailComposeViewController.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface InfoView : UIViewController<MFMailComposeViewControllerDelegate>
{
    UIAlertView *mailInfoAlert,*mailConfigAlert;
    NSString *message,*path,*versionString;
    CFStringRef *vStr;
    UILabel *versionDate;
    
    CGRect frame1;
}
//******* Image View declartion for the Backgroud settings ********//
@property (strong, nonatomic) UIImageView *infoBackground;
@property (strong, nonatomic) UIImageView *infoImage;

//******* Navigation title settings ********//
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *backButton;

//******* hyperlink creation to send a mail and youtube link ******//
@property (strong, nonatomic) UIButton *contactButton;
@property (strong, nonatomic) UIButton *youtubeButton;
@property (strong, nonatomic) UIButton *phoneButton;

-(void)backProcess;

-(void)contactProcess;
-(void)composeSheet;

-(void)youtubeProcess;

@end
