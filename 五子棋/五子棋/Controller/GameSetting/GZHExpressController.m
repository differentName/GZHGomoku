//
//  GZHExpressController.m
//  五子棋
//
//  Created by 高增洪 on 16/3/11.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHExpressController.h"
#import "MBProgressHUD+MJ.h"
#import "GZHHttpTool.h"
#import "MJExtension.h"
#import "GZHExpressModel.h"
@interface GZHExpressController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property(nonatomic,strong) NSArray *expressAry;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
- (IBAction)clickSearchBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@end

@implementation GZHExpressController
- (NSArray *)expressAry
{
    if (_expressAry == nil) {
        self.expressAry = [[NSArray alloc]init];
    }
    return _expressAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBtn.clipsToBounds = YES;
    self.searchBtn.layer.cornerRadius = 6;
    self.numLabel.clipsToBounds = YES;
    self.numLabel.layer.cornerRadius = 6;
    
    self.searchBtn.enabled = NO;
    
    self.numText.delegate = self;
    //设置导航栏背景颜色图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_black"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    //设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //设置导航栏标题字体大小及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];

    
    self.navigationItem.title = @"快递查询";
    
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

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)clickSearchBtn:(UIButton *)sender {
    [ MBProgressHUD showMessage:@"物流加载中"];
    [self loadInfoData];
}

//根据文字控制按钮是否可以被点击
- (IBAction)tectChanged:(UITextField *)sender {
    if(sender.text.length == 0){
        self.searchBtn.enabled = NO;
    }else{
        self.searchBtn.enabled = YES;
    }
    NSLog(@"%@",sender.text);
}

//加载物流订单情况
- (void)loadInfoData
{
#warning Mark 这个Key有时间限制 如果查询不到可能是key已失效 需要http://www.36wu.com/Apply去申请新的key
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"postid"] = self.numText.text;
    dict[@"format"] = @"json";
    dict[@"authkey"] = @"031def355e6b419c8bbb5c39ab112c9f";
    [GZHHttpTool get:@"http://api.36wu.com/Express/GetExpressInfo" params:dict success:^(id json) {
        NSLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([json[@"status"] isEqualToNumber:@200]) {//查询成功
            NSLog(@"%@",json);
             _expressAry = [GZHExpressModel objectArrayWithKeyValuesArray:json[@"data"]];
            [self.resultTableView reloadData];
         
        }else{//查询失败
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请输入正确地订单号"];
            self.numText.text = nil;
            self.searchBtn.enabled = NO;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网路异常"];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.expressAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"express";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    }
    GZHExpressModel *model = self.expressAry[indexPath.row];
    cell.textLabel.text = model.remark;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = model.acceptTime;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
