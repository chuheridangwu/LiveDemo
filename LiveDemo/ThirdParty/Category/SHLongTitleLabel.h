//
//  SHLongTitleLabel.h
//  9158Live
//
//  Created by 123 on 16/5/4.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHLongTitleLabel : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor  *textColor;
@property (nonatomic, assign) CGFloat  fontSize;
@property (nonatomic, assign) BOOL isAnimate;
@property (nonatomic, assign) BOOL      isShow;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) UILabel  *titleLabel;

-(void)stopTimer;

@end
