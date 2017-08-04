//
//  Gift.h
//  LiveDemo
//
//  Created by dym on 2017/8/3.
//  Copyright © 2017年 dym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gift : NSObject
@property (nonatomic, assign) NSInteger count;     //礼物个数
@property (nonatomic, assign) NSInteger startNum;  // 开始的礼物数字，默认是1
@property (nonatomic, assign) NSInteger endNum;    // 结束的礼物数字
@end
