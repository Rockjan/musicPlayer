//
//  rootViewController.h
//  musicPlayerDemo
//
//  Created by zy_PC on 14-5-21.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "leftViewController.h"
#import "customCell.h"

@class footer;

@interface rootViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,leftViewControllerDelegate,customCellDelegate>
{
    
    NSMutableArray *playerList; //所有曲目
    
    BOOL isStoreList;           //是否设定为收藏夹
    int storeCounts;            //收藏夹包含歌曲个数
    
    UITableView *musicList;             //显示歌曲列表
    NSMutableDictionary *favorMusic;    //映射表，保存收藏的歌曲

}
@property (nonatomic,assign) footer *playPanel;          //控制面板
- (void)saveSettings;
@end
