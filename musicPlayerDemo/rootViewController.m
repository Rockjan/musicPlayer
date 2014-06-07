//
//  rootViewController.m
//  musicPlayerDemo
//
//  Created by zy_PC on 14-5-21.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import "rootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "musicItem.h"
#import "footer.h"

@interface rootViewController ()

@end

@implementation rootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
           self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    imageView.image = [[UIImage imageNamed:@"bg.jpg"] autorelease];
    
    [self.view addSubview:imageView];
    [imageView release];*/
    
    storeCounts = 0;
    
    [self initDatasource];
    
    [self subViewLayout];
    
    
	// Do any additional setup after loading the view.
}
- (void) subViewLayout
{
    CGRect frame = self.view.bounds;
    
    frame.size.height -= 60;
    
    musicList = [[UITableView alloc] initWithFrame:frame];
    
    musicList.backgroundColor = [UIColor clearColor];
    musicList.backgroundColor = [UIColor colorWithRed:1/2.0 green:1/2.0 blue:1/2.0 alpha:0.2];
    musicList.layer.borderWidth = 0;
    
    musicList.dataSource = self;
    
    musicList.delegate = self;
    
    [self.view addSubview:musicList];

    _playPanel = [[footer alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 480 - frame.size.height)];
    
    _playPanel.delegate = self;
    
    [self.view addSubview:_playPanel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//退出前，保存本次设置
- (void)saveSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < playerList.count; i++) {
        
        musicItem *item = playerList[i];
        NSString *bl = (item.isFavor ? @"YES" : @"NO");
        [defaults setObject:bl forKey:[item name]];
        bl = nil;        
     }
    
    [defaults setObject:[NSString stringWithFormat:@"%d",_playPanel.loopStyleInd] forKey:@"loopStyle"];
    
    [defaults synchronize];
    
    NSLog(@"save setting successfully!");
}

- (void)dealloc
{
    [super dealloc];
    [musicList release];
    [playerList release];
    [favorMusic release];
    [_playPanel release];
    
}


#pragma mark --datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isStoreList) {
        return storeCounts;
    }
    
    return [playerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"cell";
    
    customCell *cell = (customCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
 
    int indxForFavor = 0;
    
    if (isStoreList) {
        indxForFavor = [self getIndexOfPlayList:indexPath.row];
        
    }else{
        indxForFavor = indexPath.row;
    }
    

    musicItem *item = (musicItem *)playerList[indxForFavor];
    
    
    cell.textLabel.text = [item name];
    
    cell.detailTextLabel.text = [item auther];
    
    cell.delegate = self;
    
    
    if ([item isFavor]) {
    
        [cell changeImageHeightLight];
        
    }else{
        [cell changeImageUnHeightLight];
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    item = nil;
    [item release];
    
    return cell;
}
//根据row获取歌曲在列表中的索引
- (int)getIndexOfPlayList:(int)row
{
    int indxCounts = 0;
    int indxForFavor = 0;
    
    for (int i = 0; i < playerList.count ; i++) {
        
        musicItem *item = (musicItem *)playerList[i];
        if (item.isFavor) {
            indxCounts ++;
            if (indxCounts - 1 == row) {
                indxForFavor = i;
                break;
            }
        }
        item = nil;
        [item release];
    }

    return indxForFavor;
}

#pragma mark delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isStoreList) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        musicItem *item = (musicItem *)[favorMusic objectForKey:cell.textLabel.text];
        
        [_playPanel playMusicAtLocation:item.indexInList withIndexPathrow:indexPath.row];
        
    }else{
        
        [_playPanel playMusicAtLocation:indexPath.row withIndexPathrow:indexPath.row];
    }
}

#pragma mark init method

- (void) initDatasource
{
    
    NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@".mp3" inDirectory:@""];
    
    NSString *temp = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    favorMusic = [[NSMutableDictionary alloc] initWithCapacity:array.count];
    
    playerList = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    int index = 0;

    for (NSString *path in array) {
        
        temp = [path lastPathComponent];
        
        NSString *name = [temp substringToIndex:temp.length-4];
        
        NSArray *na = [name componentsSeparatedByString:@"-"]; //song name-auther.mp3
        
        NSString *tempFav = [defaults objectForKey:na[0]];
        
        BOOL isFavor = ([tempFav isEqualToString:@"YES"]? YES : NO);  // read from a NSdictionary
        
        musicItem *item = [[musicItem alloc] initMusicItemName:na[0] withAuther:na[1] andPath:path isFavor:isFavor indexInList:index];
        
        [playerList addObject:item];
        if (isFavor) {
            [favorMusic setObject:item forKey:na[0]];
            storeCounts += 1;
        }
        
        
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

#pragma mark leftviewDelegate
- (void)updatePlayList:(int)playIndx
{
    //NSLog(@"update :%d",playIndx);
    
    if (playIndx == 0) {
        isStoreList = NO;
 
        [_playPanel prepareToFavorList:nil withFlag:NO];
        
    } else {
       
        isStoreList = YES;
        
         if (favorMusic.count > 0) {
             
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithCapacity:favorMusic.count];
            
//#warning NSDictionary 深浅拷贝问题,我不会，笨方法绕过 ！！！！！
            
            for (id key in favorMusic) {
                musicItem *item = (musicItem *)[favorMusic objectForKey:key];
                [temp setObject:item forKey:key];
                item = nil;
                [item release];
            }
            
            [_playPanel prepareToFavorList:temp withFlag:YES];
        }
    }
     
    
    [musicList reloadData];
}

#pragma mark cellDelegate
- (void)setFlagImg:(customCell *)cell isHeighlight:(BOOL)isheighlight
{
    
    int index = 0;
    NSString *disName = cell.textLabel.text;
    

    if (isheighlight) {
        
        int indx = [musicList indexPathForCell:cell].row;
        
      //  NSString *indxForArray = [NSString stringWithFormat:@"%d",indx];
        
        [favorMusic setObject:playerList[indx] forKey:disName];
        
        index = indx;
        
        storeCounts++;
        
    }else{
        
        musicItem *item = (musicItem *)[favorMusic objectForKey:disName];
        
        index = item.indexInList;
        
        [favorMusic removeObjectForKey:disName];
        
        item = nil;
        
        [item release];
        
        storeCounts--;
    }
    
    musicItem *item = (musicItem *)playerList[index];
    
    item.isFavor = isheighlight;
    
    [playerList replaceObjectAtIndex:index withObject:item];
    
    item = nil;
    
    [item release];
    
   // [musicList reloadData];
   
}
@end
