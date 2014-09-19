//
//  CheYouLoginCheckViewController.m
//  CheYou
//
//  Created by lujie on 14-9-19.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouLoginCheckViewController.h"

@interface CheYouLoginCheckViewController ()

@end

@implementation CheYouLoginCheckViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma 导航返回
- (void)backAction:(id)sender
{
    //    [self dismissViewControllerAnimated:YES completion: nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
