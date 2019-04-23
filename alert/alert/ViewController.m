//
//  ViewController.m
//  alert
//
//  Created by 高增洪 on 2019/4/23.
//  Copyright © 2019 高增洪. All rights reserved.
//

#import "ViewController.h"
#import <alertlib/AlertTool.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [AlertTool showLoadingProgressIndication];
}
@end
