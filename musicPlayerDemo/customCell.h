//
//  customCell.h
//  musicPlayerDemo
//
//  Created by zy_PC on 14-5-21.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class customCell;

@protocol customCellDelegate <NSObject>

@optional
- (void) setFlagImg:(customCell *)cell isHeighlight:(BOOL)isheighlight;

@end

@interface customCell : UITableViewCell

@property (nonatomic,assign) id<customCellDelegate> delegate;
@property (nonatomic,assign) UIImageView *customImageView;
@property (nonatomic,assign) BOOL flag;

- (void)changeImage;
- (void)changeImageHeightLight;
- (void)changeImageUnHeightLight;

@end
