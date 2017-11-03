//
//  DHWindowManager.m
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DHWindowManager.h"
#import "HTTabBarController.h"
#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "AppDelegate.h"
#import "AppDelegate+private.h"
DHWindowManager *windowManager;
@interface DHWindowManager()<CAAnimationDelegate>
//@property (copy,nonatomic) void (^guideOrLuanchWindowCompleted)();
@end
@implementation DHWindowManager
@synthesize contentWindow = _contentWindow,loginWindow = _loginWindow,luanchWindow = _luanchWindow,beginnerWindow = _beginnerWindow;

#pragma mark - public function
+ (DHWindowManager *)shareWindowManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        windowManager = [[DHWindowManager alloc] init];
    });
    return windowManager;
}

- (void)luanch{
    [self showBusinessWindow];
//    if ([[DHWindowManager shareWindowManager] canShowBeginnerGuideWindow]){ // 引导
//        @weakify(self);
//        [DHWindowManager shareWindowManager].guideOrLuanchWindowCompleted = ^(){
//            @strongify(self);
//            [[DHWindowManager shareWindowManager] hideBeginnerGuideWindow];
//            [self showBusinessWindow];
//        };
//    }else{
//        [self showBusinessWindow];
//    }
}

- (void)showLoginWindowWithAnimated:(BOOL)animated{
    _activitiedWindowType = HTWindowTypeContent;
    if (_contentWindow){
        BaseNavigationController *currentNavVC = ((HTTabBarController *)_contentWindow.rootViewController).selectedViewController;
        BaseViewController *topVC = (BaseViewController *)currentNavVC.topViewController;
    }
    [self.contentWindow makeKeyAndVisible];
//    [self.loginWindow makeKeyAndVisible];
//    [[AppDelegate shareAppDelegate] registerLoginedBlock];
//    self.loginWindow.transform = CGAffineTransformMakeTranslation(0, 0);
//    if (animated){
//        CATransition *animation = [CATransition animation];
//        //动画时间
//        animation.duration = 0.25f;
//        animation.fillMode = kCAFillModeForwards;
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:@"easeInEaseOut"]];
//        [animation setType:@"moveIn"];// rippleEffect,moveIn
//        [animation setSubtype:kCATransitionFromTop];
//        [self.loginWindow.layer addAnimation:animation forKey:nil];
//    }
//    [self performSelector:@selector(contentWindowReset) withObject:nil afterDelay:.3f];
}

- (void)showBusinessWindow{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    _activitiedWindowType = HTWindowTypeContent;
    [self.contentWindow becomeKeyWindow];
    [[DHWindowManager shareWindowManager].contentWindow makeKeyAndVisible];
//    if ([TSGlobal isLoggedIn] && [TSGlobal sharedGlobal].userInfo.isCompleted){
//        _activitiedWindowType = HTWindowTypeContent;
//        [[DHWindowManager shareWindowManager].contentWindow makeKeyAndVisible];
//    }else{
//        [[DHWindowManager shareWindowManager] showLoginWindowWithAnimated:NO];
//    }
}

- (void)hideBeginnerGuideWindow{
//    [[NSUserDefaults standardUserDefaults] setObject:[kShowGuideWindowVersionValue copy] forKey:kShowGuideWindowVersionKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [UIView animateWithDuration:.35 animations:^{
//                CGAffineTransform transform = CGAffineTransformMakeScale(.2, .2);
//                transform = CGAffineTransformTranslate(transform, -kMainBoundsWidth * 3, 0);
//        self.beginnerWindow.transform = CGAffineTransformMakeTranslation(-ScreenWidth, 0);
//        self.beginnerWindow.layer.opacity = 0;
//    } completion:^(BOOL finished) {
//        [self.beginnerWindow resignKeyWindow];
//        //        _beginnerWindow = nil;
//    }];
}
//- (BOOL)canShowBeginnerGuideWindow{
//    NSString *guideVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kShowGuideWindowVersionKey];
//    BOOL canShow = ![guideVersion isEqualToString:kShowGuideWindowVersionValue];
//    if (canShow){
//        _activitiedWindowType = HTWindowTypeBusiness;
//        [self.beginnerWindow makeKeyAndVisible];
//    }
//
//    return canShow;
//}

#pragma mark - getter
- (UIWindow *)contentWindow{
    if (!_contentWindow){
        _contentWindow = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _contentWindow.backgroundColor = kDefaultBackgroundColor;
        _contentWindow.windowLevel = UIWindowLevelNormal;
        _contentWindow.rootViewController = [HTTabBarController new];
    }
    return _contentWindow;
}

- (UIWindow *)loginWindow{
    if (!_loginWindow)
    {
        _loginWindow = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds] ];
        _loginWindow.backgroundColor = kDefaultBackgroundColor;
        _loginWindow.windowLevel = UIWindowLevelNormal + 10;
//        _loginWindow.rootViewController = [[BaseNavigationController alloc]initWithRootViewController:[TSLoginViewController new]];
    }
    return _loginWindow;
}
- (UIWindow *)beginnerWindow{
    if (!_beginnerWindow){
        _beginnerWindow = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _beginnerWindow.backgroundColor = kDefaultBackgroundColor;
        _beginnerWindow.windowLevel = UIWindowLevelStatusBar + 10;
//        TSBeginnerGuideViewController *beginnerVC = [TSBeginnerGuideViewController new];
//        @weakify(self);
//        beginnerVC.beginnerGuideGoNextSetpBlock = ^(){
//            @strongify(self);
//            ExecBlock(self.guideOrLuanchWindowCompleted);
//        };
//        _beginnerWindow.rootViewController = beginnerVC;
    }
    return _beginnerWindow;
}
@end
