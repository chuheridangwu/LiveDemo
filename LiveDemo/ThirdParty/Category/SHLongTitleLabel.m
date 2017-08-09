//
//  SHLongTitleLabel.m
//  9158Live
//
//  Created by 123 on 16/5/4.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import "SHLongTitleLabel.h"
//#import "NSAttributedString+level.h"
@interface SHLongTitleLabel ()

@property (nonatomic,assign)CGFloat wateTime;
@property (nonatomic,assign)int  animateCount;
@property (nonatomic,assign)BOOL     endAnimate;
@end
@implementation SHLongTitleLabel

- (id)initWithFrame:(CGRect)frame
{
    if (self)
    {
        self = [super initWithFrame:frame];
        self.clipsToBounds = YES;
    }
    return self;
}

- (id)init
{
    if (self)
    {
        self = [super init];
        self.clipsToBounds = YES;
    }
    return self;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        if (_textColor)
        {
            _titleLabel.textColor = _textColor;
        }
        _titleLabel.textAlignment = _textAlignment;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.titleLabel.textColor = _textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    self.titleLabel.textAlignment = _textAlignment;
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    if (_text.length > 0)
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:_fontSize] range:NSMakeRange(0, _titleLabel.attributedText.length)];
        self.titleLabel.attributedText = str;
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    if (_isAnimate)
    {
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
        self.titleLabel.text = text;
        self.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
    
    
    [_titleLabel sizeToFit];
    if (CGRectGetWidth(_titleLabel.bounds) <= CGRectGetWidth(self.bounds))
    {
        _titleLabel.frame = self.bounds;
        _animateCount = 0;
        _isAnimate = NO;
    }
    else
    {
        _wateTime = _titleLabel.mj_w / self.mj_w * 3;
        _animateCount = 0;
        if (!_isAnimate) {
            _isAnimate = YES;
            [self starAnimating];
        }
        else
        {
            _titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_titleLabel.bounds),CGRectGetHeight(self.bounds));
        }
    }
}

- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    if (_isShow && _endAnimate && _isAnimate)
    {
        _endAnimate = NO;
        _animateCount = 0;
        [self starAnimating];
    }
}

- (void)starAnimating
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(starAnimating) object:nil];
    _titleLabel.frame = _animateCount == 0 ? CGRectMake(0, 0, CGRectGetWidth(_titleLabel.bounds), CGRectGetHeight(self.bounds)) : CGRectMake(CGRectGetWidth(self.bounds), 0, CGRectGetWidth(_titleLabel.bounds), CGRectGetHeight(self.bounds));
    WS(ws)
    if (!_isShow)
    {
        _titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_titleLabel.bounds), CGRectGetHeight(self.bounds));
        _endAnimate = YES;
        return;
    }
    [UIView animateWithDuration:_animateCount == 0 ? _wateTime : _wateTime + 3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        ws.titleLabel.frame = CGRectMake(- CGRectGetWidth(ws.titleLabel.bounds), 0, CGRectGetWidth(ws.titleLabel.bounds), CGRectGetHeight(ws.bounds));
    } completion:^(BOOL finished) {
        if (ws.isAnimate)
        {
            [ws performSelector:@selector(starAnimating) withObject:nil afterDelay:0.1];
        }
    }];
    _animateCount = 2;
}

- (void)dealloc
{
    NSLog(@"longDealloc");
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(starAnimating) object:nil];
//    _isAnimate = NO;
}

-(void)stopTimer
{
    if (_isAnimate) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(starAnimating) object:nil];
        _isAnimate = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
