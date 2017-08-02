//
//  AdmireAnimationView.h
//  LiveDemo
//
//  Created by dym on 2017/8/2.
//  Copyright © 2017年 dym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdmireAnimationView : UIImageView

- (instancetype)initWithSuperView:(UIView*)view;

- (void)startWithLevel:(int)level number:(int)num;

@end
