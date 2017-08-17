//
//  PublicChatView.h
//  LiveDemo
//
//  Created by dym on 2017/8/8.
//  Copyright © 2017年 dym. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger)
{
    EditingTypeVoice,   //语音输入
    EditingTypeWrit,    //键盘输入
    EditingTypeSend     //准备发送
}EditingType;

@protocol XBPublicChatViewDelegate;
@interface PublicChatView : UIView
@property (nonatomic, assign) EditingType editType;
@property (nonatomic, strong) UIView *bottomBgView;

@property (nonatomic, weak) id<XBPublicChatViewDelegate> delegate;
@property (nonatomic, assign) BOOL isShow;


- (id)initWithSuperView:(UIView *)superView;


@end


@protocol XBPublicChatViewDelegate <NSObject>

- (void)touchPublicChatView;
//- (void)touchPublicUserNameWithUser:(User*)user;
- (void)touchPublicUrlWithUrlSting:(NSString*)urlString;
- (void)touchPublicshare;
- (void)publicChatViewShouldShow;
- (void)publicChatViewDidClose;

@end
