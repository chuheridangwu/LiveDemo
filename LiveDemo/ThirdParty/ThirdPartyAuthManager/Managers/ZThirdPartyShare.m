//
//  ZThirdPartyShare.m
//  9158
//
//  Created by tgkj on 16/9/29.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import "ZThirdPartyShare.h"
#import "AppDelegate.h"

//微信分享
#import "WXApiRequestHandler.h"
#import "WXApi.h"

//QQ分享
#import "QQApiRequestHandle.h"
#import <TencentOpenAPI/QQApiInterface.h>

//微博分享
#import "WXApiObject.h"
#import "WeiboSDK.h"

@implementation ZThirdPartyShare

+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static ZThirdPartyShare *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ZThirdPartyShare alloc] init];
    });
    return instance;
}


+ (BOOL)isInstallThirdParty:(int)thirdPartyType{
    if (thirdPartyType == wechatShare){
        if ([WXApi isWXAppInstalled]){
            return YES;
        }
    }
    else if (thirdPartyType == QQShare){
        if ([QQApiInterface isQQInstalled]){
            return YES;
        }
    }
    else if (thirdPartyType == weiboShare){
        if ([WeiboSDK isWeiboAppInstalled]){
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isInstallAnyThirdParty{
    if ([WXApi isWXAppInstalled] || [QQApiInterface isQQInstalled] || [WeiboSDK isWeiboAppInstalled]){
        return YES;
    }
    else{
        return NO;
    }
}

- (void)shareWithRoomidx:(int)useridx thirdPartyType:(ThirdPartyType)shareType{
    
//    NSString *urlString = [NSString stringWithFormat:@"%@?useridx=%d",kShareInfoUrl,useridx];
//    [NetBaseManager requestGETWithUrl:urlString withParams:nil andBlock:^(id result, NSError *error) {
//        if (!error){
//            NSLog(@"%@",result);
//            if ([result isKindOfClass:[NSDictionary class]]) {
//                int ref = [[result objectForKey:@"ref"] intValue];
//                if (ref == 0) {
//                    NSDictionary *dict = [result objectForKey:@"data"];
//                    int roomidx  = [[dict objectForKey:@"roomid"] intValue];
//                    int useridx  = [[dict objectForKey:@"useridx"] intValue];
//                    NSData *base64DataName = [NSData dataFromBase64String:[dict objectForKey:@"name"]];
//                    NSString *name = [[NSString alloc] initWithData:base64DataName encoding:NSUTF8StringEncoding];
//                    NSString *photo    = [dict objectForKey:@"myphoto"];
//                    NSData *base64DataContent = [NSData dataFromBase64String:[dict objectForKey:@"content"]];
//                    NSString *desc = [[NSString alloc] initWithData:base64DataContent encoding:NSUTF8StringEncoding];
//                    NSString *expand1  = [dict objectForKey:@"Expand1"];
//                    NSString *expand2  = [dict objectForKey:@"Expand2"];
//                    NSLog(@"%@,%@",expand1,expand2);
//    
//                    [self setSharedWithRoomidx:roomidx Useridx:useridx NickName:name Photo:photo Desc:desc ShareType:shareType];
//                }
//            }
//        }
//        else{
//            NSLog(@"%@",error);
//        }
//    }];
    _isSharing = YES;
     [self setSharedWithRoomidx:@"" Useridx:@"" NickName:@"" Photo:@"" Desc:@"" ShareType:shareType];
}
- (void)setSharedWithRoomidx:(int)roomidx Useridx:(int)userIdx NickName:(NSString *)name Photo:(NSString *)photo Desc:(NSString *)desc ShareType:(ThirdPartyType)shareType{
    //UIImage *shareImage = [UIImage imageNamed:[self getRandomphotos]];//随机图片
    UIImage *shareImage = [self imageWithImage:photo image:nil scaledToSize:CGSizeMake(200, 200)];
    NSString *urlString =  [NSString stringWithFormat:@"%@?useridx=%d",@"",userIdx];
    switch (shareType) {
        case wechatShare: //微信聊天
        {
            [WXApiRequestHandler sendLinkURL:urlString
                                     TagName:@"WECHAT_TAG_JUMP_SHOWRANK"
                                       Title:name
                                 Description:desc
                                  ThumbImage:shareImage
                                     InScene:WXSceneSession];
        }
            break;
        case friendShare: //微信朋友圈
        {
            [WXApiRequestHandler sendLinkURL:urlString
                                     TagName:@"WECHAT_TAG_JUMP_SHOWRANK"
                                       Title:desc
                                 Description:name
                                  ThumbImage:shareImage
                                     InScene:WXSceneTimeline];
        }
            break;
        case QQShare: //QQ聊天界面
        {
            [QQApiRequestHandle sendNewsObjectWithURL:[NSURL URLWithString:urlString]
                                                title:name
                                          description:desc
                                     previewImageData:[self dataFromImage:shareImage]
                                            shareType:QQShare];
        }
            break;
        case QZoneShare: //QQ空间
        {
            [QQApiRequestHandle sendNewsObjectWithURL:[NSURL URLWithString:urlString]
                                                title:name
                                          description:desc
                                     previewImageData:[self dataFromImage:shareImage]
                                            shareType:QZoneShare];
        }
            break;
        case weiboShare: //微博
        {
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = [self dataFromImage:shareImage];
            _isSharing = YES;
            WBMessageObject *message = [WBMessageObject message];
            message.text = [NSString stringWithFormat:@"%@%@",name,urlString];
            message.imageObject = imageObject;
            [WBProvideMessageForWeiboResponse responseWithMessage:message];
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        }
            break;
            
        default:
            break;
    }

}

- (void)shareH5URLString:(NSString *)string Title:(NSString *)title shareType:(ThirdPartyType)sharetype Adsmallpic:(NSString *)adsmallpic Contents:(NSString *)contents
{
    UIImage *shareImage = nil;
    if (adsmallpic == nil || [adsmallpic isEqualToString:@""]){
        shareImage = [UIImage imageNamed:[self getRandomphotos]];
    }else{
        shareImage = [self imageWithImage:adsmallpic image:nil scaledToSize:CGSizeMake(200, 200)];
    }
    if ([contents isEqualToString:@""] || contents == nil){
        contents = @"";
    }
    
    switch (sharetype) {
        case wechatShare: //微信聊天
        {
            [WXApiRequestHandler sendLinkURL:string
                                     TagName:@"WECHAT_TAG_JUMP_SHOWRANK"
                                       Title:title
                                 Description:contents
                                  ThumbImage:shareImage
                                     InScene:WXSceneSession];
        }
        
            break;
        case friendShare: //微信朋友圈
        {
            [WXApiRequestHandler sendLinkURL:string
                                     TagName:@"WECHAT_TAG_JUMP_SHOWRANK"
                                       Title:title
                                 Description:contents
                                  ThumbImage:shareImage
                                     InScene:WXSceneTimeline];
        }
            break;
        case QQShare: //QQ聊天界面
        {
            [QQApiRequestHandle sendNewsObjectWithURL:[NSURL URLWithString:string]
                                                title:title
                                          description:contents
                                     previewImageData:[self dataFromImage:shareImage]
                                            shareType:QQShare];
        }
            break;
        case QZoneShare: //QQ空间
        {
            [QQApiRequestHandle sendNewsObjectWithURL:[NSURL URLWithString:string]
                                                title:title
                                          description:contents
                                     previewImageData:[self dataFromImage:shareImage]
                                            shareType:QZoneShare];
        }
            break;
        case weiboShare: //微博
        {
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = [self dataFromImage:shareImage];
            _isSharing = YES;
            WBMessageObject *message = [WBMessageObject message];
            message.text = [NSString stringWithFormat:@"%@%@ \n%@",title,string,contents];
            message.imageObject = imageObject;
            [WBProvideMessageForWeiboResponse responseWithMessage:message];
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
            [WeiboSDK sendRequest:request];
        }
            break;
        default:
            break;
    }
}


//当前时间
- (NSString *)nowTimeString
{
    NSDate *date = [NSDate date];
    long a = (long)[date timeIntervalSince1970];
    NSNumber *number = [NSNumber numberWithLong:a];
    NSString *locationString = [NSString stringWithFormat:@"%@",number];
    return locationString;
}

//分享图片
- (void)shareWithImage:(UIImage *)image shareType:(ThirdPartyType)shareType{
    if (shareType == wechatShare || shareType == friendShare){ //微信
        UIImage *shareImage = [self imageWithImage:@"" image:image scaledToSize:CGSizeMake(200, 400)];
        if (shareType == wechatShare){
            [WXApiRequestHandler sendImageData:[self dataFromImage:image] TagName:@"9158视频" MessageExt:nil Action:nil ThumbImage:shareImage InScene:WXSceneSession];
        }
        else{
            [WXApiRequestHandler sendImageData:[self dataFromImage:image] TagName:@"9158视频" MessageExt:nil Action:nil ThumbImage:shareImage InScene:WXSceneTimeline];
        }
    }
    else if (shareType == QQShare || shareType == QZoneShare){ //QQ
        [QQApiRequestHandle  sendImageData:[self dataFromImage:image] title:nil description:nil previewImageData:nil shareType:shareType];
        if (shareType == QQShare){
        }
        else{
        }
    }
    else{ //微博
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = [self dataFromImage:image];
        WBMessageObject *message = [WBMessageObject message];
        message.imageObject = imageObject;
        [WBProvideMessageForWeiboResponse responseWithMessage:message];
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:request];
    }
}

//image转data
- (NSData *)dataFromImage:(UIImage *)image
{
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    return data;
}

//裁剪图片到指定尺寸
- (UIImage *)imageWithImage:(NSString *)imageStr image:(UIImage *)image
               scaledToSize:(CGSize)newSize;
{
    UIImage *tempImage = [UIImage imageNamed:@""];
    if (![imageStr isEqualToString:@""] && imageStr != nil && image == nil){
        NSData * dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
        tempImage = [UIImage imageWithData:dataImage];
    }else if (image != nil){
        tempImage = image;
    }
    
    UIGraphicsBeginImageContext(newSize);
    [tempImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data =  UIImageJPEGRepresentation(newImage, 0.8);
    return [UIImage imageWithData:data];
}

//得到随机图片
- (NSString *)getRandomphotos{
    int i = arc4random() % 8;
    NSArray *imagesArray = @[@"girl1",@"girl2",@"girl3",@"girl4",@"girl5",@"girl6",@"girl7",@"girl8"];
    return imagesArray[i];
}
@end
