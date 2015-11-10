//
//  LyircModel.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "LyircModel.h"

@implementation LyircModel


- (instancetype)initWithTime:(NSTimeInterval)time lyric:(NSString *)lyric{
    if (self = [super init]) {
        _time = time;
        _lyricContext = lyric;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%f,%@",_time,_lyricContext];
}
@end
