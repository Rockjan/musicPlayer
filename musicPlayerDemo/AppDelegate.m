//
//  AppDelegate.m
//  musicPlayerDemo
//
//  Created by zy_PC on 14-5-21.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import "AppDelegate.h"
#import "rootViewController.h"
#import "leftViewController.h"
#import "DDMenuController.h"
#import "footer.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [rootVC release];
    [ddMenu release];
    [leftView release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    
    imageView.image = [[UIImage imageNamed:@"background"] autorelease];
    
    [self.window addSubview:imageView];
    [imageView release];
    
    rootVC = [[rootViewController alloc] init];
    
    ddMenu = [[DDMenuController alloc] initWithRootViewController:rootVC];
    
    leftView = [[leftViewController alloc] init];
    
    leftView.delegate = rootVC;
    
    ddMenu.rightViewController = nil;
    ddMenu.leftViewController = leftView;
    
    self.window.rootViewController = ddMenu;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMain) name:@"showMain" object:nil];
    
    [ddMenu release];
    
    return YES;
}

- (void)showMain
{
    [ddMenu showRootController:YES];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [rootVC.playPanel stopWhenbackground];
    [rootVC saveSettings];
}


@end
