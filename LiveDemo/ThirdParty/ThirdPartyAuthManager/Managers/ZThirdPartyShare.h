//
//  ZThirdPartyShare.h
//  9158
//
//  Created by tgkj on 16/9/29.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ThirdPartyType)
{
    wechatShare = 0, //微信
    friendShare,     //朋友圈
    QQShare,         //qq
    QZoneShare,      //qq空间
    weiboShare       //微博
};


@interface ZThirdPartyShare : NSObject
@property (nonatomic, assign) BOOL isSharing;

+(instancetype)sharedManager;

/*
 *  微信 微博 qq 是否有安装任何一个
 *
 *  @return  NO（都没有安装）
 */
+ (BOOL)isInstallAnyThirdParty;

/*
 *  是否安装   微信/微博/qq
 *
 *  @return  YES（安装了微信/微博/qq）
 */
+ (BOOL)isInstallThirdParty:(int)thirdPartyType;

/**
 *  分享主播内容到
 *
 *  @param  useridx:主播idx
 *  @param  shareType:第三方类型 QQ/WeiBo/WeChat
 */
- (void)shareWithRoomidx:(int)useridx thirdPartyType:(ThirdPartyType)shareType;

/**
 *  分享到图片到
 *
 *  @param  image:分享的图片
 *  @param  shareType:第三方类型 QQ/WeiBo/WeChat
 */
- (void)shareWithImage:(UIImage *)image shareType:(ThirdPartyType)shareType;



/**
 share H5活动页面

 @param string string description
 @param title title description
 @param sharetype sharetype description
 @param adsmallpic adsmallpic description
 @param contents contents description
 */
- (void)shareH5URLString:(NSString *)string Title:(NSString *)title shareType:(ThirdPartyType)sharetype Adsmallpic:(NSString *)adsmallpic Contents:(NSString *)contents;



@end
