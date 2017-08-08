//
//  LiveBottonBtnView.h
//  LiveDemo
//
//  Created by dym on 2017/8/8.
//  Copyright © 2017年 dym. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LiveBottonBtnViewDelegate;
@interface LiveBottonBtnView : UIView
@property (nonatomic, weak) id<LiveBottonBtnViewDelegate>  delegate;
@end


@protocol  LiveBottonBtnViewDelegate <NSObject>
- (void)clickBtnIndex:(NSInteger)index;
@end
