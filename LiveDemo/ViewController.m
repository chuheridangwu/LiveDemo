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
    
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 50)];
    [btn1 setTitle:@"直播列表" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(changeCapture1) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn1];
    
    
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
