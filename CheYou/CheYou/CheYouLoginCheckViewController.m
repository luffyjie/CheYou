//
//  CheYouLoginCheckViewController.m
//  CheYou
//
//  Created by lujie on 14-9-19.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouLoginCheckViewController.h"
#import "AFNetworking.h"

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
    self.phoneText.keyboardType = UIKeyboardTypePhonePad;
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
        if (self.phoneText.text.length <1) {
            NSString *title = NSLocalizedString(@"提示", nil);
            NSString *message = NSLocalizedString(@"手机号不能为空", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
            [alert show];
            [self.phoneText becomeFirstResponder];
            return false;
        }
        if (self.pwdText.text.length <4) {
            NSString *title = NSLocalizedString(@"提示", nil);
            NSString *message = NSLocalizedString(@"密码不能为空或小于4位", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
            [alert show];
            [self.pwdText becomeFirstResponder];
            return false;
        }
        //和上次登录信息进行验证
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userPhone = [userDefaults stringForKey:@"userPhone"];
        NSString *userPwd = [userDefaults stringForKey:@"userPhone"];
        if (userPhone && userPwd) {
            if ([userPwd isEqualToString:self.phoneText.text] && [userPwd isEqualToString:self.pwdText.text]) {
                //设置用户登录状态
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setInteger:2 forKey:@"userOut"];
                [userDefaults synchronize];
                [self performSegueWithIdentifier:@"home_segue" sender:self];
                return FALSE;
            }
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{@"account": self.phoneText.text,@"passwd": self.pwdText.text};
        [manager POST:@"http://114.215.187.69/citypin/rs/user/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            //缓存用户手机号，密码到本地
            [userDefaults setObject:self.phoneText.text forKey:@"userPhone"];
            [userDefaults setObject:self.pwdText.text forKey:@"userPwd"];
            [userDefaults setInteger:2 forKey:@"userOut"];
            [userDefaults synchronize];
            [self performSegueWithIdentifier:@"home_segue" sender:self];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSString *title = NSLocalizedString(@"提示", nil);
            NSString *message = NSLocalizedString(@"密码或手机号码错误", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
            [alert show];
        }];

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userPhone = [userDefaults stringForKey:@"userPhone"];
    NSString *userPwd = [userDefaults stringForKey:@"userPwd"];
    if (userPhone.length>1 && userPwd.length>1) {
        if ([userPhone isEqualToString:self.phoneText.text] && [userPwd isEqualToString:self.pwdText.text]) {
            //设置用户登录状态
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:2 forKey:@"userOut"];
            [userDefaults synchronize];
            [self performSegueWithIdentifier:@"home_segue" sender:self];
            return;
        }
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"account": self.phoneText.text,@"passwd": self.pwdText.text};
    [manager POST:@"http://114.215.187.69/citypin/rs/user/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //缓存用户手机号，密码到本地
        [userDefaults setObject:self.phoneText.text forKey:@"userPhone"];
        [userDefaults setObject:self.pwdText.text forKey:@"userPwd"];
        //设置用户登录状态
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:2 forKey:@"userOut"];
        [userDefaults synchronize];
        [self performSegueWithIdentifier:@"home_segue" sender:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"密码或手机号码错误", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
    }];
}

@end
