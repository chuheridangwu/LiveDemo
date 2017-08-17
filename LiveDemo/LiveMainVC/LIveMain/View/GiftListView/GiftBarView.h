//
//  GiftBarView.h
//  LiveDemo
//
//  Created by dym on 2017/8/17.
//  Copyright © 2017年 dym. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GiftBarViewDelegate <NSObject>
- (void)pushToRecharView;
- (void)giftBarWillShow;
//- (void)didSendGiftWithGift:(SHGiftObj*)gift toUser:(int)userIdx;
//- (void)giftBarReciveUserChange:(int)userIdx;
//- (void)giftDidChange:(SHGiftObj*)gift;
- (void)showRedPaperView;                   //发红包
- (void)closeSHGiftView;         //关闭自身
@end

@interface GiftBarView : UIView

@property (nonatomic,assign)int gifNum;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,weak)id <GiftBarViewDelegate>delegate;
@property (nonatomic,assign)BOOL isFirstIn;
- (void)show;
- (void)close;
//- (void)getData;
- (void)superviewDealloc;
- (id)initWithFrame:(CGRect)frame;

+ (GiftBarView*)shareGiftBar;
//+ (NSArray*)getGiftList;

@end
