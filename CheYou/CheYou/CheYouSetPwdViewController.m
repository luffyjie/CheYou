//
//  CheYouSetPwdViewController.m
//  CheYou
//
//  Created by lujie on 14-9-20.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouSetPwdViewController.h"

@interface CheYouSetPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextField *yzmText;

@end

@implementation CheYouSetPwdViewController

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
    // Do any additional setup after loading the view.
    self.pwdText.delegate = self;
    self.pwdText.returnKeyType = UIReturnKeyDone;
    self.pwdText.secureTextEntry = YES;
    self.yzmText.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self.pwdText becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITextFeild 委托

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [self.pwdText resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        if (self.pwdText.text.length <4) {
            NSString *title = NSLocalizedString(@"提示", nil);
            NSString *message = NSLocalizedString(@"密码不能为空或小于4位", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
            
            [alert show];
            [self.pwdText becomeFirstResponder];
            return FALSE;
        }
        
        return FALSE;
    }
    return YES;
}


#pragma  重发验证码按钮

- (IBAction)sendAction:(id)sender {
    
}

#pragma 导航按钮

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextAction:(id)sender {
    
      [self performSegueWithIdentifier:@"reginfo_segue" sender:self];
}

@end
