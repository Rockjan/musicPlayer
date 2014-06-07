//
//  musicItem.m
//  musicPlayerDemo
//
//  Created by zy_PC on 14-6-3.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import "musicItem.h"

@implementation musicItem

- (id)initMusicItemName:(NSString *)name withAuther:(NSString *)auther andPath:(NSString *)path isFavor:(BOOL)isFavor indexInList:(int)index
{
    if (self = [super init]) {
        
        self.name = name;
        self.path = path;
        self.auther = auther;
        self.isFavor = isFavor;
        self.indexInList = index;
        
    }

    return self;
}

@end
