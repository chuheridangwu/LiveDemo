//
//  VoicePromptView.m
//  LiveDemo
//
//  Created by dym on 2017/8/17.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "VoicePromptView.h"

@interface VoicePromptView ()
@property (nonatomic, strong) UIView *speakingFlagView;
@property (nonatomic, strong) UIView *speakingCancelView;
@property (nonatomic, strong) UIImageView *volumeImage;
@property (nonatomic, strong) UILabel     *numberLabel;

@property (nonatomic, assign) int Countdown;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation VoicePromptView

- (id)initWithViceType:(VoiceType)type
{
    if (self) {
        self = [self initWithFrame:CGRectMake(0, 0, 150, 140)];
        self.showType = type;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        self = [super initWithFrame:frame];
        self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

- (UIView*)speakingFlagView
{
    if (!_speakingFlagView) {
        _speakingFlagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 140)];
        _speakingFlagView.backgroundColor = [UIColor clearColor];
        [self addSubview:_speakingFlagView];
        
        WS(ws);
        _volumeImage = [[UIImageView alloc]init];
        _volumeImage.image = [UIImage imageNamed:@"volume1"];
        [_speakingFlagView addSubview:_volumeImage];
        [_volumeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.speakingFlagView.mas_top).offset(23);
            make.centerX.equalTo(ws.speakingFlagView.mas_centerX).offset(0);
            make.width.offset(90);
            make.height.offset(70);
        }];
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = [UIFont systemFontOfSize:70];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.text = @"5";
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [_speakingFlagView addSubview:_numberLabel];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.speakingFlagView.mas_top).offset(23);
            make.centerX.equalTo(ws.speakingFlagView.mas_centerX).offset(0);
            make.width.offset(90);
            make.height.offset(70);
        }];
        _numberLabel.hidden = YES;
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"上滑取消";
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        [_speakingFlagView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.volumeImage.mas_bottom).offset(22);
            make.centerX.equalTo(ws.volumeImage.mas_centerX).offset(0);
        }];
        
        
    }
    return _speakingFlagView;
}

- (UIView*)speakingCancelView
{
    if (!_speakingCancelView) {
        _speakingCancelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 140)];
        _speakingCancelView.backgroundColor = [UIColor clearColor];
        [self addSubview:_speakingCancelView];
        
        WS(ws);
        UIImageView *cancel = [[UIImageView alloc]init];
        cancel.image = [UIImage imageNamed:@"spack_cancel"];
        [_speakingCancelView addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.speakingFlagView.mas_top).offset(23);
            make.centerX.equalTo(ws.speakingFlagView.mas_centerX).offset(0);
            make.width.offset(90);
            make.height.offset(70);
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"松开取消";
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        [_speakingCancelView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cancel.mas_bottom).offset(22);
            make.centerX.equalTo(cancel.mas_centerX).offset(0);
        }];
        
    }
    return _speakingCancelView;
}


- (void)setCountdown:(int)Countdown
{
    _Countdown = Countdown;
    if (_Countdown <=5) {
        _numberLabel.hidden = NO;
        _volumeImage.hidden = YES;
        _numberLabel.text = [NSString stringWithFormat:@"%d",_Countdown];
    }
}

- (void)setShowType:(VoiceType)showType
{
    if (_showType != VoiceTypeSpeaking && showType == VoiceTypeSpeaking) {
        _numberLabel.hidden = YES;
        _volumeImage.hidden = NO;
        self.Countdown = 15;
        [self stopTimer];
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(starCountdownAnimate) userInfo:nil repeats:YES];
        }
    }
    _showType = showType;
    if (_showType == VoiceTypeCancel && _timer) {
        [self stopTimer];
    }
    self.speakingFlagView.hidden = _showType == VoiceTypeSpeaking?NO:YES;
    self.speakingCancelView.hidden = _showType==VoiceTypeCancel?NO:YES;
    self.volume = 0;
}

- (void)setVolume:(int)volume
{
    _volume = volume;
    int voiceLevel = ceilf(volume / ( 30 / 4));
    if (voiceLevel == 0) {
        voiceLevel =1;
    }
    _volumeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"volume%d",voiceLevel]];
}

- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    self.hidden = !_isShow;
    if (!isShow) {
        [self stopTimer];
    }
    
}

- (void)starCountdownAnimate
{
    if (self.Countdown > 1) {
        self.Countdown = self.Countdown - 1;
    }else{
        [self stopTimer];
        self.isShow = NO;
        if ([_delegate respondsToSelector:@selector(speakingSend)]) {
            [_delegate speakingSend];
        }
    }
}


- (void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


- (void)dealloc
{
    [self stopTimer];
}

@end
