//
//  ShareScreenshotView.h
//  9158Live
//
//  Created by zhongqing on 2016/12/9.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ButtonType) {
    shareWeiXin = 0,
    shareWeiXinFriend,
    shareQQ,
    shareWeiBo=4,
};

@protocol ShareScreenshotViewDelegate <NSObject>
/** 点击分享 */
- (void)clickButton:(ButtonType)nType;
/** 隐藏ShareScreenshotView */
- (void)hideShareScreenshotView:(BOOL)isHide;
/** 是否保存照片 */
- (void)savePhoto:(BOOL)isSave;
@end

@interface ShareScreenshotView : UIView

@property (nonatomic, weak) id<ShareScreenshotViewDelegate>delegate;

-(instancetype)initWithImage:(UIImage *)image shareImage:(UIImage *)shareImage;

-(void)show;

@end
