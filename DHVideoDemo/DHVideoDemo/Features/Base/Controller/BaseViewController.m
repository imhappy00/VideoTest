//
//  BaseViewController.m
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "MBProgressHUD.h"
#import "Helper+Utils.h"
#import "UIView+Additional.h"
#import "UIImage+Additional.h"
typedef NS_ENUM(NSUInteger, kViewControllerState) {
    kViewControllerStateNone = 0,
    kViewControllerStateWillBack = 1,
    kViewControllerStateDidBack = 2,
    kViewControllerStateCancelBack = 3,
};
@interface BaseViewController ()<UIGestureRecognizerDelegate>
{
    MBProgressHUD *progressView;
    BOOL _shownBackButton;
}
@property (assign,nonatomic) kViewControllerState state;
@end

@implementation BaseViewController
+ (void)initialize{
    [[UINavigationBar appearanceWhenContainedIn:[BaseNavigationController class], nil] setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[BaseNavigationController class], nil] setTintColor:kMainColor];
    [[UINavigationBar appearanceWhenContainedIn:[BaseNavigationController class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName : kWhiteColor}];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)]];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _navigationBarState = NavigationBarStateNone;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentViewControllers = self.navigationController.viewControllers.count;
    self.navigationItem.hidesBackButton = YES;
    self.shownBackButton = YES;
    progressView = [[MBProgressHUD alloc] initWithView:self.view];
    self.view.backgroundColor = kDefaultBackgroundColor;
    [self.view addSubview:progressView];
    [self setStaticDatas];
    [self setupViews];
    [self requestDatas];
}

- (void)setShownBackButton:(BOOL)shownBackButton{
    if (_shownBackButton == shownBackButton){
        return;
    }
    _shownBackButton = shownBackButton;
    if (_shownBackButton && _currentViewControllers > 1){// && !self.navigationController.navigationBarHidden){
        [self setNavBackButton];
    }
    else{
        self.navigationItem.leftBarButtonItem = nil;
    }
}


- (UIButton *)navBackButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    UIImage *navBack = [UIImage imageNamed:@"icon_return"];
    [button setImage:navBack forState:UIControlStateNormal];
    [button setImage:navBack forState:UIControlStateHighlighted];
    [button setImage:navBack forState:UIControlStateDisabled];
    button.size = navBack.size;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [button addTarget:self action:@selector(navBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.left = 16;
    button.top = 2 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    return button;
}

- (void)setNavBackButton{
    UIButton *btn = [self navBackButton];
    btn.top = btn.left = 0;
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (BOOL)shownBackButton{
    return _shownBackButton;
}

- (void)setStaticDatas{}
- (void)setupViews{}
- (void)requestDatas{}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarState:self.navigationBarState];
    [[UIApplication sharedApplication] setStatusBarStyle:[self preferredStatusBarStyle] animated:YES];
  }
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _isLoaded = YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (NSUInteger)viewControllersCount{
    return self.navigationController.viewControllers.count;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

#pragma mark - UIGestureRecongnizerDelegate
- (void)handleSwipeGR:(UIGestureRecognizer*)gestureRecognizer{
    if (UISwipeGestureRecognizerDirectionLeft){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setNavRightButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action{
    self.navigationItem.rightBarButtonItem = [self getButtonItemWithImg:normalImg selImg:selImg title:title action:action isBorder:NO];
}

- (void)setNavLeftButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action{
    self.navigationItem.leftBarButtonItem = [self getButtonItemWithImg:normalImg selImg:selImg title:title action:action isBorder:NO];
}

- (void)setNavLeftButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action isBorder:(BOOL)isBorder{
    self.navigationItem.leftBarButtonItem = [self getButtonItemWithImg:normalImg selImg:selImg title:title action:action isBorder:isBorder];
}

-(void)setNavRightButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action isBorder:(BOOL)isBorder{
    self.navigationItem.rightBarButtonItem = [self getButtonItemWithImg:normalImg selImg:selImg title:title action:action isBorder:isBorder];
}

- (void)setNavRightButtonEnable:(BOOL)enable{
    [self.navigationItem.rightBarButtonItem setEnabled:enable];
}

- (void)setNavLeftButtonEnable:(BOOL)enable{
    [self.navigationItem.leftBarButtonItem setEnabled:enable];
}

#pragma mark - NavButton Clicked
- (void)navGoHomeButtonClicked:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)navBackButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MG_NavBaseViewController private
- (UIBarButtonItem *)getButtonItemWithImg:(NSString *)norImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action isBorder:(BOOL)isBorder{
    CGSize navbarSize = self.navigationController.navigationBar.bounds.size;
    CGRect frame = CGRectMake(0, 0, navbarSize.width / 3, navbarSize.height - 3);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    if (norImg){
        UIImage* norImage = [UIImage imageNamed:norImg];
        [button setImage:norImage forState:UIControlStateNormal];
        [button setImage:norImage forState:UIControlStateHighlighted];
        [button setImage:norImage forState:UIControlStateDisabled];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        button.size = norImage.size;
    }
    if (selImg){
        UIImage* selImage = [UIImage imageNamed:selImg];
        [button setImage:selImage forState:UIControlStateHighlighted];
    }
    if (title) {
        CGSize strSize = [Helper sizeForLabelWithString:title withFontSize:16 constrainedToSize:frame.size];
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [button setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        [button setTitleColor:kWhiteColor forState:UIControlStateDisabled];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        frame.size.width = MIN(frame.size.width, strSize.width);
        frame.size.height = strSize.height+5;
        if (isBorder) {
            button.layer.cornerRadius = 2.f;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            button.layer.borderWidth = 0.5f;
        }
        button.frame = frame;
    }
    button.top = 0;
    button.left = 0;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* tmpBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return tmpBarBtnItem;
}

#pragma mark - ProgressView Event
- (void)showProgressViewWithTitle:(NSString *)title{
    if (title){
        progressView.label.text = title;
    }
    [progressView showAnimated:YES];
    [self.view bringSubviewToFront:progressView];
}

- (void)hideProgressView{
    [progressView hideAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
    return YES;
    return NO;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - getter & setter
- (void)setNavigationBarState:(NavigationBarState)navigationBarState{
    _navigationBarState = navigationBarState;
    if (self.navigationBarState != NavigationBarStateNone && self.navigationBarState != self.navigationController.navigationBarHidden){
        [self.navigationController setNavigationBarHidden:self.navigationBarState animated:YES];
    }
}

@end
