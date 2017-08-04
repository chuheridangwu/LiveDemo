//
//  Gift.m
//  LiveDemo
//
//  Created by dym on 2017/8/3.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "Gift.h"

@interface Gift ()
@property (nonatomic, assign)NSInteger sNum;
@end

@implementation Gift

- (NSInteger)count{
    NSInteger num = [self backWantNum:15];
    if (num < 0 ) {
        num = [self count];
    }
    return num;
}

- (NSInteger)startNum{
    NSInteger num = [self backWantNum:100];
    if (num < 0 ) {
        num = [self startNum];
    }
    _sNum = num;
    return num;
}

- (NSInteger)endNum{
    NSInteger num = [self backWantNum:1000];
    if (num < _sNum) {
        num = self.endNum;
    }
    return num;
}

- (NSInteger)backWantNum:(int)num{
    return arc4random()%num;
}
@end
