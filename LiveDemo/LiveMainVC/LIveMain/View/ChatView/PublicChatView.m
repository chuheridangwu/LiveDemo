//
//  PublicChatView.m
//  LiveDemo
//
//  Created by dym on 2017/8/8.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "PublicChatView.h"
#import <iflyMSC/iflyMSC.h>
#import "VoicePromptView.h"

@interface PublicChatView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IFlySpeechRecognizerDelegate,UIScrollViewDelegate>
 @property (nonatomic, assign) UIView *superView;
@property (nonatomic, strong) UITableView *massageTableView;
@property (nonatomic, strong) UILabel  *swichTitleLab;
@property (nonatomic, strong) UIButton *swichBtn;
@property (nonatomic, strong) UIButton *functionBtn;  //功能按钮，切换输入方式
@property (strong, nonatomic) CAGradientLayer *maskLayer;
@property (nonatomic, strong) VoicePromptView *voicePromptView;


@property (nonatomic, strong) UIImageView *voiceRemindView;  //语音引导
@property (nonatomic, strong) UIView   *textFildBgView;
@property (nonatomic, strong) UIButton *totalBtn;     //全站弹幕开关
@property (nonatomic, strong) UITextField *textFild;
@property (nonatomic, strong) UIView *listenTouchView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *massageArray;

@property (nonatomic, assign) BOOL isCancel; //语音是否取消
@property (nonatomic, assign) BOOL     isSendBarrage;
@property (nonatomic, assign) int      barrageType;

@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@end

@implementation PublicChatView

- (id)initWithSuperView:(UIView *)superView
{
    if (self)
    {
        self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (kPublicHeight + kRoombottomHeight), SCREEN_WIDTH - 60, kPublicHeight)];
        _superView = superView;
        [self loadSubView];
//        _errorMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPublicHeight)];
//        _errorMessageView.userInteractionEnabled = NO;
//        [self addSubview:_errorMessageView];
//        _once = 0;
//        _isCancel = NO;
     
    }
    return self;
}

- (void)loadSubView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.bounds) - 20, kPublicHeight)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bgView];
    bgView.layer.mask = self.maskLayer;
    
    self.massageTableView = [[UITableView alloc]initWithFrame:bgView.bounds style:UITableViewStyleGrouped];
    self.massageTableView.backgroundColor = [UIColor clearColor];
    self.massageTableView.delegate = self;
    self.massageTableView.dataSource = self;
    self.massageTableView.rowHeight = 30;
    self.massageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.massageTableView.showsVerticalScrollIndicator = NO;
    
    [bgView addSubview:self.massageTableView];
    self.transform = CGAffineTransformMakeScale(1, 1);
    self.maskLayer.frame = self.massageTableView.frame;
    
    self.bottomBgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60)];
    self.bottomBgView.backgroundColor = UIColorFromRGBWithAlpha(0xefefef, 1);
    [_superView addSubview:self.bottomBgView];
    
    _swichBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _swichBtn.layer.cornerRadius = 5;
    _swichBtn.layer.masksToBounds = YES;
    _swichBtn.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.24]CGColor];
    _swichBtn.layer.borderWidth = 0.5;
    _swichBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [_swichBtn addTarget:self action:@selector(swichStateDidChange) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBgView addSubview:_swichBtn];
    [_swichBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomBgView).offset(5);
        make.width.offset(48);
        make.height.offset(32);
        make.centerY.equalTo(_bottomBgView).offset(-7);
    }];
    
    _swichTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, 34, 28)];
    _swichTitleLab.layer.cornerRadius = 5;
    _swichTitleLab.layer.masksToBounds = YES;
    _swichTitleLab.textAlignment = NSTextAlignmentCenter;
    _swichTitleLab.font = [UIFont systemFontOfSize:12];
    _swichTitleLab.text = @"喇叭";
    _swichTitleLab.backgroundColor = [UIColor whiteColor];
    _swichTitleLab.textColor = [UIColor colorWithWhite:0 alpha:0.4];
    [_swichBtn addSubview:_swichTitleLab];
    
    _functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_functionBtn setImage:[UIImage imageNamed:@"btn_keyboard"] forState:UIControlStateNormal];
    _functionBtn.backgroundColor = [UIColor yellowColor];
    _functionBtn.frame = CGRectMake(SCREEN_WIDTH - 56, 7.5, 46, 32);
    _functionBtn.layer.cornerRadius = 5;
    _functionBtn.layer.masksToBounds = YES;
    _functionBtn.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.24]CGColor];
    _functionBtn.layer.borderWidth = 0.5;
    [_functionBtn addTarget:self action:@selector(functionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomBgView addSubview:_functionBtn];
    
    _voiceRemindView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 284, CGRectGetHeight(self.bounds)-32, 274, 46)];
    [_voiceRemindView setImage:[UIImage imageNamed:@"voice_remind"]];
    [_voiceRemindView setAlpha:0];
    [self addSubview:_voiceRemindView];
    CGRect rect = _voiceRemindView.bounds;
    rect.size.height = 36;
    UILabel *voiceLabel = [[UILabel alloc] initWithFrame:rect];
    [voiceLabel setBackgroundColor:[UIColor clearColor]];
    [voiceLabel setFont:[UIFont systemFontOfSize:16]];
    [voiceLabel setTextAlignment:NSTextAlignmentCenter];
    [voiceLabel setTextColor:UIColorFromRGBWithAlpha(0xa65207, 1)];
    [voiceLabel setText:@"来试试语音输入，解放双手尽情撸"];
    [_voiceRemindView addSubview:voiceLabel];
    
    
    _textFildBgView = [[UIView alloc]init];
    _textFildBgView.backgroundColor = [UIColor whiteColor];
    _textFildBgView.layer.cornerRadius = 5;
    _textFildBgView.layer.masksToBounds = YES;
    _textFildBgView.clipsToBounds = NO;
    _textFildBgView.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.2]CGColor];
    _textFildBgView.layer.borderWidth = 0.5;
    [_bottomBgView addSubview:_textFildBgView];
    [_textFildBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_swichBtn.mas_right).offset(5);
        make.right.equalTo(_functionBtn.mas_left).offset(-10);
        make.top.equalTo(_bottomBgView).offset(7.5);
        make.height.offset(32);
    }];
    
    _totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _totalBtn.frame = CGRectMake(65, 14, 42, 18);
    [_totalBtn setTitle:@"房间" forState:UIControlStateNormal];
    [_totalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_totalBtn setImage:[UIImage imageNamed:@"barrage_change1"] forState:UIControlStateNormal];
    [_totalBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -17, 0, 3)];
    [_totalBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 29, 0, 4)];
    _totalBtn.backgroundColor = UIColorFromRGBWithAlpha(0xb3b3b3, 1);
    _totalBtn.layer.shadowOffset = CGSizeMake(0, 1);
    _totalBtn.layer.shadowColor = [UIColorFromRGBWithAlpha(0x36aacc, 1) CGColor];
    _totalBtn.layer.shadowRadius = 0;
    _totalBtn.layer.shadowOpacity = 1;
    _totalBtn.layer.cornerRadius = 5;
    _totalBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [_totalBtn addTarget:self action:@selector(totalBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _totalBtn.hidden = YES;
    [_bottomBgView addSubview:_totalBtn];
    
    _textFild = [[UITextField alloc]initWithFrame:CGRectMake(7, 1,SCREEN_WIDTH - 138, 30)];
    _textFild.font = [UIFont systemFontOfSize:14];
    _textFild.placeholder = @"说点什么吧";
    _textFild.returnKeyType = UIReturnKeySend;
    _textFild.delegate = self;
    [_textFildBgView addSubview:_textFild];
    [_textFild addTarget:self action:@selector(textFildTextDidChange) forControlEvents:UIControlEventEditingChanged];
    self.listenTouchView.hidden = NO;
    
    self.bottomBgView.hidden = YES;
    
//    _enterEffectView = [[SWEnterEffectView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 45, _MainScreen_Width - 75, 55)];
//    _enterEffectView.delegate = self;
//    [self addSubview:_enterEffectView];
//    
    self.editType = EditingTypeVoice;
    [_textFild resignFirstResponder];
    
 
    
    [self.massageArray addObject:@"1"];
    [self.massageArray addObject:@"2"];
    [self.massageArray addObject:@"3"];
    [self.massageArray addObject:@"4"];
    [self.massageArray addObject:@"5"];
    [self.massageArray addObject:@"1"];
    [self.massageArray addObject:@"2"];
    [self.massageArray addObject:@"3"];
    [self.massageArray addObject:@"4"];
    [self.massageArray addObject:@"5"];
    [self.massageArray addObject:@"1"];
    [self.massageArray addObject:@"2"];
    [self.massageArray addObject:@"3"];
    [self.massageArray addObject:@"4"];
    [self.massageArray addObject:@"5"];

    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publicCellDidTouchOther)];
    [_massageTableView addGestureRecognizer:gesture];
}

- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    self.bottomBgView.hidden = NO;
    if (_isShow) {
        [self showVoiceRemind];
        if (_editType != EditingTypeVoice) {
            [_textFild becomeFirstResponder];
        }
    }
    else
    {
        [self closeVoiceRemind];
        [_textFild endEditing:YES];
        [self closeMessageBubble];
        
        [_titleLabel setText:@"按住说话"];
        self.voicePromptView.isShow = NO;
        _listenTouchView.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"playerMute" object:@"1"];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomBgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60);
        }completion:^(BOOL finished) {
            self.bottomBgView.hidden = YES;
            if (_delegate && [_delegate respondsToSelector:@selector(publicChatViewDidClose)])
            {
                [_delegate publicChatViewDidClose];
            }
        }];
    }
}

- (void)setIsSendBarrage:(BOOL)isSendBarrage
{
    _isSendBarrage = isSendBarrage;
    if (_editType != EditingTypeVoice) {
        [_textFild becomeFirstResponder];
    }
    _totalBtn.hidden = !_isSendBarrage;
    if (_isSendBarrage) {
        [self totalBtnAnimationStart];
    }
    if (_isSendBarrage) {
        self.barrageType = self.barrageType + 3;
    }
    else{
        _textFildBgView.layer.borderColor =[[UIColor colorWithWhite:0 alpha:0.2]CGColor];
        [self closeMessageBubble];
    }
    [UIView animateWithDuration:0.2 animations:^{
        _textFild.frame = _isSendBarrage ? CGRectMake(43+11, 1, SCREEN_WIDTH - 174, 30) : CGRectMake(7, 1,SCREEN_WIDTH - 138, 30);
        if (_isSendBarrage)
        {
            _swichBtn.backgroundColor = UIColorFromRGBWithAlpha(0x9f670c, 1.0);
            _swichTitleLab.textColor = UIColorFromRGBWithAlpha(0x9f670c, 1.0);
            _swichTitleLab.frame = CGRectMake(12, 2, 34, 28);
        }else
        {
            _swichBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
            _swichTitleLab.textColor = [UIColor colorWithWhite:0 alpha:0.4];
            _swichTitleLab.frame = CGRectMake(2, 2, 34, 28);
            _textFild.placeholder = @"说点什么吧";
        }
    }];
}


- (void)totalBtnAnimationStart
{
    [UIView animateWithDuration:0.3 animations:^{
        _totalBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _totalBtn.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}

- (void)closeMessageBubble
{
//    if (_msgView && _msgView.alpha != 0) {
//        [UIView animateWithDuration:0.4 animations:^{
//            self.msgView.alpha = 0;
//        }];
//    }
}

- (void)textFildTextDidChange
{
    if (_editType == EditingTypeSend && _textFild.text.length == 0) {
        self.editType = EditingTypeWrit;
    }
    if (_editType == EditingTypeWrit && _textFild.text.length != 0) {
        self.editType = EditingTypeSend;
    }
}

- (void)closeVoiceRemind
{
    if (_voiceRemindView && _voiceRemindView.alpha != 0) {
        [UIView animateWithDuration:0.4 animations:^{
            self.voiceRemindView.alpha = 0;
        }];
    }
}


- (void)publicCellDidTouchOther
{
    NSLog(@"点击了其它地方");
    if (_delegate && [_delegate respondsToSelector:@selector(touchPublicChatView)])
    {
        [_delegate touchPublicChatView];
    }
}

- (void)showVoiceRemind
{
    return;
    NSString *show = [[NSUserDefaults standardUserDefaults]objectForKey:@"VoiceInputRemind"];
    if (!show || ![show isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES"forKey:@"VoiceInputRemind"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UIView animateWithDuration:0.4 animations:^{
            self.voiceRemindView.alpha = 1;
        }completion:^(BOOL finished) {
            [self performSelector:@selector(closeVoiceRemind) withObject:nil afterDelay:5];
        }];
    }
}

#pragma mark   -- 选择按钮
- (void)swichStateDidChange{
    self.isSendBarrage = !_isSendBarrage;
    [self changeTitleLabel];
}

- (void)changeTitleLabel {
    
    NSString *barrageCount= @"";
    if (_isSendBarrage) {
        switch (_barrageType % 3) {
            case 0:
            {
//                barrageCount = [GiftManager instense].barrageCion;
                if (!barrageCount || [barrageCount isEqualToString:@""]) {
                    barrageCount = @"100";
                }
            }
                break;
            case 1:
            {
//                barrageCount = [GiftManager instense].tolalBarrageCion;
                if (!barrageCount || [barrageCount isEqualToString:@""]) {
                    barrageCount = @"5万";
                }
            }
                break;
            case 2:
            {
//                barrageCount = [GiftManager instense].portalBarrageCion;
                if (!barrageCount || [barrageCount isEqualToString:@""]) {
                    barrageCount = @"打开传送门5万币/条";
                }
            }
                break;
                
            default:
                break;
        }
    }else{
        barrageCount = @"";
    }
    barrageCount = barrageCount.length > 0 ? [NSString stringWithFormat:@"(%@币/条)",barrageCount] : barrageCount;
    NSString *title = [NSString stringWithFormat:@"按住说话%@",barrageCount];
    NSMutableAttributedString *arrttibut = [[NSMutableAttributedString alloc]initWithString:title];
    [arrttibut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0 alpha:0.6] range:NSMakeRange(0, 4)];
    if (barrageCount.length > 0) {
        [arrttibut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0 alpha:0.4] range:NSMakeRange(4, title.length - 4)];
    }
    _titleLabel.attributedText = arrttibut;
}

- (void)functionBtnAction{
    [_voiceRemindView setHidden:YES];
    switch (self.editType) {
        case EditingTypeVoice:
        {
            self.editType = EditingTypeWrit;
//            [User currentUser].publicChatKeyboardType = EditingTypeWrit;
        }
            break;
        case EditingTypeWrit:
        {
            self.editType = EditingTypeVoice;
//            [User currentUser].publicChatKeyboardType = EditingTypeVoice;
        }
            break;
        case EditingTypeSend:
        {
            [self sendMassage];
        }
            break;
            
        default:
            break;
    }
}

- (void)setEditType:(EditingType)editType
{
    _editType = editType;
    _functionBtn.backgroundColor = _editType == EditingTypeSend ? kSkinColor(1.0) : [UIColor clearColor];
    [_functionBtn setTitle:_editType == EditingTypeSend ? @"发送" : @"" forState:UIControlStateNormal];
    [_functionBtn setTitleColor:kFontColor(1.0) forState:UIControlStateNormal];
    _functionBtn.titleLabel.font = kFont(15);
    _listenTouchView.hidden = _editType != EditingTypeVoice;
    switch (_editType) {
        case EditingTypeSend:
        {
            _functionBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 7.5, 50, 32);
            [_functionBtn setImage:nil forState:UIControlStateNormal];
            
            
        }
            break;
        case EditingTypeVoice:
        {
            _functionBtn.frame = CGRectMake(SCREEN_WIDTH - 56, 7.5, 46, 32);
            [_functionBtn setImage:[UIImage imageNamed:@"btn_keyboard"] forState:UIControlStateNormal];
            [_textFild resignFirstResponder];
            if (!_isSendBarrage) {
                _textFild.placeholder = @"说点什么吧";
            }
            else {
                self.barrageType = self.barrageType;
            }
        }
            break;
        case EditingTypeWrit:
        {
            _functionBtn.frame = CGRectMake(SCREEN_WIDTH - 56, 7.5, 46, 32);
            [_functionBtn setImage:[UIImage imageNamed:@"btn_speaking"] forState:UIControlStateNormal];
            [_textFild becomeFirstResponder];
        }
            break;
        default:
            break;
    }
    
}



- (void)sendMassage
{
    if ( _editType == EditingTypeSend) {
        self.editType = EditingTypeWrit;
    }
    NSString *msg = [[_textFild text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    msg =  [msg stringByReplacingOccurrencesOfString:@" " withString:@""];
    msg = [msg stringByReplacingOccurrencesOfString:@"﷽" withString:@""];

    [self.massageArray addObject:msg];
    [self.massageTableView reloadData];
    
}

- (void)totalBtnAction{
    self.barrageType = self.barrageType + 1;
}

#pragma mark  --- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.massageArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2343242"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"2343242"];
    }
    cell.textLabel.text = self.massageArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark - IFlySpeechRecognizerDelegate
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    //    _result =[NSString stringWithFormat:@"%@%@", _textView.text,resultString];
    NSString * resultFromJson =  [self stringFromJson:resultString];
    NSLog(@"%@",resultFromJson);
    _textFild.text = [NSString stringWithFormat:@"%@%@",_textFild.text,resultFromJson];
}

- (void) onError:(IFlySpeechError *) errorCode
{
    if (errorCode.errorCode == 0 && !_isCancel) {
        NSLog(@"zhaizhen 听写结束！");
        [self sendMassage];
    }
    _isCancel = NO;
}

- (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}


- (void) onVolumeChanged: (int)volume
{
    self.voicePromptView.volume = volume;
}

- (void) onCancel
{
    NSLog(@"zhaizhen 用户自己取消");
    _isCancel = YES;
}


#pragma mark  --
- (CAGradientLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAGradientLayer layer];
        _maskLayer.startPoint = CGPointMake(0, 0);
        _maskLayer.endPoint   = CGPointMake(0, 1);
        _maskLayer.locations  = @[@(0), @(0.03), @(0.1)];
        _maskLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor];
    }
    return _maskLayer;
}


- (NSMutableArray*)massageArray{
    if (!_massageArray) {
        _massageArray = [NSMutableArray array];
    }
    return _massageArray;
}

- (VoicePromptView*)voicePromptView
{
    if (!_voicePromptView) {
        _voicePromptView = [[VoicePromptView alloc]initWithViceType:VoiceTypeCancel];
        _voicePromptView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 );
        _voicePromptView.volume = 0;
        _voicePromptView.delegate = self;
        [_superView addSubview:_voicePromptView];
    }
    return _voicePromptView;
}


- (IFlySpeechRecognizer *)iFlySpeechRecognizer
{
    if (!_iFlySpeechRecognizer) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        _iFlySpeechRecognizer.delegate = self;
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //设置语言
        [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
    return _iFlySpeechRecognizer;
}

- (UIView*)listenTouchView
{
    if (!_listenTouchView) {
        _listenTouchView = [[UIView alloc]init];
        _listenTouchView.backgroundColor = [UIColor whiteColor];
        _listenTouchView.layer.cornerRadius = 5;
        _listenTouchView.layer.masksToBounds = YES;
        [_textFildBgView addSubview:_listenTouchView];
        [_listenTouchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_textFildBgView);
            make.top.equalTo(_textFildBgView);
            make.size.equalTo(_textFildBgView);
        }];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self changeTitleLabel];
        [_listenTouchView addSubview:_titleLabel];
        _titleLabel.textColor = kBlack(0.6);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_textFild);
        }];
        
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
        [_listenTouchView addGestureRecognizer:gesture];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
        [_listenTouchView addGestureRecognizer:longPress];
    }
    return _listenTouchView;
}

- (void)panGestureAction:(UIGestureRecognizer*)gesture
{
    _swichBtn.userInteractionEnabled = NO;
    _functionBtn.userInteractionEnabled = NO;
    
    CGPoint point = [gesture locationInView:gesture.view];
    static BOOL isSetting;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            isSetting = YES;
        }
        case UIGestureRecognizerStateChanged:
        {
            if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]] &&  gesture.state == UIGestureRecognizerStateBegan) {
                [self.iFlySpeechRecognizer cancel];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"playerMute" object:@"0"];
                //设置音频来源为麦克风
                [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
                
                //设置听写结果格式为json
                [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
                
                //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
                [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
                
                [_iFlySpeechRecognizer setDelegate:self];
                
                BOOL ret = [self.iFlySpeechRecognizer startListening];
                [_titleLabel setText:@"松开发送"];
            }
            if (isSetting && !self.voicePromptView.isShow) {
                isSetting = NO;
                self.voicePromptView.isShow = YES;
                _listenTouchView.backgroundColor = UIColorFromRGBWithAlpha(0xdbdbdb, 1);
            }
            if (point.y < -20) {
                self.voicePromptView.showType = VoiceTypeCancel;
                _isCancel = YES;
                [self.iFlySpeechRecognizer cancel];
                [_titleLabel setText:@"松开取消"];
            }else{
                self.voicePromptView.showType = VoiceTypeSpeaking;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            _swichBtn.userInteractionEnabled = YES;
            _functionBtn.userInteractionEnabled = YES;
            //            [_titleLabel setText:@"按住说话"];
            [self changeTitleLabel];
            self.voicePromptView.showType = VoiceTypeCancel;
            _listenTouchView.backgroundColor = [UIColor whiteColor];
            if (self.voicePromptView.isShow) {
                self.voicePromptView.isShow = NO;
                if (point.y < - 20) {
                    NSLog(@"zhaizhen 取消");
                    [self.iFlySpeechRecognizer cancel];
                    _isCancel = YES;
                }else{
                    NSLog(@"zhaizhen 发送");
                    _isCancel = NO;
                    [self.iFlySpeechRecognizer stopListening];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"playerMute" object:@"1"];
            }
            break;
        }
        default:
            break;
    }
}



















- (void)dealloc
{
    _textFild.delegate = nil;
//    _enterEffectView.delegate = nil;
    if (_voicePromptView) {
        [_voicePromptView stopTimer];
        _voicePromptView.delegate = nil;
    }
//    for (PublicChatCell *cell in self.massageTableView.visibleCells) {
//        cell.delegate = nil;
//    }
    self.massageTableView.delegate = nil;
}

@end
