//
//  customCell.m
//  musicPlayerDemo
//
//  Created by zy_PC on 14-5-21.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import "customCell.h"

@implementation customCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(320-40, 10, 40, 40)];
        UIImage *img = [UIImage imageNamed:@"flag"];
        _customImageView.image = img;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage)];
        
        
        tap.delegate = self;

        _flag = NO;
        _customImageView.userInteractionEnabled = YES;
        
        [_customImageView addGestureRecognizer:tap];
        
        
        
        [self addSubview:_customImageView];
        
        [tap release];
        
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeImage
{
    _flag = !_flag;
    
    if (_flag) {

        [self changeImageHeightLight];
       // [img release];
    }
    else{
        
        [self changeImageUnHeightLight];
        
      //  [img release];
    }
    
    [_delegate setFlagImg:self isHeighlight:_flag];
}

- (void)changeImageHeightLight
{
    _flag = YES;
    UIImage *img = [UIImage imageNamed:@"hflag"];
    _customImageView.image = img;
}

- (void)changeImageUnHeightLight
{
    _flag = NO;
    UIImage *img = [UIImage imageNamed:@"flag"];
    _customImageView.image = img;
    // [img release];
}

- (void)dealloc
{
    [super dealloc];
    [_customImageView release];
}

@end
