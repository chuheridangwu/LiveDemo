//
//  WeiboApiManager.h
//  9158
//
//  Created by tgkj on 16/9/30.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
@protocol WeiboApiManagerDelegate <NSObject>

@optional
- (void)managerDidReceivedAuthResponse:(WBBaseResponse*)response;
- (void)managerDidReceivedSendMessageResponse:(WBBaseResponse*)response;

@end

@interface WeiboApiManager : NSObject<WeiboSDKDelegate>

@property (nonatomic, weak) id<WeiboApiManagerDelegate>delegate;

+(instancetype)sharedManager;

@end
