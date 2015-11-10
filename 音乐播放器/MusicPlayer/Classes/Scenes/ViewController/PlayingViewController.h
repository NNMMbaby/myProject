//
//  PlayingViewController.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/7.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController

@property (nonatomic, assign)NSInteger index;

@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) IBOutlet UILabel *singerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *img4Pic;
// storyboard上拉拽到Playing View Controller 上添加dataSource 和 delegate
@property (strong, nonatomic) IBOutlet UITableView *tabView4Lyric;
@property (strong, nonatomic) IBOutlet UILabel *lab4lastTime;
@property (strong, nonatomic) IBOutlet UILabel *lab4leaveTime;
@property (strong, nonatomic) IBOutlet UISlider *slider4Time;
@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;

@property (strong, nonatomic) IBOutlet UIButton *btn4PlayPause;
// 顺序 随机 单曲

@property (strong, nonatomic) IBOutlet UIButton *btn4Order;
@property (strong, nonatomic) IBOutlet UIButton *btn4Random;
@property (strong, nonatomic) IBOutlet UIButton *btn4One;




// 暂停或播放
- (IBAction)action4PlayOrPause:(UIButton *)sender;
// 上一首
- (IBAction)action4Last:(UIButton *)sender;
// 下一首
- (IBAction)action4Next:(UIButton *)sender;
// 播放进度
- (IBAction)action4ChangeTime:(UISlider *)sender;
// 声音大小
- (IBAction)action4Volmn:(UISlider *)sender;

// 随机播放 && 顺序播放 && 单曲循环
- (IBAction)action4Random:(UIButton *)sender;
- (IBAction)action4Order:(UIButton *)sender;
- (IBAction)action4One:(UIButton *)sender;


+ (instancetype)sharedPlayerVC;

@end
