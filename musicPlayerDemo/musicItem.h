//
//  musicItem.h
//  musicPlayerDemo
//
//  Created by zy_PC on 14-6-3.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface musicItem : NSObject
/*
 {
 NSString *name;
 NSString *path;
 BOOL isFavor;
 }
 */
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *path;
@property (nonatomic,retain) NSString *auther;
@property (nonatomic,assign) BOOL isFavor;
@property (nonatomic,assign) int indexInList;

- (id)initMusicItemName:(NSString *)name withAuther:(NSString *)auther andPath:(NSString *)path isFavor:(BOOL)isFavor indexInList:(int)index;

@end
