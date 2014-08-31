//
//  CheYouFaXianViewController.m
//  CheYou
//
//  Created by lujie on 14-8-30.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouFaXianViewController.h"
#import "LuJieCommon.h"

@interface CheYouFaXianViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, strong) UIButton *accphoto;
@property (nonatomic, strong) UIButton *accsharp;
@property (nonatomic, strong) UIButton *accwink;

@end

@implementation CheYouFaXianViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //键盘工具栏初始化
    self.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,  self.view.bounds.size.height - 46, self.view.bounds.size.width, 46)];
    self.accessoryView.backgroundColor = [LuJieCommon UIColorFromRGB:0xE4E4E4];
    
    self.accphoto = [[UIButton alloc] initWithFrame:CGRectMake(21, 13, 20, 20)];
    [self.accphoto setBackgroundImage:[UIImage imageNamed:@"keyboard_image"] forState:UIControlStateNormal];
    [self.accphoto addTarget:self action:@selector(accphotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.accessoryView addSubview:self.accphoto];
    
    self.accsharp = [[UIButton alloc] initWithFrame:CGRectMake(83, 13, 20, 20)];
    [self.accsharp setBackgroundImage:[UIImage imageNamed:@"keyboard_wink"] forState:UIControlStateNormal];
    [self.accsharp addTarget:self action:@selector(accsharpAction:) forControlEvents:UIControlEventTouchDown];
    [self.accessoryView addSubview:self.accsharp];
    
    self.accwink = [[UIButton alloc] initWithFrame:CGRectMake(145, 13, 20, 20)];
    [self.accwink setBackgroundImage:[UIImage imageNamed:@"keyboard_sharp"] forState:UIControlStateNormal];
    [self.accwink addTarget:self action:@selector(accwinkAction:) forControlEvents:UIControlEventTouchDown];
    [self.accessoryView addSubview:self.accwink];
    
    //默认显示键盘
    [self.textView becomeFirstResponder];
    self.textView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 216 - 46);
    self.textView.inputAccessoryView = self.accessoryView;
    
    //监听键盘 设置输入框的高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidekeyboard:) name:UIKeyboardDidHideNotification object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)sendAction:(id)sender {

    [self.textView resignFirstResponder];
}

#pragma 动态设置输入框的高度

- (void)keyboardWasChange:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (kbSize.height == 262) {
        self.textView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - 262);
    
    }else if(kbSize.height == 298){
        self.textView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - 298);
    }
}

-(void)hidekeyboard:(NSNotification *)aNotification {
    
}

#pragma accessry 键盘附加栏按钮事件

- (void)accphotoAction:(id)sender
{

    NSLog(@"111");
}

- (void)accsharpAction:(id)sender
{
    
    NSLog(@"2221222");
}

- (void)accwinkAction:(id)sender
{
    
    NSLog(@"33333");
}



@end
