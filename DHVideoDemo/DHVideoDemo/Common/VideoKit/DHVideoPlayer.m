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
#define WMPlayerImage(file)      [UIImage imageNamed:WMPlayerSrcName(file)]
static void *PlayerViewStatusChangeObservationContext = &PlayerViewStatusChangeObservationContext;
@interface DHVideoPlayer(){
    //是否已经初始化player
    BOOL _isInitPlayer;
    //播放总时间
    CGFloat totalTime;
    DHControlPlayType _controlType;
    //开始触摸的位置
    CGPoint _touchBeginPoint;
    //触摸开始亮度
    float _touchBeginLightValue;
    //触摸开始的音量
    float _touchBeginVoiceValue;
    //触摸开始的进度
    float _touchBeginProgressValue;
    
}
@property (strong, nonatomic) UIImageView *topToolBarView;//顶部工具条
@property (strong, nonatomic) UIImageView *bottomToolBarView;//底部工具条
@property (strong, nonatomic) UIView *contentView;//播放的view
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *fullScreenBtn;
@property (strong,  nonatomic) UISlider *progressSlider;//播放进度滑块，可以拖拽快进或后退
@property (strong, nonatomic) UISlider *volumeSlider;//声音滑块用来调节声音的大小

@property (strong, nonatomic) UIProgressView *loadingProgress;//缓存进度条
@property (strong, nonatomic) UILabel *beginTimeLabel;
@property (strong, nonatomic) UILabel *totalTimeLabel;

@property (copy, nonatomic) NSString *urlString;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;
//监听播放起状态的监听者
@property (nonatomic ,strong) id playbackTimeObserver;
//是否正在拖拽进度条滑块
@property (assign, nonatomic) BOOL isSliderDraging;
@end
@implementation DHVideoPlayer

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString {
    self = [super initWithFrame:frame];
    if (self) {
        self.urlString = urlString;
        [self initPlayer];
        [self playItemAddObservers];
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayItem];
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
    
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    for (UIControl *view in volumeView.subviews) {
        if ([view.superclass isSubclassOfClass:[UISlider class]]) {
            self.volumeSlider = (UISlider *)view;
            self.volumeSlider.value = 1;
        }
    }
}

- (void)contentViewAddSubViews {
    [self.contentView addSubview:self.topToolBarView];
    [self.topToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.bottomToolBarView];
    [self.bottomToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(50);
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
        make.centerY.equalTo(self.bottomToolBarView.mas_centerY).offset(-1);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.bottomToolBarView addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-40.f);
        make.centerY.equalTo(self.bottomToolBarView.mas_centerY).offset(-1);
        make.height.mas_equalTo(20.f);
    }];
    [self.bottomToolBarView addSubview:self.fullScreenBtn];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomToolBarView).mas_offset(0);
        make.centerY.equalTo(self.bottomToolBarView.mas_centerY).offset(-1);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.bottomToolBarView addSubview:self.loadingProgress];
    [self.loadingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-40.f);
        make.centerY.equalTo(self.bottomToolBarView.mas_centerY).offset(-1);
    }];
    
    [self.bottomToolBarView addSubview:self.beginTimeLabel];
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).mas_offset(0);
        make.bottom.equalTo(self.bottomToolBarView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    
    [self.bottomToolBarView addSubview:self.totalTimeLabel];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomToolBarView);
        make.bottom.equalTo(self.bottomToolBarView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    
}
- (void)topToolBarAddSubViews {
    
}
/**
 * 监听playerItem的status 、loadedTimeRanges、duration(视频时长)等属性的变化
 */
- (void)playItemAddObservers {
    [self.currentPlayItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:PlayerViewStatusChangeObservationContext];
    [self.currentPlayItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:PlayerViewStatusChangeObservationContext];
    [self.currentPlayItem addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:PlayerViewStatusChangeObservationContext];
 }

#pragma mark - touchs
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *)touches.anyObject;
    if (touches.count > 1 || [touch tapCount] > 1 || event.allTouches.count > 1) {
        return;
    }
    _touchBeginPoint = [touch locationInView:self];
    //亮度
    _touchBeginLightValue = [UIScreen mainScreen].brightness;
    //声音
    _touchBeginVoiceValue = _volumeSlider.value;
    //进度
    _touchBeginProgressValue = self.progressSlider.value;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint tempPoint = [touches.anyObject locationInView:self];
    
    float tan = fabs(tempPoint.y - _touchBeginPoint.y)/fabs(tempPoint.x - _touchBeginPoint.x);
    //小于30度角为调节进度
    if (tan < 1/ sqrt(3)) {
        _controlType = DHControlPlayProgressType;
    }else{
        if (tempPoint.x > self.bounds.size.width/2){
            _controlType = DHControlPlayLightType;
        }else{
            _controlType = DHControlPlayVoiceType;
        }
    }
    
    if (_controlType == DHControlPlayProgressType) {
        double progressValue = _touchBeginProgressValue + self.progressSlider.maximumValue * (tempPoint.x - _touchBeginPoint.x)/self.bounds.size.width;
        if (progressValue < self.progressSlider.maximumValue) {
            [self.progressSlider setValue:progressValue animated:YES];
            [self seekToTimeToPlay:progressValue];
        }else{
            progressValue = 0.0;
            [self.progressSlider setValue:progressValue animated:NO];
            [self seekToTimeToPlay:progressValue];
        }
    }else if (_controlType == DHControlPlayLightType) {
        float lightValue = _touchBeginLightValue - (tempPoint.y - _touchBeginPoint.y)/self.bounds.size.height;
        if (lightValue < 1) {
            [UIScreen mainScreen].brightness = lightValue;
        }else {
            [UIScreen mainScreen].brightness = 1;
        }
    }else if (_controlType == DHControlPlayVoiceType){
        float voiceValue = _touchBeginVoiceValue - (tempPoint.y - _touchBeginPoint.y)/self.bounds.size.height;
        if (voiceValue < 1) {
            self.volumeSlider.value = voiceValue;
        }else {
            self.volumeSlider.value = 1;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - private
- (void)play {
    if (!_isInitPlayer) {
        [self.contentView.layer insertSublayer:self.playerLayer atIndex:0];
        self.playerLayer.frame = self.contentView.layer.bounds;
        //视频的默认填充模式，AVLayerVideoGravityResizeAspect
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//        [self.player]
        [self.player play];
        self.playBtn.selected = NO;
        _isInitPlayer = YES;
    }else{
        [self playOrpause];
    }
}

- (void)seekToTimeToPlay:(double)time {
    if (self.player&&self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        if (time>=totalTime) {
            time = 0.0;
        }
        if (time<0) {
            time=0.0;
        }
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:CMTimeMakeWithSeconds(time, weakSelf.currentPlayItem.currentTime.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            
        }];
    }
}


/**
 * 滑块的拖拽的拖拽事件实现视频的快进或后退
 */
- (void)sliderDragingAction:(UISlider *)slider {
    self.isSliderDraging = YES;
    __weak typeof (self) weakSelf = self;
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value, weakSelf.currentPlayItem.currentTime.timescale) completionHandler:^(BOOL finished) {
        weakSelf.isSliderDraging = NO;
    }];
 }
/**
 * 视频播放结束收到通知后相应的处理
 */
- (void)moviePlayDidEnd:(NSNotification *)noti {
    self.state = DHVideoPlayStatePlayFinished;
    self.playBtn.selected = YES;
    [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
//    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
//
//    }];
}

/*
 * 增加播放时间的监听，更新播放进度
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
        if (weakSelf.isSliderDraging) {
            
        }else{
            long long nowTime = weakSelf.currentPlayItem.currentTime.value/weakSelf.currentPlayItem.currentTime.timescale;
            float minValue = [weakSelf.progressSlider minimumValue];
            float maxValue = [weakSelf.progressSlider maximumValue];
            weakSelf.beginTimeLabel.text = [weakSelf convertTime:(CGFloat)CMTimeGetSeconds(weakSelf.currentPlayItem.currentTime)];
            [weakSelf.progressSlider setValue:(maxValue - minValue) * nowTime / totalTime + minValue];
        }
    }];
}

/**
 * 获取播放总时长
 */
- (CMTime)playerItemDuration {
    AVPlayerItem *playerItem = self.currentPlayItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}

/**
 * 播放或暂停
 */
- (void)playOrpause {
    if (self.state == DHVideoPlayStatePlaying) {
        [self.player pause];
        self.state = DHVideoPlayStatePlayStop;
        self.playBtn.selected = YES;
    }else if (self.state == DHVideoPlayStatePlayStop || self.state == DHVideoPlayStatePlayFaild || self.state == DHVideoPlayStatePlayFinished){
        [self.player play];
        self.state = DHVideoPlayStatePlaying;
        self.playBtn.selected = NO;
    }
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
                self.totalTimeLabel.text = [self convertTime:totalTime];
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
                    self.state = DHVideoPlayStatePlayFaild;
                    self.playBtn.selected = YES;
                    [self.loadingView stopAnimating];
                    break;
                default:
                    break;
            }
            
        }
    }
}

- (NSString *)convertTime:(float)second {
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    return [[self dateFormatter] stringFromDate:d];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    }
    return _dateFormatter;
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
- (void)setState:(DHVideoPlayState)state {
    _state = state;
    switch (_state) {
        case DHVideoPlayStatePlayBuffering:
            [self.loadingView startAnimating];
            break;
        case DHVideoPlayStatePlaying:
            [self.loadingView stopAnimating];
            break;
        case DHVideoPlayStatePlayFaild:
            [self.loadingView startAnimating];
            break;
        default:
            break;
    }
}


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

- (UIImageView *)topToolBarView {
    if (!_topToolBarView) {
        _topToolBarView = [[UIImageView alloc]init];
        _topToolBarView.userInteractionEnabled = YES;
    }
    return _topToolBarView;
}

- (UIImageView *)bottomToolBarView {
    if (!_bottomToolBarView) {
        _bottomToolBarView = [[UIImageView alloc]init];
        _bottomToolBarView.userInteractionEnabled = YES;
        _bottomToolBarView.image = WMPlayerImage(@"bottom_shadow");
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
        _playBtn.showsTouchWhenHighlighted = YES;
        [_playBtn setImage:WMPlayerImage(@"pause") forState:UIControlStateNormal];
        [_playBtn setImage:WMPlayerImage(@"play") forState:UIControlStateSelected];
        _playBtn.selected = YES;
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
        [_progressSlider addTarget:self action:@selector(sliderDragingAction:) forControlEvents:UIControlEventTouchDragInside];
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

- (UILabel *)beginTimeLabel {
    if (!_beginTimeLabel) {
        _beginTimeLabel = [[UILabel alloc]init];
        _beginTimeLabel.textAlignment = NSTextAlignmentCenter;
        _beginTimeLabel.textColor = kWhiteColor;
        _beginTimeLabel.text = @"00:00";
    }
    
    return _beginTimeLabel;
}
- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.textColor = kWhiteColor;
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}
@end
