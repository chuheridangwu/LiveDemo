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

#import <IJKMediaFramework/IJKMediaFramework.h>


@interface LiveSubViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@property (nonatomic, strong) UIView *clearBgView;  //可以被清除的View
@property (nonatomic, strong) AdmireAnimationView *admireAnimationView;

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
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 100, 100)];
    [self.clearBgView addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchDown];
    
    
    
    
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
- (void)panClearBgViewView:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan translationInView:self.clearBgView];
    NSLog(@"%ld", pan.state);
    if (point.y / point.x > 1 || point.y / point.x < -1) {
        
    }
    
    
}


#pragma mark   ----  清爽模式
- (void)panClearBgViewView{

}


- (void)endLive{
    // 界面消失，一定要记得停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
    _player = nil;
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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAndima)];
        [_clearBgView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panClearBgViewView:)];
        pan.delegate = self;
        [_clearBgView addGestureRecognizer:pan];
    }
    return _clearBgView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
