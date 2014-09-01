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
@property (weak, nonatomic) IBOutlet UIView *keyboarbarView;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *canceButton;


@end

@implementation CheYouFaXianViewController

{
    UIView *accessoryView;
    UIButton *accphoto;
    UIButton *accsharp;
    UIButton *accwink;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    [self.sendButton setEnabled:YES];
    //键盘工具栏初始化
    self.keyboarbarView.frame = CGRectMake(0,  0, self.view.bounds.size.width, 46);
    //设置textview
    self.textView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 216 - 46);
    self.textView.font = [UIFont systemFontOfSize:16.f];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.textView.inputAccessoryView = self.keyboarbarView;
    self.textView.delegate = self;
    
    //监听键盘 设置输入框的高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidekeyboard:) name:UIKeyboardWillHideNotification object:nil];

    //另外设置一个工具栏
    accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,  self.view.bounds.size.height - 46, self.view.bounds.size.width, 46)];
    accessoryView.backgroundColor = [LuJieCommon UIColorFromRGB:0xE4E4E4];
    accessoryView.hidden = YES;
    [self.view addSubview:accessoryView];
    
    accphoto = [[UIButton alloc] initWithFrame:CGRectMake(21, 13, 20, 20)];
    [accphoto setBackgroundImage:[UIImage imageNamed:@"keyboard_image"] forState:UIControlStateNormal];
    [accphoto addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchDown];
    [accessoryView addSubview:accphoto];
    
    
    accwink = [[UIButton alloc] initWithFrame:CGRectMake(145, 13, 20, 20)];
    [accwink setBackgroundImage:[UIImage imageNamed:@"keyboard_sharp"] forState:UIControlStateNormal];
    [accwink addTarget:self action:@selector(winkAction:) forControlEvents:UIControlEventTouchDown];
    [accessoryView addSubview:accwink];
    
    accsharp = [[UIButton alloc] initWithFrame:CGRectMake(83, 13, 20, 20)];
    [accsharp setBackgroundImage:[UIImage imageNamed:@"keyboard_wink"] forState:UIControlStateNormal];
    [accsharp addTarget:self action:@selector(sharpAction:) forControlEvents:UIControlEventTouchDown];
    [accessoryView addSubview:accsharp];
    
    //图片模块
    UIImageView *userPhoto1 = [[UIImageView alloc] initWithFrame:CGRectMake(14, self.textView.bounds.size.height - 180 , 92, 92)];
    userPhoto1.image = [UIImage imageNamed:@"welcome"];
    [self.textView addSubview:userPhoto1];
    
    UIImageView *userPhoto2 = [[UIImageView alloc] initWithFrame:CGRectMake(14 + 92 + 6, self.textView.bounds.size.height - 180 , 92, 92)];
    userPhoto2.image = [UIImage imageNamed:@"welcome"];
    [self.textView addSubview:userPhoto2];
    
    UIImageView *userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(14 + 92 + 92 + 6 + 6, self.textView.bounds.size.height - 180 , 92, 92)];
    userPhoto.image = [UIImage imageNamed:@"user_photo"];
    [self.textView addSubview:userPhoto];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    //默认显示键盘
    [self.textView becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //释放之前注册的键盘监控事件
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma textview 委托

-(void)textViewDidChange:(UITextView *)textView
{
    self.promptLabel.hidden = YES;
//    NSString *textLength = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (textLength.length > 0) {
//        self.promptLabel.hidden = YES;
//        [self.sendButton setEnabled:YES];
//    }else
//    {
//        [self.sendButton setEnabled:NO];
//        self.promptLabel.hidden = NO;
//    }
}
    
#pragma 导航按钮事件

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
    
    accessoryView.hidden = NO;
//    self.textView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - 46);
//    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.textView.frame;
//    frame.size.height += keyboardRect.size.height - 46;
    frame.size.height = self.view.bounds.size.height - 46;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.textView.frame = frame;
    [UIView commitAnimations];
}

#pragma accessry 键盘工具栏按钮事件

- (IBAction)photoAction:(id)sender {
    
#if 1
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [LuJieCommon UIColorFromRGB:0x37D077];
    appearanceConfig.assetsGroupSelectedImageName = @"checker";
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
#endif
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionVideo = 0;
    picker.maximumNumberOfSelectionPhoto = 5;
    [self presentViewController:picker animated:YES completion:^{}];
}

- (IBAction)winkAction:(id)sender {
    
}

- (IBAction)sharpAction:(id)sender {
    
}

#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
        DLog(@"assets %@",assets);

}

- (void)UzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"目前只允许选择5张图片！"
                                                   delegate:nil
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:nil];
    [alert show];
}


@end
