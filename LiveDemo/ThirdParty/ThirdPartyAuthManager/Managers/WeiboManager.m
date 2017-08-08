//
//  WeiboManager.m
//  9158
//
//  Created by 翟振 on 2016/11/22.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import "WeiboManager.h"
#import "WeiboSDK.h"
//#import "WeiboUser.h"

#define kWBAppRedirectURL @"http://www.sina.com"


@interface WeiboManager() <WeiboSDKDelegate>

@property (nonatomic, copy) ThirdAuthBlock respBlcok;

@end

@implementation WeiboManager

+ (instancetype)manager
{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WeiboManager alloc] init];
    });
    return manager;
}

+ (BOOL)isAppInstalled
{
    return ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanSSOInWeiboApp]);
}

+ (void)registerApp
{
    if ([WeiboSDK registerApp:WBAppKey]) {
        NSLog(@"WeiboSDK registerApp OK");
    }
}

+ (void)sendAuthWithBlock:(ThirdAuthBlock)result
{
    WeiboManager *manager = [WeiboManager manager];
    manager.respBlcok = result;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWBAppRedirectURL;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:[WeiboManager manager]];
}

#pragma mark -
// 收到一个来自微博客户端程序的请求
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"didReceiveWeiboRequest");
}

// 收到一个来自微博客户端程序的响应
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            if (self.respBlcok) {
                self.respBlcok([(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],[(WBAuthorizeResponse *)response refreshToken]);
            }
            
        } else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
            if (self.respBlcok) {
                self.respBlcok(@"用户取消微博授权", @"1",@"0");
            }
        } else {//if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
            if (self.respBlcok) {
                self.respBlcok( @"微博授权失败", @"2", @"0");
            }
        }
    } else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {//分享
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            NSLog(@"分享成功");
        } else {
            if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
                
                [NSError errorWithDomain:@"用户取消微博分享" code:response.statusCode userInfo:nil];
            }
            
        }
    }
}




@end
