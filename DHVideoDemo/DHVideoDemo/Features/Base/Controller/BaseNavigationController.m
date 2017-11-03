//
//  LSBaseNavigationController.m
//
//
//  Created by vernepung on 14-4-17.
//  Copyright (c) 2014年 open. All rights reserved.
//

#import "BaseNavigationController.h"
//#import "Helper+Utils.h"
#import "BaseViewController.h"
#import "UIImage+Additional.h"
#import "AppDelegate.h"
@interface BaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    BOOL _isEnablePop; //打开pop响应手势
}

@end
static UIImage *backImage = nil;
@implementation BaseNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak BaseNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    BaseNavigationController* nvc = [super initWithRootViewController:rootViewController];
    nvc.delegate = self;
    return nvc;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSString *backTitle = @" ";
    if ([viewController isKindOfClass:[BaseViewController class]])
    {
        //        backTitle = ((BaseViewController *)viewController).nextViewBackTitle;
        if (!backTitle || backTitle.length <= 0)
            backTitle = @" ";
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:backTitle style:UIBarButtonItemStylePlain target:nil action:nil];
    viewController.navigationItem.backBarButtonItem = backItem;
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(self.viewControllers.count <= 1){
        return NO;
    }
    return _isEnablePop;
}

//控制根Controller不能右滑动
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _isEnablePop = YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    _isEnablePop = NO;
    if (self.viewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:animated];
    
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    return [super popToRootViewControllerAnimated:animated];
}

- (BOOL)shouldAutorotate{
    return [[[self viewControllers] lastObject] shouldAutorotate];
    //    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    UIViewController* vc = self.viewControllers.lastObject;
    if ([vc respondsToSelector:@selector(preferredStatusBarStyle)]) {
        return [vc preferredStatusBarStyle];
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return [[[self viewControllers] lastObject] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    //    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

// Override to allow orientations other than the default portrait orientation ios6.0
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [[[self viewControllers] lastObject] supportedInterfaceOrientations];
    //    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
