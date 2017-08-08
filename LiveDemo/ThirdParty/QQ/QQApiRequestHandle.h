//
//  QQApiRequestHandle.h
//  9158
//
//  Created by tgkj on 16/9/30.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
@interface QQApiRequestHandle : NSObject

/**
 *  用于分享新闻内容
 *
 *  @param url   视频内容的目标URL
 *  @param title 分享内容的标题
 *  @param description 分享内容的描述
 *  @param previewURL  分享内容的预览图像URL
 *  @param shareType   分享类型QQ/QZone
 *  @note  如果url为空，调用<code>QQApi#sendMessage:</code>时将返回FALSE
 */
+ (QQApiSendResultCode)sendNewsObjectWithURL:(NSURL*)url
                                       title:(NSString*)title
                                 description:(NSString*)description
                            previewImageURL:(NSURL*)previewUrl
                                   shareType:(NSUInteger)shareType;

+ (QQApiSendResultCode)sendNewsObjectWithURL:(NSURL*)url
                       title:(NSString*)title
                 description:(NSString*)description
             previewImageData:(NSData*)previewData
                   shareType:(NSUInteger)shareType;
/**
 *  用于分享图片内容
 */
+ (QQApiSendResultCode)sendImageData:(NSData *)imageData
                title:(NSString *)title
          description:(NSString *)description
     previewImageData:(NSData *)previewImageData
            shareType:(NSUInteger)shareType;

@end
