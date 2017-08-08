//
//  QQApiRequestHandle.m
//  9158
//
//  Created by tgkj on 16/9/30.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import "QQApiRequestHandle.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

@implementation QQApiRequestHandle

+(QQApiSendResultCode)sendNewsObjectWithURL:(NSURL*)url
                       title:(NSString*)title
                 description:(NSString*)description
             previewImageData:(NSData*)previewData
                   shareType:(NSUInteger)shareType{
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:url
                                                        title:title
                                                  description:description
                                              previewImageData:previewData];
    if (shareType == QQShare){
        [newsObj setCflag:kQQAPICtrlFlagQQShare];
    }
    else{
        [newsObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    }
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    if (shareType == QQShare){ //QQ聊天界面
        return [QQApiInterface sendReq:req];
    }
    else{//QQ空间
        return [QQApiInterface SendReqToQZone:req];
    }
}

+ (QQApiSendResultCode)sendImageData:(NSData *)imageData
                title:(NSString *)title
          description:(NSString *)description
     previewImageData:(NSData *)previewImageData
            shareType:(NSUInteger)shareType{
    QQApiImageObject *obj = [QQApiImageObject objectWithData:imageData
                                            previewImageData:previewImageData
                                                       title:title
                                                 description:description];
    if (shareType == QQShare) {//QQ聊天界面
        [obj setCflag: kQQAPICtrlFlagQQShare];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
        return [QQApiInterface sendReq:req];
    }
    else {//QQ空间
        [obj setCflag: kQQAPICtrlFlagQZoneShareOnStart];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
        return [QQApiInterface SendReqToQZone:req];
    }
}
@end
