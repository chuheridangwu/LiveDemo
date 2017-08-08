//
//  QQApiManager.m
//  9158
//
//  Created by tgkj on 16/9/30.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import "QQApiManager.h"

@implementation QQApiManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static QQApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[QQApiManager alloc] init];
    });
    return instance;
}

#pragma mark - QQApiInterfaceDelegate

- (void)onResp:(QQBaseResp *)resp{
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        if ([resp.result intValue] == -4) {
            //[DataStatistics shareData:[Room currentRoom].watchingAnchor.nUserIDx type:@"qq" result:2];
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
