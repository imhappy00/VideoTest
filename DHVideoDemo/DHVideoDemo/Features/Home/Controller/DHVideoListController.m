//
//  DHVideoListController.m
//  DHVideoDemo
//
//  Created by DuHongXing on 2017/11/2.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DHVideoListController.h"
#import "DHVideoPlayer.h"
@interface DHVideoListController ()
@property (strong, nonatomic) DHVideoPlayer *player;
@end

@implementation DHVideoListController
- (void)setupViews {
    [self.view addSubview:self.player];
//    [self.player play];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter && setter
- (DHVideoPlayer *)player {
    if (!_player) {
        _player = [[DHVideoPlayer alloc]initWithFrame:CGRectMake((ScreenWidth - 300)/2, 100, 300, 200) urlString:@"https://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4"];
    }
    return _player;
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
