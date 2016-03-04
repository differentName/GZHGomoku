//
//  GZHNewDetailController.m
//  五子棋
//
//  Created by 高增洪 on 16/3/3.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHNewDetailController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface GZHNewDetailController ()
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation GZHNewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"趣闻详情";
    
    self.playBtn.clipsToBounds = YES;
    self.playBtn.layer.cornerRadius = 10;
    
    self.nameLabel.text = self.titleName;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playVideo:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_content]];
}

@end
