//
//  ThirdPartyAuthManager.m
//  9158
//
//  Created by 翟振 on 2016/11/22.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import "ThirdPartyAuthManager.h"
#import "WXApiManager.h"
#import "WeiboManager.h"
#import "TencentManager.h"

#define CheckAuthType(auth, type) ((auth & (type)) == (type))

static ThirdAuthType sAuthType;

@implementation ThirdPartyAuthManager


+ (void)registerApp:(ThirdAuthType)authType
    withApplication:(UIApplication *)application
        withOptions:(NSDictionary *)launchOptions
{
    sAuthType = authType;
    if (CheckAuthType(sAuthType, ThirdAuthTencent)) {
        [[TencentManager manager] registerApp];
    }
    if (CheckAuthType(sAuthType, ThirdAuthWeibo)) {
        [WeiboManager registerApp];
    }
    if (CheckAuthType(sAuthType, ThirdAuthWeixin)) {
        [WXApiManager registerApp];
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url
          application:(UIApplication *)application
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
{
    if (CheckAuthType(sAuthType, ThirdAuthTencent)) {
        if ([TencentManager handleOpenURL:url]) {
            return TRUE;
        }
    }
    if (CheckAuthType(sAuthType, ThirdAuthWeibo)) {
        if ([WeiboManager handleOpenURL:url]) {
            return TRUE;
        }
    }
    if (CheckAuthType(sAuthType, ThirdAuthWeixin)) {
        if ([WXApiManager handleOpenURL:url]) {
            return TRUE;
        }
    }
    return FALSE;
}


+ (BOOL)isAppInstalled:(ThirdAuthType)authType
{
    BOOL ret = FALSE;
    switch (authType) {
        case ThirdAuthTencent: {
            ret = [TencentManager isAppInstalled];
            break;
        }
        case ThirdAuthWeibo: {
            ret = [WeiboManager isAppInstalled];
            break;
        }
        case ThirdAuthWeixin: {
            ret = [WXApiManager isAppInstalled];
            break;
        }
        default:
            break;
    }
    return ret;
}


+ (void)sendAuthType:(ThirdAuthType)authType
           withBlock:(ThirdAuthBlock)result
      withController:(UIViewController *)vc
{
    switch (authType) {
        case ThirdAuthTencent: {
            [TencentManager sendAuthWithBlock:result];
            break;
        }
        case ThirdAuthWeibo: {
            [WeiboManager sendAuthWithBlock:result];
            break;
        }
        case ThirdAuthWeixin: {
            [WXApiManager sendAuthWithBlock:result withController:vc];
            break;
        }
        default:
            break;
    }
}


@end
