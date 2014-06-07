//
//  playWind.m
//  musicPlayerDemo
//
//  Created by zy_PC on 14-5-22.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import "LRCPanel.h"

@interface LRCPanel ()

@end

@implementation LRCPanel
int secCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.view.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    secCount = 0;
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initValue:) name:@"playWind" object:nil];
    
    
    UIView *shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
    shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:shadowView];
    
    
    timeArray = [[NSMutableArray alloc] initWithCapacity:10];
    lrcDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    lrcTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, 350)];
    lrcTable.backgroundColor = [UIColor clearColor];
    
    lrcTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    lrcTable.dataSource = self;
    
    [self.view addSubview:lrcTable];
    
    

    
    [self subViewsLayout];
}

#pragma mark 得到歌词

- (void)initLRC
{
    
    NSString *LRCPath = [[NSBundle mainBundle] pathForResource:_curPlayName ofType:@"lrc"];
    
    if (LRCPath != NULL) {  //如果目录中存在_curPlayName的lrc歌词，则加载，否则不加载
        
        NSString *contentStr = [NSString stringWithContentsOfFile:LRCPath encoding:NSUTF8StringEncoding error:nil];
        //    NSLog(@"contentStr = %@",contentStr);
        NSArray *array = [contentStr componentsSeparatedByString:@"\n"];
        for (int i = 0; i < [array count]; i++) {
            NSString *linStr = [array objectAtIndex:i];
            NSArray *lineArray = [linStr componentsSeparatedByString:@"]"];
            if ([lineArray[0] length] > 8) {
                NSString *str1 = [linStr substringWithRange:NSMakeRange(3, 1)];
                NSString *str2 = [linStr substringWithRange:NSMakeRange(6, 1)];
                if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                    NSString *lrcStr = [lineArray objectAtIndex:1];
                    NSString *timeStr = [[lineArray objectAtIndex:0] substringWithRange:NSMakeRange(1, 5)];//分割区间求歌词时间
                    //把时间 和 歌词 加入词典
                    [lrcDict setObject:lrcStr forKey:timeStr];
                    [timeArray addObject:timeStr];//timeArray的count就是行数
                }
            }
        }
    }else{
        
        [timeArray removeAllObjects];
    }

    
    //NSLog(@"TimeArray:%@ ------",lrcDict);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (timeArray.count <= 0) {
        return 1;
    }
    return [timeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LRCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (timeArray.count <= 0) {
        
        cell.textLabel.text = @"没有找到对应歌词！";
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }else{
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//该表格选中后没有颜色
        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.row == lrcLineNumber) {
            cell.textLabel.text = lrcDict[timeArray[indexPath.row]];
            cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
        } else {
            cell.textLabel.text = lrcDict[timeArray[indexPath.row]];
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        cell.textLabel.backgroundColor = [UIColor clearColor];
        //        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        [cell.textLabel setNumberOfLines:2];
    }

    
    //        [cell.contentView addSubview:lable];//往列表视图里加 label视图，然后自行布局
    return cell;
}


- (void) subViewsLayout
{
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"fold"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(10, 10, 25, 15);
    
    [self.view addSubview:btn];
    
    
    process = [[UISlider alloc] initWithFrame:CGRectMake(0, 420, 320, 40)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderValueChanged:)];
    [process addGestureRecognizer:tap];
    [tap release];
    
   // process.maximumValue = 10.0;
    process.minimumValue = 0.0;

    UIImage *sliderImg = [UIImage imageNamed:@"slider.png"];

    [process setMaximumTrackTintColor:[UIColor grayColor]];
    [process setMinimumTrackTintColor:[UIColor greenColor]];
    
    [process setThumbImage:sliderImg forState:UIControlStateNormal];
    [process setThumbImage:sliderImg forState:UIControlStateHighlighted];
    
    [self.view addSubview:process];
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initLRC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [btn release];
    [process release];
    [lrcTable release];
    [lrcDict release];
    [timeArray release];
    
    [super dealloc];
}

//返回按钮
- (void)goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- footerDelegate

//根据时间，调整slider的值
- (void) changeTimeSliderValue:(int)value
{
   // NSLog(@"slider :%d",value);
    process.value = value;
}
//设置slider的最大值
- (void) setTimeSliderMaxValue:(int)value
{
    process.maximumValue = value;
}
//当自动播放下一首，跟新slider最大值和当前播放曲目名，同时更新tableview
- (void) setTimeSliderMaxValue:(int)value andSongName:(NSString *)name
{
    process.maximumValue = value;
    
    _curPlayName = [name copy];
    
    [self initLRC];
    
    [lrcTable reloadData];
}

//slider 的单击事件
- (void)sliderValueChanged:(UITapGestureRecognizer *)tap
{

    //获取点击点的坐标
    CGPoint point=[tap locationInView:self.view];
    
    //根据坐标、屏幕宽度以及歌曲总时长，获得快进位置
    
    float value = process.maximumValue*(point.x/self.view.bounds.size.width);
    
    NSString *time = [NSString stringWithFormat:@"%f",value];
    NSDictionary *dict = @{@"time": time};
    
    //通知快进或快退
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePlayTime" object:self userInfo:dict];
}

#pragma mark 动态显示歌词
//根据时间显示歌词
- (void)displaySondWord:(NSUInteger)time {
    //    NSLog(@"time = %u",time);
    
    if (timeArray.count > 0) {
        for (int i = 0; i < [timeArray count]; i++) {
            
            NSArray *array = [timeArray[i] componentsSeparatedByString:@":"];//把时间转换成秒
            NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
            if (i == [timeArray count]-1) {
                //求最后一句歌词的时间点
                NSArray *array1 = [timeArray[timeArray.count-1] componentsSeparatedByString:@":"];
                NSUInteger currentTime1 = [array1[0] intValue] * 60 + [array1[1] intValue];
                if (time > currentTime1) {
                    [self updateLrcTableView:i];
                    break;
                }
            } else {
                //求出第一句的时间点，在第一句显示前的时间内一直加载第一句
                NSArray *array2 = [timeArray[0] componentsSeparatedByString:@":"];
                NSUInteger currentTime2 = [array2[0] intValue] * 60 + [array2[1] intValue];
                if (time < currentTime2) {
                    [self updateLrcTableView:0];
                    //                NSLog(@"马上到第一句");
                    break;
                }
                //求出下一步的歌词时间点，然后计算区间
                NSArray *array3 = [timeArray[i+1] componentsSeparatedByString:@":"];
                NSUInteger currentTime3 = [array3[0] intValue] * 60 + [array3[1] intValue];
                if (time >= currentTime && time <= currentTime3) {
                    [self updateLrcTableView:i];
                    break;
                }
                
            }
        }
    }

}

#pragma mark 动态更新歌词表歌词
- (void)updateLrcTableView:(NSUInteger)lineNumber {
    
    //重新载入 歌词列表lrcTabView
    lrcLineNumber = lineNumber;
    [lrcTable reloadData];
    //使被选中的行移到中间
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lineNumber inSection:0];
    [lrcTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    //    NSLog(@"%i",lineNumber);
}

@end
