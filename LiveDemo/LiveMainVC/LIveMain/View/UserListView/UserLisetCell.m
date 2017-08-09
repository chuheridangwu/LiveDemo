//
//  UserLisetCell.m
//  LiveDemo
//
//  Created by dym on 2017/8/9.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "UserLisetCell.h"

@interface UserLisetCell ()
@property (nonatomic,strong)    UIImageView *imgView;

@end

@implementation UserLisetCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        imgView.clipsToBounds = YES;
        imgView.layer.borderWidth = 1.5;
        imgView.layer.borderColor = [[UIColor whiteColor]CGColor];
        imgView.layer.cornerRadius = imgView.frame.size.width / 2;
        imgView.userInteractionEnabled = YES;
        [self.contentView addSubview:imgView];
        _imgView = imgView;
      
    
        
    }
    return self;
}

- (void)setUserImgURL:(NSString *)url{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:url]];
}


@end
