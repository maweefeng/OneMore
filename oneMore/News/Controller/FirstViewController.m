//
//  FirstViewController.m
//  oneMore
//
//  Created by Weefeng Ma on 2017/11/17.
//  Copyright © 2017年 maweefeng. All rights reserved.
//

#import "FirstViewController.h"
#import "G8HistoryCell.h"
#import "G8HistoryModel.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation FirstViewController

#pragma mark 懒加载数组
-(NSMutableArray *)dataArray{
    
    if (_dataArray==nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataArr];
    [self generalDrawCellSetting];
    
    
}
-(void)generalDrawCellSetting{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[G8HistoryCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}
-(void)generalSetting{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}
-(void)getDataArr{
    
    NSString *httpUrl = @"http://api.juheapi.com/japi/toh?key=09c04592403f9904e0962b454dea07d8&v=1.0&month=11&day=1";
    NSString *httpArg = @"limit=10";
    [[NetWorkManager shareManager] request: httpUrl withHttpArg:httpArg success:^(id responseObject) {
        for (NSDictionary * dic in responseObject[@"result"]) {
            
            G8HistoryModel * model = [[G8HistoryModel alloc]initWithDic:dic];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)go{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ---tableViewDelegate----

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    G8HistoryCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[G8HistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    G8HistoryModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    G8HistoryModel * model = self.dataArray[indexPath.row];
   
    
}
#pragma mark ---tableViewDataSource----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
