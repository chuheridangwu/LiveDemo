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


@interface LiveMainViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LiveSubViewController *liveSubVC;
@property (nonatomic, assign) BOOL delayStart;       // 在滚动结束后，设置延时加载RoomViewController

@property (nonatomic, copy) NSString *liveUrl;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger curIndex;
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
    //    _liveSubVC.delegate = self;
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

#pragma mark  --- lazy -----

- (void)backVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton*)closePlayerBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"roomPhone_icon_close"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.view.frame.size.width - 40, self.view.frame.size.height - 40, 30, 30);
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
