//
//  Imageproessing.m
//  LiveCL
//
//  Created by hztg on 15/11/30.
//  Copyright © 2015年 tiange. All rights reserved.
//

#import "ImageProessing.h"

@implementation ImageProessing

+(UIImage*) setImageCutNine:(NSString *)strPath
{
    UIImage *pImage     = [UIImage imageNamed:strPath];
    CGFloat top         = 20; // 顶端盖高度
    CGFloat bottom      = 20; // 底端盖高度
    CGFloat left        = 20; // 左端盖宽度
    CGFloat right       = 20; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    pImage              = [pImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    return pImage;
}


+(NSString*) saveImage:(UIImage *)image
     withFileName:(NSString *)imageName
           ofType:(NSString *)extension
      inDirectory:(NSString *)directoryPath
{
    NSString *strImgPath;
    if ([[extension lowercaseString] isEqualToString:@"png"])
    {
        strImgPath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]];
        [UIImagePNGRepresentation(image) writeToFile:strImgPath options:NSAtomicWrite error:nil];
        return strImgPath;
    }
    else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"])
    {
        strImgPath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]];
        BOOL bRet = [UIImageJPEGRepresentation(image, 1.0) writeToFile:strImgPath options:NSAtomicWrite error:nil];
        if (bRet) {
         return strImgPath;
        }
        return nil;
    }
    else
    {
        NSLog(@"文件后缀不认识");
    }
    return nil;
}

+(UIImage *) loadImage:(NSString *)filePath
{
    if (filePath == nil && filePath.length <= 0) {
        return nil;
    }
    NSString *strTemp;
    NSArray *paths       =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * plistPath = [paths objectAtIndex:0];
    
    NSRange nLen = [filePath rangeOfString:@"Documents" options:NSCaseInsensitiveSearch];
    
    strTemp = [ filePath substringFromIndex:nLen.length+nLen.location];
    
    //得到完整的文件名
    NSString* _mFilename = [plistPath stringByAppendingPathComponent:strTemp];
    
    UIImage * result = [UIImage imageWithContentsOfFile:_mFilename];
    
    return result;
}

+(UIImage*) blur:(UIImage*)theImage level:(int)level
{
    // create our blurred image
    CIContext *context          = [CIContext contextWithOptions:nil];
    CIImage *inputImage         = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"                           keysAndValues:kCIInputImageKey, inputImage,                                         @"inputRadius", @(level),nil];
    CIImage *outputImage = filter.outputImage;
    CGImageRef outImage = [context createCGImage:outputImage                                      fromRect:[inputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return image;
//    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
//    CGAffineTransform xform     = CGAffineTransformMakeScale(0.8, 0.8);
//    
//    [affineClampFilter setValue:inputImage forKey:kCIInputImageKey];
//    [affineClampFilter setValue:[NSValue valueWithBytes:&xform
//                                               objCType:@encode(CGAffineTransform)]
//                                                forKey:@"inputTransform"];
//    
//    CIImage *extendedImage = [affineClampFilter valueForKey:kCIOutputImageKey];
//    
//    // setting up Gaussian Blur (could use one of many filters offered by Core Image)
//    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [blurFilter setValue:extendedImage forKey:kCIInputImageKey];
//    [blurFilter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
//    
//    CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];
//    
//    // CIGaussianBlur has a tendency to shrink the image a little,
//    // this ensures it matches up exactly to the bounds of our original image
//    CGImageRef cgImage   = [context createCGImage:result fromRect:[inputImage extent]];
//
//    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
//    //create a UIImage for this function to "return" so that ARC can manage the memory of the blur...
//    //ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
//    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
//    
//    return returnImage;
}


//延中心点旋转
+(UIImage *)rotateImage:(UIImage *)aImage
{
    CGImageRef imgRef           = aImage.CGImage;
    CGFloat width               = CGImageGetWidth(imgRef);
    CGFloat height              = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds               = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio          = 1;
    CGFloat boundHeight;
    UIImageOrientation orient   = aImage.imageOrientation;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            break;
    }
    
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return imageCopy;
}

//镜像旋转
+(UIImage *) mirrorTheImage:(UIImage *)src
{
    CGRect rect = CGRectMake(0, 0, src.size.width , src.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextClipToRect(currentContext, rect);
    
    CGContextRotateCTM(currentContext, M_PI);
    CGContextTranslateCTM(currentContext, -rect.size.width, -rect.size.height);
    CGContextDrawImage(currentContext, rect, src.CGImage);
    UIImage *mirrorImage = UIGraphicsGetImageFromCurrentImageContext();
    return mirrorImage;
    
}
@end
