//
//  LyricManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject

// 对外的歌词
@property (nonatomic, strong)NSArray * allLyric;

//单例方法
+ (LyricManager *)sharedLyricManager;
// 加载歌词通过字符串
- (void)loadLyricWithString:(NSString *)lyricString;
// 根据播放时间获取到该播放的歌词 
- (NSInteger)index:(NSTimeInterval)time;





@end
