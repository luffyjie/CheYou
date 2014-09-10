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
@property (strong, nonatomic) IBOutlet UILabel *greenLabel;

@end

@implementation CheYouUserViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //设置按钮选择状态
    [self.oilButton  setImage:[UIImage imageNamed:@"my_talk_select"] forState:UIControlStateHighlighted];
    [self.oilButton  addTarget:self action:@selector(oilButtonAction:)forControlEvents:UIControlEventTouchDown];
    
    [self.labaButton  setImage:[UIImage imageNamed:@"my_talk_select"] forState:UIControlStateHighlighted];
    [self.labaButton  addTarget:self action:@selector(labaButtonAction:)forControlEvents:UIControlEventTouchDown];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 按钮事件
- (void)oilButtonAction:(id)sender
{
    self.greenLabel.frame = CGRectMake(108, 198, 104, 2);
}

- (void)labaButtonAction:(id)sender
{
    
    self.greenLabel.frame = CGRectMake(1, 198, 104, 2);
}


@end
