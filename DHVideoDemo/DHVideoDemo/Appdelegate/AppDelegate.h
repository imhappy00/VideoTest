//
//  AppDelegate.h
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZKeychainItemWrapper.h"
//#import "KeychainItemWrapper.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
// 此处为了避免第三方使用此Window带来的崩溃情况,故此处传出VPWindow的当前Window
@property (strong, nonatomic, readwrite) UIWindow *window;
@property (strong, nonatomic, readonly) XZKeychainItemWrapper *wrapper;
+ (AppDelegate *)shareAppDelegate;
@end

