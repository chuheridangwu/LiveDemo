//
//  RoomImageView.h
//  9158Live
//
//  Created by lushuang on 16/4/1.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomImageView : UIImageView

- (id)initWithPageIndex:(NSInteger)index;
- (void)setPageIndex:(NSInteger)index;
- (NSInteger)getPageIndex;

@end
