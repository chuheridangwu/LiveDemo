//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "ThirdPartyAuthManager.h"
#import "WXApi.h"

#define WXAppKey    @"wx0c6d589dabfe919d"
//#define WXSecret    @"c454b6604b65cf4bb852fc4ac27cb50f"


// SystemConfiguration.framework,libz.dylib,libsqlite3.0.dylib

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, weak) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;


+ (BOOL)isAppInstalled;

+ (void)registerApp;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)sendAuthWithBlock:(ThirdAuthBlock)result
           withController:(UIViewController *)viewController;

@end
