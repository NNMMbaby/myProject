//
//  DataManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UpDateBlock)();

@interface DataManager : NSObject


@property (nonatomic, copy)UpDateBlock upDateBlock;
@property (nonatomic, assign)NSArray *allMusic;

// 单例
+ (DataManager *)sharedDataManager;
// 单元格传入一个音乐
- (Music *)musicFromIndex:(NSInteger)index;

@end
