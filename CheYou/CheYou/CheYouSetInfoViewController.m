//
//  CheYouSetInfoViewController.m
//  CheYou
//
//  Created by lujie on 14-9-20.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouSetInfoViewController.h"

@interface CheYouSetInfoViewController ()



@end

@implementation CheYouSetInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    backButton.image = [UIImage imageNamed:@"back"];
    [self.navigationItem setLeftBarButtonItem:backButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 导航按钮

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finishAction:(id)sender {
    
}

@end
