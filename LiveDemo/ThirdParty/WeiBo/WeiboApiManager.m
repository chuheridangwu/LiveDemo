//
//  WeiboApiManager.m
//  9158
//
//  Created by tgkj on 16/9/30.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import "WeiboApiManager.h"
@implementation WeiboApiManager
+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static WeiboApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WeiboApiManager alloc] init];
    });
    return instance;
}
#pragma -mark WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    //分享
    if([response isKindOfClass:[WBSendMessageToWeiboResponse class]]){
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess){
            NSLog(@"成功");
            
        }
        else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel){
            NSLog(@"取消");
        }
    }
    //登录
    else if([response isKindOfClass:[WBAuthorizeResponse class]]){
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            if (_delegate && [_delegate respondsToSelector:@selector(managerDidReceivedAuthResponse:)]){
                [_delegate managerDidReceivedAuthResponse:response];
            }
        }
        else if (response.statusCode ==  WeiboSDKResponseStatusCodeUserCancel){
            NSLog(@"用户取消授权登录");
        }
        else if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
            NSLog(@"授权失败");
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

@end
