//
//  CheYouPbCommentViewController.m
//  CheYou
//
//  Created by lujie on 14-9-15.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouPbCommentViewController.h"
#import "LuJieCommon.h"

@interface CheYouPbCommentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;

@end

@implementation CheYouPbCommentViewController

{
    UILabel *promptLabel;
}

- (void)viewDidLoad
{
    self.sendButton.enabled = NO;
    [super viewDidLoad];
    self.textView.text = @"";
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.selectedRange = NSMakeRange(0,0);
    self.textView.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview: self.textView];
    self.textView.delegate = self;
    
    //提示内容
    promptLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 8, 100, 19)];
    promptLabel.text = @"最新发现...";
    promptLabel.font = [UIFont systemFontOfSize:16.f];
    promptLabel.textColor = [LuJieCommon UIColorFromRGB:0x999999];
    [self.textView addSubview:promptLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma textview delegete

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        promptLabel.text = @"我们是首堵...";
        self.sendButton.enabled = NO;
    }else{
        promptLabel.text = @"";
        self.sendButton.enabled = YES;
    }
}

#pragma 导航按钮

-(void)viewDidAppear:(BOOL)animated
{
    [self.textView becomeFirstResponder];
}

- (IBAction)canceButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)sendButton:(id)sender {
    
    
}




@end
