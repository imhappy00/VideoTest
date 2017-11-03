//
//  BaseViewController.h
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,NavigationBarState) {
    NavigationBarStateNone = -1,
    NavigationBarStateHide = 1,
    NavigationBarStateShow = 0
};
@interface BaseViewController : UIViewController
@property (assign,readonly,nonatomic) BOOL isLoaded;
@property (assign,nonatomic) NavigationBarState navigationBarState;
@property (assign,nonatomic) BOOL shownBackButton;
@property (assign,readonly,nonatomic) NSUInteger currentViewControllers;

/**
 *  填充页面静态或者本地数据
 */
-(void)setStaticDatas;
/**
 *  初始化Views
 */
-(void)setupViews;
/**
 *  请求数据
 */
-(void)requestDatas;

- (void)setNavRightButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action;
- (void)setNavLeftButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action;

- (void)setNavLeftButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action isBorder:(BOOL)isBorder;
-(void)setNavRightButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action isBorder:(BOOL)isBorder;

- (void)setNavRightButtonEnable:(BOOL)enable;
- (void)setNavLeftButtonEnable:(BOOL)enable;
//progress event
- (void)showProgressViewWithTitle:(NSString *)title;
- (void)hideProgressView;
- (void)navBackButtonClicked:(UIButton *)sender;
- (UIButton *)navBackButton;
@end
