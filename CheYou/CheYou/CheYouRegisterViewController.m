//
//  CheYouRegisterViewController.m
//  CheYou
//
//  Created by lujie on 14-9-20.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouRegisterViewController.h"
#import "CheYouSetPwdViewController.h"

@interface CheYouRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@end

@implementation CheYouRegisterViewController

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
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)viewDidAppear:(BOOL)animated
{

    [self.phoneText becomeFirstResponder];
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

- (IBAction)nextAction:(id)sender {
    if (self.phoneText.text.length <1) {
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"手机号不能为空", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        
        [alert show];
        [self.phoneText becomeFirstResponder];
        return;
    }
    //缓存用户手机号码到本地
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.phoneText.text forKey:@"userPhone"];
    [self performSegueWithIdentifier:@"duanx_segue" sender:self];
}

#pragma mark 处理segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"duanx_segue"]) {
        CheYouSetPwdViewController *setPwdView = (CheYouSetPwdViewController*)segue.destinationViewController;
        setPwdView.phoneNum = self.phoneText.text;
    }
}

@end
