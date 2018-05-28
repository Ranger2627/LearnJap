//
//  StartViewController.m
//  FiftyTest
//
//  Created by Wuxinglin on 2018/5/28.
//  Copyright © 2018年 DS. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()
@property(strong,nonatomic)NSMutableArray *dataArray;   //操作的数据
@property(strong,nonatomic)UILabel *mainLabel;          //主显示的大字
@property(strong,nonatomic)UILabel *progressLabel;      //进度标识
@property(assign,nonatomic)NSInteger maxNumber;         //最多的数字
@property(assign,nonatomic)NSInteger remainNumber;      //剩下的量
@property(strong,nonatomic)UIButton *nextButton;        //下一个直到结束
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainLabel];
    [self.view addSubview:self.progressLabel];
    //创建数据源
    [self creatData];
    //加载第一次数据
    [self showInfomationForlabel];
    
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(0, Main_Height-50, Main_Width, 50)];
    self.nextButton.backgroundColor = [UIColor purpleColor];
    [self.nextButton setTitle:@"下一个" forState:(UIControlStateNormal)];
    [self.nextButton addTarget:self action:@selector(showInfomationForlabel) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.nextButton];
    
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(Main_Width-45, 40, 30, 30)];
    cancleButton.backgroundColor = [UIColor lightGrayColor];
    [cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:cancleButton];
    
}

-(void)cancleAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel*)mainLabel{
    if (!_mainLabel) {
        _mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Main_Width, Main_Width)];
        _mainLabel.textAlignment = NSTextAlignmentCenter;
        _mainLabel.font = [UIFont systemFontOfSize:250];
    }
    return _mainLabel;
}

-(UILabel*)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Main_Width, Main_Width, 30)];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:20];
        _progressLabel.textColor = [UIColor grayColor];
    }
    return _progressLabel;
}

#pragma mark - 创建数据源
-(void)creatData{
    self.dataArray = [NSMutableArray array];
    NSArray *tempArray = @[@"a",@"i",@"u",@"e",@"o",
                       @"ka",@"ki",@"ku",@"ke",@"ko",
                       @"sa",@"si",@"su",@"se",@"so",
                       @"ta",@"chi",@"tu",@"te",@"to"
                       ];
    self.maxNumber = tempArray.count;
    for (NSString *string in tempArray) {
        [self.dataArray addObject:string];
    }
}

-(void)showInfomationForlabel{
    if ([self.nextButton.titleLabel.text isEqualToString:@"结束"]) {
        //结束
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    NSLog(@"剩余%@",self.dataArray);
    self.remainNumber = self.maxNumber-self.dataArray.count +1;
    NSInteger x = arc4random() % self.dataArray.count;
    NSString *string = self.dataArray[x];
    self.mainLabel.text = string;
    [self.dataArray removeObject:string];
    
    //展示进度
    self.progressLabel.text = [NSString stringWithFormat:@"%ld/%ld",(self.remainNumber),(long)self.maxNumber];
    
    if (self.remainNumber == self.maxNumber) {
        [self.nextButton setTitle:@"结束" forState:(UIControlStateNormal)];
    }
}

@end
