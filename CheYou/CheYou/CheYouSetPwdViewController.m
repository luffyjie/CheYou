//
//  CheYouSetPwdViewController.m
//  CheYou
//
//  Created by lujie on 14-9-20.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouSetPwdViewController.h"
#import "CCPRestSDK.h"

@interface CheYouSetPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextField *yzmText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CheYouSetPwdViewController
{
    NSString *userYzm;
}
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
    //发送验证码按钮
//    self.sendButton.enabled = NO;
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

- (void)timeShow
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.timeLabel.text= @"";
                self.sendButton.enabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重发验证码", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.timeLabel.text= strTime;
            });
            timeout--;
        }  
    });  
    dispatch_resume(_timer);

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


#pragma  发验证码按钮

- (IBAction)sendAction:(id)sender {
    //ip格式如下，不需要带https://
    userYzm = [NSString stringWithFormat:@"%u%u%u%u",arc4random_uniform(9 + 1),
                     arc4random_uniform(9 + 1),arc4random_uniform(9 + 1),arc4random_uniform(9 + 1)];
    NSLog(@"YZM--- %@",userYzm);
    CCPRestSDK* ccpRestSdk = [[CCPRestSDK alloc] initWithServerIP:@"sandboxapp.cloopen.com" andserverPort:8883];
    [ccpRestSdk setApp_ID:@"8a48b551488d07a80148a8096bd70bcc"];
    [ccpRestSdk enableLog:YES];
    [ccpRestSdk setAccountWithAccountSid: @"8a48b551488d07a80148a807b2dd0bca" andAccountToken:@"95d9d8e056854594a6fea59996ae01ca"];
    NSArray*  arr = [NSArray arrayWithObjects:userYzm, @"30", nil];
    NSMutableDictionary *dict = [ccpRestSdk sendTemplateSMSWithTo:self.phoneNum andTemplateId:@"1" andDatas:arr];
    NSLog(@"dict----%@",[dict description]);
    self.sendButton.enabled = NO;
    [self timeShow];
}

#pragma 导航按钮

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextAction:(id)sender {
    
    if (self.pwdText.text.length <1 || self.yzmText.text.length <1) {
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"密码为空或验证码为空！", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![userYzm isEqualToString:self.yzmText.text]) {
        NSString *title = NSLocalizedString(@"提示", nil);
        NSString *message = NSLocalizedString(@"验证码错误！", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self performSegueWithIdentifier:@"reginfo_segue" sender:self];
}

-(int)getRandomNumber:(int)from to:(int)to
{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}

@end
