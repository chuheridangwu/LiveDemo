//
//  LiveMainViewController.m
//  LiveDemo
//
//  Created by dym on 2017/8/1.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "LiveMainViewController.h"
#import "LiveSubViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "YZLiveItem.h"
#import "YZCreatorItem.h"

@interface LiveMainViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
@end

@implementation LiveMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:[self closePlayerBtn]];
    
    // 设置直播占位图片
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_live.creator.portrait]];
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    [_scrollView addSubview:_imageView];
    

    [_scrollView addSubview:self.player.view];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 界面消失，一定要记得停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
}


- (void)backVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton*)closePlayerBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"roomPhone_icon_close"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.view.frame.size.width - 40, self.view.frame.size.height - 40, 30, 30);
    return btn;
}

- (IJKFFMoviePlayerController *)player{
    if (!_player) {
        // 拉流地址
        NSURL *url = [NSURL URLWithString:_live.stream_addr];
        
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

- (UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 3);
    }
    return _scrollView;
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
