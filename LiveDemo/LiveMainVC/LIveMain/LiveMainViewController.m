//
//  LiveMainViewController.m
//  LiveDemo
//
//  Created by dym on 2017/8/1.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "LiveMainViewController.h"
#import "LiveSubViewController.h"
#import "YZLiveItem.h"
#import "YZCreatorItem.h"
#import "RoomImageView.h"


@interface LiveMainViewController ()<UIScrollViewDelegate,LiveSubViewControllerDelegate,CAAnimationDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LiveSubViewController *liveSubVC;
@property (nonatomic, assign) BOOL delayStart;       // 在滚动结束后，设置延时加载RoomViewController

@property (nonatomic, copy) NSString *liveUrl;

@property (nonatomic, strong) NSArray *dataArray;   // 数据源
@property (nonatomic, assign) NSInteger curIndex;

@property (nonatomic, strong) UIImageView *switchImageView; //切换的图片
@property (nonatomic, assign) CGRect touchRect;     //切换麦的位置


@end

@implementation LiveMainViewController

- (void)setDataSource:(NSArray*)source  curIndex:(NSInteger)curIndex{
    _dataArray = source;
    _curIndex = curIndex;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:[self closePlayerBtn]];
    
    [self resetScrollContent:_curIndex];
    
    YZLiveItem *item = [_dataArray objectAtIndex:_curIndex];
    _liveUrl = item.stream_addr;
    [self startEnterRoom];
}


- (void)startEnterRoom{
    _liveSubVC = [[LiveSubViewController alloc]init];
    [_liveSubVC endLive];
    _liveSubVC.liveURL = _liveUrl;
    [self addChildViewController:_liveSubVC];
    _liveSubVC.delegate = self;
    [_liveSubVC.view setFrame:CGRectMake(0, CGRectGetHeight(_scrollView.frame), CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    [_scrollView addSubview:_liveSubVC.view];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_delayStart) {
        _delayStart = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startEnterRoom) object:nil];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y == CGRectGetMaxY(_scrollView.frame) && _liveSubVC) {
        return;
    }
    
    if (_liveSubVC) {
        [_liveSubVC endLive];
        [_liveSubVC.view removeFromSuperview];
        [_liveSubVC removeFromParentViewController];
        _liveSubVC = nil;
    }
    
    if (scrollView.contentOffset.y == (2 * CGRectGetHeight(_scrollView.frame))) {  //往下翻一张
        _curIndex = [self validRoomIndex:_curIndex + 1];
        [self resetScrollContent:_curIndex];
    }else if (scrollView.contentOffset.y == 0){  //往上翻一张
        _curIndex = [self validRoomIndex:_curIndex - 1];
        [self resetScrollContent:_curIndex];
    }
    
    
    YZLiveItem *item = [_dataArray objectAtIndex:_curIndex];
    _liveUrl = item.stream_addr;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startEnterRoom) object:nil];
    [self performSelector:@selector(startEnterRoom) withObject:nil afterDelay:0.3];
    _delayStart = YES;
    
}

- (NSInteger)validRoomIndex:(NSInteger)index {
    
    if(index == -1)     //如果是往后话
        index = [_dataArray count] - 1;
    if(index == [_dataArray count])
        index = 0;
    
    return index;
}

- (void)resetScrollContent:(NSInteger)roomIndex{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_dataArray.count == 0) {
        return;
    }
    NSInteger preIndex = [self validRoomIndex:roomIndex -1];
    NSInteger nextIndex = [self validRoomIndex:roomIndex + 1];
    NSMutableArray *viewAry = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSInteger index = preIndex;
        if (i == 1) {
            index = roomIndex;
        }else if (i == 2){
            index = nextIndex;
        }
        
        UIImageView *imgView = [[RoomImageView alloc]initWithPageIndex:index];
        [imgView setFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) * i, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        YZLiveItem *item = [_dataArray objectAtIndex:index];
        [imgView sd_setImageWithURL:[NSURL URLWithString:item.creator.portrait] placeholderImage:[UIImage imageNamed:@""]];
        [_scrollView addSubview:imgView];
        [viewAry addObject:imgView];
    }

    [_scrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(_scrollView.frame))];
    if (_liveSubVC) {
        [_scrollView addSubview:_liveSubVC.view];
    }

}

#pragma mark  ---- LiveSubViewControllerDelegate  ------
- (void)switchAnchor:(NSString *)liveURL touchRect:(CGRect)rect{
    [_liveSubVC refreshPlayAddress:liveURL];
    _touchRect = rect;
    
    [_liveSubVC.view insertSubview:self.switchImageView belowSubview:_liveSubVC.clearBgView];
    [self addZoomLayer:self.switchImageView];
}

- (void)addZoomLayer:(UIView*)view{
    CGPoint finaPoint;
    finaPoint = CGPointMake(_touchRect.origin.x + _touchRect.size.width / 2.0, _touchRect.origin.y + _touchRect.size.height / 2.0 - SCREEN_HEIGHT);
    if (_touchRect.origin.y + _touchRect.size.height / 2.0 > SCREEN_HEIGHT / 2.0) {
        finaPoint = CGPointMake(_touchRect.origin.x + _touchRect.size.width / 2.0, _touchRect.origin.y + _touchRect.size.height / 2.0);
    }
    CGFloat radius = sqrt((finaPoint.x * finaPoint.x) + (finaPoint.y * finaPoint.y));
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(_touchRect, -radius, -radius)];
    UIBezierPath *maskStartBP = [UIBezierPath bezierPathWithOvalInRect:_touchRect];
    
    //创建一个CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath; // 将它的path指定为最终的path来避免在动画完成后回弹
    view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(maskFinalBP.CGPath);
    maskLayerAnimation.duration = 0.4f;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _switchImageView.layer.mask = nil;
    [_switchImageView removeFromSuperview];
    _touchRect = CGRectZero;
    
}


#pragma mark  --- lazy -----

- (void)backVC{
    if (_liveSubVC) {
        [_liveSubVC endLive];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton*)closePlayerBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"roomPhone_icon_close"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50, 35, 35);
    return btn;
}


- (UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 3);
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.frame.size.height) animated:NO];
    }
    return _scrollView;
}

- (UIImageView*)switchImageView{
    if (!_switchImageView) {
        _switchImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _switchImageView.contentMode = UIViewContentModeScaleAspectFill;
        YZLiveItem *item = [_dataArray objectAtIndex:_curIndex];        
        [_switchImageView sd_setImageWithURL:[NSURL URLWithString:item.creator.portrait] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _switchImageView.image = [ImageProessing blur:image level:20];
        }];
    }
    return _switchImageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 内存不足时，而且当前view不是正在显示的view，则把自己销毁
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
