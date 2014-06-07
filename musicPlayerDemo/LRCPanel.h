//
//  playWind.h
//  musicPlayerDemo
//
//  Created by zy_PC on 14-5-22.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "footer.h"


@interface LRCPanel : UIViewController<UITableViewDataSource,UITableViewDelegate,footerDelegate>
{
    UIButton *btn;          //goback 按钮
    UISlider *process;      //时间进度条
    
    UITableView *lrcTable;  
    NSMutableDictionary *lrcDict;
    NSMutableArray *timeArray;
    
    int lrcLineNumber;
}
@property (nonatomic,retain) NSString *curPlayName;
@end
