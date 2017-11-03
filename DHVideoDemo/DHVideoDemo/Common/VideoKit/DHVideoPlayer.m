//
//  DHVideoKit.m
//  DHVideoDemo
//
//  Created by DuHongXing on 2017/11/2.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DHVideoPlayer.h"
#import <Masonry/Masonry.h>
#define WMPlayerSrcName(file) [@"WMPlayer.bundle" stringByAppendingPathComponent:file]
//#define WMPlayerFrameworkSrcName(file) [@"Frameworks/WMPlayer.framework/WMPlayer.bundle" stringByAppendingPathComponent:file]
#define WMPlayerImage(file)      [UIImage imageNamed:WMPlayerSrcName(file)]
static void *PlayerViewStatusChangeObservationContext = &PlayerViewStatusChangeObservationContext;
@interface DHVideoPlayer(){
    BOOL _isInitPlayer;

    //总时间
    CGFloat totalTime;
}
@property (strong, nonatomic) UIView *topToolBarView;
@property (strong, nonatomic) UIView *bottomToolBarView;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *fullScreenBtn;
@property (strong,  nonatomic) UISlider *progressSlider;
@property (strong, nonatomic) UIProgressView *loadingProgress;

@property (copy, nonatomic) NSString *urlString;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;

//监听播放起状态的监听者
@property (nonatomic ,strong) id playbackTimeObserver;
@end
@implementation DHVideoPlayer

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString {
    self = [super initWithFrame:frame];
    if (self) {
        self.urlString = urlString;
        [self initPlayer];
        [self playItemAddObservers];
    }
    return self;
}

- (void)initPlayer {
    [self addContentViewToself];
}

- (void)addContentViewToself {
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self contentViewAddSubViews];
}

- (void)contentViewAddSubViews {
    [self.contentView addSubview:self.topToolBarView];
    [self.topToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.bottomToolBarView];
    [self.bottomToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.contentView);
    }];
    [self bottomToolBarAddSubViews];
    [self topToolBarAddSubViews];
    
    [self.contentView addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

- (void)bottomToolBarAddSubViews {
    [self.bottomToolBarView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomToolBarView).mas_offset(10);
        make.bottom.equalTo(self.bottomToolBarView).mas_offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.bottomToolBarView addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-40.f);
        make.centerY.equalTo(self.bottomToolBarView.mas_centerY).offset(-1);
        make.height.mas_equalTo(10.f);
    }];
    [self.bottomToolBarView addSubview:self.fullScreenBtn];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomToolBarView).mas_offset(-10);
        make.bottom.equalTo(self.bottomToolBarView).mas_offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.bottomToolBarView addSubview:self.loadingProgress];
    [self.loadingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-40.f);
        make.centerY.equalTo(self.bottomToolBarView.mas_centerY).offset(-1);
    }];
}
- (void)topToolBarAddSubViews {
    
}

- (void)playItemAddObservers {
    [self.currentPlayItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:PlayerViewStatusChangeObservationContext];
    [self.currentPlayItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:PlayerViewStatusChangeObservationContext];
    [self.currentPlayItem addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:PlayerViewStatusChangeObservationContext];
 }

#pragma mark - private
- (void)play {
    if (!_isInitPlayer) {
//        [self.contentView]
        [self.contentView.layer addSublayer:self.playerLayer];
        self.playerLayer.frame = self.contentView.bounds;
        [self.player play];
        _isInitPlayer = YES;
    }else{
        [self playOrpause];
    }
}

/*
 * 监听播放时间
 */
- (void)initTimer {
    double interval = .1f;
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    __weak typeof (self) weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        long long nowTime = weakSelf.currentPlayItem.currentTime.value/weakSelf.currentPlayItem.currentTime.timescale;
        float minValue = [weakSelf.progressSlider minimumValue];
        float maxValue = [weakSelf.progressSlider maximumValue];
        [weakSelf.progressSlider setValue:(maxValue - minValue) * nowTime / totalTime + minValue];

    }];
//    [self.progressSlider setValue:(maxValue - minValue) * nowTime / totalTime + minValue];
    
}

- (CMTime)playerItemDuration {
    AVPlayerItem *playerItem = self.currentPlayItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}

- (void)playOrpause {
//    [self play];
}
/**
 *监听当前播放项的属性更新进度等
 *
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == PlayerViewStatusChangeObservationContext) {
        if ([keyPath isEqualToString:@"duration"]) {
            if ((CGFloat)CMTimeGetSeconds(self.currentPlayItem.duration) != totalTime) {
                totalTime = (CGFloat)CMTimeGetSeconds(self.currentPlayItem.duration);
                self.progressSlider.maximumValue = totalTime;
            }
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.currentPlayItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            //缓冲颜色
            self.loadingProgress.progressTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
            [self.loadingProgress setProgress:timeInterval / totalDuration animated:NO];
        }else if ([keyPath isEqualToString:@"status"]) {
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey]integerValue];
            switch (status) {
                case AVPlayerStatusUnknown:
                {
                    [self.loadingProgress setProgress:0.0 animated:NO];
                    self.state = DHVideoPlayStatePlayBuffering;
                    [self.loadingView startAnimating];
                 }
                    break;
                case AVPlayerStatusReadyToPlay:
                {
                    self.state = DHVideoPlayStatePlaying;
                    [self initTimer];
                }
                    
                    break;
                case AVPlayerStatusFailed:
                    
                    break;

                default:
                    break;
            }
            
        }
    }
}

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [self.currentPlayItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}



#pragma mark - getter && setter
- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.currentPlayItem];
    }
    return _player;
}

- (AVPlayerItem *)currentPlayItem {
    if(!_currentPlayItem) {
        _currentPlayItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:self.urlString]];
    }
    return  _currentPlayItem;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    }
    return  _playerLayer;
}

- (UIView *)topToolBarView {
    if (!_topToolBarView) {
        _topToolBarView = [[UIView alloc]init];
    }
    return _topToolBarView;
}

- (UIView *)bottomToolBarView {
    if (!_bottomToolBarView) {
        _bottomToolBarView = [[UIView alloc]init];
    }
    return _bottomToolBarView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:WMPlayerImage(@"pause") forState:UIControlStateNormal];
        [_playBtn setImage:WMPlayerImage(@"play") forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:WMPlayerImage(@"fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn setImage:WMPlayerImage(@"nonfullscreen") forState:UIControlStateSelected];
    }
    return _fullScreenBtn;
}

- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc]init];
        _progressSlider.minimumValue = 0.0;
        _progressSlider.maximumValue = 1.0;
        
        [_progressSlider setThumbImage:WMPlayerImage(@"dot")  forState:UIControlStateNormal];
        _progressSlider.minimumTrackTintColor = [UIColor greenColor];
        _progressSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        _progressSlider.value = 0.0;//指定初始值

    }
    return _progressSlider;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _loadingView;
}

- (UIProgressView *)loadingProgress {
    if (!_loadingProgress) {
        _loadingProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _loadingProgress.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _loadingProgress.trackTintColor    = [UIColor clearColor];
        [_loadingProgress setProgress:0.0 animated:NO];
    }
    return _loadingProgress;
}
@end
