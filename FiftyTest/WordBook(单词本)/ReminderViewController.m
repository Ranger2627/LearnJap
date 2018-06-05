//
//  ReminderViewController.m
//  FiftyTest
//
//  Created by Wuxinglin on 2018/5/29.
//  Copyright © 2018年 DS. All rights reserved.
//

#import "ReminderViewController.h"
#import "ReminderTableViewCell.h"

@interface ReminderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *jackTableView;
@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.jackTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
-(UITableView*)jackTableView{
    if (!_jackTableView) {
        _jackTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Main_Width, Main_Height-64) style:(UITableViewStylePlain)];
        _jackTableView.delegate = self;
        _jackTableView.dataSource = self;
        [_jackTableView registerNib:[UINib nibWithNibName:@"ReminderTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReminderTableViewCell"];
    }
    return _jackTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.wordArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderTableViewCell" forIndexPath:indexPath];
    NSString *string = self.wordArray[indexPath.row];
    cell.titleLabel.text = string;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Width, 1)];
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
@end
