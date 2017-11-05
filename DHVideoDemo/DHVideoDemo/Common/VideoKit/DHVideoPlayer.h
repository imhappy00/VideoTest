//
//  DHVideoKit.h
//  DHVideoDemo
//
//  Created by DuHongXing on 2017/11/2.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

/**
 视频播放状态
 - DHVideoPlayStatePlayFaild: 播放失败
 - DHVideoPlayStatePlaying: 播放中
 - DHVideoPlayStatePlayStop: 播放暂停
 - DHVideoPlayStatePlayBuffering: 缓冲中
 - DHVideoPlayStatePlayFinished: 播放结束
 */
typedef NS_ENUM(NSInteger, DHVideoPlayState) {
    DHVideoPlayStatePlayFaild = 1,
    DHVideoPlayStatePlaying = 2,
    DHVideoPlayStatePlayStop = 3,
    DHVideoPlayStatePlayBuffering = 4,
    DHVideoPlayStatePlayFinished = 5,
};
/**
 手势调控类型
 右半边上下滑动控制视频亮度；左半边上下滑动控制视频音量大小;滑动角度小于30度为控制进度
 - DHControlPlayVoiceType: 声音调控中
 - DHControlPlayLightType; 亮度调节
 - DHControlPlayProgressType;进度调节
 */
typedef NS_ENUM(NSInteger, DHControlPlayType){
    DHControlPlayVoiceType = 1,
    DHControlPlayLightType = 2,
    DHControlPlayProgressType = 3,
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
