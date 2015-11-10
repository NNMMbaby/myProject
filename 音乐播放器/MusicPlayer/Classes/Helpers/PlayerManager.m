//
//  PlayerManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/7.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "PlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerManager ()
// 播放器 全局唯一不变 不然有两个播放器就会一起播放
@property (nonatomic, strong)AVPlayer * player;

// 在play 事件初始化 监听slider的进度时刻更新
@property (nonatomic, strong) NSTimer *timer;

@end

static PlayerManager * manager = nil;

@implementation PlayerManager
// 单例方法
+ (instancetype)sharedPlayerManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PlayerManager new];
    });
    return manager;
}


- (instancetype)init{
    if (self = [super init]) {
        // 添加通知中心 当self发出 AVPlayerItemDidPlayToEndTimeNotification 时 触发 playerDidPlayEnd事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
// 自动播放下一首
- (void)playerDidPlayEnd:(NSNotification *)not{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPlayEnd)]) {
        // 接收到item 播放结束后，让代理去干一些事情，代理会怎么办，播放器不知道
        [self.delegate playerDidPlayEnd];
    }
}

#pragma mark -- 对外方法

- (void)play{
    
    // 如果正在播放的话，就不播放了，直接返回就行
    if (_isPlaying) {
        return;
    }
    [self.player play];
    // 开始播放后标记一下
    _isPlaying = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingWithSeconds) userInfo:nil repeats:YES];
    
}
- (void)playingWithSeconds{
  //  NSLog(@"%lld",self.player.currentTime.value/self.player.currentTime.timescale);
    // 我移动了 给你时间 你也动啊
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayingWithTime:)]) {
        NSTimeInterval time = self.player.currentTime.value / self.player.currentTime.timescale;
        [self.delegate playerPlayingWithTime:time];
    }
    
}

- (void)pause{
    [self.player pause];
    // 暂停播放后标记一下
    _isPlaying = NO;
    // 销毁时间
    [self.timer invalidate];
    _timer = nil;
}

- (void)seekToTime:(NSTimeInterval)time{
    // 先暂停
    [self pause];
    
    //CMTime 结构体 value / timeCale = seconds 获取那个当前点的时间（秒数）
    // self.player.currentTime.timescale
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
           // 拖拽成功了再播放
            [self play];
        }
    }];
    
}
- (NSInteger)volume{
    return self.player.volume;
}



- (void)seekToVolume:(NSInteger)volume{
    
    self.player.volume = volume;
    
}

//
- (void)playWitnUrlString:(NSString *)urlString{
    // 如果切换歌曲，先要移除正在播放的观察者 （当播放下一曲时候移除之前的观察者）
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    // 创建一个item
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    // 对item添加观察者
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    // 通过观察者 观看资源URL 是否正确可以播放 然后播放
}

// lazyLoading
- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}

#pragma mark - 观察响应
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"%@",keyPath);
    NSLog(@"%@",change);
    AVPlayerStatus status = [change[@"new"] integerValue];
    switch (status) {
        case AVPlayerStatusFailed:
            NSLog(@"加载失败");
            break;
        case AVPlayerStatusUnknown:
            NSLog(@"资源不对");
            break;
        case AVPlayerStatusReadyToPlay:
            NSLog(@"准备好了，可以播放");
            [self pause];
            // 开始播放
            [self play];
            break;
        default:
            break;
    }
    
}



@end
