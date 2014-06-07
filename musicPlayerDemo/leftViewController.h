//
//  leftViewController.h
//  musicPlayerDemo
//
//  Created by zy_PC on 14-6-3.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol leftViewControllerDelegate <NSObject>

@optional
- (void) updatePlayList:(int)playIndx;

@end

@interface leftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *list;
    NSArray *dataSource;
}
@property (nonatomic,assign) id<leftViewControllerDelegate> delegate;

@end
