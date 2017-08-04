//
//  GiftContaierView.m
//  LiveDemo
//
//  Created by dym on 2017/8/2.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "GiftContaierView.h"
#import "Gift.h"
#import "MobileGiftView.h"

static GiftContaierView *gGiftContainer = nil;

@interface GiftContaierView ()
@property (nonatomic, strong)NSMutableArray *giftViewAry;

@end

@implementation GiftContaierView

+ (id)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (gGiftContainer == nil) {
            int height = 165;
            if (iPhone5) {
                height = 250 - (kPublicHeight  - 165);
            }else if (iPhone6){
                height = 335 - (kPublicHeight - 165);
            }else if (iPhone6P){
                height = 420 - (kPublicHeight - 165);
            }
            gGiftContainer = [[GiftContaierView alloc]initWithFrame:CGRectMake(10, 0, 45, height)];
        }
    });

    return gGiftContainer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initView];
    }
    return self;
}

- (void)initView{
    if (_giftViewAry) {
        [_giftViewAry removeAllObjects];
    }else{
        _giftViewAry = [[NSMutableArray alloc]init];
    }
    
    CGRect rect = CGRectMake(-183, CGRectGetHeight(self.frame) - 85, 183, 45);
    for (int i = 0; i < [Room currentRoom].allowDisplayCount; i++) {
        MobileGiftView *giftView = [[MobileGiftView alloc] initWithFrame:rect];
        [giftView setHidden:YES];
        [self addSubview:giftView];
        [_giftViewAry addObject:giftView];
        rect.origin.y -= 85;
    }
    
}

- (void)showNextGift{
    Gift *gift = [[Gift alloc]init];
    [self showNextGift:gift];
    
    [self showLuckView];
}

- (void)showNextGift:(Gift *)preGift
{
    // 如果要可以显示的giftview都被占用了，就return
    BOOL hasFreeView = NO;
    for (int i = 0; i < [Room currentRoom].allowDisplayCount; i++) {
        if (i >= [_giftViewAry count]) {
            break;
        }
        MobileGiftView *giftView = [_giftViewAry objectAtIndex:i];
        if (giftView.hidden) {
            hasFreeView = YES;
            break;
        }
    }
    if (!hasFreeView) {
        return;
    }
    
    
    for (int i = 0; i < [Room currentRoom].allowDisplayCount; i++) {
        if (i >= [_giftViewAry count]) {
            return;
        }
        MobileGiftView *giftView = [_giftViewAry objectAtIndex:i];
        if (giftView.hidden) {
            [giftView showWithGift:nil];
            break;
        }
    }
    
}

// 显示中奖视图
- (void)showLuckView{
    for (int i = 0; i < [_giftViewAry count]; i++) {
        MobileGiftView *giftView = [_giftViewAry objectAtIndex:i];
        if (arc4random()%4 == i) {
           [giftView showLuckyView];
            break;
        }
   }
}


@end
