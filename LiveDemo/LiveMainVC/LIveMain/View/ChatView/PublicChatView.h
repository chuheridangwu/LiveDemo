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

@interface PublicChatView : UIView


+ (void)showChatView;
@end
