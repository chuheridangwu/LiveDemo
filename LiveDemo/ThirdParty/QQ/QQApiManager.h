//
//  QQApiManager.h
//  9158
//
//  Created by tgkj on 16/9/30.
//  Copyright © 2016年 com.tiange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface QQApiManager : NSObject <QQApiInterfaceDelegate>

+ (instancetype)sharedManager;

@end
