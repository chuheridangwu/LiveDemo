//
//  LiveSubViewController.m
//  LiveDemo
//
//  Created by dym on 2017/8/1.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "LiveSubViewController.h"
#import "AdmireAnimationView.h"
#import "GiftContaierView.h"
#import "RightAnchorListView.h"
#import "LiveBottonBtnView.h"
#import "LiveTopImageView.h"

#import "CombinationShotScreen.h"
#import "ShareScreenshotView.h"
#import "CombinationShareView.h"
#import "UserListView.h"
#import "PublicChatView.h"



#import <IJKMediaFramework/IJKMediaFramework.h>


@interface LiveSubViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,LiveBottonBtnViewDelegate,ShareScreenshotViewDelegate,XBPublicChatViewDelegate>
@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@property (nonatomic, assign) BOOL                  clearViewShow;        //标记是否清爽模式
@property (nonatomic, assign) BOOL               rightListShow;           //主播列表是否显示
@property (nonatomic, assign) CGFloat               MoveStarX;            //麦序开始移动的X

@property (nonatomic, assign) movingType            movingType;


@property (nonatomic, strong) AdmireAnimationView *admireAnimationView; //点赞动画
@property (nonatomic, strong) RightAnchorListView *rightAnchorListView; //右边公麦私麦列表
@property (nonatomic, strong) LiveBottonBtnView *bottonView; //底部按钮
@property (nonatomic, strong) UIImage *shareImage;  //截图分享的图片
@property (nonatomic, strong) ShareScreenshotView    *shareShotScreen;//截屏
@property (nonatomic, strong) LiveTopImageView  *topUserListView; //头部用户列表
@property (nonatomic, strong) PublicChatView  *chatView; //文字输入
@end

@implementation LiveSubViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 界面消失，一定要记得停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
    _player = nil;
    [_player.view removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.player.view];
    [self.view addSubview:self.clearBgView];
    _admireAnimationView = [[AdmireAnimationView alloc]initWithSuperView:self.view];

    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 40, 40)];
    [self.clearBgView addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"talk_public"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchDown];
    
    [self.clearBgView addSubview:self.bottonView];
    [self.clearBgView addSubview:self.topUserListView];
    [self.clearBgView addSubview:self.chatView];

    
    GiftContaierView *containerView = [GiftContaierView sharedInstance];
    [containerView setFrame:CGRectMake(10, SCREEN_HEIGHT - 150 + 31 - CGRectGetHeight(containerView.frame), 45, CGRectGetHeight(containerView.frame))];
    [self.clearBgView addSubview:containerView];
    containerView.backgroundColor = [UIColor redColor];
    
    [self.clearBgView addSubview:self.rightAnchorListView];
    
  
    

    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(clearViewMoveToLeft:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
}

- (void)clickBtn{
    [[GiftContaierView sharedInstance]  showNextGift];
}

#pragma mark   --   点赞动画
- (void)showAnimation{
    [_admireAnimationView startWithLevel:1 number:1];
}


// 这个为了将上下滑动的手势传递到parent view
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [gestureRecognizer translationInView:self.view.superview];
        
        return fabs(translation.y) <= fabs(translation.x);
    }
    
    return YES;
}

#pragma mark -- 清爽模式下左滑
- (void)clearViewMoveToLeft:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan translationInView:self.view];
    NSLog(@"%ld", pan.state);
    if (point.y / point.x > 1 || point.y / point.x < -1) {
        
    }
    if (point.x < 0 && !_clearViewShow) {
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
                
                break;
            case UIGestureRecognizerStateChanged:
            {
                _clearBgView.center = CGPointMake(SCREEN_WIDTH + SCREEN_WIDTH / 2 + point.x, _clearBgView.center.y);
            }
                break;
                case UIGestureRecognizerStateEnded:
                
            {
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    _clearBgView.center = CGPointMake(_clearBgView.center.x > SCREEN_WIDTH * 5 / 4 ? SCREEN_WIDTH + SCREEN_WIDTH / 2 : SCREEN_WIDTH - SCREEN_WIDTH / 2, _clearBgView.center.y);
                } completion:^(BOOL finished) {
                    _clearViewShow = _clearBgView.center.x < SCREEN_WIDTH;
                }];
                
            }
                break;
            default:
                break;
        }
    }
    
    
}


#pragma mark  ---  滑动麦序或者礼物界面
- (void)touchDidMove:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan translationInView:self.view];
    switch (_movingType) {
        case movingTypeNone:
        {
            if (point.x / point.y > 1 || point.x / point.y < -1) {
                if (self.rightListShow || (!self.rightListShow && point.x < 0)) {
                    
                    _movingType = movingTypeMicroList;
                    [self rightListMoveAnimate:pan];
                }else{
                    
                    _movingType = movingTypeClearView;
                    [self clearViewMoveAnimate:pan];
                }
            }
        }
            break;
        case movingTypeMicroList:
        {
            [self rightListMoveAnimate:pan];
        }
            break;
        case movingTypeClearView:
        {
            [self clearViewMoveAnimate:pan];
        }
            break;
        default:
            break;
    }

}

//  清爽模式移动
- (void)clearViewMoveAnimate:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan translationInView:self.view];
    NSLog(@"%ld",pan.state);
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:
        {
            if (point.x >= 0) {
                _clearBgView.center = CGPointMake(SCREEN_WIDTH / 2 + point.x, _clearBgView.center.y);
            }
        }
            break;
            case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.2 animations:^{
                _clearBgView.center = CGPointMake(_clearBgView.center.x > SCREEN_WIDTH * 3 / 4 ? SCREEN_WIDTH + SCREEN_WIDTH / 2 : SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
            } completion:^(BOOL finished) {
                _clearViewShow = _clearBgView.center.x < SCREEN_WIDTH;
            }];
            _movingType = movingTypeNone;
        }
            
        default:
            break;
    }
}

// 麦序移动
- (void)rightListMoveAnimate:(UIPanGestureRecognizer*)pan{
    CGFloat itemWidth = CGRectGetWidth(self.rightAnchorListView.frame);
    CGPoint point1 = [pan translationInView:self.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _MoveStarX = self.rightAnchorListView.center.x;
            break;
        case UIGestureRecognizerStateChanged:
        {
            if ((self.rightAnchorListView.center.x > SCREEN_WIDTH - itemWidth / 2 && point1.x < 0) || (self.rightAnchorListView.center.x < SCREEN_WIDTH + itemWidth / 2 && point1.x > 0)) {
                self.rightAnchorListView.center = CGPointMake(_MoveStarX + point1.x / 2, self.rightAnchorListView.center.y);
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            _rightListShow = self.rightAnchorListView.center.x < SCREEN_WIDTH;
            [UIView animateWithDuration:0.2 animations:^{
                self.rightAnchorListView.center = CGPointMake(_rightListShow ? SCREEN_WIDTH - itemWidth / 2 : SCREEN_WIDTH + itemWidth / 2, self.rightAnchorListView.center.y);
            }];
            _movingType = movingTypeNone;
        }
            break;
        default:
            break;
    }
}



- (void)endLive{
    // 界面消失，一定要记得停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
    _player = nil;
    [_player.view removeFromSuperview];

}


- (void)refreshPlayAddress:(NSString*)address{
    [self endLive];
    _liveURL = address;
    [self.view insertSubview:self.player.view belowSubview:self.clearBgView];
}


 //
- (void)clickBtnIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
    switch (index) {
        case 0:
        {
            [self showPublicChatView];
        }
            break;
        case 1:
        {
            [self takeScreenshot];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ----  截屏
- (void)takeScreenshot{
    UIImage *image = [UIImage takeScreenshot];
    if(image){
        //分享的加水印图片
        self.shareImage = [UIImage addImage:image addMsakImage:[UIImage imageNamed:@"screenShot_img_9158live"] MaskImageRect:CGRectMake(SCREEN_WIDTH-10-197/2, 26.5, 197/2, 25)];;
        //分享组合视图
        CombinationShotScreen *shotView = [[CombinationShotScreen alloc] initWithImage:self.shareImage];
        UIImage *shotViewImg = [UIImage screenView:shotView];
        //分享视图
        if (_shareShotScreen) {
            [_shareShotScreen removeFromSuperview];
            _shareShotScreen = nil;
        }
        _shareShotScreen = [[ShareScreenshotView alloc] initWithImage:shotViewImg shareImage:self.shareImage];
        
        _shareShotScreen.delegate = self;
        
        [_shareShotScreen show];
       
        [[UIApplication sharedApplication].keyWindow addSubview:_shareShotScreen];
    }
}

#pragma mark -ShareScreenshotViewDelegate
/** 点击分享 */
- (void)clickButton:(ButtonType)nType
{
    [self shareShotScreenView:self.shareImage shareType:nType];
}
- (void)shareShotScreenView:(UIImage *)image shareType:(NSInteger)type
{
   
    CombinationShareView *combin = [[CombinationShareView alloc] initWithImage:image address:@""];
    image = [UIImage screenView:combin];
    
    [[ZThirdPartyShare sharedManager] shareWithImage:image shareType:type];
    [self closeShareShot];
}

/** 隐藏ShareScreenshotView */
- (void)hideShareScreenshotView:(BOOL)isHide
{
    
}
/** 是否保存照片 */
- (void)savePhoto:(BOOL)isSave
{
    [self closeShareShot];
}

- (void)closeShareShot
{
    if (_shareShotScreen) {
        [_shareShotScreen removeFromSuperview];
        _shareShotScreen = nil;
    }
}


#pragma mark  ---   聊天窗口
- (void)showPublicChatView{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillHideNotification object:nil];
    self.chatView.isShow = YES;
    self.chatView.bottomBgView.hidden = NO;
//    if([UIconfig sharedInstance].closeBtnState != CloseBtnPositionRightTop)
//        if (_delegate && [_delegate respondsToSelector:@selector(cancelBtnShouldHidden:)])
//        {
//            [_delegate cancelBtnShouldHidden:YES];
//        }
    [UIView animateWithDuration:0.2 animations:^{
        self.chatView.bottomBgView.frame = CGRectMake(0,SCREEN_HEIGHT - 50, SCREEN_WIDTH, 60);
    }];
}

- (void)keyboardChanged:(NSNotification *) notif{
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    NSDictionary *info = [notif userInfo];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    if (notif.name == UIKeyboardWillShowNotification) {
        self.clearBgView.mj_y =  - keyboardEndFrame.size.height ;
        
    }else{
        
        if (self.clearBgView.mj_y != 0)
        {
            self.clearBgView.mj_y = 0;
        }
    }
    [UIView commitAnimations];
}

#pragma mark  -- XBPublicChatViewDelegate
- (void)touchPublicChatView{
    if (![self creatShowView]) {
        [self showAnimation];
    }
}



/*
 * 确认弹出的控件，全收回
 */
- (bool)creatShowView
{
    BOOL isShareBtn = NO;
    bool haveShow = NO;
//    if (self.gifBar.isShow) {
//        [self.gifBar close];
//        haveShow = YES;
//    }
//    if (self.privateChatView.isShow) {
//        [self.privateChatView closeView];
//        haveShow = YES;
//    }
//    if (self.shareView.isShareViewShow)
//    {
//        [self.shareView close];
//        haveShow = YES;
//        isShareBtn = YES;
//    }
    if (self.chatView.isShow) {
        self.chatView.isShow = NO;
        haveShow = YES;
    }
//    if (_anchorView.isShow) {
//        self.chatViewTabBar.isDown = NO;
//        [self.chatViewTabBar leftAnchorTap];
//        haveShow = YES;
//    }
//    if (_settingBar && _settingBar.isShow) {
//        [_settingBar close];
//        haveShow = YES;
//    }
    
//    if (haveShow) {
//        [self isHiddenBottomView:NO];
//    }
//    roomCanScroll = YES;
//    
//    if (isShareBtn == NO) {
//        GiftContaierView *containerView = [GiftContaierView sharedInstance];
//        [containerView setFrame:CGRectMake(10, CGRectGetMinY(self.publicChatView.frame) - CGRectGetHeight(containerView.frame), 45, CGRectGetHeight(containerView.frame))];
//        [containerView changeDisplayCount:ROOM_BOTTOM_NONE];
//    }
    
    return haveShow;
}



#pragma mark    -------------    lazy
- (IJKFFMoviePlayerController *)player{
    if (!_player) {
        // 拉流地址
        NSURL *url = [NSURL URLWithString:_liveURL];

        // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
        IJKFFMoviePlayerController *playerVc = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
        
        // 准备播放
        [playerVc prepareToPlay];
        
        playerVc.view.frame = [UIScreen mainScreen].bounds;
        
        // 强引用，反正被销毁
        _player = playerVc;
        
    }
    return _player;
}


- (UIView*)clearBgView{
    if (!_clearBgView) {
        _clearBgView = [[UIView alloc]initWithFrame:self.view.bounds];
        _clearBgView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(touchDidMove:)];
        pan.delegate = self;
        [_clearBgView addGestureRecognizer:pan];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:self.view.bounds];
        [_clearBgView addSubview:btn];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(showAnimation) forControlEvents:UIControlEventTouchDown];
    }
    return _clearBgView;
}

- (RightAnchorListView*)rightAnchorListView{
    if (!_rightAnchorListView) {
        _rightAnchorListView = [[RightAnchorListView alloc]init];
        WS(ws);
        [_rightAnchorListView setSelectBlock:^(NSString *liveAddStr,CGRect rect){
            if ([ws.delegate respondsToSelector:@selector(switchAnchor:touchRect:)]) {
                [ws.delegate switchAnchor:liveAddStr touchRect:rect];
            }
        }];
        
    }
    return _rightAnchorListView;
}

- (LiveBottonBtnView*)bottonView{
    if (!_bottonView) {
        _bottonView = [[LiveBottonBtnView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.mj_w - 60, 40)];
        _bottonView.delegate = self;
    }
    return _bottonView;
}

- (LiveTopImageView*)topUserListView{
    if (!_topUserListView) {
        _topUserListView = [[LiveTopImageView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 55)];
        _topUserListView.vc = self;
    }
    return _topUserListView;
}

- (PublicChatView*)chatView{
    if (!_chatView) {
        _chatView = [[PublicChatView alloc]initWithSuperView:self.clearBgView];
        _chatView.delegate = self;
    }
    return _chatView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
