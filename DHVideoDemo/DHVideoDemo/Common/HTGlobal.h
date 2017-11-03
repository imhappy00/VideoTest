//
//  HTGlobal.h
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/28.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import "HTUserInfoModel.h"
@interface HTGlobal : BaseModel
/**
 *  用户名
 */
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *password;

/**
 *  当前用户信息
 */
@property (strong, nonatomic) HTUserInfoModel *userInfo;

@property (assign, nonatomic) BOOL isUploadDevice;
@property (assign, nonatomic) NSInteger luanchCounts;/**
 *  是否已经登录
 *
 *  @return
 */
+ (BOOL)isLoggedIn;
+ (void)logout;
+ (NSString *)userId;
+ (NSString *)token;
+ (void)archived;
@end
