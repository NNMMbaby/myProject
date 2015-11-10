//
//  PlayingViewController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/7.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "PlayingViewController.h"

@interface PlayingViewController ()<PlayManagerDelegate>

@property (nonatomic, assign) NSInteger currentIndex;
//
@property (nonatomic, strong) Music *currentModel;


// 判断播放状态 0：顺序 1：随机 2:单曲
@property (nonatomic, assign)NSInteger playingStause;

@end

static PlayingViewController * playingVC = nil;
static NSString *cellIdentifier =@"cellReuse";

@implementation PlayingViewController
// 实现单例
+ (instancetype)sharedPlayerVC{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
    });
    return playingVC;
    
}

// 开始 播放
- (void)startPlay{
    
    [[PlayerManager sharedPlayerManager] playWitnUrlString:self.currentModel.mp3Url];
    
    NSLog(@"%@",self.currentModel.mp3Url);
    [self buildUI];
    
    
}
// 每一次播新歌 都会更新这个方法
- (void)buildUI{
    
   // 需要self. 才会走 setter方法 在改变歌曲时候才会改变
    self.songLabel.text = self.currentModel.name;
    self.singerLabel.text = self.currentModel.singer;
   [ self.img4Pic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
//    self.img4Pic.layer.masksToBounds = YES;
//    self.img4Pic.layer.cornerRadius = self.img4Pic.frame.size.width/2;
    // 更改btn
   // [self.btn4PlayPause setTitle:@"暂停" forState:(UIControlStateNormal)];
    [self.btn4PlayPause setImage:[UIImage imageNamed:@"pause@2x"] forState:(UIControlStateNormal)];
    // 改变slider进度条的最大值 和maximumValue 一样 毫秒转成秒
    self.slider4Time.maximumValue = [self.currentModel.duration integerValue]/ 1000;
    
    self.slider4Time.value = 0;
    // 更改角度 图片归为
    self.img4Pic.transform = CGAffineTransformMakeRotation(0);
    
    // 添加音量的最大值
    self.slider4Volume.maximumValue = 5;
//    self.slider4Volume.maximumValue = 1;
    
    // 调用解析歌词
    [[LyricManager sharedLyricManager] loadLyricWithString:self.currentModel.lyric];
    
    [self.tabView4Lyric reloadData];
    
}

// 将要出现的时候显现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_index == _currentIndex) {
        return;
    }
    _currentIndex = _index;
   
    [self startPlay];
    
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 先给一个值
    _currentIndex = -1;
    
    // 播放模式 playingStause
    self.playingStause = 0;

    self.btn4Order.imageView.image = [UIImage imageNamed:@"hiddenOrder"];
    self.btn4Random.imageView.image = [UIImage imageNamed:@"hiddenRan"];
    self.btn4One.imageView.image = [UIImage imageNamed:@"hiddenOne"];
    
    
    // 加圆角
    self.img4Pic.layer.masksToBounds = YES;
    self.img4Pic.layer.cornerRadius = self.img4Pic.frame.size.width/2;
    
    // 设置播放器的代理，当播放器干一些事情
    [PlayerManager sharedPlayerManager].delegate = self;
    
    // 注册tableView
    [self.tabView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    //self.slider4Volume.value = [[PlayerManager sharedPlayerManager] ]
    
}


#pragma mark --PlayerManagerDelegate
// 下一首 事件
- (void)playerDidPlayEnd{
    
    if (_playingStause == 0) {
        // 0.顺序播放
        // 执行下一首的button事件
        [self action4Next:nil];
    }else if(_playingStause ==1){
        // 1.随机播放
        [self action4Random:nil];
    }else if(_playingStause == 2){
        // 2.单曲循环
        [self action4One:nil];
    }
}
// 播放器每0.1秒会让代理（也就是这个页面）执行以下这个事件
- (void)playerPlayingWithTime:(NSTimeInterval)time{
   // NSLog(@"%f",time);
    self.slider4Time.value = time;
    self.lab4lastTime.text = [self stringWithTime:time];
    //  当前播放歌曲的持续时间 就是已经播放的时间
    NSTimeInterval leaveTime = [self.currentModel.duration integerValue]/1000 - time;
    self.lab4leaveTime.text = [self stringWithTime:leaveTime];
    // 每0.1秒转1度
    self.img4Pic.transform = CGAffineTransformRotate(self.img4Pic.transform, M_PI/180);
    
    // 根据 当前播放的事件获取到当前播放的歌词
    
    NSInteger index = [[LyricManager sharedLyricManager] index:time];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    // 让tableView 选中我们找到的歌词
    [self.tabView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
    
}
// 返回播放时间 分:秒
- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger minutes = time / 60;
    NSInteger second = (int)time %60 ;
    return [NSString stringWithFormat:@"%ld:%ld",(long)minutes,(long)second];
    
}


#pragma mark -- 可视化编程
- (IBAction)Action4Back:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 暂停或播放
- (IBAction)action4PlayOrPause:(UIButton *)sender {
    
    _btn4PlayPause.showsTouchWhenHighlighted = YES;
    // 判断是否正在播放
    if ([PlayerManager sharedPlayerManager].isPlaying) {
        // 正在播放就暂停，同时该表Button的text
        [[PlayerManager sharedPlayerManager] pause];
        [sender setImage:[UIImage imageNamed:@"Playing"] forState:(UIControlStateNormal)];
        //[sender setTitle:@"播放" forState:(UIControlStateNormal)];
    }else{
        [[PlayerManager sharedPlayerManager] play];
        [sender setImage:[UIImage imageNamed:@"pause@2x"] forState:(UIControlStateNormal)];
       // [sender setTitle:@"暂停" forState:(UIControlStateNormal)];
    }
    
    
    
}
// 上一首
- (IBAction)action4Last:(UIButton *)sender {
 //   _btn4PlayPause.showsTouchWhenHighlighted = YES;
    _currentIndex --;
    // 上面先++了所以等于数组的个数
    if (_currentIndex == -1) {
        _currentIndex = [DataManager sharedDataManager].allMusic.count - 1;
    }
    
    [self startPlay];
}
// 下一首
- (IBAction)action4Next:(UIButton *)sender {
    // _btn4PlayPause.showsTouchWhenHighlighted = YES;
    _currentIndex ++;
    // 上面先++了所以等于数组的个数
    if (_currentIndex == [DataManager sharedDataManager].allMusic.count) {
        _currentIndex = 0;
    }
    [self startPlay];
}
// 播放进度
- (IBAction)action4ChangeTime:(UISlider *)sender {
    
  //  UISlider *slider = sender;
    // 调用接口
    [[PlayerManager sharedPlayerManager] seekToTime:sender.value];
    
}

//声音大小
- (IBAction)action4Volmn:(UISlider *)sender {

    [[PlayerManager sharedPlayerManager]seekToVolume:sender.value];
    
}

// 顺序播放
- (IBAction)action4Order:(UIButton *)sender {
    _playingStause = 0;
}

// 随机播放
- (IBAction)action4Random:(UIButton *)sender {
    _playingStause = 1;
    NSInteger musicCount = [DataManager sharedDataManager].allMusic.count;
    
    _currentIndex = arc4random()% musicCount + 1;
    
    [self startPlay];

    
}

// 单曲循环
- (IBAction)action4One:(UIButton *)sender {
    _playingStause = 2;

    [self startPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Music *)currentModel{
    // 用当前的currectIndex;
    Music *music = [[DataManager sharedDataManager] musicFromIndex:self.currentIndex];
    return music;
}

#pragma mark --- UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [LyricManager sharedLyricManager].allLyric.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    // cell.textLabel.text = @"歌词";
    // 取出对应的cell
    LyircModel *lyric = [LyricManager sharedLyricManager].allLyric[indexPath.row];
    cell.textLabel.text = lyric.lyricContext;
    
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;

}



//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
