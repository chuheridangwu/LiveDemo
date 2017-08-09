//
//  LiveListViewController.m
//  LiveDemo
//
//  Created by dym on 2017/8/1.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "LiveListViewController.h"
#import "LiveMainViewController.h"
#import "Room.h"
#import "YZLiveItem.h"
#import "YZLiveCell.h"


static NSString * const ID = @"cell";


@interface LiveListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *lives;

@end

@implementation LiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"直播列表";
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
      [self.tableView registerNib:[UINib nibWithNibName:@"YZLiveCell" bundle:nil] forCellReuseIdentifier:ID];
    
    // 加载数据
    [self loadData];
}

- (void)loadData
{
    // 映客数据url
    NSString *urlStr = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    
    // 请求数据
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [mgr GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        _lives = [YZLiveItem mj_objectArrayWithKeyValuesArray:responseObject[@"lives"]];
        [Room currentRoom].liveArray = _lives;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lives.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.live = _lives[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 430;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"----------------");
    LiveMainViewController *mainvc = [[LiveMainViewController alloc]init];
    [mainvc setDataSource:_lives curIndex:indexPath.row];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainvc];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
