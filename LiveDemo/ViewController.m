//
//  ViewController.m
//  LiveDemo
//
//  Created by dym on 2017/7/31.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "ViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "UserLiveViewController.h"
#import "LiveListViewController.h"
#import "LiveSubViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:@"开播" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeCapture) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 250, 100, 50)];
    [btn1 setTitle:@"直播列表" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(changeCapture1) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 350, 150, 50)];
    [btn2 setTitle:@"观看自己直播" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(lookSelfLive) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn2];
    
//    UIView * view = [UIView alloc]initWithFrame:@{CGPointMake(100, 100):CGSizeMake(50, 50)};
    
}

- (void)changeCapture1{
    LiveListViewController *vc = [[LiveListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)changeCapture{
    UserLiveViewController *vc = [[UserLiveViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookSelfLive{
        LiveSubViewController *vc = [[LiveSubViewController alloc]init];
        vc.liveURL = @"rtmp://ks-uplive.app-remix.com/live/126079831822569889?accesskey=7W2tOoj2ImD7U6tzlDCw&expire=1501777583&public=1&vdoid=121171858611973966&signature=irJryfvFhmbh5bAvPIM9k27%2BrPg%3D";
        [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
