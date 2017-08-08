//
//  CombinationShareView.m
//  9158Live
//
//  Created by zhongqing on 2016/12/13.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import "CombinationShareView.h"


@interface CombinationShareView()

@property (nonatomic, strong) UIImageView *shotScreenImage;

@property (nonatomic, strong) UIImageView *bottonImage;

@property (nonatomic, strong) UIImageView *qrCodeImage;

@property (nonatomic, strong) UIImageView *qrCodeBk;

@end

@implementation CombinationShareView

-(instancetype)initWithImage:(UIImage *)image address:(NSString *)address
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {

        _shotScreenImage = [[UIImageView alloc] initWithFrame:self.frame];
        [_shotScreenImage setImage:image];
        [self addSubview:self.shotScreenImage];
        
        UIImage *bottomImg = [UIImage imageNamed:@"qrcode_icon"];
        self.bottonImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-bottomImg.size.height, SCREEN_WIDTH, bottomImg.size.height)];
        [_bottonImage setImage:bottomImg];
        [self addSubview:self.bottonImage];
        
        //二维码背景
        UIImage *qrCodeBkImg = [UIImage imageNamed:@"qrCode_bg"];
        self.qrCodeBk = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-qrCodeBkImg.size.width)/2+5, SCREEN_HEIGHT-(qrCodeBkImg.size.height+80), qrCodeBkImg.size.width, qrCodeBkImg.size.height)];
        [_qrCodeBk setImage:qrCodeBkImg];
        [self addSubview:self.qrCodeBk];
        
        //创建二维码
        CIImage *ciImage = [CombinationShareView createQRCode:address];
        UIImage *shareQRCode =[UIImage createNonInterpolatedUIImageFormCIImage:ciImage withSize:qrCodeBkImg.size.width-46];
//        二维码
        int y = (qrCodeBkImg.size.height - shareQRCode.size.height)/2;
        
        self.qrCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, y, shareQRCode.size.width, shareQRCode.size.height)];
        [_qrCodeImage setImage:shareQRCode];
        [self.qrCodeBk addSubview:self.qrCodeImage];
        
    }
    return self;
}

+ (CIImage*)createQRCode:(NSString *)str
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    [filter setValue:@"L" forKey: @"inputCorrectionLevel"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    return image;
}

@end
