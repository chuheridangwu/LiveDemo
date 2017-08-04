//
//  LiveSubViewController.h
//  LiveDemo
//
//  Created by dym on 2017/8/1.
//  Copyright © 2017年 dym. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {        //移动手势触发的时候移动中的view类型
    movingTypeNone,   //没有标记
    movingTypeMicroList,//副麦列表移动
    movingTypeClearView//清爽模式移动
}movingType;

@interface LiveSubViewController : UIViewController
@property (nonatomic,copy)NSString *liveURL;


- (void)endLive;
@end
