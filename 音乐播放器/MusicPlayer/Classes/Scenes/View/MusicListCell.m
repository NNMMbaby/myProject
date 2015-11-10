//
//  MusicListCell.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "MusicListCell.h"

@implementation MusicListCell


- (void)setMusic:(Music *)music{
    _music = music; // 赋值 不然以后用不了
    
    self.songName.text = music.name;
    self.singerName.text = music.singer;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString: music.picUrl] placeholderImage:[UIImage imageNamed:@"o"]];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
