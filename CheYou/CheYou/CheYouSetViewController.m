//
//  CheYouSetViewController.m
//  CheYou
//
//  Created by lujie on 14-9-17.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouSetViewController.h"

@interface CheYouSetViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logbutton;

@end

@implementation CheYouSetViewController

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
    
    //设置退出按钮位置
    self.logbutton.frame = CGRectMake(30, self.view.frame.size.height - 120, self.view.frame.size.width - 60, 30);
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma 设置按钮

- (IBAction)geRenButton:(id)sender {
    
}

- (IBAction)yiJianButton:(id)sender {
    
}

- (IBAction)cacheButton:(id)sender {
    
}

- (IBAction)about:(id)sender {
    
}

- (IBAction)logOutButton:(id)sender {
    
}


@end
