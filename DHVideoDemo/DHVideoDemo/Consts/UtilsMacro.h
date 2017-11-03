//
//  UtilsMacro.h
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/27.
//  Copyright © 2017年 duxing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "WQFactoryUI.h"
#ifndef UtilsMacro_h
#define UtilsMacro_h
#pragma mark - 1像素宽度/高度
#define kOnePixelWidth  1.0f / [UIScreen mainScreen].scale

#pragma mark - 状态栏
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X (Is_Iphone && ScreenHeight == 812.0)
#define kNavBarHeight (Is_Iphone_X ? 68 : 44)
#define kTabbarHeight (Is_Iphone_X ? 83 : 49)
#define BottomHeight (Is_Iphone_X ? 34 : 0)

#pragma mark - 导航栏 + 状态栏
#define kNavBarHeightWithStatusBarHeight (kStatusBarHeight + kNavBarHeight)

#pragma mark - 系统版本号
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]


#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define NSLog(...)
#   define DLog(...)
#endif


#pragma mark - 弱引用self
#if DEBUG
#define ext_keywordify autoreleasepool {}
#else
#define ext_keywordify try {} @catch (...) {}
#endif

#define weakify(VAR) \
ext_keywordify \
__weak __typeof(&*VAR) __weak##VAR = VAR;
#define strongify(VAR) \
ext_keywordify \
__strong __typeof(&*VAR) VAR = __weak##VAR;

#define dispatch_global_async(block)\
dispatch_async(dispatch_get_global_queue(0, 0),block);\

#define dispatch_global_sync(block)\
dispatch_sync(dispatch_get_global_queue(0, 0),block);\

#define ExecBlock(block, ...) if (block) { block(__VA_ARGS__); };
#endif /* UtilsMacro_h */
/** 获取app的名称 **/

UIKIT_STATIC_INLINE NSString *appName(){
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
}

/** 获取APP的版本号 */
UIKIT_STATIC_INLINE NSString *appVersion(){
    return ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
}
///** 获取app内部的版本号 */
UIKIT_STATIC_INLINE NSString *appBuildVersion(){
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

UIKIT_STATIC_INLINE NSString *appBundleIdentifier(){
    return [[NSBundle mainBundle] bundleIdentifier];
}

/**
 *  打开Url
 */
UIKIT_STATIC_INLINE void openUrlInSafariWithCompleteBlock(NSString *url,NSDictionary<NSString *,id> *options, void (^completed)(BOOL success)){
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:options completionHandler:^(BOOL success) {
            ExecBlock(completed, success);
        }];
    }else{
        BOOL openSuccess = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        ExecBlock(completed, openSuccess);
    }
}

/**
 *  打开Url
 */
UIKIT_STATIC_INLINE void openUrlInSafari(NSString *url){
    openUrlInSafariWithCompleteBlock(url, nil, nil);
}

