//
//  LiveTopImageView.m
//  LiveDemo
//
//  Created by dym on 2017/8/8.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "LiveTopImageView.h"
#import "SHLongTitleLabel.h"
#import "UserListView.h"


@interface LiveTopImageView ()
@property (strong, nonatomic) UIView *anchorBgView;
@property (strong, nonatomic) UIImageView *anchorHeaderImage;
@property (nonatomic, strong) SHLongTitleLabel *anchorTitleLab;       //主播昵称
@property (nonatomic, strong) UIButton     *followdBtn;      //主播关注按钮
@property (nonatomic, strong)  SHLongTitleLabel *seeNumLab;



@property (nonatomic, strong) SHTopUserList         *topUserListView;     //上方用户列表
@property (nonatomic, strong) UserListView  *bigUserlistView; //观看用户列表


@end

@implementation LiveTopImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.anchorBgView];
        [self setIsFollowAnchor:YES];
        
        _topUserListView = [[SHTopUserList alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_anchorBgView.frame) + 5, 15, SCREEN_WIDTH - CGRectGetMaxX(_anchorBgView.frame) - 15, 45)];
        [self addSubview:_topUserListView];
    }
    return self;
}


// 关注
- (void)followAnchor{
    _followdBtn.hidden = YES;
    _followdBtn.frame  = CGRectMake(CGRectGetMaxX(_anchorTitleLab.frame)+5,5,_followdBtn.bounds.size.width, _followdBtn.bounds.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        _anchorBgView.frame  = CGRectMake(10, 19, 90, 43);
        _topUserListView.frame = CGRectMake(CGRectGetMaxX(_anchorBgView.frame) + 5, 15, SCREEN_WIDTH - CGRectGetMaxX(_anchorBgView.frame) - 15 - 0, 48);
        [_topUserListView frameDidChange];
    }];
}
     
     

- (void)setIsFollowAnchor:(BOOL)isFollowAnchor
{        _followdBtn.hidden = NO;
        _followdBtn.frame = CGRectMake(CGRectGetMaxX(_anchorTitleLab.frame) + 5,5, 45, _followdBtn.frame.size.height);
        [UIView animateWithDuration:0.5 animations:^{
            _anchorBgView.frame = CGRectMake(10, 19,CGRectGetMaxX(_followdBtn.frame) + 5 , 43);
            _topUserListView.frame = CGRectMake(CGRectGetMaxX(_anchorBgView.frame) + 5, 15, SCREEN_WIDTH - CGRectGetMaxX(_anchorBgView.frame) - 15 - 40, 48);
        }completion:^(BOOL finished) {
            _followdBtn.hidden = NO;
        }];
}

// 用户列表
- (void)showBigUserList{
    [self.vc.navigationController.view addSubview:self.bigUserlistView];
    [self.bigUserlistView showUserListView];
}

- (UserListView*)bigUserlistView
{
    if (!_bigUserlistView) {
        _bigUserlistView = [[UserListView alloc]init];
    }
    return _bigUserlistView;
}


- (UIView*)anchorBgView
{
    if (!_anchorBgView)
    {
        //主播头像
        _anchorBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 19, 80, 43)];
        _anchorBgView.userInteractionEnabled = YES;
        
        _anchorBgView.backgroundColor = UIColorFromRGBWithAlpha(0x000000, 0.3);
        
        _anchorBgView.layer.cornerRadius = 21.5;
        _anchorBgView.layer.masksToBounds = YES;
        [self addSubview:_anchorBgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigUserList)];
        [_anchorBgView addGestureRecognizer:tap];
        _anchorBgView.backgroundColor = [UIColor yellowColor];

        
        _anchorHeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 33, 33)];
        [_anchorHeaderImage sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502787779&di=b7b1cd13ec2e29b845551844eeb8e0f1&imgtype=jpg&er=1&src=http%3A%2F%2Fp6.qhimg.com%2Ft0129d3a419067a42bb.jpg"]];
        [_anchorBgView addSubview:_anchorHeaderImage];
        _anchorHeaderImage.layer.masksToBounds = YES;
        _anchorHeaderImage.layer.cornerRadius = _anchorHeaderImage.mj_h / 2;
        _anchorHeaderImage.userInteractionEnabled = YES;
        
        //主播昵称
        _anchorTitleLab = [[SHLongTitleLabel alloc]initWithFrame:CGRectMake(42, 5, 55, 16.5)];
        _anchorTitleLab.textAlignment = NSTextAlignmentLeft;
        _anchorTitleLab.textColor = [UIColor whiteColor];
        _anchorTitleLab.fontSize = 11;
        _anchorTitleLab.type = 3;
        _anchorTitleLab.isShow = YES;
        _anchorTitleLab.text = @"这是一个测试的主播昵称";
        [_anchorBgView addSubview:_anchorTitleLab];
        self.seeNumLab.backgroundColor = [UIColor clearColor];
        //关注按钮
        _followdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _followdBtn.hidden = YES;
        _followdBtn.backgroundColor = kSkinColor(1);
        _followdBtn.frame = CGRectMake(CGRectGetMaxX(_anchorTitleLab.frame)+5,6.5, 0, 30);
        _followdBtn.layer.cornerRadius = 15;
        _followdBtn.layer.masksToBounds = YES;
        
        [_followdBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_followdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _followdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_anchorBgView addSubview:_followdBtn];
        [_followdBtn addTarget:self action:@selector(followAnchor) forControlEvents:UIControlEventTouchUpInside];
    }
    return _anchorBgView;
}

- (SHLongTitleLabel *)seeNumLab
{
    if (!_seeNumLab) {
        _seeNumLab = [[SHLongTitleLabel alloc] initWithFrame:CGRectMake(42, 5+16.5, _anchorTitleLab.width, 16.5)];
        _seeNumLab.textAlignment = NSTextAlignmentLeft;
        _seeNumLab.textColor = [UIColor whiteColor];
        _seeNumLab.fontSize = 11;
        _seeNumLab.text = @"0";
        _seeNumLab.type = 3;
        _seeNumLab.isShow = YES;
        [_anchorBgView addSubview:_seeNumLab];
    }
    return _seeNumLab;
}

@end




//用户头像列表
@interface SHTopUserList()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,copy)NSMutableArray *dataArray;
@property (nonatomic,copy)NSDictionary *useerListDic;
@property (nonatomic,assign)BOOL canReload;
@property (nonatomic,strong)CAGradientLayer *maskLayer;
@property (nonatomic, assign)int layerType;
@property (nonatomic, assign)NSTimeInterval lastRefreshTime;
@end
@implementation SHTopUserList


- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        self = [super initWithFrame:frame];
        _layerType = -1;
        _lastRefreshTime = 0;
        [self refreshUsers];
        _dataArray = [NSMutableArray array];
        [self addUserListView];
        _canReload = YES;
    }
    return self;
}

- (void)refreshUsers {
    if (_lastRefreshTime == 0) {
        [self reloaduserList];
    }
    else {
        if ([[NSDate date] timeIntervalSince1970] - _lastRefreshTime < 2) {
            return;
        }
        [self stopRefresh];
        [self performSelector:@selector(reloaduserList) withObject:nil afterDelay:1.5];
    }
    _lastRefreshTime = [[NSDate date] timeIntervalSince1970];
}

- (void)reloaduserList
{
    WS(ws);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        for (int i = 0; i < 5000; i ++ ) {
            NSString *str  = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502787779&di=b7b1cd13ec2e29b845551844eeb8e0f1&imgtype=jpg&er=1&src=http%3A%2F%2Fp6.qhimg.com%2Ft0129d3a419067a42bb.jpg";
            [ws.dataArray addObject:str];
            if (ws.dataArray.count == i) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionView reloadData];
                });
            }
        }
        
    });
}

- (void)changeMaskLayerTransparent:(int)type
{
    if (_layerType == type) {
        return;
    }
    _layerType = type;
    if (type == 0) {
        _maskLayer.locations  = @[@(0), @(0.03), @(0.1)];
        _maskLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor];
    }
    else if (type == 1) {
        _maskLayer.locations  = @[@(0), @(0.03), @(0.1), @(0.9), @(0.93), @(1)];
        _maskLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor];
    }
    else {
        _maskLayer.locations  = @[@(0.9), @(0.93), @(1)];
        _maskLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,
                              (__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor];
    }
}

- (void)addUserListView
{
    _maskLayer = [CAGradientLayer layer];
    _maskLayer.startPoint = CGPointMake(1, 0);
    _maskLayer.endPoint   = CGPointMake(0, 0);
    [self changeMaskLayerTransparent:0];
    self.layer.mask = _maskLayer;
    
    UICollectionViewFlowLayout *layou = [[UICollectionViewFlowLayout alloc]init];
    layou.itemSize = CGSizeMake(40, 40);
    layou.minimumLineSpacing = 5;
    layou.minimumInteritemSpacing = 0;
    layou.sectionInset = UIEdgeInsetsMake(0, 0, 0, 20);
    layou.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layou];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    _maskLayer.frame = _collectionView.frame;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(touchDidMove:)];
    [self addGestureRecognizer:gesture];
}

- (void)frameDidChange
{
    _collectionView.frame = self.bounds;
    _maskLayer.frame = _collectionView.frame;
}

- (void)stopRefresh
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloaduserList) object:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
//    cell.backgroundColor  = [UIColor redColor];
    
    UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:cell.bounds];
    [cell.contentView addSubview:imgView1];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:cell.bounds];
//    imgView.clipsToBounds = YES;
    imgView.layer.borderWidth = 1.5;
//    imgView.layer.borderColor = [[UIColor whiteColor]CGColor];
    imgView.layer.cornerRadius = imgView.frame.size.width / 2;
    imgView.userInteractionEnabled = YES;
    [cell.contentView addSubview:imgView];
 
    
    NSString *item = _dataArray[indexPath.item];
    [imgView sd_setImageWithURL:[NSURL URLWithString:item] placeholderImage:[[UIImage imageNamed:@"placeholder_head"] cutCircleImage]];
    
    
    return cell;
}

//把点击事件代理出去
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    SHUserListCell *cell = (SHUserListCell*)[collectionView cellForItemAtIndexPath:indexPath];
//    if (_delegate && [_delegate respondsToSelector:@selector(didSelectItemWithUser:)])
//    {
//        [_delegate didSelectItemWithUser:cell.user];
//    }
}

- (void)touchDidMove:(UIPanGestureRecognizer*)gesture
{
    NSLog(@"1111111");
    switch (gesture.state)
    {
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
        {
            CGPoint point = [gesture velocityInView:self];
            if ((point.x / point.y > 1 || point.x / point.y))
            {
//                if (_delegate && [_delegate respondsToSelector:@selector(topUserListTouchDidMove:)]) {
//                    [_delegate topUserListTouchDidMove:gesture];
//                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        //        if (scrollView.contentOffset.x <= 0) {
        //            [self changeMaskLayerTransparent:0];
        //        }
        //        else if (scrollView.contentOffset.x >= scrollView.contentSize.width) {
        //            [self changeMaskLayerTransparent:2];
        //        }
        //        else {
        //            [self changeMaskLayerTransparent:1];
        //        }
    }
}

     

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

