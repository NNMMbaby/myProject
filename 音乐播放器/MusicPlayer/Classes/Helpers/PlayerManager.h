//
//  PlayerManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/7.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PlayManagerDelegate <NSObject>

// 当一首歌结束后，让代理去做的事情
- (void)playerDidPlayEnd;

//播放音乐中一直执行的一个方法 监听更新的进度条 传的数据是当前播放音乐的时间
- (void)playerPlayingWithTime:(NSTimeInterval)time;

@end

@interface PlayerManager : NSObject
// 是否正在播放
@property (nonatomic, assign)BOOL isPlaying;

@property (nonatomic, assign)id<PlayManagerDelegate> delegate;

+ (instancetype)sharedPlayerManager;

// 给一个接口，让AVPlayer 播放
- (void)playWitnUrlString:(NSString *)urlString;

// 播放
- (void)play;

// 暂停
- (void)pause;

// 改变播放进度
- (void)seekToTime:(NSTimeInterval)time;

// 改变音量
- (void)seekToVolume:(NSInteger)volume;


- (NSInteger)volume;






@end
