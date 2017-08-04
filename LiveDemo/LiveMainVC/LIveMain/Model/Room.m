//
//  Room.m
//  LiveDemo
//
//  Created by dym on 2017/8/3.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "Room.h"
#import "Gift.h"

static Room* g_currentRoom = nil;


@implementation Room


+ (Room*)currentRoom {
    static dispatch_once_t dis;
    dispatch_once(&dis, ^{
        if (g_currentRoom == nil) {
            g_currentRoom = [[Room alloc] init];
        }
    });
    return g_currentRoom;
}

- (NSInteger)allowDisplayCount{
    if (iPhone5) {
        _allowDisplayCount = 2;
    }else if (iPhone6){
        _allowDisplayCount = 3;
    }else if (iPhone6P){
        _allowDisplayCount = 4;
    }
    return _allowDisplayCount;
}

- (NSTimeInterval)getGiftShowTime:(Gift*)gift{
    return 1.5;
}

@end
