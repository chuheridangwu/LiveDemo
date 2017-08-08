//
//  WeiboManager.h
//  9158
//
//  Created by 翟振 on 2016/11/22.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThirdPartyAuthManager.h"

#define WBAppKey         @"1160842380"

//iOS 应用推荐使用默认授权回调页
#define kRedirectURI @"http://www.sina.com"

//QuartzCore.framework 、 ImageIO.framework 、 SystemConfiguration.framework 、 Security.framework 、CoreTelephony.framework 、 CoreText.framework 、 UIKit.framework 、 Foundation.framework 和 CoreGraphics.framework

@interface WeiboManager : NSObject

+ (BOOL)isAppInstalled;

+ (void)registerApp;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)sendAuthWithBlock:(ThirdAuthBlock)result;



@end
