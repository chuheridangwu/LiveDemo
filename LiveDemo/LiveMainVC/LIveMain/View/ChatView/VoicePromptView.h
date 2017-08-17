//
//  VoicePromptView.h
//  LiveDemo
//
//  Created by dym on 2017/8/17.
//  Copyright © 2017年 dym. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VoiceTypeSpeaking = 0,  //说话中
    VoiceTypeCancel     //松手取消
}VoiceType;

@protocol VoicePromptDelegate <NSObject>

- (void)speakingCancel;
- (void)speakingSend;

@end

@interface VoicePromptView : UIView
@property (nonatomic, assign) VoiceType showType;
@property (nonatomic, assign) int volume;  //音量值
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) BOOL isShow;

- (id)initWithViceType:(VoiceType)type;
- (void)stopTimer;
@end
