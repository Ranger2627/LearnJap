//
//  ViewController.m
//  FiftyTest
//
//  Created by Jack on 2018/5/28.
//  Copyright © 2018年 DS. All rights reserved.
//

#import "ViewController.h"
#import "StartViewController.h"
#import "ReminderViewController.h"
#import "CusViewController.h"
#import "AboutViewController.h"
#import <StoreKit/StoreKit.h>       //app内评价

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     Devices - iPhone     -> 在iPad上也可以运行，右下角有1x，2x可选
             - iPad
             - universual -> 运行在iPad上是正常效果，但是UI布局需要重新处理
     */
    
    /*
     调试适配各种ipad信息
     if (isiPad) {
     NSLog(@"是iPad");
     }
     
     if (padPro) {
     NSLog(@"是iPad Pro");
     }
     NSLog(@"屏幕宽度%f",Main_Width);
     NSLog(@"屏幕处理比例%f",screenScale);
     NSLog(@"ipad------%f",padScale);
     */
    
    //infoButton
    UIButton *infoButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 80, (Main_Width-60)*(screenScale), (Main_Width-80)*(screenScale))];
    
    infoButton.backgroundColor = [UIColor lightGrayColor];
    [infoButton setImage:[UIImage imageNamed:@"icon1024"] forState:(UIControlStateNormal)];
    [infoButton addTarget:self action:@selector(infoPageAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:infoButton];
    
    CGFloat ipxPosition = 0;
    if (isIphoneX) {
        ipxPosition = 14;
    }
    
    UIButton *bookButton = [[UIButton alloc]initWithFrame:CGRectMake(30, Main_Height - ipxPosition - 80, Main_Width-60, 40)];
    bookButton.backgroundColor = [UIColor purpleColor];
    [bookButton setTitle:@"单词本" forState:(UIControlStateNormal)];
    [bookButton addTarget:self action:@selector(pushToWordBook) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:bookButton];
    
    //开始测试button
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(30, bookButton.frame.origin.y - 55, Main_Width-60, 40)];
    startButton.backgroundColor = [UIColor orangeColor];
    [startButton addTarget:self action:@selector(startTestNow) forControlEvents:(UIControlEventTouchUpInside)];
    [startButton setTitle:@"开始测试" forState:(UIControlStateNormal)];
    [self.view addSubview:startButton];
    [self RequestReviewAction];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startTestNow{
    StartViewController *new = [[StartViewController alloc]init];
    //弹出选择三种模式，全部，自定，没记住的
    NSInteger type = 0;
    if (isiPad) {
        type = 1;
    }
    UIAlertController *testTypeAlert = [UIAlertController alertControllerWithTitle:nil message:@"请选择测试模式" preferredStyle:(type)];
    //全部
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"全部模式" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        new.infoArray = @[@"a",@"i",@"u",@"e",@"o",
                          @"ka",@"ki",@"ku",@"ke",@"ko",
                          @"sa",@"shi",@"su",@"se",@"so",
                          @"ta",@"chi",@"tsu",@"te",@"to",
                          @"na",@"ni",@"nu",@"ne",@"no",
                          @"ha",@"hi",@"fu",@"he",@"ho",
                          @"ma",@"mi",@"mu",@"me",@"mo",
                          @"ya",@"yu",@"yo",
                          @"ra",@"ri",@"ru",@"re",@"ro",
                          @"wa",@"wo",
                          @"ga",@"gi",@"gu",@"ge",@"go",
                          @"za",@"zi",@"zu",@"ze",@"zo",
                          @"da",@"di",@"du",@"de",@"do",
                          @"ba",@"bi",@"bu",@"be",@"bo",
                          @"pa",@"pi",@"pu",@"pe",@"po",
                          @"n"];
        [self presentViewController:new animated:YES completion:nil];
        //使用次数计数
        [self AddUseTimeCount];
    }];
    [testTypeAlert addAction:allAction];
    //自选
    UIAlertAction *cusAction = [UIAlertAction actionWithTitle:@"自定模式" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //自定义模式，跳到新的页面来选择
        CusViewController *new = [[CusViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:new];
        [self presentViewController:nav animated:YES completion:nil];
        //使用次数计数
        [self AddUseTimeCount];
    }];
    [testTypeAlert addAction:cusAction];
    
    //没有错题记录时候不现实这一条就好
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"forgetWords.plist"];
    NSArray *wordsArray = [NSArray arrayWithContentsOfFile:filePath];
    if (wordsArray != nil && wordsArray.count != 0) {
        UIAlertAction *reminderAction = [UIAlertAction actionWithTitle:@"复习模式" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            new.infoArray = wordsArray;
            [self presentViewController:new animated:YES completion:nil];
            //使用次数计数
            [self AddUseTimeCount];
        }];
        [testTypeAlert addAction:reminderAction];
    }
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [testTypeAlert addAction:cancleAction];
    [self presentViewController:testTypeAlert animated:YES completion:nil];
}

-(void)pushToWordBook{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"forgetWords.plist"];
    NSMutableArray *wordsArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (wordsArray == nil || wordsArray.count == 0) {
        UIAlertController *nonAlert = [UIAlertController alertControllerWithTitle:nil message:@"单词本内暂无信息\n进行测试时您可将印象模糊及记忆有误的音节记录在单词本中，请先进行测试" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [nonAlert addAction:sureAction];
        [self presentViewController:nonAlert animated:YES completion:nil];
    }else{
        ReminderViewController *new = [[ReminderViewController alloc]init];
        new.wordArray = wordsArray;
        [self.navigationController pushViewController:new animated:YES];
    }
    
}

#pragma mark - 进入到app相关页面
-(void)infoPageAction{
    AboutViewController *new = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:new animated:YES];
}

#pragma mark - App内进行评价
-(void)RequestReviewAction{
    NSInteger useTimes = [[NSUserDefaults standardUserDefaults] integerForKey:@"userTimes"];
    if (useTimes == 3) {
        //使用过3次的时候提示评价，下面的一句话便可以实现评分页面的弹出
        [SKStoreReviewController requestReview];
        //目前设计仅弹出一次
        [self AddUseTimeCount];
    }
}

-(void)AddUseTimeCount{
    NSInteger useTimes = [[NSUserDefaults standardUserDefaults] integerForKey:@"userTimes"];
    useTimes += 1;
    [[NSUserDefaults standardUserDefaults]setInteger:useTimes forKey:@"userTimes"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/*
 *更新日志
 *1.0 - 基础功能上线
 *1.1 - 修正测试时最后一个题目无法加入到单词本中的bug - 完成
        单词本中增加删除功能                      - 完成
        App内提示到评分                          - 完成
 */

@end
