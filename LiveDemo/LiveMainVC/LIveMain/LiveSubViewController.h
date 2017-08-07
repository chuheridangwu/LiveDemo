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

@protocol LiveSubViewControllerDelegate;
@interface LiveSubViewController : UIViewController
@property (nonatomic, copy)NSString *liveURL;
@property (nonatomic, strong) UIView *clearBgView;  //滑动的View

@property (nonatomic, weak) id<LiveSubViewControllerDelegate> delegate;

// 更新房间链接
- (void)refreshPlayAddress:(NSString*)address;
- (void)endLive;
@end

@protocol LiveSubViewControllerDelegate <NSObject>
- (void)switchAnchor:(NSString*)liveURL  touchRect:(CGRect)rect;

@end
