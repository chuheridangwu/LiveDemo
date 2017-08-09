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
#import "ShowLiveViewController.h"

#import "iflyMSC/IFlyMSC.h"

@interface ViewController ()<IFlySpeechRecognizerDelegate>
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;

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
    
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(100, 450, 150, 50)];
    [btn3 setTitle:@"语音转文字" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(yuyin) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn3];
}

- (void)yuyin{
    //创建语音识别对象
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance]; //设置识别参数
    _iFlySpeechRecognizer.delegate = self;
    //设置为听写模式
    [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path 是录音文件名，设置 value 为 nil 或者为空取消保存，默认保存目录在 Library/cache 下。
    [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //启动识别服务
    [_iFlySpeechRecognizer startListening];
}


//IFlySpeechRecognizerDelegate 协议实现
//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    NSLog(@"识别结果返回代理  --- %@",results);
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    //    _result =[NSString stringWithFormat:@"%@%@", _textView.text,resultString];
    NSString * resultFromJson =  [self stringFromJson:resultString];
    NSLog(@"%@",resultFromJson);
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 300, 200, 30)];
    label.text = resultFromJson;
    [self.view addSubview:label];
}


- (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}

//识别会话结束返回代理
- (void)onError: (IFlySpeechError *) error{
    NSLog(@"识别会话结束返回代理");
}
//停止录音回调
- (void) onEndOfSpeech{
    NSLog(@"停止录音回调");
}
//开始录音回调
- (void) onBeginOfSpeech{
    NSLog(@"开始录音回调");
}
//音量回调函数
- (void) onVolumeChanged: (int)volume{
    NSLog(@"音量回调函数");
}
//会话取消回调
- (void) onCancel{
    NSLog(@"会话取消回调");
}


- (void)changeCapture1{
    LiveListViewController *vc = [[LiveListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)changeCapture{
//    UserLiveViewController *vc = [[UserLiveViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    ShowLiveViewController *showTimeVc = [UIStoryboard storyboardWithName:NSStringFromClass([ShowLiveViewController class]) bundle:nil].instantiateInitialViewController;
    [self presentViewController:showTimeVc animated:YES completion:nil];
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
