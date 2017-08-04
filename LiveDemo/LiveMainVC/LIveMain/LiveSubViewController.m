//
//  LiveSubViewController.m
//  LiveDemo
//
//  Created by dym on 2017/8/1.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "LiveSubViewController.h"
#import "AdmireAnimationView.h"
#import "GiftContaierView.h"
#import "RightAnchorListView.h"

#import <IJKMediaFramework/IJKMediaFramework.h>


@interface LiveSubViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@property (nonatomic, assign) BOOL                  clearViewShow;        //标记是否清爽模式
@property (nonatomic, assign) BOOL               rightListShow;           //主播列表是否显示
@property (nonatomic, assign) CGFloat               MoveStarX;            //麦序开始移动的X

@property (nonatomic, assign) movingType            movingType;


@property (nonatomic, strong) UIView *clearBgView;  //滑动的View
@property (nonatomic, strong) AdmireAnimationView *admireAnimationView; //点赞动画
@property (nonatomic, strong) RightAnchorListView *rightAnchorListView; //右边公麦私麦列表


@end

@implementation LiveSubViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 界面消失，一定要记得停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
    _player = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.player.view];
    
    [self.view addSubview:self.clearBgView];
    
    _admireAnimationView = [[AdmireAnimationView alloc]initWithSuperView:self.view];

    GiftContaierView *containerView = [GiftContaierView sharedInstance];
    [containerView setFrame:CGRectMake(10, SCREEN_HEIGHT - 150 + 31 - CGRectGetHeight(containerView.frame), 45, CGRectGetHeight(containerView.frame))];
    [self.clearBgView addSubview:containerView];
    containerView.backgroundColor = [UIColor redColor];
    
    ;
    [self.clearBgView addSubview:self.rightAnchorListView];

    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 100, 100)];
    [self.clearBgView addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchDown];
    

    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(clearViewMoveToLeft:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
}

- (void)clickBtn{
    [[GiftContaierView sharedInstance]  showNextGift];
}

#pragma mark   --   点赞动画
- (void)tapAndima{
    [_admireAnimationView startWithLevel:1 number:1];
}


// 这个为了将上下滑动的手势传递到parent view
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [gestureRecognizer translationInView:self.view.superview];
        
        return fabs(translation.y) <= fabs(translation.x);
    }
    
    return YES;
}

#pragma mark -- 清爽模式下左滑
- (void)clearViewMoveToLeft:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan translationInView:self.view];
    NSLog(@"%ld", pan.state);
    if (point.y / point.x > 1 || point.y / point.x < -1) {
        
    }
    if (point.x < 0 && !_clearViewShow) {
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
                
                break;
            case UIGestureRecognizerStateChanged:
            {
                _clearBgView.center = CGPointMake(SCREEN_WIDTH + SCREEN_WIDTH / 2 + point.x, _clearBgView.center.y);
            }
                break;
                case UIGestureRecognizerStateEnded:
                
            {
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    _clearBgView.center = CGPointMake(_clearBgView.center.x > SCREEN_WIDTH * 5 / 4 ? SCREEN_WIDTH + SCREEN_WIDTH / 2 : SCREEN_WIDTH - SCREEN_WIDTH / 2, _clearBgView.center.y);
                } completion:^(BOOL finished) {
                    _clearViewShow = _clearBgView.center.x < SCREEN_WIDTH;
                }];
                
            }
                break;
            default:
                break;
        }
    }
    
    
}



- (void)touchDidMove:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan translationInView:self.view];
    if (point.x < 0 && !_rightListShow) {
        
        [_rightAnchorListView show];
        _rightListShow = YES;
        
    }else if (point.x > 0 && _rightListShow){
        [_rightAnchorListView close];
        _rightListShow = NO;
    }else {
        [self clearViewMoveAnimate:pan];
    }

}

#pragma mark   ----  清爽模式移动
- (void)clearViewMoveAnimate:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan translationInView:self.view];
    NSLog(@"%ld",pan.state);
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:
        {
            if (point.x >= 0) {
                _clearBgView.center = CGPointMake(SCREEN_WIDTH / 2 + point.x, _clearBgView.center.y);
            }
        }
            break;
            case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.2 animations:^{
                _clearBgView.center = CGPointMake(_clearBgView.center.x > SCREEN_WIDTH * 3 / 4 ? SCREEN_WIDTH + SCREEN_WIDTH / 2 : SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
            } completion:^(BOOL finished) {
                _clearViewShow = _clearBgView.center.x < SCREEN_WIDTH;
            }];
            _movingType = movingTypeNone;
        }
            
        default:
            break;
    }
}

// 麦序移动
- (void)rightListMoveAnimate:(UIPanGestureRecognizer*)pan{
    
}



- (void)endLive{
    // 界面消失，一定要记得停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
    _player = nil;
}


- (void)refreshPlayAddress:(NSString*)address{
    [self endLive];
    _liveURL = address;
    [self.view addSubview:self.player.view];
    [self.view sendSubviewToBack:self.player.view];
}

- (IJKFFMoviePlayerController *)player{
    if (!_player) {
        // 拉流地址
        NSURL *url = [NSURL URLWithString:_liveURL];

        //本地的拉流
//        NSURL *url = [NSURL URLWithString:@"rtmp://ks-uplive.app-remix.com/live/126079831822569889?accesskey=7W2tOoj2ImD7U6tzlDCw&expire=1501777583&public=1&vdoid=121171858611973966&signature=irJryfvFhmbh5bAvPIM9k27%2BrPg%3D"];
        // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
        IJKFFMoviePlayerController *playerVc = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
        
        // 准备播放
        [playerVc prepareToPlay];
        
        
        playerVc.view.frame = [UIScreen mainScreen].bounds;
        
        // 强引用，反正被销毁
        _player = playerVc;
        
    }
    return _player;
}





- (UIView*)clearBgView{
    if (!_clearBgView) {
        _clearBgView = [[UIView alloc]initWithFrame:self.view.bounds];
        _clearBgView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(touchDidMove:)];
        pan.delegate = self;
        [_clearBgView addGestureRecognizer:pan];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAndima)];
//        [_clearBgView addGestureRecognizer:tap];
    }
    return _clearBgView;
}

- (RightAnchorListView*)rightAnchorListView{
    if (!_rightAnchorListView) {
        _rightAnchorListView = [[RightAnchorListView alloc]init];
        WS(ws);
        [_rightAnchorListView setSelectBlock:^(NSString *liveAddStr){
            [ws refreshPlayAddress:liveAddStr];
        }];
        
    }
    return _rightAnchorListView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
