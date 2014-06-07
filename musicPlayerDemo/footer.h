//
//  footer.h
//  musicPlayerDemo
//
//  Created by zy_PC on 14-5-22.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JingRoundView.h"

@class musicItem;
@class LRCPanel;

@protocol footerDelegate <NSObject>

@optional
- (void) changeTimeSliderValue:(int)value;
- (void) setTimeSliderMaxValue:(int)value;
- (void) displaySondWord:(NSUInteger)time;

- (void) setTimeSliderMaxValue:(int)value andSongName:(NSString *)name;

@end

@interface footer : UIView <JingRoundViewDelegate,AVAudioPlayerDelegate>
{

    NSTimer *myTimer;       //全局计时器
    
    int curPlayLocation;    //当前播放索引
    BOOL isStore;       //是否为收藏夹歌曲
    int totalCounts;    //待播放曲目总数
    int subIndex;       //收藏夹索引
    BOOL isLRCOpen;     //表示lrc面板是否打开
    
    AVAudioPlayer *audioPlayer; //播放器
    NSMutableArray *playerList; //所有曲目列表
    NSMutableArray *favorList;  //收藏夹
    
}

@property (nonatomic,assign) id <footerDelegate> delegate;

//控制按钮以及显示label

@property (nonatomic,assign) UIButton *pre;
@property (nonatomic,assign) UIButton *next;
@property (nonatomic,assign) UIButton *play;
@property (nonatomic,assign) UIButton *loopStyle;
@property (nonatomic,assign) JingRoundView *DVDImg;
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,copy) NSString *musicNameWillPlay;
@property (nonatomic,assign) UILabel *showCurTime;
@property (nonatomic,assign) UILabel *musicName;
@property (nonatomic,assign) int loopStyleInd;

- (void) stopWhenbackground;
- (void) playMusicAtLocation:(int)location withIndexPathrow:(int)row;
- (void) prepareToFavorList:(NSMutableDictionary *)dict withFlag:(BOOL)flag;

@end
