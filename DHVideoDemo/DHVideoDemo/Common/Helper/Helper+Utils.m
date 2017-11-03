//
//  Helper+Utils.m
//  APGroupLeader
//
//  Created by user on 15/5/25.
//  Copyright (c) 2015年 teacherSecretary. All rights reserved.
//

#import "Helper+Utils.h"
#import "OpenUDID.h"
#include <sys/utsname.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <objc/runtime.h>
#import "AppDelegate.h"
//#import "TSGlobal.h"

@implementation Helper (Utils)
/**
 *	@brief 获取当前设备的UDID
 *
 */
+ (NSString*)getCurrentDeviceUDID{
        return [OpenUDID value];
}

+ (void)callPhoneWithPhoneNumber:(NSString *)phone
{
    openUrlInSafari([NSString stringWithFormat:@"telprompt:%@",phone]);
}

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (APDeviceType)getDeciceType{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if(screenSize.width == 320.0f && screenSize.height == 568.0f){
        return APDeviceIPhone5;
    }
    else if(screenSize.width == 375.0f){
        return APDeviceIPhone6;
    }
    else if(screenSize.width == 414.0f){
        return APDeviceIPhone6Plus;
    }
    return APDeviceClassical;
}

//+ (NSString *)getShareUrlWithCode:(NSString *)code type:(TSShareType)type{
//    NSString *shareUrl = [NSString stringWithFormat:@"%@/business/clazz_group/clazz_share.xhtml?code=%@&name=%@&type=%zd",TSServerBaseUrl,code,[TSGlobal sharedGlobal].userInfo.user.nickname,type];
//    return  [shareUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}
@end
