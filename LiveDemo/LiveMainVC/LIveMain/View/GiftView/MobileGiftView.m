//
//  MobileGiftView.m
//  LiveDemo
//
//  Created by dym on 2017/8/2.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "MobileGiftView.h"
#import "Gift.h"

#define viewWidth 183
#define bignum 9


@interface MobileGiftView ()
@property (nonatomic, strong)Gift *showedGift;
@property (nonatomic, strong)Gift *waitingGift;         // 在第一个礼物在滚动的过程中，收到的礼物，等待动画结束后再显示
@property (nonatomic, strong)UIButton *headerBtn;
@property (nonatomic, copy)NSString *giftImageUrl;
@property (nonatomic, strong)UIView *sendNameBgView;
@property (nonatomic, strong)UIView *reciveNameBgView;
@property (nonatomic,strong)UILabel *sendNameLabel;
@property (nonatomic,strong)UILabel *reciveNameLabel;
@property (nonatomic,strong)UIImageView *giftImage;
@property (nonatomic,strong)UIView *moveBgView;
@property (nonatomic,strong)UIImageView *xImage;
@property (nonatomic,strong)UIImageView *awadBg;        //旋转的光芒


@property (nonatomic,strong)NSMutableArray *moveViewArray;
@property (nonatomic,strong)NSMutableArray *numArray;      //
@property (nonatomic,strong)NSMutableArray *moveCountArray;//

@property (nonatomic, strong)NSTimer *stayTimer;
@property (nonatomic, assign)NSTimeInterval startTimeInterval;  // 定时器开启时的时间

@property (nonatomic, assign)CGRect originalFrame;

@property (nonatomic, strong)UIView *winView;

@property (nonatomic,strong)UIImageView  *layerBgView;

@property (nonatomic,strong) UILabel *sendLabel;
@end

@implementation MobileGiftView
- (instancetype)initWithFrame:(CGRect)frame{
    _originalFrame = frame;
    if (self = [super initWithFrame:frame]) {
        _layerBgView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_layerBgView];
        
        // 头像
        _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerBtn.frame = CGRectMake(2.5, 2.5, 40, 40);
        _headerBtn.layer.cornerRadius = 20;
        _headerBtn.layer.masksToBounds = YES;
        _headerBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
        _headerBtn.layer.borderWidth = 1;
        [self addSubview:_headerBtn];
        
        // 送礼物的用户昵称
        _sendNameBgView = [[UIView alloc]initWithFrame:CGRectMake(50, 6, 83, 16)];
        _sendNameBgView.clipsToBounds = YES;
        [self addSubview:_sendNameBgView];
        
        _sendNameLabel = [[UILabel alloc]initWithFrame:_sendNameBgView.bounds];
        _sendNameLabel.textColor = [UIColor whiteColor];
        _sendNameLabel.font = [UIFont systemFontOfSize:14];
        [_sendNameBgView addSubview:_sendNameLabel];
        
        _sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 27, 14, 13)];
        _sendLabel.textColor = [UIColor whiteColor];
        _sendLabel.font = [UIFont systemFontOfSize:11];
        //  _sendLabel.text = NSLocalizedString(@"LR_Send", @"");
        [self addSubview:_sendLabel];
        
        
        // 主播的用户昵称
        _reciveNameBgView = [[UIView alloc]initWithFrame:CGRectMake(64, 27, 69, 13)];
        _reciveNameBgView.clipsToBounds = YES;
        [self addSubview:_reciveNameBgView];
        
        _reciveNameLabel = [[UILabel alloc]initWithFrame:_reciveNameBgView.bounds];
        _reciveNameLabel.textColor = [UIColor whiteColor];
        _reciveNameLabel.font = [UIFont systemFontOfSize:11];
        [_reciveNameBgView addSubview:_reciveNameLabel];
     
        
        _giftImage = [[UIImageView alloc]initWithFrame:CGRectMake(- 55, -5, 55, 55)];
        [self addSubview:_giftImage];
        
        _moveBgView = [[UIView alloc]initWithFrame:CGRectMake(viewWidth + 27, 7.5, 20, 30)];
        _moveBgView.clipsToBounds = YES;
        _moveBgView.hidden = YES;
        [self addSubview:_moveBgView];
        
        _xImage = [[UIImageView alloc]initWithFrame:CGRectMake(viewWidth + 5, 7.5, 20, 30)];
        _xImage.image = [UIImage imageNamed:@"Number.bundle/x.png"];
        _xImage.hidden = YES;
        [self addSubview:_xImage];
        
        _awadBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 232, 232)];
        _awadBg.image = [UIImage imageNamed:@"award_rotate"];
        _awadBg.hidden = YES;
        [self addSubview:_awadBg];
        
        _moveViewArray = [[NSMutableArray alloc]init];
        _moveCountArray = [[NSMutableArray alloc]init];
        _showedGift = [[Gift alloc]init];
        
    }
    return self;
}


- (void)showWithGift:(Gift *)gift{
    self.hidden = NO;
    [self updateUI];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.center = CGPointMake(self.center.x + viewWidth, self.center.y);
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _giftImage.frame = CGRectMake(viewWidth - 55, -5, 55, 55);
    } completion:^(BOOL finished) {
        _moveBgView.hidden = NO;
        _xImage.hidden = NO;
        [self showUserNameAnimate];
        [self showNumberAnimate];
    }];
}

- (void)updateUI{
    _giftImageUrl = @"https://mimtenroom.tiao58.com/item/305_m_121413.png";
    [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_giftImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"giftViewBg"]];
//    _headerBtn.layer.borderColor = [];
    _sendNameLabel.attributedText = [MobileGiftView stringWithShadowWithString:@"这是一个发送者的昵称" shadowColor:[UIColor colorWithWhite:0 alpha:0.4] fontSize:14];
    [_sendNameLabel sizeToFit];
    _sendNameLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_sendNameLabel.bounds), 16);
    
    _reciveNameLabel.attributedText = [MobileGiftView stringWithShadowWithString:@"接收礼物的主播111" shadowColor:[UIColor colorWithWhite:0 alpha:0.4] fontSize:11];
    [_reciveNameLabel sizeToFit];
    _reciveNameLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_reciveNameLabel.bounds), 13);
    
    _sendLabel.attributedText = [MobileGiftView stringWithShadowWithString:@"送" shadowColor:[UIColor colorWithWhite:0 alpha:0.4] fontSize:14];
    
    [_giftImage sd_setImageWithURL:[NSURL URLWithString:_giftImageUrl]];
    _layerBgView.image =/* DISABLES CODE */ (NO)  ?[UIImage imageNamed:@"giftViewBgMe"]:[UIImage imageNamed:@"giftViewBg"];

    [self createNumberView];
    
}

- (void)createNumberView{
    [self clearMassage];
    if (_showedGift.count > bignum) {  //设置跳动的动画
        [self setBigNum];
    }else{
        [self setNormalNum];
    }
    
}

- (void)clearMassage
{
    [_moveBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_moveViewArray.count > 0) {
        [_moveViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_moveViewArray removeAllObjects];
    }
    [self.moveCountArray removeAllObjects];
}

// 布置正常跳动数字
- (void)setNormalNum{
    NSString *endNumStr = [NSString stringWithFormat:@"%d", arc4random()%10];
    int len = (int)endNumStr.length;
    _moveBgView.frame = CGRectMake(viewWidth + 27, 7.5, 20 * len, 30);
    for (int i = 0; i < len; i ++)
    {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i * 20, 0, 20, 30)];
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number.bundle/%@", endNumStr.length > 0 ? [endNumStr substringToIndex:1] : @"0"]];
        endNumStr = endNumStr.length > 0 ? [endNumStr substringFromIndex:1] : @"0";
        [self.moveBgView addSubview:img];
    }
}

//布置大数字滚动
- (void)setBigNum{
    if (!_moveViewArray) {
        _moveViewArray = [[NSMutableArray alloc]init];
    }
    if (!_moveCountArray) {
        _moveCountArray = [[NSMutableArray alloc]init];
    }
    NSString *startNumStr = [NSString stringWithFormat:@"%ld", _showedGift.startNum];
    NSString *endNumStr = [NSString stringWithFormat:@"%ld", _showedGift.endNum];
    _moveBgView.frame = CGRectMake(viewWidth + 27, 7.5, 20 * endNumStr.length, 30);
    
    long zeroCount = endNumStr.length - startNumStr.length;
    
    if (startNumStr.length != endNumStr.length)
    {
        for (int i = 0; i < zeroCount; i ++)
        {
            startNumStr = [NSString stringWithFormat:@"0%@",startNumStr];
        }
    }
    long lenth = endNumStr.length;
    
    long changeCount = -1;
    
    for (long i = 0; i < lenth; i ++)
    {
        UIView *view = [[UIView alloc]init];
        [_moveBgView addSubview:view];
        int starNum = startNumStr.length > 0 ? [[startNumStr substringToIndex:1]intValue] : 0;
        int endNum = endNumStr.length > 0 ? [[endNumStr substringToIndex:1]intValue] : 0;
        if (endNum > starNum) {
            changeCount = i;
        }
        else if (changeCount >= 0)
        {
            endNum =  10 + endNum;
        }
        if (zeroCount > 0) {
            view.frame = CGRectMake(i * 20, 110 * zeroCount , 20, 30);
            view = [self createMoveView:view fromNum:1 toNum:endNum];
            [self.moveCountArray addObject:[NSString stringWithFormat:@"%ld",110 * zeroCount + (endNum - 1) * 30]];
            zeroCount --;
        }
        else
        {
            view.frame = CGRectMake(i * 20, 0, 20, 30);
            view = [self createMoveView:view fromNum:starNum toNum:endNum];
            [self.moveCountArray addObject:[NSString stringWithFormat:@"%d",(endNum  - starNum) * 30]];
        }
        [self.moveViewArray addObject:view];
        startNumStr = [startNumStr substringFromIndex:1];
        endNumStr = [endNumStr substringFromIndex:1];
    }
}

//滚动数字
- (UIView*)createMoveView:(UIView*)view fromNum:(int)starNum toNum:(int)toNum{
    if (toNum <= starNum) {
        toNum += 10;
    }
    for (int i = 0; i <= toNum - starNum; i++) {
        UIImageView *numImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30 * i, 20, 30)];
        numImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number.bundle/%d.png",(i + starNum) % 10]];
        [view addSubview:numImg];
        if (i == toNum - starNum) {
            [self.numArray addObject:numImg];
        }
    }
    return view;
}

/**
 *  名字比较长的时候进行移动动画
 */
- (void)showUserNameAnimate{
    if (_sendNameLabel.mj_w > _sendNameBgView.mj_w || _reciveNameLabel.mj_w > _reciveNameBgView.mj_w) {
        [UIView animateWithDuration:1.2 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (_sendNameLabel.mj_w > _sendNameBgView.mj_w) {
                _sendNameLabel.frame = CGRectMake(_sendNameBgView.mj_w - _sendNameLabel.mj_w, 0, _sendNameLabel.mj_w, 16);
            }else{
                _reciveNameLabel.frame = CGRectMake(_reciveNameBgView.mj_w - _reciveNameLabel.mj_w, 0, _reciveNameLabel.mj_w, 13);
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}



- (void)showNumberAnimate{
    if (10 <= bignum) {
        [self starNormalNumAnimate];
    }
    else
    {
        _moveBgView.transform = CGAffineTransformMakeScale(4, 4);
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _moveBgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _moveBgView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL finished)
             {
                 [self starBigNumAnimation];
             }];
        }];
    }
}


- (void)animationStop
{
    if (_waitingGift) {
        [self showWaitingGift];
    }
    else {
        [self startTimer];
    }
}

- (void)showWaitingGift
{
    if (_waitingGift) {
        [self stopTimer];
        _waitingGift = nil;
        [self createNumberView];
        [self showNumberAnimate];
    }
}




//开始跳动动画
- (void)starNormalNumAnimate
{
    _moveBgView.transform = CGAffineTransformMakeScale(4, 4);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _moveBgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _moveBgView.transform = CGAffineTransformMakeScale(1, 1);
        }completion:^(BOOL finished)
         {
             [self animationStop];
         }];
    }];
}

//开始滚动动画
- (void)starBigNumAnimation
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        for (int i = 0; i < self.moveViewArray.count; i ++)
        {
            int moveCount = [self.moveCountArray[i] intValue];
            UIView *view = self.moveViewArray[i];
            view.center = CGPointMake(view.center.x, view.center.y - moveCount);
        }
    } completion:^(BOOL finished) {
        [self animationStop];
    }];
}



// 定时器
- (void)startTimer
{
    [self stopTimer];
    _stayTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(closeGiftView) userInfo:nil repeats:NO];
    _startTimeInterval = [[NSDate date] timeIntervalSince1970];
}

- (void)stopTimer
{
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(closeGiftView) object:nil];
    if (_stayTimer != nil && [_stayTimer isValid]) {
        [_stayTimer invalidate];
        _stayTimer = nil;
    }
    _startTimeInterval = 0;
}

- (void)closeGiftView{
    [self stopTimer];
    [UIView animateWithDuration:0.2 animations:^{
        self.center = CGPointMake(self.center.x + 100, self.center.y);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self restoreView];
    }];
}
- (void)restoreView
{
    [self setFrame:_originalFrame];
    self.alpha = 1;
    self.hidden = YES;
    _giftImageUrl = nil;
    _moveBgView.hidden = YES;
    _xImage.hidden = YES;
    _awadBg.hidden = YES;
    [_awadBg setFrame:CGRectMake(0, 0, 232, 232)];
    [_giftImage setFrame:CGRectMake(- 55, -5, 55, 55)];
    if (_winView) {
        [_winView removeFromSuperview];
        _winView = nil;
    }
}


#pragma mark   -------  中奖的动画
- (void)showLuckyView{
    if (_winView) {
        return;
    }
        if (_startTimeInterval > 0) {
            [self startTimer];
        }
    
        _winView = [self createLuckyWinShowView:1000];
        [self addSubview:_winView];
        if (/* DISABLES CODE */ (1000) >= 500) {
            _winView.center = CGPointMake(_winView.center.x, _winView.center.y - 150);
            _winView.transform = CGAffineTransformMakeScale(4, 4);
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                _winView.center = CGPointMake(_winView.center.x, _winView.center.y + 150);
                _winView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    _winView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                }completion:^(BOOL finished)
                 {
                     [UIView animateWithDuration:0.1 animations:^{
                         _winView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }];
                     _awadBg.hidden = NO;
                     _awadBg.center = CGPointMake(CGRectGetMinX(_winView.frame) + CGRectGetWidth(_winView.frame)/2, CGRectGetMinY(_winView.frame) + CGRectGetHeight(_winView.frame)/2);
                         [self sbAnimation];
                     
                     [UIView animateWithDuration:2.0 animations:^{
                         _awadBg.transform = CGAffineTransformRotate(_awadBg.transform, M_PI / 2);
                     }completion:^(BOOL finished) {
                         _awadBg.hidden = YES;
                         [_winView removeFromSuperview];
                         _winView = nil;
                     }];
                     
                 }];
            }];
        }
        else {
            _winView.frame = CGRectMake(32.5, 44, 135, 33);
            _winView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            [UIView animateWithDuration:0.2 animations:^{
                _winView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
            [UIView animateWithDuration:0.2 delay:1000 >= 500 ? 1.8 : 1.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _winView.alpha = 0;
            } completion:^(BOOL finished) {
                [_winView removeFromSuperview];
                _winView = nil;
            }];
        }
    
}



+ (NSMutableAttributedString*)stringWithShadowWithString:(NSString*)string shadowColor:(UIColor*)color fontSize:(CGFloat)font
{
    if (!color) {
        color = [UIColor colorWithWhite:0 alpha:0.8];
    }
    if (string==nil) {
        return 0;
    }
    NSRange range =  [string rangeOfString:@"亲密度"];
    NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc]initWithString:string];
    NSShadow *shadow = [[ NSShadow alloc] init];
    shadow. shadowColor = color;
    shadow. shadowBlurRadius = 1 ;
    shadow. shadowOffset = CGSizeMake (0 , 0.6);
    NSDictionary *attributes2 = @{ NSShadowAttributeName : shadow} ;
    [attributString addAttributes:attributes2 range:NSMakeRange(0, attributString.length)];
    [attributString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font > 0 ? font : 14] range:NSMakeRange(0, attributString.length)];
    [attributString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    return attributString;
}


- (UIView *)createLuckyWinShowView:(NSInteger)count
{
    if (count >= 500) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 175)/2, 10, 175, 100)];
        [img setImage:[UIImage imageNamed:@"congratulation"]];
        
        UIView *countView = [[UIView alloc] init];
        [countView setBackgroundColor:[UIColor clearColor]];
        NSString *countStr = [NSString stringWithFormat:@"%@", @(count)];
        CGRect rect = CGRectMake(0, 0, 12, 20);
        for (int i = 0; i < countStr.length; i++) {
            UIImageView *num = [[UIImageView alloc] initWithFrame:rect];
            [num setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Number.bundle/y%@.png", [countStr substringWithRange:NSMakeRange(i, 1)]]]];
            [countView addSubview:num];
            rect.origin.x += CGRectGetWidth(rect) + 2;
        }
        rect.size.width = 18;
        UIImageView *countImg = [[UIImageView alloc] initWithFrame:rect];
        [countImg setImage:[UIImage imageNamed:@"Number.bundle/ycount.png"]];
        [countView addSubview:countImg];
        [countView setFrame:CGRectMake((CGRectGetWidth(img.frame) - CGRectGetMaxX(rect))/2, 64, CGRectGetMaxX(rect), CGRectGetHeight(rect))];
        [img addSubview:countView];
        
        return img;
    }
    else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(- 135, 44, 135, 33)];
        UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 6.5, 110, 20)];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        bgView.layer.cornerRadius = 10;
        bgView.layer.masksToBounds = YES;
        bgView.layer.borderColor = [UIColorFromRGBWithAlpha(0xffcc00, 1)CGColor];
        bgView.layer.borderWidth = 1;
        [view addSubview:bgView];
        [label bringSubviewToFront:bgView];
        [str insertAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString(@"LR_Win3", @""),@(count)]] atIndex:0];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, str.length)];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBWithAlpha(0xffcc00, 1) range:NSMakeRange(0, str.length)];
        label.textAlignment = NSTextAlignmentLeft;
        label.attributedText = str;
        [view addSubview:label];
        
        return view;
    }
    
    return nil;
}
/**
 *  撒币效果
 */
- (void)sbAnimation
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int count = 50;
        while (count > 0)//循环50次
        {
            count --;
            dispatch_async(dispatch_get_main_queue(), ^{
                int width = arc4random() % 15;
                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(- 50,0, 20 + width, 20 + width)];
                img.image = [UIImage imageNamed:@"sbCoin"];
                [self.superview.superview addSubview:img];
                int x = arc4random() % (100);
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                CGRect rect = [(CALayer*)[_awadBg.layer presentationLayer] frame];
                //UIBezierPath贝塞尔曲线
                CGPoint center = CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect)/2, CGRectGetMinY(rect) + CGRectGetHeight(rect)/2);
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(center.x + CGRectGetMinX(self.superview.frame) - 50 + x, center.y + CGRectGetMinY(self.frame)+CGRectGetMinY(self.superview.frame))];
                
                //在路径上添加一条贝塞尔曲线
                CGFloat scale = (SCREEN_WIDTH ) / 100;
                //在路径上添加一条曲线，需要指定路径经过点。
                CGFloat y = SCREEN_HEIGHT - 150;//快捷送礼相对纵坐标
                [path addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH - 70 + x * 0.2, y) controlPoint:CGPointMake(x * scale,- 250)];
                animation.removedOnCompletion = YES;
                animation.duration = 2;
                animation.path = path.CGPath;
                [img.layer addAnimation:animation forKey:@"curve"];
                //延迟变小动画
                [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
                    img.transform = CGAffineTransformMakeScale(0.5, 0.5);
                } completion:^(BOOL finished)
                 {
                     [img removeFromSuperview];
                 }];
            });
            [NSThread sleepForTimeInterval:0.02];//每个币延时0.02s发出
        }
    });
}

@end
