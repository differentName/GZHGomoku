//
//  GZHGameNewsHomeController.m
//  五子棋
//
//  Created by 高增洪 on 16/3/3.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHGameNewsHomeController.h"
#import "DCPicScrollView.h"
#import "GZHHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "GZHNewsModel.h"
#import "GZHNewDetailController.h"
#import "GZHSQLTool.h"
@interface GZHGameNewsHomeController ()
{
    DCPicScrollView *_scrollView;
}
@property (assign, nonatomic) int category_id;
@property (assign, nonatomic) int page;
@property (nonatomic,strong) NSArray *picAry;
@property (nonatomic,strong) NSArray *titleAry;
@property (nonatomic,strong) NSArray *topAry;
@property (nonatomic,strong) NSMutableArray *dataAry;
@end

@implementation GZHGameNewsHomeController
- (NSMutableArray *)dataAry
{
    if (_dataAry == nil) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showMessage:@"数据加载中"];
    //初始化轮播图数据
    self.titleAry = @[@"五子棋的基础",@"五子棋解题方法与技巧",@"高飞五子棋公开课"];
    self.picAry = @[@"http://img0.pchouse.com.cn/pchouse/1509/27/1285682_39.jpg",@"http://imgsrc.baidu.com/forum/pic/item/63d0f703918fa0eca2d9d4b9269759ee3d6ddb6c.jpg",@"http://www.wuzi8.com/renwu/UploadFiles/201111/2011112216513911.jpg"];
    self.topAry = @[@"http://player.youku.com/embed/XNDI2MDY1MTc2",@"http://player.youku.com/embed/XMzY3NzE1NjI4",@"http://player.youku.com/embed/XMzU2NDEzMTY4"];
    
    self.category_id = 446;
    self.page = 1;
    
    // 2.先尝试从数据库中加载微博数据
    NSArray *newsAry = [GZHSQLTool newsWithParams:nil];
    NSLog(@"%@",newsAry);
    if (newsAry.count) { // 数据库有缓存数据
        NSLog(@"%@",newsAry);
        [self.dataAry addObjectsFromArray:[GZHNewsModel objectArrayWithKeyValuesArray:newsAry]];
        
        [MBProgressHUD hideHUD];
        
        [self.tableView reloadData];
    } else {
    //请求新闻数据 //子线程请求网络数据避免阻塞
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [GZHHttpTool get:@"http://112.124.20.32:9999/web_manage/api/news_list.do?admin_id=152" params:@{@"category_id":[NSString stringWithFormat:@"%d",self.category_id ],@"page":[NSString stringWithFormat:@"%d",self.page]} success:^(id json) {
            //将数据保存到数据库
            [GZHSQLTool saveNews:json[@"data"]];
            
            [self.dataAry addObjectsFromArray:[GZHNewsModel objectArrayWithKeyValuesArray:json[@"data"]]];
            
            [MBProgressHUD hideHUD];
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"数据异常"];
        }];

    });
    }
    
    //设置导航栏标题
    self.title = @"五子趣闻";
    
    //设置上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    
    //设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //设置导航栏背景颜色图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_black"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    //设置导航栏标题字体大小及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
//返回上层界面
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.category_id = 446;
    self.page = 1;
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return self.dataAry.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *ID = @"NewsTopCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,160*([UIScreen mainScreen].bounds.size.width/320));
        if (_scrollView == nil) {
            _scrollView = [[DCPicScrollView alloc] initWithFrame:frame WithImageNames:self.picAry];
            _scrollView.placeImage = [UIImage imageNamed:@"lunbotu_default"];
            _scrollView.titleData = self.titleAry;
            __weak typeof(self) weakself = self;
            [_scrollView setImageViewDidTapAtIndex:^(NSInteger index) {
//                            printf("你点到我了😳index:%zd\n",index);
                GZHNewDetailController *newDetail = [[GZHNewDetailController alloc]init];
                newDetail.titleName = weakself.titleAry[index];
                newDetail.content = weakself.topAry[index];
                [weakself.navigationController pushViewController:newDetail animated:YES];
            }];
        }
        [cell addSubview:_scrollView];
        return cell;
    }else{
        static NSString *ID = @"NewsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.imageView.image = [UIImage imageNamed:@"cellIcon"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        GZHNewsModel *new = self.dataAry[indexPath.row];
        cell.textLabel.text = new.title;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 160*([UIScreen mainScreen].bounds.size.width/320);
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZHNewsModel *selectedModel = _dataAry[indexPath.row];
    
    GZHNewDetailController *newDetail = [[GZHNewDetailController alloc]init];
    newDetail.titleName = selectedModel.title;
    newDetail.content = selectedModel.content;
    [self.navigationController pushViewController:newDetail animated:YES];
}

//上拉加载更多数据
- (void)loadMore{
    int category_id;
    int page;
    if (self.category_id == 446 && self.page==1) {
        
        category_id = 446;
        page = 2;
    }else{
        category_id = self.category_id;
        page = 1;
    }
    self.category_id+=1;
    self.page+=1;
    
    [GZHHttpTool get:@"http://112.124.20.32:9999/web_manage/api/news_list.do?admin_id=152" params:@{@"category_id":[NSString stringWithFormat:@"%d",category_id ],@"page":[NSString stringWithFormat:@"%d",page]} success:^(id json) {
        //            NSLog(@"%@",json);
        [_dataAry addObjectsFromArray:[GZHNewsModel objectArrayWithKeyValuesArray:json[@"data"]]];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
        NSLog(@"%@",error);
    }];
}

@end
