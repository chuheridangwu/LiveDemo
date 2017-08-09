//
//  UserListView.m
//  LiveDemo
//
//  Created by dym on 2017/8/8.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "UserListView.h"
#import "UserLisetCell.h"

@interface UserListView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,UIScrollViewDelegate>


@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign)int selectCount;
@property (nonatomic,strong)NSMutableArray *deletArray;
@property (nonatomic,strong)  NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *roomOwnerArray;
//@property (nonatomic,strong)UIControl       *control;

@property (nonatomic,strong)UITextField      *textField;
@property (nonatomic,copy)NSDictionary      *userDic;
@property (nonatomic,strong)UIActionSheet   *actionSheet;


@end

@implementation UserListView

- (id)init
{
    if (self) {
        self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
        _dataArray = [NSMutableArray array];
        [self reloaduserList];
    }
    return self;
}

- (void)createSubView
{
    UIView *topNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 64)];
    topNavView.backgroundColor = [UIColor whiteColor];
    topNavView.userInteractionEnabled = YES;
    [self addSubview:topNavView];
    
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    titleLabel.center = CGPointMake(SCREEN_WIDTH / 2, 42);
    titleLabel.textColor = UIColorFromRGBWithAlpha(0x333333, 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"用户列表";
    [self addSubview:titleLabel];
    
    UIButton *choseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    choseBtn.frame = CGRectMake(SCREEN_HEIGHT - 50, 20, 50, 44);
    [choseBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [choseBtn setTitleColor:UIColorFromRGBWithAlpha(0x333333, 1) forState:UIControlStateNormal];
    [choseBtn addTarget:self action:@selector(choseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:choseBtn];
    
    UIView *topColorBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    topColorBgView.backgroundColor = UIColorFromRGBWithAlpha(0xefeff4, 1);
    [self addSubview:topColorBgView];
    
    UIView *searchBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 6, SCREEN_WIDTH - 20, 32)];
    searchBgView.backgroundColor = [UIColor whiteColor];
    searchBgView.layer.cornerRadius = 7;
    searchBgView.layer.masksToBounds = YES;
    searchBgView.layer.borderWidth = 0.5;
    searchBgView.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.4]CGColor];
    [topColorBgView addSubview:searchBgView];
    
    UIImageView *searIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(6, 4, 24, 24)];
    searIconImage.image = [UIImage imageNamed:@"input_search"];
    [searchBgView addSubview:searIconImage];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(36, 0, SCREEN_WIDTH - 46, 32)];
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.delegate = self;
    _textField.placeholder = @"搜索";
    _textField.returnKeyType = UIReturnKeySearch;
//    [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBgView addSubview:_textField];
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(touchDidMove:)];
    [self addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userDidTouch)];
    [topNavView addGestureRecognizer:tapGesture];
    [_collectionView addGestureRecognizer:tapGesture];
    
    UICollectionViewFlowLayout *layou = [[UICollectionViewFlowLayout alloc]init];
    layou.itemSize = CGSizeMake(65, 65);
    layou.minimumLineSpacing = 20;
    layou.minimumInteritemSpacing = 20;
    _selectCount = -1;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108 - 30) collectionViewLayout:layou];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UserLisetCell class] forCellWithReuseIdentifier:@"UserLisetCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
}

- (void)reloaduserList
{
    WS(ws);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        for (int i = 0; i < 5001; i ++ ) {
            NSString *str  = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502787779&di=b7b1cd13ec2e29b845551844eeb8e0f1&imgtype=jpg&er=1&src=http%3A%2F%2Fp6.qhimg.com%2Ft0129d3a419067a42bb.jpg";
            [ws.dataArray addObject:str];
            if (i == 5000) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionView reloadData];
                });
            }
        }
        
    });
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserLisetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserLisetCell" forIndexPath:indexPath];
    NSString *item = _dataArray[indexPath.item];
    [cell setUserImgURL:item];
    
    return cell;
}

- (void)userDidTouch{
    [self removeFromSuperview];
}

- (void)touchDidMove:(UIPanGestureRecognizer*)pan{
    
}

- (void)showUserListView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void)goBack{
    [_textField endEditing:YES];
    [self close];
}


- (void)choseBtnClick{
    [self endEditing:YES];
    [self.actionSheet showInView:self];
    SEL selector = NSSelectorFromString(@"_alertController");
    if ([self.actionSheet respondsToSelector:selector])
    {
        UIAlertController *alertController = [self.actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]])
        {
            alertController.view.tintColor = [UIColor blackColor];
        }
    }
}


- (void)close
{
//    if (_delegate && [_delegate respondsToSelector:@selector(roomScrollViewCanScrollEnable:)])
//    {
//        [_delegate roomScrollViewCanScrollEnable:YES];
//    }
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished) {
//        self.isShow = NO;
    }];
}


- (NSMutableArray*)deletArray
{
        if (!_deletArray) {
            _deletArray = [[NSMutableArray alloc]init];
        }
    return _deletArray;
}

@end
