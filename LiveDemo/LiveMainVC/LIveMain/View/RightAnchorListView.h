//
//  RightAnchorListView.h
//  LiveDemo
//
//  Created by dym on 2017/8/4.
//  Copyright © 2017年 dym. All rights reserved.

//  主播列表

#import <UIKit/UIKit.h>

@interface RightAnchorListView : UIView
@property (nonatomic,strong)void (^selectBlock)( NSString *liveAddStr ,CGRect rect);


- (void)show;
- (void)close;
@end
