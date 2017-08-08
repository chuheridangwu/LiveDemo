//
//  UIView+UIViewEx.h
//  9158
//
//  Created by 陈奕涛 on 14-10-14.
//  Copyright (c) 2014年 com.tiange. All rights reserved.
//

#import <UIKit/UIKit.h>

//CGPoint CGRectGetCenter(CGRect rect);
//CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (UIViewEx)

@property CGPoint origin;
@property CGSize size;
@property CGFloat height;
@property CGFloat width;
@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end
