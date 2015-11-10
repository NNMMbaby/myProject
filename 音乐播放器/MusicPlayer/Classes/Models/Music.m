//
//  Music.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "Music.h"

@implementation Music

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }else{
        NSLog(@"error key:%@",key);
    }
}

@end
