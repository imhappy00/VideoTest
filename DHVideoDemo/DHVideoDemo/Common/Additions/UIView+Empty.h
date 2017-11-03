//
//  UIView+Empty.h
//  teacherSecretary
//
//  Created by verne on 16/5/31.
//  Copyright © 2016年 vernepung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Empty)
+ (void)registerEmptyImage:(NSString *)imageName;
//+ (void)registerEmptyImageWithImageName:(NSString *)name NS_DEPRECATED_IOS(2_0, 7_0, "请使用 [UIView registerEmptyImage:]");

- (void)showFriendlyTipsWithMessage:(NSString *)msg;
//- (void)showFriendlyTipsForNoDataWithMessage:(NSString *)msg NS_DEPRECATED_IOS(2_0, 7_0, "请使用 [UIView showFriendlyTipsWithMessage:]");

- (void)showFriendlyTipsWithMessage:(NSString *)msg frame:(CGRect)frame;
//- (void)showFriendlyTipsForNoDataWithMessage:(NSString *)msg frame:(CGRect)frame NS_DEPRECATED_IOS(2_0, 7_0, "请使用 [UIView showFriendlyTipsWithMessage:frame:]");

- (void)hideFriendlyTips;
//- (void)hideFriendlyTipsForNoData NS_DEPRECATED_IOS(2_0, 7_0, "请使用 [UIView hideFriendlyTipsForNoData:]");
@end
