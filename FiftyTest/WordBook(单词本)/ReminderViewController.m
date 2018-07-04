//
//  ReminderViewController.m
//  FiftyTest
//
//  Created by Jack on 2018/5/29.
//  Copyright © 2018年 DS. All rights reserved.
//

#import "ReminderViewController.h"
#import "ReminderTableViewCell.h"

@interface ReminderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *jackTableView;
@property(strong,nonatomic)UIButton *deleteButton;          //底部出现的删除button
@property(strong,nonatomic)UIBarButtonItem *rightItem;
@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"单词本";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.jackTableView];
    [self.view addSubview:self.deleteButton];
    
    //添加Navigation右侧的按钮
    self.rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightButtonAction:)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
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
        
        _jackTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Width, 50)];
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
    
    if (tableView.editing == YES) {
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"取消点选");
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Width, 1)];
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - 左滑删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing == YES) {
        //正在编辑，这里需要返回两个，以实现又缩紧
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //先删除数据源
        [self.wordArray removeObjectAtIndex:indexPath.row];
        //再删除cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationTop)];
        NSLog(@"删除%@",indexPath);
    }
}

#pragma mark - 底部出现的删除按钮
-(UIButton*)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, Main_Height, Main_Width, 50)];
        _deleteButton.backgroundColor = [UIColor redColor];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:1];
        [_deleteButton setTitle:@"删除所选" forState:(UIControlStateNormal)];
        [_deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _deleteButton;
}

-(void)deleteButtonAction{
    /*
     点击批量删除按钮
     */
    
    //取出已经选中的indexpath
    NSArray *selRowArray = self.jackTableView.indexPathsForSelectedRows;
    NSMutableArray *deleArray = [NSMutableArray array];
    for (NSIndexPath *selIndexPath in selRowArray) {
        NSInteger selIndex = selIndexPath.row;
        NSString *deleString = self.wordArray[selIndex];
        [deleArray addObject:deleString];
    }
    //更新数据源
    [self.wordArray removeObjectsInArray:deleArray];
    //删除对应的tableViewCell
    [self.jackTableView deleteRowsAtIndexPaths:selRowArray withRowAnimation:(UITableViewRowAnimationTop)];
    
    CGRect origRect = self.deleteButton.frame;
    origRect.origin.y = Main_Height;
    self.rightItem.title = @"编辑";
    [UIView animateWithDuration:0.3 animations:^{
        self.deleteButton.frame = origRect;
    }];
    [self.jackTableView setEditing:NO animated:YES];
}

-(void)rightButtonAction:(UIBarButtonItem*)sender{
    
    CGRect origRect = self.deleteButton.frame;
    /*
     右上角Navigation上面的按钮
     根据origRect.origin.y的位置来控制底部deleteButton的隐藏还是显示
     */
    CGFloat ipx = 0;
    if (isIphoneX) {
        ipx = 34;
    }
    BOOL openEditing = YES;
    if (origRect.origin.y == Main_Height) {
        //隐藏->展示
        origRect.origin.y = Main_Height-origRect.size.height-ipx;
        sender.title = @"完成";
        sender.style = UIBarButtonItemStyleDone;
        
    }else{
        //展示->隐藏
        origRect.origin.y = Main_Height;
        sender.title = @"编辑";
        openEditing = NO;

    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.deleteButton.frame = origRect;
        
    }];
    [self.jackTableView setEditing:openEditing animated:YES];
}

-(void)dealloc{
    ////////////plist文件的归档////////////
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"forgetWords.plist"];
    [self.wordArray writeToFile:filePath atomically:YES];
    ////////////plist文件的归档////////////
    NSLog(@"单词本完全释放");
}
@end
