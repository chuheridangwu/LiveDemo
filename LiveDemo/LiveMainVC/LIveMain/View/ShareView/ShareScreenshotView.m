//
//  ShareScreenshotView.m
//  9158Live
//
//  Created by zhongqing on 2016/12/9.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import "ShareScreenshotView.h"
#import "ZThirdPartyShare.h"
#define kSpace   (iPhone5?(70 - 39)/2.0:26)
#define kWidth 39


@interface ShareScreenshotView()

@property (nonatomic, strong) UIImageView *shotScreenImage;

@property (nonatomic, strong) UIView *backView;         //背景
@property (nonatomic, strong) UIButton *closeButton;          //关闭按钮
@property (nonatomic, strong) UIImage *saveImage;//要保存本地的图片
@property (nonatomic, strong) NSMutableArray *btnsArr;

@end

@implementation ShareScreenshotView

-(instancetype)initWithImage:(UIImage *)image shareImage:(UIImage *)shareImage
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        
        //点击事件层
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_backView addGestureRecognizer:tap];
        [self addSubview:_backView];
        _backView.backgroundColor = kBlack(0.35);
        
        
        _shotScreenImage = [[UIImageView alloc] initWithFrame:CGRectMake(-7, -(image.size.height-SCREEN_HEIGHT)/2, image.size.width, image.size.height)];
        _shotScreenImage.centerX = self.centerX;
        [_shotScreenImage setImage:image];
        _shotScreenImage.userInteractionEnabled = YES;
        _shotScreenImage.layer.cornerRadius = 6.25;
        //_shotScreenImage.clipsToBounds = YES;
        [self addSubview:self.shotScreenImage];
        
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(image.size.width-20, -10, 30, 30)];
        [_closeButton setImage:[UIImage imageNamed:@"screenshot_btn_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [_shotScreenImage addSubview:_closeButton];
        
        
        if ([ZThirdPartyShare isInstallAnyThirdParty]) {
            NSMutableArray *imageTitles = [NSMutableArray array];
            
            if ([ZThirdPartyShare isInstallThirdParty:wechatShare]) {
                [imageTitles addObject:@"share_weixin_s"];
                [imageTitles addObject:@"share_friend_s"];
                
            }
            if ([ZThirdPartyShare isInstallThirdParty:QQShare]) {
                [imageTitles addObject:@"share_qq_s"];
            }
            if ([ZThirdPartyShare isInstallThirdParty:weiboShare]) {
                [imageTitles addObject:@"share_weibo_s"];
            }
            if (_btnsArr) {
                [_btnsArr removeAllObjects];
            }
            for (NSInteger i = 0; i<imageTitles.count; i++) {
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [shareBtn addTarget:self action:@selector(onButtonShare:) forControlEvents:UIControlEventTouchUpInside];
                [shareBtn setImage:[UIImage imageNamed:imageTitles[i]] forState:UIControlStateNormal];
                
                shareBtn.tag = 1000+[self getShareTypeWithName:imageTitles[i]];
                
                shareBtn.frame = CGRectMake((image.size.width-(kWidth*imageTitles.count+(kSpace*(imageTitles.count-1)*2)))/2.0+i*(kWidth+kSpace*2),SCREEN_HEIGHT-58+5, kWidth, kWidth);
                [self.btnsArr addObject:shareBtn];
                [_shotScreenImage addSubview:shareBtn];
            }
        }else{
            self.saveImage = shareImage;
            UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
            
            save.frame = CGRectMake((image.size.width-100)/2, SCREEN_HEIGHT-60, 100, 50);
            [save setTitle:@"保存到本地" forState:UIControlStateNormal];
            [save setTitleColor:kBlack(0.9) forState:UIControlStateNormal];
            [save addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
            [_shotScreenImage addSubview:save];
        }
        self.hidden = YES;
    }
    return self;
}

- (void)savePhoto
{
    [self loadImageFinished:self.saveImage];
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if ([_delegate respondsToSelector:@selector(savePhoto:)]) {
        [_delegate savePhoto:YES];
    }
}

- (NSInteger)getShareTypeWithName:(NSString *)name
{
    if ([name isEqualToString:@"share_weixin_s"]) {
        return 0;
    }else if ([name isEqualToString:@"share_friend_s"])
    {
        return 1;
    }else if ([name isEqualToString:@"share_qq_s"])
    {
        return 2;
        
    }else if ([name isEqualToString:@"share_weibo_s"])
    {
        return 4;
    }
    return 0;
}


-(void)show
{
    self.hidden = NO;
    
    CGFloat scale = 0.75;
    CGFloat scale1 = 1.33;
    if (iPhone5 || iPhone4) {
        scale = 0.75;
    }
    [UIView animateWithDuration:0.4 animations:^{
        _shotScreenImage.transform = CGAffineTransformMakeScale(scale,scale);
        
        for (UIButton *btn in self.btnsArr) {
            btn.transform = CGAffineTransformMakeScale(scale1,scale1);
        }
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hide
{
    _backView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.2 animations:^{
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + SCREEN_HEIGHT/2);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
        if ([_delegate respondsToSelector:@selector(hideShareScreenshotView:)]) {
            [_delegate hideShareScreenshotView:YES];
        }
        
    }];
}

-(void)onButtonShare:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(clickButton:)]) {
        [_delegate clickButton:sender.tag-1000];
    }
    
}


- (NSMutableArray *)btnsArr
{
    if (!_btnsArr)
    {
        _btnsArr = [NSMutableArray array];
    }
    return _btnsArr;
}



@end
