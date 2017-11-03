//
//  AppDelegate+NetWork.m
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/28.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "AppDelegate+NetWork.h"

@implementation AppDelegate (NetWork)
#pragma mark - 推送注册
- (void)uploadDevice {
//    if (![Helper isBlankString:[TSGlobal sharedGlobal].registerId]) {
//        [[[FTBindDeviceRequest alloc]init] sendRequest];
//    }
}

#pragma mark - App 更新
- (void)showUpdateView {
    
}
#pragma mark - 获取登录后的用户信息
- (void)fetchUserInfo {
//    [[[FTUserDetailRequest alloc] initWithOtherUserId:[TSGlobal sharedGlobal].userInfo.identification] sendRequest];
}

#pragma mark - 获取所有的收藏
- (void)fetchAllCollectAndAllLike {
//    FTGetAllTopicCollectRequest *getAllCollectRequest = [[FTGetAllTopicCollectRequest alloc]init];
//    [getAllCollectRequest sendRequest];
//    FTGetAllTopicLikeRequest *getAllLikeRequest = [[FTGetAllTopicLikeRequest alloc]init];
//    [getAllLikeRequest sendRequest];
}

- (void)ht_didFinishLaunching {
//#if !DEBUG
//    [self showUpdateView];
//#endif
//    [self uploadDevice];
//    if ([TSGlobal isLoggedIn] && [TSGlobal clazz].identification){
//        [self fetchSystemDic];
//    }
}

- (void)ht_applicationDidBecomeActive {
    
}


/**
 window改变
 */
- (void)ft_showContentCompletedHandler {
//    [self uploadDevice];
//    if ([TSGlobal isLoggedIn] && [TSGlobal clazz].identification){
//        [self fetchAllCollectAndAllLike];
//        //        [self waitScoreCount];
//    }
}

@end
