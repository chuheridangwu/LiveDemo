//
//  Room.h
//  LiveDemo
//
//  Created by dym on 2017/8/3.
//  Copyright © 2017年 dym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject
@property (nonatomic, assign) NSInteger allowDisplayCount;
@property (nonatomic, strong) NSArray *liveArray; //所有的主播列表

+ (Room*)currentRoom;
@end



