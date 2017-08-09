//
//  RightAnchorListView.m
//  LiveDemo
//
//  Created by dym on 2017/8/4.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "RightAnchorListView.h"
#import "YZLiveItem.h"
#import "YZCreatorItem.h"


static NSString *identifi = @"anchorList";


@interface RightAnchorListView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,copy)NSArray *dataArray;


@end

@implementation RightAnchorListView


- (instancetype)initWithFrame:(CGRect)frame{
    CGFloat width = 75;
    if (iPhone5) {
        width = 65;
    }
    frame = CGRectMake(SCREEN_WIDTH, 48, width, SCREEN_HEIGHT - 224);
    if (self = [super initWithFrame:frame]){
        [self addListView];
    
    }
    return self;
}

- (void)addListView{
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bgView];
    
    //  设置渐变
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.frame = bgView.bounds;
    maskLayer.startPoint = CGPointMake(0, 1);
    maskLayer.endPoint   = CGPointMake(0, 0);
    maskLayer.locations  = @[@(0), @(0.03), @(0.1)];
    maskLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,
                         (__bridge id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,
                         (__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor];
    bgView.layer.mask = maskLayer;
    
    UICollectionViewFlowLayout *layou = [[UICollectionViewFlowLayout alloc]init];
    CGFloat width = CGRectGetWidth(self.frame);
    layou.itemSize = CGSizeMake(width, width);
    layou.minimumLineSpacing = 20;
    layou.minimumInteritemSpacing = 0;
    layou.scrollDirection = UICollectionViewScrollDirectionVertical;
    layou.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    
    self.dataArray = [Room currentRoom].liveArray;
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layou];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifi];
    [bgView addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifi forIndexPath:indexPath];
    if([_dataArray count] <= indexPath.row)
        return cell;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:cell.bounds];
    imgView.clipsToBounds = YES;
    imgView.layer.borderWidth = 1.5;
    imgView.layer.borderColor = [[UIColor whiteColor]CGColor];
    imgView.layer.cornerRadius = self.frame.size.width / 2;
    imgView.userInteractionEnabled = YES;
    [cell.contentView addSubview:imgView];
    
    YZLiveItem *item = _dataArray[indexPath.item];
    [imgView sd_setImageWithURL:[NSURL URLWithString:item.creator.portrait]];
    
    return cell;
}

- (void)show
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(SCREEN_WIDTH - CGRectGetWidth(self.bounds) / 2, self.center.y);
    } completion:^(BOOL finished) {
    }];
}

- (void)close
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(SCREEN_WIDTH + CGRectGetWidth(self.bounds) / 2, self.center.y);
    } completion:^(BOOL finished) {
    }];
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YZLiveItem *item = _dataArray[indexPath.item];
    if (_selectBlock) {
        CGFloat pointX = CGRectGetMinX(self.frame);
        CGFloat pointY = pointY = 95 * indexPath.item + 5 - _collectionView.contentOffset.y;
        CGRect  headerRect = CGRectMake(pointX, pointY, 70, 70);
        
        _selectBlock(item.stream_addr,headerRect);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


@end
