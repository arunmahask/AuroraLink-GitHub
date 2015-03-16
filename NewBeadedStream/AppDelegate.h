//
//  AppDelegate.h
//  NewBeadedStream
//
//  Created by fsp on 6/14/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MBProgressHUD.h"
//
//#import "GAI.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) NSMutableArray *anlastArr;
@property (strong, nonatomic) MBProgressHUD *lAnimate;
@property (nonatomic, readwrite) int totalRowCount;
@property (nonatomic, readwrite) int refRowCount;

//***** CBCentralManager - used for Core Bluetooth operation ******//
@property (strong, nonatomic) CBCentralManager *cManager;

//***** CBPeripheral - used to create a object for the device ******//
@property (strong, nonatomic) CBPeripheral *activePeripheral;

//@property (strong, nonatomic)id<GAITracker> tracker;


+(AppDelegate *)app;

@end
