//
//  TencentManager.m
//  9158
//
//  Created by 翟振 on 2016/11/22.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import "TencentManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface TencentManager() <TencentSessionDelegate,QQApiInterfaceDelegate>

@property (nonatomic, copy) ThirdAuthBlock respBlcok;

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation TencentManager

+ (instancetype)manager
{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TencentManager alloc] init];
    });
    return manager;
}

+ (BOOL)isAppInstalled
{
    if (([TencentOAuth iphoneQQInstalled] && [TencentOAuth iphoneQQSupportSSOLogin])
        || ([TencentOAuth iphoneQZoneInstalled] && [TencentOAuth iphoneQZoneSupportSSOLogin])) {
        return TRUE;
    }
    return FALSE;
}

- (void)registerApp
{
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppID andDelegate:self];
}

+ (void)sendAuthWithBlock:(ThirdAuthBlock)result

{
    TencentManager *manager = [TencentManager manager];
    manager.respBlcok = result;
    
    NSArray *permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];
    [manager.tencentOAuth authorize:permissions];
//    [manager.tencentOAuth authorize:permissions inSafari:NO];
    //[manager.tencentOAuth authorize:permissions localAppId:QQAppID inSafari:NO];
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url] || [QQApiInterface handleOpenURL:url delegate:[TencentManager manager]];
}


#pragma mark - TencentLoginDelegate
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]) {
        if (self.respBlcok) {
            self.respBlcok( [_tencentOAuth openId], [_tencentOAuth accessToken], @"0");
        }
        [_tencentOAuth getUserInfo];
    } else {
        if (self.respBlcok) {
            self.respBlcok( @"QQ登录失败", @"0",@"0");
        }
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        if (self.respBlcok) {
            self.respBlcok( @"用户取消QQ登录", @"1" ,@"0");
        }
    } else {
        if (self.respBlcok) {
            self.respBlcok( @"QQ登录失败", @"2" ,@"0");
        }
    }
}

- (void)tencentDidNotNetWork
{
    if (self.respBlcok) {
        self.respBlcok(@"无网络连接，请设置网络", @"3", @"0");
    }
}

#pragma mark - QQApiInterfaceDelegate

- (void)onResp:(QQBaseResp *)resp{
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        if ([resp.result intValue] == -4) {
            NSLog(@"取消");
        }
        if ([resp.result intValue] == 0) {
            NSLog(@"成功");
        }
    }
}

- (void)onReq:(QQBaseReq *)req{
    
}
- (void)isOnlineResponse:(NSDictionary *)response{
    
}

@end
