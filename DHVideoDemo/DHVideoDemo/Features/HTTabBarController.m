//
//  HTTabBarController.m
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "HTTabBarController.h"
#import "UIImage+Additional.h"
#import "BaseNavigationController.h"
//#import "HTMineViewController.h"
#import "DHMoreVideoController.h"
#import "DHVideoListController.h"
#import "DHMineViewController.h"
#import "DHTopicViewController.h"


@interface HTTabBarController ()

@end
@implementation HTTabBarController

+ (void)initialize {
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:kDefaultBackgroundColor size:CGSizeMake(1, 1)]];
    [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:kSeparatorLineColor size:CGSizeMake(1, 1)]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kOtherFontColor,NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kMainColor,NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
}

- (instancetype)init {
    self = [super init];
    if(self){
        UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:@"视频列表" image: [UIImage imageNamed:@"tab_icon_unselect_01"] selectedImage:[UIImage imageNamed:@"tab_icon_select_01"]];
        UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:@"互动" image:[UIImage imageNamed:@"tab_icon_unselect_02"] selectedImage:[UIImage imageNamed:@"tab_icon_select_02"]];
        UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:@"服务" image:[UIImage imageNamed:@"tab_icon_unselect_03"] selectedImage:[UIImage imageNamed:@"tab_icon_select_03"]];
        UITabBarItem *item4 = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"tab_icon_unselect_04"] selectedImage:[UIImage imageNamed:@"tab_icon_select_04"]];
        
        BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:[DHVideoListController new]];
        nav1.tabBarItem = item1;
        BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:[DHMoreVideoController new]];
        nav2.tabBarItem = item2;
        BaseNavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:[DHTopicViewController new]];
        nav3.tabBarItem = item3;
        BaseNavigationController *nav4 = [[BaseNavigationController alloc] initWithRootViewController:[DHMineViewController new]];
        nav4.tabBarItem = item4;
        self.viewControllers = @[nav1,nav2,nav3,nav4];
        for (UITabBarItem *item in self.tabBar.items) {
            item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
