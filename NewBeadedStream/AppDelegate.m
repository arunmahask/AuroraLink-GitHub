//
//  AppDelegate.m
//  NewBeadedStream
//
//  Created by fsp on 6/14/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


static NSString *const tracking_Id=@"UA-46654518-1";
static NSString *const allow_tracking=@"Allow Tracking";


@implementation AppDelegate

@synthesize cManager;
@synthesize activePeripheral;

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [GAI sharedInstance].optOut=![[NSUserDefaults standardUserDefaults] boolForKey:allow_tracking];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSDictionary *appDefaults=@{allow_tracking:@(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    self.anlastArr = [[NSMutableArray alloc] init];
    
    /*[GAI sharedInstance].optOut=![[NSUserDefaults standardUserDefaults]boolForKey:allow_tracking];
    [GAI sharedInstance].dispatchInterval=120;
    [GAI sharedInstance].trackUncaughtExceptions=YES;
    self.tracker=[[GAI sharedInstance]trackerWithName:@"AuroraLink" trackingId:tracking_Id];*/
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController=[[ViewController alloc]init];

    self.nav=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:22.0]}];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Create a object for the AppDelegate to use the CBCentralManager, CBPeripheral through out the application

+(AppDelegate * )app
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
