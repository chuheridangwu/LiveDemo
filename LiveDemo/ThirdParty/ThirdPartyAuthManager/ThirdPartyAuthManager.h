//
//  ThirdPartyAuthManager.h
//  9158
//
//  Created by 翟振 on 2016/11/22.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, ThirdAuthType)
{
    ThirdAuthNone          = 0,
    
    ThirdAuthTencent       = 1 << 0,
    ThirdAuthWeibo         = 1 << 1,
    ThirdAuthWeixin        = 1 << 2,
    
    WMAuthAll = ThirdAuthTencent | ThirdAuthWeibo | ThirdAuthWeixin
};



/**
 * openID   qq的 openid  微博的 userID  微信 默认为 100
 * token    qq的 accesstoken  微博的 wbToken  微信 code
 * refreshToken  微博专用   qq 微信 默认为 0
 */

typedef void (^ThirdAuthBlock) (NSString *open_ID, NSString *token, NSString *refreshToken);

@interface ThirdPartyAuthManager : NSObject

// 用户手机是否安装对应第三方
+ (BOOL)isAppInstalled:(ThirdAuthType)thirdLoginType;


// 注册第三方
+ (void)registerApp:(ThirdAuthType)authType
    withApplication:(UIApplication *)application
        withOptions:(NSDictionary *)launchOptions;


// 第三方回调响应
+ (BOOL)handleOpenURL:(NSURL *)url
          application:(UIApplication *)application
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation;

// 发起对应第三方跳转登录
+ (void)sendAuthType:(ThirdAuthType)authType
           withBlock:(ThirdAuthBlock)result// 登录回调block，成功返回TRUE和ID，失败返回FALSE和错误信息
      withController:(UIViewController *)vc;//weixin专用


@end
