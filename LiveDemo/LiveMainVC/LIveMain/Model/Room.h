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

+ (Room*)currentRoom;
@end



