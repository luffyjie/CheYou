//
//  CheYouGeRenViewController.m
//  CheYou
//
//  Created by lujie on 14-9-17.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouGeRenViewController.h"

@interface CheYouGeRenViewController ()

@end

@implementation CheYouGeRenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbar.hidden = YES;
    // Do any additional setup after loading the view.
    // 设置返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"返回"
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

#pragma 导航返回
- (void)backAction:(id)sender
{
    //    [self dismissViewControllerAnimated:YES completion: nil];
    [self.navigationController popViewControllerAnimated:YES]; 
}

@end
