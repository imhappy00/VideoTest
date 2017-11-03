//
//  Helper+Utils.h
//  teacherSecretary
//
//  Created by user on 15/5/25.
//  Copyright (c) 2015年 teacherSecretary. All rights reserved.
// 

#import "Helper.h"
//#import "EnumMacro.h"

/**
 @brief 屏幕尺寸大小，暂时分四种
 */
typedef NS_ENUM(NSUInteger,APDeviceType){
    APDeviceClassical, //3.5寸
    APDeviceIPhone5, //4.0寸
    APDeviceIPhone6, //iPhone6
    APDeviceIPhone6Plus, //iPhone6 Plus
};

@interface Helper (Utils)
/**
 *	@brief 获取当前设备的UDID
 *
 */
+ (NSString*)getCurrentDeviceUDID;
/**
 *  @descrtion 拨打电话
 *
 *  @param phone 电话/手机号码
 */
+ (void)callPhoneWithPhoneNumber:(NSString *)phone;

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input;
/**
 @brief 获取设备类型，此方法根据设备屏幕大小来进行判断
 @note 屏幕大小参数：
 @note iPhone4s: 320 * 480  iPhone5: 320*568 iPhone6: 375*667 iPhone6Plus:414*736
 */
+ (APDeviceType)getDeciceType;

@end
