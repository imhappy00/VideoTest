//
//  DHVideoKit.h
//  DHVideoDemo
//
//  Created by DuHongXing on 2017/11/2.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger, DHVideoPlayState) {
    DHVideoPlayStatePlayFaild = 1,
    DHVideoPlayStatePlaying = 2,
    DHVideoPlayStatePlayStop = 3,
    DHVideoPlayStatePlayBuffering = 4,
    DHVideoPlayStatePlayFinished = 5,
};

@interface DHVideoPlayer : UIView
/**
 *  播放状态
 */
@property (assign,  nonatomic) DHVideoPlayState state;
/**
 *  播放器player
 */
@property (strong, nonatomic) AVPlayer *player;
/**
 *playerLayer,可以修改frame
 */
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
/*
 *播放项（源）
 */
@property (strong, nonatomic) AVPlayerItem *currentPlayItem;

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString;
- (void)play;
- (void)playOrpause;
@end
