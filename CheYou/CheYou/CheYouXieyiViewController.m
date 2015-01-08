//
//  CheYouXieyiViewController.m
//  CheYou
//
//  Created by lujie on 15/1/8.
//  Copyright (c) 2015年 CheYou. All rights reserved.
//

#import "CheYouXieyiViewController.h"

@interface CheYouXieyiViewController ()

@end

@implementation CheYouXieyiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    backButton.image = [UIImage imageNamed:@"back"];
    [self.navigationItem setLeftBarButtonItem:backButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 导航返回
- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion: nil];
}

@end
