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
                                   initWithTitle:@""
                                   style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    backButton.image = [UIImage imageNamed:@"back"];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    //设置退出按钮位置
    self.logbutton.frame = CGRectMake(30, self.view.frame.size.height - 130, self.view.frame.size.width - 60, 40);
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
    
    [self performSegueWithIdentifier:@"geren_segue" sender:self];
}

- (IBAction)yiJianButton:(id)sender {
    
    [self performSegueWithIdentifier:@"segue_suggest" sender:self];
}

- (IBAction)cacheButton:(id)sender {
    NSString *title = NSLocalizedString(@"提示", nil);
    NSString *message = NSLocalizedString(@"缓存清除成功！", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alert show];
}

- (IBAction)about:(id)sender {
    
    [self performSegueWithIdentifier:@"segue_about" sender:self];
}

- (IBAction)logOutButton:(id)sender {
    //设置用户退出状态
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:@"userOut"];
    [userDefaults synchronize];
    [self performSegueWithIdentifier:@"backlogin_segue" sender:self];
}

@end
