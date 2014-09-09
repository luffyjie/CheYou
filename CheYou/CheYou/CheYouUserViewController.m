//
//  CheYouUserViewController.m
//  CheYou
//
//  Created by lujie on 14-9-9.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouUserViewController.h"

@interface CheYouUserViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *oilButton;
@property (weak, nonatomic) IBOutlet UILabel *oil_num;
@property (weak, nonatomic) IBOutlet UIButton *labaButton;
@property (weak, nonatomic) IBOutlet UILabel *laba_num;

@end

@implementation CheYouUserViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //设置按钮选择状态
    [self.oilButton setBackgroundImage:[UIImage imageNamed:@"my_talk_select"] forState:UIControlStateHighlighted];
    [self.labaButton setBackgroundImage:[UIImage imageNamed:@"my_talk_select"] forState:UIControlStateHighlighted];
}

@end
