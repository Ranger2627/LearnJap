//
//  ViewController.m
//  FiftyTest
//
//  Created by Wuxinglin on 2018/5/28.
//  Copyright © 2018年 DS. All rights reserved.
//

#import "ViewController.h"
#import "StartViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    startButton.backgroundColor = [UIColor orangeColor];
    [startButton addTarget:self action:@selector(startTestNow) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:startButton];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startTestNow{
    StartViewController *new = [[StartViewController alloc]init];
    [self presentViewController:new animated:YES completion:nil];
}

@end
