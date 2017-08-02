//
//  AdmireAnimationView.m
//  LiveDemo
//
//  Created by dym on 2017/8/2.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "AdmireAnimationView.h"

@interface AdmireAnimationView ()
{
    UIView *_superView;
    UIView *_baseView;
    int animatiomNum;
    float nlevel;
}
@end

@implementation AdmireAnimationView

- (instancetype)initWithSuperView:(UIView *)view{
    if (self = [super init]) {
        _superView = view;
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT / 2 - 55, 100, SCREEN_HEIGHT / 2)];
        _baseView.userInteractionEnabled= NO;
        [_superView addSubview:_baseView];
    }
    return self;
}

- (void)startWithLevel:(int)level number:(int)num{
    animatiomNum = num;
    nlevel = level;
    
    [self showAdmireImage];
}

- (void)showAdmireImage{
    if (animatiomNum -- == 0)
    {
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            return;
        }
    }
    
    double width = (double)(arc4random()%5) + 30;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, _baseView.mj_h - 20, width, width)];
    imgView.alpha = 1;
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d",(arc4random() % 13 + 1)]];
    imgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [_baseView addSubview:imgView];
    
    [UIView animateWithDuration:0.2 animations:^{
        imgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
    
    int time = arc4random() % 15 / 10.0 + 2.5;
    [UIView animateWithDuration:1 animations:^{
        imgView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time - 1.5 animations:^{
            imgView.alpha = 0;
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
        }];
    }];
    
    //创建关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation  animationWithKeyPath:@"position"];
    
    //添加路径
    CGMutablePathRef path = CGPathCreateMutable();
    //将编辑点移动到某个位置
    CGPathMoveToPoint(path, NULL, imgView.center.x, imgView.center.y);
    
    //从编辑点画一条直线到目标点，同时编辑点到目标点
    CGPathAddLineToPoint(path, NULL, arc4random()%30 + 35, CGRectGetHeight(_baseView.frame) / 3 * 2);
    int x = arc4random()%60 + 20;
    CGPathAddLineToPoint(path, NULL, x, CGRectGetHeight(_baseView.frame) / 3 * 1);
    CGPathAddLineToPoint(path, NULL, x, 0);
    
    //动画行进的路径
    animation.path = path;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = time;
    
    //释放路径
    CGPathRelease(path);
    
    [imgView.layer addAnimation:animation forKey:@"position"];
    [self performSelector:@selector(showAdmireImage) withObject:nil afterDelay:1.0/nlevel];
       
}

@end
