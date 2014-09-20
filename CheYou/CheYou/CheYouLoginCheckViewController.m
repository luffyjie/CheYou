//
//  CheYouLoginCheckViewController.m
//  CheYou
//
//  Created by lujie on 14-9-19.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouLoginCheckViewController.h"

@interface CheYouLoginCheckViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;

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
    
    //设置键盘类型
    self.phoneText.delegate = self;
    self.pwdText.delegate = self;
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneText.tag = 1;
    self.pwdText.returnKeyType = UIReturnKeyDone;
    self.pwdText.secureTextEntry = YES;
    self.pwdText.tag = 2;
    
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
    if (textField.tag == 1) {
         return [self validateNumber:string];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma 导航返回
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 登录按钮
- (IBAction)LoginButton:(id)sender {
    if (self.phoneText.text.length <1) {
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"手机号不能为空", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        
        [alert show];
        [self.phoneText becomeFirstResponder];
        return;
    }
    if (self.pwdText.text.length <4) {
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"密码不能为空或小于4位", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        
        [alert show];
        [self.pwdText becomeFirstResponder];
        return;
    }
    
    [self performSegueWithIdentifier:@"home_segue" sender:self];
}

@end
