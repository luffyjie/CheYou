//
//  CheYouAboutController.m
//  CheYou
//
//  Created by lujie on 14-10-16.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouAboutController.h"

@implementation CheYouAboutController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbar.hidden = YES;
    // 设置返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    backButton.image = [UIImage imageNamed:@"back"];
    [self.navigationItem setLeftBarButtonItem:backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 导航返回
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
