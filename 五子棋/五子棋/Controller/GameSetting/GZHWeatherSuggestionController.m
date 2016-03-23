//
//  GZHWeatherSuggestionController.m
//  五子棋
//
//  Created by 高增洪 on 16/3/23.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHWeatherSuggestionController.h"

@interface GZHWeatherSuggestionController ()
@property (nonatomic,strong) NSArray *keyAry;
@property (nonatomic,strong) NSArray *iconAry;
@end

@implementation GZHWeatherSuggestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"天气指南";
    //设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}


- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   self.iconAry = @[@"xiche",@"chuanyi",@"ganmao",@"yundong",@"lvyou",@"ziwaixian"];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keyAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"weatherSuggestion";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.imageView.clipsToBounds = YES;
        cell.imageView.layer.cornerRadius = 25;
    }
//    cell.imageView
    cell.textLabel.text = [_dict objectForKey:self.keyAry[indexPath.row]][@"brief"];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"\n\%@",[_dict objectForKey:self.keyAry[indexPath.row]][@"details"]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.font  = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.iconAry[indexPath.row]];
    return cell;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.keyAry = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
}

@end
