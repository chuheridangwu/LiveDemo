//
//  RoomImageView.m
//  9158Live
//
//  Created by lushuang on 16/4/1.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import "RoomImageView.h"

@interface RoomImageView()

@property (nonatomic, assign)NSInteger pageIndex;

@end

@implementation RoomImageView

- (id)initWithPageIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        _pageIndex = index;
    }
    
    return self;
}

- (void)setPageIndex:(NSInteger)index
{
    _pageIndex = index;
}

- (NSInteger)getPageIndex
{
    return _pageIndex;
}

@end
