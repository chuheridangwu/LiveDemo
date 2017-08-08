//
//  LiveBottonBtnView.m
//  LiveDemo
//
//  Created by dym on 2017/8/8.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "LiveBottonBtnView.h"

@implementation LiveBottonBtnView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *array = @[@"talk_public",@"talk_screenShot_icon",@"talk_sendgift",];
        for (int i = 0; i < array.count; i++) {
            CGFloat offsetX = 20 + i * (40 + 20);
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(offsetX, 0, 40, 40)];
            [self addSubview:btn];
            [btn setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
            btn.tag = i;
        }
    }
    return self;
}

- (void)clickBtn:(UIButton*)btn{
    if ([self.delegate respondsToSelector:@selector(clickBtnIndex:)]) {
        [self.delegate clickBtnIndex:btn.tag];
    }
}

@end
