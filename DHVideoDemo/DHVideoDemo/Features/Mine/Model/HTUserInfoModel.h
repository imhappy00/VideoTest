//
//  HTUserInfoModel.h
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/28.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "BaseModel.h"

@interface HTUserInfoModel : BaseModel
@property (nonatomic, copy)   NSString *token;
/**
 ＊绑定手机号
 */
@property (nonatomic , copy)  NSString *bindPhone;
/**
 *  手机号
 */
@property (nonatomic , copy)  NSString *phone;
/**
 *  昵称
 */
@property (nonatomic , copy)  NSString *name;
/**
 *  用户名
 */
@property (nonatomic , copy)  NSString *username;
/**
 *  性别
 */
@property (nonatomic , copy)  NSString *sex;

@end
