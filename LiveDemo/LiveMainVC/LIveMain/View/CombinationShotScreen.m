//
//  CombinationShotScreen.m
//  9158Live
//
//  Created by zhongqing on 2016/12/9.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import "CombinationShotScreen.h"
#import "ZThirdPartyShare.h"
@interface CombinationShotScreen()

@end

@implementation CombinationShotScreen

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(-10, -10, SCREEN_WIDTH+20, SCREEN_HEIGHT+20)];
    if (self) {
        
        self.backgroundColor = kWhite(1.0);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        UIImageView *screenshotImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, SCREEN_HEIGHT-110)];
        
        screenshotImage.contentMode = UIViewContentModeTop;
        
        [screenshotImage setImage:image];
        screenshotImage.clipsToBounds = YES;
        [self addSubview:screenshotImage];
        
        if ([ZThirdPartyShare isInstallAnyThirdParty]) {
            UILabel *shareTo = [[UILabel alloc] initWithFrame:CGRectMake(screenshotImage.centerX-25, screenshotImage.bottom+11, 50, 20)];
            shareTo.text = @"分享到";
            shareTo.textAlignment = NSTextAlignmentCenter;
            shareTo.textColor = UIColorFromRGBWithAlpha(0xb3b3b3, 1.0);
            shareTo.font = kFont(15);
            [self addSubview:shareTo];
            UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(screenshotImage.left, screenshotImage.bottom+10, (screenshotImage.width-shareTo.width)/2-10, 0.5)];
            leftLine.centerY = shareTo.centerY;
            leftLine.backgroundColor = UIColorFromRGBWithAlpha(0xe6e6e6, 1.0);
            [self addSubview:leftLine];
            UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(shareTo.right+10, screenshotImage.bottom+10, leftLine.width, 0.5)];
            rightLine.centerY = shareTo.centerY;
            rightLine.backgroundColor = UIColorFromRGBWithAlpha(0xe6e6e6, 1.0);
            [self addSubview:rightLine];

        }
    }
    return self;
}

/** 创建 imageView */
- (UIImageView *)createImageViewWithImageName:(NSString *)imagename cornerRadius:(CGFloat)cornerRadius tapAction:(SEL)action
{
    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:imagename];
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = cornerRadius;
    image.userInteractionEnabled = YES;
    if (action) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
        [image addGestureRecognizer:tap];
    }
    [self addSubview:image];
    return image;
}


@end
