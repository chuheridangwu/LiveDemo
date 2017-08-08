//
//  AdmireAnimationView.h
//  LiveDemo
//
//  Created by dym on 2017/8/2.
//  Copyright © 2017年 dym. All rights reserved.

//  点赞动画

#import <UIKit/UIKit.h>

@interface AdmireAnimationView : UIImageView

- (instancetype)initWithSuperView:(UIView*)view;

- (void)startWithLevel:(int)level number:(int)num;

@end
