//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

#define kWXAppKey  @"3243242"

@interface WXApiManager() <WXApiDelegate>

@property (nonatomic, copy) ThirdAuthBlock respBlcok;

@end

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}
+ (BOOL)isAppInstalled
{
    return [WXApi isWXAppInstalled];
}

+ (void)registerApp
{
    [WXApi registerApp:kWXAppKey];
}

+ (void)sendAuthWithBlock:(ThirdAuthBlock)result
           withController:(UIViewController *)viewController
{
    WXApiManager *manager = [WXApiManager sharedManager];
    manager.respBlcok = result;
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"413e6ad8cae81487d315780b0a6717c0";
    
    [WXApi sendAuthReq:req viewController:viewController delegate:manager];
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


- (void)dealloc {
    self.delegate = nil;
    //[super dealloc];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    //分享
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == WXSuccess){
           //  [[SocketDataFormer sharedinstance]shareLiveSuccess:[Room currentRoom].watchingAnchor.uid];
            if (_delegate
                && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
                SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
                [_delegate managerDidRecvMessageResponse:messageResp];
            }
        }
        else if (resp.errCode == WXErrCodeUserCancel){
            NSLog(@"用户点击取消并返回");
        }
        else if (resp.errCode == WXErrCodeAuthDeny){
            NSLog(@"授权失败");
        }
    }
    //登录
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == WXSuccess){
            
            SendAuthResp *authResp = (SendAuthResp *)resp;
            if (self.respBlcok) {
                self.respBlcok(@"100", authResp.code,@"0");
            }
        }
        else if (resp.errCode == WXErrCodeUserCancel){
            NSLog(@"用户点击取消并返回");
            if (self.respBlcok) {
                self.respBlcok(@"100", @"1",@"0");
            }
        }
    }
    
    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }
    else  if ([resp isKindOfClass:[PayResp class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:resp];
        /*
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
        */
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end
