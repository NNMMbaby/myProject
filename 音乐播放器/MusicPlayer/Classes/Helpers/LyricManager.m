//
//  LyricManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "LyricManager.h"

static LyricManager *manager = nil;

@interface LyricManager()
// 用来存放歌词
@property (nonatomic, strong)NSMutableArray *lyrics;

@end


@implementation LyricManager

+(LyricManager *)sharedLyricManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LyricManager new];
    });
    return manager;
}

/**
 [00:13.110]那时候 我以为爱的是生活
 [00:19.490]也算懂得 什么适合什么不可
 [00:26.300]最近还是一样努力着
 [00:29.840]配合你的性格
 [00:32.800]你的追求者 你的坎坷
 */
- (void)loadLyricWithString:(NSString *)lyricString{
    // 1.分行 通过换行符@“/n”分隔成数组
    
    NSMutableArray * lyricStringArray = [[lyricString componentsSeparatedByString:@"\n"] mutableCopy];
// 删除最后一行 因为最后一行后面也换行 然后会患处新的一行直接删除就行了
    [lyricStringArray removeLastObject];
    
    // 播放下一首之前将原来的歌词移除
    [self.lyrics removeAllObjects];
    
    for (NSString *str in lyricStringArray) {
        NSLog(@"%@",str);

        // 为了防止最后面有换行 当str是空就直接继续就行
        if ([str isEqualToString:@""]) {
            continue;
        }
        // 2.通过@“]” 来截取时间和歌词
        /*[00:32.800
         你的追求者 你的坎坷
         */
       // timeAndLyric[0] = time timeAndLyric[1] = lyric
        NSArray * timeAndLyric = [str componentsSeparatedByString:@"]"];
        if (timeAndLyric.count !=2) {
            continue;
        }
        // 去掉时间左边的块
        NSString *time =[timeAndLyric[0] substringFromIndex:1];
        // 变成 00:32.800
        // 4.截取时间 获取 分和秒
        NSArray *minureAndSecond = [time componentsSeparatedByString:@":"];
        NSInteger minute = [minureAndSecond[0] integerValue];
        double second = [minureAndSecond[1] doubleValue];
        
        // 5.存到model里面
        // 创建model
        LyircModel *model = [[LyircModel alloc] initWithTime:(minute * 60 + second) lyric:timeAndLyric[1]];
        // 如果解析没有歌词 则显示无歌词
        if (model.time == 0) {
            model.lyricContext = @"________❤️_______";
        }
        // 6.添加到数组
        [self.lyrics addObject:model];
        
     //  🙅 self.lyrics addObjectsFromArray:(nonnull NSArray *)
    }
}
// lazyLoading
- (NSMutableArray *)lyrics{
    if (!_lyrics) {
        _lyrics = [NSMutableArray new];
    }
    return  _lyrics;
}

// get方法 给对外数组
- (NSArray *)allLyric{
    return self.lyrics;
}


- (NSInteger)index:(NSTimeInterval)time{
    // 遍历数组 找到还没有播放的那个歌词
    NSInteger indexx = 0;
    for (int i = 0 ; i < self.lyrics.count; i ++) {
        LyircModel *model = self.lyrics[i];
        // 如果一句歌词长了两秒呢 所以要向下找 只要在他以后的最近的就是他的下一个
        if (model.time > time) {//i-1是当前播放的句子
            // 注意如果是第0 个元素，而且元素时间比要播放的时间大 i- 1 就会小于0，这样tableView就是crash
            indexx = (i - 1 > 0) ?i - 1 : 0;
            // 一定要break 要不就会一直循环下去
            break;
        }
    }
    return indexx;
}

@end
