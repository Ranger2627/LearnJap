//
//  AboutViewController.m
//  FiftyTest
//
//  Created by Jack on 2018/6/4.
//  Copyright © 2018年 DS. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iconImage.layer.shadowOffset = CGSizeMake(0, 5);
    self.iconImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.iconImage.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    self.iconImage.layer.shadowRadius = 6;//阴影半径，默认3
    
    //版本信息
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.infoLabel.text = [NSString stringWithFormat:@"熟练记忆五十音写法的辅助App\n\n版本号：%@\n\n感谢参与测试的小朋友",app_Version];
    
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
