//
//  leftViewController.m
//  musicPlayerDemo
//
//  Created by zy_PC on 14-6-3.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import "leftViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface leftViewController ()

@end

@implementation leftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor colorWithRed:1/1.2 green:1/2.0 blue:1/2.0 alpha:0.2];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 150, 480)];
    
    list.backgroundColor = [UIColor clearColor];
    
    list.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    list.dataSource = self;
    
    list.delegate = self;
    
    dataSource = [[NSArray alloc] initWithArray:@[@"全部歌曲", @"收藏夹"]];
    
    
    [self.view addSubview:list];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.textLabel.text = dataSource[indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    NSString *imgName = (indexPath.row == 0 ? @"all" : @"fav");
    
    
    UIImage *img = [UIImage imageNamed:imgName];

    cell.imageView.image = img;
    
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMain" object:nil];
    [_delegate updatePlayList:indexPath.row];
}


@end
