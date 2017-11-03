//
//  Helper+Validate.h
//  PublicProject
//
//  Created by verne on 16/6/20.
//  Copyright © 2016年 vernepung. All rights reserved.
//

#import "Helper.h"

@interface Helper (Validate)
/**
 @brief 是否是空字符串
 */
+ (BOOL)isBlankString:(NSString *)string;
/**
 @brief 是否为正数
 */
+ (BOOL)isPositiveNumber:(NSString *)numStr;
/**
 @brief 通过正则表达式判断是否是手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 @brief 是否为Int
 */
+ (BOOL)isPureInt:(NSString *)string;
+ (BOOL)isPureFloat:(NSString *)string;
/**
 @brief 通过正则表达式判断是否是身份证号码
 */
+ (BOOL)isValidIdentityCard: (NSString *)identityCard;
/**
 @brief 检查银行卡是否合法(Luhn算法)
 */
+ (BOOL)isValidCardNumber:(NSString *)cardNumber;
@end
