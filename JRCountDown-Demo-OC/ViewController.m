//
//  ViewController.m
//  JRCountDown-Demo-OC
//
//  Created by Johnson Rey on 2017/11/8.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

#import "ViewController.h"
#import "JRCountDown.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray * dataList;

@property (strong, nonatomic) UITableView * tableView;

@property (strong, nonatomic) JRCountDown * countDown;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.countDown = [[JRCountDown alloc] initWithTableView:self.tableView dataSource:self.dataList];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.tag = indexPath.row;
    cell.textLabel.tag = 1314;
    
    cell.textLabel.text = [self.countDown wh_countDownWithIndexPath:indexPath];
    
    return cell;
}


- (NSArray *)dataList {
    NSMutableArray * nmArr;
    if (_dataList == nil) {
        _dataList = [NSArray array];
        
        nmArr = [NSMutableArray array];
        NSArray *arr = [NSArray array];
        NSDate * datenow = [NSDate date];
        NSString*timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        NSInteger nowInteger = [timeSp integerValue];
        for (int i = 0; i < 50; i ++) {
            NSString *str = [NSString stringWithFormat:@"%zd",arc4random()%100000 + nowInteger];
            NSString *str1 = [NSString stringWithFormat:@"%zd",arc4random()%1000 + nowInteger];
            NSString *str2 = [NSString stringWithFormat:@"%zd",arc4random()%100 + nowInteger];
            arr = @[str,str1,str2];
            [nmArr addObjectsFromArray:arr];
        }
        _dataList = nmArr.copy;
    }
    return _dataList;
}

@end
