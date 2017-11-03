//
//  AppDelegate+private.m
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "AppDelegate+private.h"
#import "UIView+Empty.h"
#import "DHWindowManager.h"
@implementation AppDelegate (private)
/**
 *  配置App相关
 *
 *  @param launchOptions 启动参数
 */
- (void)configApplication:(NSDictionary *)launchOptions {
    [CSToastManager setDefaultPosition:CSToastPositionCenter];
    [CSToastManager setQueueEnabled:NO];
    [UIView registerEmptyImage:@"img_empty"];
}

- (void)registerLoginedBlock{
    if ([DHWindowManager shareWindowManager].activitiedWindowType != HTWindowTypeContent){
        @weakify(self);
        [DHWindowManager shareWindowManager].showContentCompletedBlock = ^(){
            @strongify(self);
            if ([self respondsToSelector:NSSelectorFromString(@"uploadDevice")]){
                [self performSelectorInBackground:NSSelectorFromString(@"uploadDevice") withObject:nil];
            }
            if ([self respondsToSelector:NSSelectorFromString(@"refreshMessagePoint")]){
                [self performSelectorInBackground:NSSelectorFromString(@"refreshMessagePoint") withObject:nil];
            }
        };
    }
}

- (UIWindow *)window {
    switch ([DHWindowManager shareWindowManager].activitiedWindowType) {
        case HTWindowTypeLogin:
            return [DHWindowManager shareWindowManager].loginWindow;
            break;
        case HTWindowTypeContent:
            return [DHWindowManager shareWindowManager].contentWindow;
            break;
        case HTWindowTypeBusiness:
            return [DHWindowManager shareWindowManager].beginnerWindow;
            break;
        default:
            break;
    }
    return nil;
}

@end
