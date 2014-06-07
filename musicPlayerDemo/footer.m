//
//  footer.m
//  musicPlayerDemo
//
//  Created by zy_PC on 14-5-22.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import "footer.h"
#import "musicItem.h"
#import "LRCPanel.h"


#define imgWidth 50
#define imgHeight 38

@implementation footer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor colorWithRed:1/2.0 green:1/2.0 blue:1/2.0 alpha:0.6];
        
        
        //读取上一次设置
        NSString *str = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"loopStyle"];
        
        _loopStyleInd = [str intValue];

        
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];    
    
    NSError *error;
    
    AVAudioSession *audionSession = [AVAudioSession sharedInstance];
    [audionSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    [audionSession setActive:YES error:&error];
        _pre = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _play = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _loopStyle = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    _DVDImg = [[JingRoundView alloc] init];
    _DVDImg.delegate = self;
    _DVDImg.rotationDuration = 8.0;
    _DVDImg.isPlay = NO;
    
    _DVDImg.roundImage = [UIImage imageNamed:@"dvd"];

    _DVDImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLRCWind)];
    
    [_DVDImg addGestureRecognizer:tap];
    
    [tap release];
    
    [self initDatasource];
    
    [self subViewlayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePlayTime:) name:@"changePlayTime" object:nil];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) subViewlayout
{
    
    
    _DVDImg.frame = CGRectMake(5, 0, 60, 60);
    
    [self addSubview:_DVDImg];
    
    
    [_pre setBackgroundImage:[UIImage imageNamed:@"newpre"] forState:UIControlStateNormal];
    
    _pre.frame = CGRectMake(80, 20, imgWidth, imgHeight);
    
    [_pre addTarget:self action:@selector(onClickPre) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_pre];
    
    
    [_play setBackgroundImage:[UIImage imageNamed:@"newplay"] forState:UIControlStateNormal];
    
    _play.frame = CGRectMake(80+imgWidth + 5, 20, imgWidth, imgHeight);
    
    [_play addTarget:self action:@selector(onClickPlay) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_play];
    
    
    [_next setBackgroundImage:[UIImage imageNamed:@"newnext"] forState:UIControlStateNormal];
    
    _next.frame = CGRectMake(80 + 2*(imgWidth) + 5, 20, imgWidth, imgHeight);
    
    [_next addTarget:self action:@selector(onClickNext) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_next];
    
    NSString *imgName = [NSString stringWithFormat:@"%d.png",_loopStyleInd];
    
    
    [_loopStyle setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    _loopStyle.frame = CGRectMake(80 + 3*(imgWidth) + 5, 25, imgWidth - 25, imgHeight - 10);
    
    [_loopStyle addTarget:self action:@selector(onClickLoop) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_loopStyle];
    
    _showCurTime = [[UILabel alloc] initWithFrame:CGRectMake(80 + 4*(imgWidth) - 10, 24, imgWidth, imgHeight - 10)];
    _showCurTime.text = @"00:00";
    _showCurTime.backgroundColor = [UIColor clearColor];
    _showCurTime.textColor = [UIColor whiteColor];
    _showCurTime.font = [UIFont fontWithName:@"GBK" size:3];
    
    [self addSubview:_showCurTime];
    
    _musicName = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 200, 20)];
    _musicName.text = @"";
    _musicName.textColor = [UIColor whiteColor];
    _musicName.backgroundColor = [UIColor clearColor];
    _musicName.font = [UIFont fontWithName:@"GBK" size:13.0];
    
    [self addSubview:_musicName];
}

- (void) initDatasource
{
    
    NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@".mp3" inDirectory:@""];
    
    NSString *temp = nil;
    
    totalCounts = array.count;
    
    playerList = [[NSMutableArray alloc] initWithCapacity:totalCounts];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    int index = 0;
    
    for (NSString *path in array) {
        
        temp = [path lastPathComponent];
        
        NSString *name = [temp substringToIndex:temp.length-4];
        
        NSArray *na = [name componentsSeparatedByString:@"-"]; //song name-auther.mp3
        
        NSString *tempFav = [defaults objectForKey:na[0]];
        
        BOOL isFavor = ([tempFav isEqualToString:@"YES"]? YES : NO);  // read from a NSdictionary
        
        musicItem *item = [[musicItem alloc] initMusicItemName:na[0] withAuther:na[1] andPath:path isFavor:isFavor indexInList:index];
        
        [playerList addObject:item];
        
        name = nil;
        [name release];
        [item release];
        na = nil;
        [na release];
        
        index ++;
    }
    
    temp = nil;
    [temp release];
    array = nil;
    [array release];
    
}

- (void)dealloc
{
    [super dealloc];
    
    [myTimer release];
    
    [playerList release];
    [favorList release];
}

#pragma mark- override the setter method

- (void)setFlag:(BOOL)flag
{
    _flag = flag;

    
    if (flag) {
        [_play setBackgroundImage:[UIImage imageNamed:@"newpause"] forState:UIControlStateNormal];
        
        _DVDImg.isPlay = YES;
        
        if (audioPlayer == nil) {
            [self initPlayer];
        }
        
        [audioPlayer play];
        [self startTimer];
        
        
      //  NSLog(@"Start to paly!");
    }else{
        [_play setBackgroundImage:[UIImage imageNamed:@"newplay"] forState:UIControlStateNormal];
        
        [audioPlayer pause];
        [self releaseTimer];

        _DVDImg.isPlay = NO;
       // NSLog(@"pause to paly!");
    }
}
- (void) stopWhenbackground
{
    [self onPause];
}
#pragma mark- player control method

- (void)onPause
{
    self.flag = NO;
    
    // NSLog(@"onPause");
}

- (void)onClickPlay
{
    self.flag = !_flag;

}

- (void)onClickPre
{
    
    switch (_loopStyleInd) {
        case 0:   //loop
            
            if (isStore) {
                subIndex --;
                
                if (subIndex <0) {
                    subIndex = totalCounts -1;
                }
                subIndex %= totalCounts;
                
                curPlayLocation = [self getIndexFromSub:subIndex];
            }else{
                
                curPlayLocation -= 1;
                
                if (curPlayLocation < 0) {
                    curPlayLocation = totalCounts-1;
                }
                curPlayLocation %= totalCounts;
            } 
            break;
            
        case 1: //single
            //do nothing
            break;
            
        case 2: //random
            if (isStore) {
                subIndex = arc4random()%totalCounts;
                curPlayLocation = [self getIndexFromSub:subIndex];
            }else {
                curPlayLocation = arc4random()%totalCounts;
            }
            break;
    }
    
    [self initPlayer];
    
    self.flag = YES;
    
    // NSLog(@"onPlayPre");
}

- (void)onClickNext
{
    switch (_loopStyleInd) {
        case 0:   //loop

            if (isStore) {
                subIndex++;
                subIndex %= totalCounts;
                
                curPlayLocation = [self getIndexFromSub:subIndex];
            }else
            {
                curPlayLocation += 1;
                curPlayLocation %= totalCounts;
            }
            
            break;
            
        case 1: //single
            //do nothing
            break;
            
        case 2: //random
            if (isStore) {
                subIndex = arc4random()%totalCounts;
                curPlayLocation = [self getIndexFromSub:subIndex];
            }else {
                curPlayLocation = arc4random()%totalCounts;
            }
            break;
    }
    
    [self initPlayer];
    
    self.flag = YES;
    
    // NSLog(@"onPlayNext");
}
- (void) onClickLoop
{
    _loopStyleInd = (_loopStyleInd+1)%3;
    
    NSString *imgName = [NSString stringWithFormat:@"%d",_loopStyleInd];
    
    [_loopStyle setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
   // NSLog(@"OnLoopStyle:%d",_loopStyleInd);
}

//把收藏夹索引转换成所有歌曲列表的索引
-(int) getIndexFromSub:(int)subInd
{
    return [(musicItem *)favorList[subInd] indexInList];
}
//播放location位置的歌曲，如果是收藏夹中的歌曲，根据row获取subIndex
- (void) playMusicAtLocation:(int)location withIndexPathrow:(int)row;
{
    curPlayLocation = location;
    _flag = NO;
    if (isStore) {
        subIndex = row;
    }
    
    if (audioPlayer != nil) {
        [audioPlayer release];
        audioPlayer = nil;
    }
    [self onClickPlay];
}
//如果当前列表选项为收藏夹（flag = YES），则准备收藏夹播放列表
- (void) prepareToFavorList:(NSMutableDictionary *)dict withFlag:(BOOL)flag
{
   
    if (flag) {
        
        totalCounts = dict.count;
        
        if (favorList != nil) {
            [favorList release];
        }
        
        favorList = [[NSMutableArray alloc] initWithCapacity:totalCounts];
        
        //NSLog(@"--------counts:%d",totalCounts);
        
        while (dict.count>0) {
            
            int minIndx = 10;
            NSString *str = nil;
            
            for (id key in dict) {
                musicItem *item = (musicItem *)[dict objectForKey:key];
                if (item.indexInList < minIndx) {
                    minIndx = item.indexInList;
                    str = key;
                }
                
                item = nil;
                [item release];
            }
            
            
            
            [favorList addObject:playerList[minIndx]];
            [dict removeObjectForKey:str];
        }
        subIndex = 0;
        curPlayLocation = [(musicItem *)favorList[0] indexInList];
        isStore = YES;
        
    }else{
        
        isStore = NO;
        totalCounts = playerList.count;
        curPlayLocation = 0;
    }
    
}
//播放完毕，继续下一首
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self onClickNext];
    if (isLRCOpen) {
        
        //更新播放曲目名，用以更新lrc歌词
        NSString *name = [(musicItem *)playerList[curPlayLocation] name];
        
        //更新lrc面板的slider总时长
        [_delegate setTimeSliderMaxValue:audioPlayer.duration andSongName:name];

    }
}

#pragma mark- avaudioplayer and timer

- (void) initPlayer
{
    if (audioPlayer != nil) {

        [audioPlayer release];
    }
    
  //  NSLog(@"Path:%@",[(musicItem *)playerList[curPlayLocation] path]);
    NSURL *url = [NSURL fileURLWithPath:[(musicItem *)playerList[curPlayLocation] path]];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [audioPlayer prepareToPlay];
    audioPlayer.delegate = self;
    
    _musicName.text = [(musicItem *)playerList[curPlayLocation] name];
    _musicName.font = [UIFont systemFontOfSize:12];
}

- (void)startTimer
{
    myTimer = [[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES] retain];
}
- (void)releaseTimer
{
    if (myTimer != nil) {
        [myTimer invalidate];
        [myTimer release];
        myTimer = nil;
    }
}

- (void)updateTimeLabel
{    
    NSString *formateTime = [self formateTime:audioPlayer.currentTime];
   
    _showCurTime.text = formateTime;
    
    if (isLRCOpen) {
        
        //如果 lrc 面板已经打开，则时刻更新进度条
        [_delegate changeTimeSliderValue:audioPlayer.currentTime];
        
        //如果 lrc 面板已经打开，则更新lrc 歌词
        [_delegate displaySondWord:audioPlayer.currentTime];
    }
}

//当正在播放时，点击显示lrc面板
- (void)showLRCWind
{
    if (audioPlayer.isPlaying) {
        
        LRCPanel *lrcPanel = [[LRCPanel alloc] init];
        if (isStore) {
            curPlayLocation = [self getIndexFromSub:subIndex];
        }
        
        lrcPanel.curPlayName = [(musicItem *)playerList[curPlayLocation] name];
        
        //设置delegate为player（lrc面板）
        self.delegate = lrcPanel;
        
        UIView *superV = [self superview];
        
        //获取父视图控制器
        UIResponder *nextResponder = [superV nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            [(UIViewController *)nextResponder presentViewController:lrcPanel animated:YES completion:^{}];
            
            //设置lrc面板打开标志
            isLRCOpen = YES;
            
            //设置lrc面板slider的最大值
            [_delegate setTimeSliderMaxValue:audioPlayer.duration];
        }
    }

}
//格式化时间
- (NSString *)formateTime:(int)ct
{
    int h = 0;
    int m = 0;
    int s = 0;
    
    NSString *hs = @"", *ms = @"00:", *ss = @"00";
    
    h = ct / 3600;
    
    ct %= 3600;
    
    m = ct / 60;
    
    ct %= 60;
    
    s = ct;
    
    if(h > 0)
    {
        hs = [NSString stringWithFormat:@"0%d:",h];
    }
    
    if(m > 0)
    {
        ms = [NSString stringWithFormat:@"0%d:",m];
    }
    
    if (s / 10 > 0) {
        
        ss = [NSString stringWithFormat:@"%d",s];
    }else
    {
        ss = [NSString stringWithFormat:@"0%d",s];
    }
    
    NSString *finalStr = [NSString stringWithFormat:@"%@%@%@",hs,ms,ss];
    
    return finalStr;
}

#pragma mark- notification
//点击进度条，快进快退
- (void)changePlayTime:(NSNotification *)noti
{
    int time = [(NSString *)[[noti userInfo] valueForKey:@"time"] intValue];
    audioPlayer.currentTime = time;
}
@end
