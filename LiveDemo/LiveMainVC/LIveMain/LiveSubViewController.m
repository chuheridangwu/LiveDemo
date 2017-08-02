//
//  LiveSubViewController.m
//  LiveDemo
//
//  Created by dym on 2017/8/1.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "LiveSubViewController.h"
#import "AdmireAnimationView.h"
#import <IJKMediaFramework/IJKMediaFramework.h>


@interface LiveSubViewController ()<UIScrollViewDelegate>

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

}



#pragma mark   --   点赞动画
- (void)tapAndima{
    [_admireAnimationView startWithLevel:1 number:1];
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
