//
//  DHWindowManager.h
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HTWindowType) {
    HTWindowTypeLogin = 1,
    HTWindowTypeContent = 2,
    HTWindowTypeBusiness = 3
};
@interface DHWindowManager : NSObject
@property (assign,nonatomic,readonly) HTWindowType activitiedWindowType;
@property (copy,nonatomic) void (^showContentCompletedBlock)(void);
@property (strong,nonatomic,readonly) UIWindow *contentWindow;
@property (strong,nonatomic,readonly) UIWindow *loginWindow;
@property (strong,nonatomic,readonly) UIWindow *luanchWindow;
@property (strong,nonatomic,readonly) UIWindow *beginnerWindow;

+ (DHWindowManager *)shareWindowManager;
/** 启动 */
- (void)luanch;
/** 调起登录Window */
- (void)showLoginWindowWithAnimated:(BOOL)animated;
/** 隐藏登录Window */
- (void)hideLoginWindow;
/** 重置主Window */
- (void)contentWindowReset;
@end
