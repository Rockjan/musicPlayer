//
//  AppDelegate.h
//  musicPlayerDemo
//
//  Created by zy_PC on 14-5-21.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDMenuController;
@class rootViewController;
@class leftViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DDMenuController *ddMenu;
    rootViewController *rootVC;
    leftViewController *leftView;
}

@property (strong, nonatomic) UIWindow *window;

@end
