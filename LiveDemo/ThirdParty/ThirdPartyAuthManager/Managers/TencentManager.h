//
//  TencentManager.h
//  9158
//
//  Created by 翟振 on 2016/11/22.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThirdPartyAuthManager.h"

#define QQAppID     @"100523664"

// Security.framework”, “libiconv.dylib”，“SystemConfiguration.framework”，“CoreGraphics.Framework”、“libsqlite3.dylib”、“CoreTelephony.framework”、“libstdc++.dylib”、“libz.dylib”

@interface TencentManager : NSObject

- (void)registerApp;

+ (BOOL)isAppInstalled;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)sendAuthWithBlock:(ThirdAuthBlock)result;

+ (instancetype)manager;

@end
