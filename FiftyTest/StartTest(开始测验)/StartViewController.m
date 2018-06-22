//
//  StartViewController.m
//  FiftyTest
//
//  Created by Jack on 2018/5/28.
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
@property(copy,nonatomic)NSArray *engArray;             //罗马音(不会去操作)
@property(strong,nonatomic)NSMutableArray *japArray;    //日语(生成后不会去操作)
@property(assign,nonatomic)BOOL showTips;               //是否查看过提示
@property(copy,nonatomic)NSString *lastString;          //翻牌时记录现在显示哪个
@property(strong,nonatomic)NSMutableArray *forgetArray; //忘记词汇数组
@property(assign,nonatomic)BOOL didForget;    //点击下一个按钮是否提示忘记
@property(strong,nonatomic)UIView *showInfoView;        //写在小本本上
@property(strong,nonatomic)UILabel *infoLabel;
@property(strong,nonatomic)UIView *tapTipView;          //第一次打开时候的帮助
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //禁用滑动返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.view addSubview:self.mainLabel];
    [self.view addSubview:self.showInfoView];
    [self.view addSubview:self.progressLabel];
    //创建数据源
    [self creatData];
    //加载第一次数据
    [self showInfomationForlabel];
    CGFloat yPosition = Main_Height-50;
    if (isIphoneX) {
        yPosition = yPosition - 34;
    }
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(0,yPosition, Main_Width, 50)];
    self.nextButton.backgroundColor = [UIColor purpleColor];
    [self.nextButton setTitle:@"写好啦，下一个" forState:(UIControlStateNormal)];
    [self.nextButton addTarget:self action:@selector(showInfomationForlabel) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.nextButton];
    
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(Main_Width-45, 40, 30, 30)];
    [cancleButton setImage:[UIImage imageNamed:@"CancelImage"] forState:(UIControlStateNormal)];
    cancleButton.backgroundColor = [UIColor redColor];
    [cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:cancleButton];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    /*
     第一次打开时候弹出提示，点击提示消失+反转卡片
     以后不再显示
     */
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"FirstLuanch"]) {
        [self.mainLabel addSubview:self.tapTipView];
        [UIView animateWithDuration:1 animations:^{
            self.tapTipView.alpha = 0.5;
        }];
        [[NSUserDefaults standardUserDefaults] setObject:@"NotFirst" forKey:@"FirstLuanch"];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)cancleAction{
    //这里判断，如果不是最后一个，则弹出提示，是否准备退出
    if ([self.nextButton.titleLabel.text isEqualToString:@"结束"]) {
        //应属于正常结束
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertController *skipAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认退出，本次自测中加入单词本的信息也会被保存" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //先判空，如果不为空的话执行
            if (self.forgetArray.count > 0) {
                ///////plist文件的归档
                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *filePath = [path stringByAppendingPathComponent:@"forgetWords.plist"];
                [self.forgetArray writeToFile:filePath atomically:YES];
                ///////plist文件的归档
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            //什么都不做
        }];
        [skipAlert addAction:sureAction];
        [skipAlert addAction:cancleAction];
        [self presentViewController:skipAlert animated:YES completion:nil];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel*)mainLabel{
    if (!_mainLabel) {
        _mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Main_Width, Main_Width)];
        _mainLabel.textAlignment = NSTextAlignmentCenter;
        _mainLabel.font = [UIFont systemFontOfSize:200];
        _mainLabel.backgroundColor = [UIColor lightGrayColor];
        //点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchCardAction)];
        [_mainLabel addGestureRecognizer:tap];
        _mainLabel.userInteractionEnabled = YES;
    }
    return _mainLabel;
}

-(UIView*)tapTipView{
    if (!_tapTipView) {
        _tapTipView = [[UIView alloc]initWithFrame:self.mainLabel.bounds];
        _tapTipView.backgroundColor = [UIColor blackColor];
        _tapTipView.alpha = 0;
        _tapTipView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipTouchAction)];
        [_tapTipView addGestureRecognizer:tap];
        
        CGFloat padHeight = 50;
        if (Main_Height < 667.0) {
            //低分辨率iPad
            padHeight = 40;
        }
        UILabel *tipInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _tapTipView.frame.origin.y+_tapTipView.frame.size.height-padHeight, Main_Width, 20)];
        
        tipInfoLabel.textAlignment = NSTextAlignmentCenter;
        tipInfoLabel.textColor = [UIColor whiteColor];
        tipInfoLabel.text = @"可点击查看答案";
        tipInfoLabel.font = [UIFont systemFontOfSize:20 weight:15];
        [_tapTipView addSubview:tipInfoLabel];
        
    }
    return _tapTipView;
}

-(void)tipTouchAction{
    [UIView animateWithDuration:0.4 animations:^{
        self.tapTipView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tapTipView removeFromSuperview];
        [self switchCardAction];
    }];
}

-(UILabel*)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Main_Width+5, Main_Width, 30)];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:20];
        _progressLabel.textColor = [UIColor grayColor];
        
    }
    return _progressLabel;
}

-(UIView*)showInfoView{
    if (!_showInfoView) {
        _showInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.progressLabel.frame.origin.y+self.progressLabel.frame.size.height, Main_Width, Main_Height-(self.progressLabel.frame.origin.y+self.progressLabel.frame.size.height))];
        _showInfoView.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(showInfoAction:)];
        [_showInfoView addGestureRecognizer:tap];
        
        //提示信息
        CGFloat padHeight = 30.0*Main_Width/375;
        if (Main_Height < 667.0) {
            //低分辨率iPad
            padHeight = -10;
        }
        self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, padHeight, Main_Width, 100)];
        self.infoLabel.text = @"把答案写在小本本上吧";
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        self.infoLabel.font = [UIFont systemFontOfSize:30];
        self.infoLabel.alpha = 0;
        
        [_showInfoView addSubview:self.infoLabel];
        
    }
    return _showInfoView;
}

#pragma mark - 自认为能写字时候慢慢弹出的提示
-(void)showInfoAction:(UIPanGestureRecognizer*)tap{
    //滑动结束时候执行动作
    if (tap.state == UIGestureRecognizerStateEnded) {
        tap.view.userInteractionEnabled = NO;
        if (self.infoLabel.alpha == 0) {
            //慢慢出现
            [UIView animateWithDuration:.5 animations:^{
                self.infoLabel.alpha = 1;
            } completion:^(BOOL finished) {
                tap.view.userInteractionEnabled = YES;
            }];
        }else{
            //慢慢消失
            [UIView animateWithDuration:0.3 animations:^{
                self.infoLabel.alpha = 0;
            } completion:^(BOOL finished) {
                tap.view.userInteractionEnabled = YES;
            }];
        }
    }
    
}

#pragma mark - 卡片翻转
-(void)switchCardAction{
    if (!self.showTips) {
        //点击查看
        self.lastString = self.mainLabel.text;
        NSInteger index = [self.engArray indexOfObject:self.mainLabel.text];
        NSString *japString = self.japArray[index];
        self.mainLabel.text = japString;
        //这里记录卡片翻转过
        self.didForget = YES;
    }else{
        self.mainLabel.text = self.lastString;
    }
    //使用UIView实现的翻转效果
    [UIView beginAnimations:@"fanzhuan" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.mainLabel cache:NO];
    [UIView commitAnimations];
    //改变状态
    self.showTips = !self.showTips;
    
}
#pragma mark - 创建数据源
-(void)creatData{
    self.dataArray = [NSMutableArray array];
    self.forgetArray = [NSMutableArray array];
    self.engArray = self.infoArray;
    //全部假名，给japArray提供数据
    NSArray *allJap = @[@"あ",@"い",@"う",@"え",@"お",
                        @"か",@"き",@"く",@"け",@"こ",
                        @"さ",@"し",@"す",@"せ",@"そ",
                        @"た",@"ち",@"つ",@"て",@"と",
                        @"な",@"に",@"ぬ",@"ね",@"の",
                        @"は",@"ひ",@"ふ",@"へ",@"ほ",
                        @"ま",@"み",@"む",@"め",@"も",
                        @"や",@"ゆ",@"よ",
                        @"ら",@"り",@"る",@"れ",@"ろ",
                        @"わ",@"を",
                        @"が",@"ぎ",@"ぐ",@"げ",@"ご",
                        @"ざ",@"じ",@"ず",@"ぜ",@"ぞ",
                        @"だ",@"ぢ",@"づ",@"で",@"ど",
                        @"ば",@"び",@"ぶ",@"べ",@"ぼ",
                        @"ぱ",@"ぴ",@"ぷ",@"ぺ",@"ぽ",
                        @"ん"];
    NSArray *allEng = @[@"a",@"i",@"u",@"e",@"o",
                        @"ka",@"ki",@"ku",@"ke",@"ko",
                        @"sa",@"si",@"su",@"se",@"so",
                        @"ta",@"chi",@"tsu",@"te",@"to",
                        @"na",@"ni",@"nu",@"ne",@"no",
                        @"ha",@"hi",@"hu",@"he",@"ho",
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
    self.japArray = [NSMutableArray array];
    self.maxNumber = self.engArray.count;
    for (NSString *string in self.engArray) {
        [self.dataArray addObject:string];
        NSString *japString = allJap[[allEng indexOfObject:string]];
        [self.japArray addObject:japString];
    }
}

#pragma mark - 下一页按钮动作
-(void)showInfomationForlabel{
    if ([self.nextButton.titleLabel.text isEqualToString:@"结束"]) {
        //结束
        ///////plist文件的归档
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [path stringByAppendingPathComponent:@"forgetWords.plist"];
        [self.forgetArray writeToFile:filePath atomically:YES];
        ///////plist文件的归档
        
        UIAlertController *doneAlart = [UIAlertController alertControllerWithTitle:@"辛苦啦" message:@"测试完成，休息一下吧" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [doneAlart addAction:sureAction];
        [self presentViewController:doneAlart animated:YES completion:nil];
        
    }else{
        if (self.didForget == YES) {
            //有翻过牌牌
            UIAlertController *tipController = [UIAlertController alertControllerWithTitle:nil message:@"是否加入单词本" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                //确认后执行
                [self.forgetArray addObject:self.lastString];
                [self realNextActionWithType:2];
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                //取消后执行
                [self realNextActionWithType:1];
            }];
            [tipController addAction:sureAction];
            [tipController addAction:cancleAction];
            [self presentViewController:tipController animated:YES completion:^{
                self.didForget = NO;
            }];
        }else{
            //很自信，直接点过
            [self realNextActionWithType:1];
        }
    
    }
    
}

-(void)realNextActionWithType:(NSInteger)type{
    //这个需要复原
    self.showTips = NO;
    
    NSLog(@"剩余%@",self.dataArray);
    self.remainNumber = self.maxNumber-self.dataArray.count +1;
    NSInteger x = arc4random() % self.dataArray.count;
    NSString *string = self.dataArray[x];
    self.mainLabel.text = string;
    [self.dataArray removeObject:string];
    
    ///////////开始动画效果
    CATransition *animation = [CATransition animation];
    animation.type = @"reveal";
    
    if (type == 1) {
        //正常情况
        animation.duration = 0.4;
        animation.subtype = @"fromRight";
    }else{
        //存入忘记单词本
        animation.duration = 0.5;
        animation.subtype = @"fromLeft";
    }
    
    [self.mainLabel.layer addAnimation:animation forKey:@"anim"];
    ///////////结束动画效果
    
    //展示进度
    self.progressLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)(self.remainNumber),(long)self.maxNumber];
    
    if (self.remainNumber == self.maxNumber) {
        [self.nextButton setTitle:@"结束" forState:(UIControlStateNormal)];
    }
}

@end
