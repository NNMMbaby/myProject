//
//  DataManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()

@property (nonatomic, retain)NSMutableArray *musicArray;
@property (nonatomic, retain)NSMutableArray *lyricArray;

@end

static DataManager *manager = nil;

@implementation DataManager

+ (DataManager *)sharedDataManager{
    // gcd 提供的一种单例方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
        [manager requestParser];
    });
    return manager;
}
// 解析数据
- (void)requestParser{
    // 在子线程中请求数据 防止假死
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:KmusicURL]];
        for (NSDictionary *dic in array) {
            Music *music = [Music new];
            [music setValuesForKeysWithDictionary:dic];
            [self.musicArray addObject:music];
            // self.musicArrat self.调用set方法 不能直接用_musicArray 添加
        }
     //   NSLog(@"musicArray.count = %ld",_musicArray.count);
        // 返回主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.upDateBlock) {
                NSLog(@"block没有代码");
            }else{
                self.upDateBlock();
            }
        });

    });
}
// lazyLoading
- (NSMutableArray *)lyricArray{
    if (!_lyricArray) {
        _lyricArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _lyricArray;
}

// 单元格传入一个音乐
- (Music *)musicFromIndex:(NSInteger)index{
    return _musicArray[index];
}

// lazyLoad
- (NSMutableArray *)musicArray{
    if (!_musicArray) {
        self.musicArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _musicArray;
}


// 给外部接口
- (NSArray *)allMusic{
    return _musicArray;
}


@end
