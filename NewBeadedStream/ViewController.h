//
//  ViewController.h
//  NewBeadedStream
//
//  Created by fsp on 6/14/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataBaseControl.h"
#import "InfoView.h"



#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ViewController : UIViewController
{
    UIImageView * splashView; //display spalash screen.
    
    NSTimer * Mytime;
    
    DataBaseControl *dbc;
    
    CGRect frame1;
    
    UIImageView *homeBackground;
    
    UIImageView *historyContain;
    UISlider *histroySlide;
    
    UIImageView *loggerContain;
    UISlider *loggerSlide;
    
    UIButton *infoButton;
    
 }

//****** Method for the interface object ******//

-(void)viewLogger;
-(void)viewHistory;

-(void)viewInfo:(id)sender;

@end
