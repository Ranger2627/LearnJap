//
//  CusViewController.m
//  FiftyTest
//
//  Created by Jack on 2018/5/31.
//  Copyright © 2018年 DS. All rights reserved.
//

#import "CusViewController.h"
#import "ReminderTableViewCell.h"
#import "StartViewController.h"

@interface CusViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *jackTableView;
@property(copy,nonatomic)NSArray *dataArray;
@property(strong,nonatomic)NSMutableArray *statusArray;  //记录选择状态的数据
@end

@implementation CusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择范围";
    //创建数据源
    [self makeDataForTableView];
    //加载tableView
    [self.view addSubview:self.jackTableView];
    //添加一个能够取消的button
    UIBarButtonItem *rightCancle = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancleAction)];
    self.navigationItem.rightBarButtonItem = rightCancle;
    
    CGFloat yPosition = Main_Height-50;
    if (isIphoneX) {
        yPosition = yPosition-34;
    }
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(0, yPosition, Main_Width, 50)];
    startButton.backgroundColor = [UIColor orangeColor];
    [startButton setTitle:@"开始测试" forState:(UIControlStateNormal)];
    [startButton addTarget:self action:@selector(starttestAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:startButton];
}

-(void)cancleAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 创建数据
-(void)makeDataForTableView{
    
    self.dataArray = @[
                       @[@"あ 行",
                         @"か 行",
                         @"さ 行",
                         @"た 行",
                         @"な 行",
                         @"は 行",
                         @"ま 行",
                         @"や 行",
                         @"ら 行",
                         @"わ 行"],
                        @[@"が 行",
                          @"ざ 行",
                          @"だ 行",
                          @"ば 行"],
                        @[@"ぱ 行"],
                        @[@"ん 行"]
                       ];
    self.statusArray = [NSMutableArray arrayWithCapacity:2];
    for (NSArray *smallArray in self.dataArray) {
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSInteger i = 0; i < smallArray.count; i++) {
            NSString *string = @"No";
            [muArray addObject:string];
        }
        [self.statusArray addObject:muArray];
    }
}

#pragma mark - tableView & 代理
-(UITableView*)jackTableView{
    if (!_jackTableView) {
        CGFloat tableHeight = Main_Height-50;
        if (isIphoneX) {
            tableHeight = tableHeight-34;
        }
        _jackTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Width, tableHeight) style:(UITableViewStylePlain)];
        _jackTableView.delegate = self;
        _jackTableView.dataSource = self;
        _jackTableView.showsVerticalScrollIndicator = NO;
        
        [_jackTableView registerNib:[UINib nibWithNibName:@"ReminderTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReminderTableViewCell"];
    }
    return _jackTableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Width, 40)];
    header.backgroundColor = [UIColor lightGrayColor];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, Main_Width, 20)];
    if (section == 0) {
        headerLabel.text = @"  清音";
    }else if (section == 1){
        headerLabel.text = @"  浊音";
    }else if (section == 2){
        headerLabel.text = @"  半浊音";
    }else if (section == 3){
        headerLabel.text = @"  拔音";
    }
    [header addSubview:headerLabel];
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出数据
    NSArray *tempArray = self.dataArray[indexPath.section];
    NSMutableArray *secStaArray = self.statusArray[indexPath.section];
    
    ReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([secStaArray[indexPath.row] isEqualToString:@"No"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.titleLabel.text = tempArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *secStaArray = self.statusArray[indexPath.section];
    ReminderTableViewCell *cell = [self.jackTableView cellForRowAtIndexPath:indexPath];
    if (![secStaArray[indexPath.row] isEqualToString:@"No"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.statusArray[indexPath.section][indexPath.row] = @"No";
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.statusArray[indexPath.section][indexPath.row] = @"Yes";
    }
}

#pragma mark - 开始测试
-(void)starttestAction{
    StartViewController *new = [[StartViewController alloc]init];
    NSArray *allEng = @[
                        @[@[@"a",@"i",@"u",@"e",@"o"],
                          @[@"ka",@"ki",@"ku",@"ke",@"ko"],
                          @[@"sa",@"si",@"su",@"se",@"so"],
                          @[@"ta",@"chi",@"tsu",@"te",@"to"],
                          @[@"na",@"ni",@"nu",@"ne",@"no"],
                          @[@"ha",@"hi",@"hu",@"he",@"ho"],
                          @[@"ma",@"mi",@"mu",@"me",@"mo"],
                          @[@"ya",@"yu",@"yo"],
                          @[@"ra",@"ri",@"ru",@"re",@"ro"],
                          @[@"wa",@"wo"]],
                        @[@[@"ga",@"gi",@"gu",@"ge",@"go"],
                          @[@"za",@"zi",@"zu",@"ze",@"zo"],
                          @[@"da",@"di",@"du",@"de",@"do"],
                          @[@"ba",@"bi",@"bu",@"be",@"bo"]],
                        @[@[@"pa",@"pi",@"pu",@"pe",@"po"]],
                        @[@"n"]];
    NSMutableArray *sendArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.statusArray.count; i ++) {
        NSArray *array = self.statusArray[i];
        for (NSInteger m = 0; m < array.count; m++) {
            NSString *string = array[m];
            if ([string isEqualToString:@"Yes"]) {
                NSLog(@"i=%ld, m=%ld",(long)i,(long)m);
                [sendArray addObjectsFromArray:allEng[i][m]];
            }
        }
    }
    if (sendArray.count == 0) {
        //判空防止崩溃
        UIAlertController *tipCon = [UIAlertController alertControllerWithTitle:nil message:@"请选择范围后开始测试" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"好的" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [tipCon addAction:sureAction];
        [self presentViewController:tipCon animated:YES completion:^{
            
        }];
        return;
        
    }
    new.infoArray = sendArray;
    [self.navigationController pushViewController:new animated:YES];
}

@end
