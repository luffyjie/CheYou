//
//  CheYouPublishViewController.m
//  CheYou
//
//  Created by lujie on 14-8-29.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouPublishViewController.h"
#import "LuJieCommon.h"
#include "CheYouFaXianViewController.h"

@implementation CheYouPublishViewController
{
    UIButton *pb_faxian;
    UIButton *pb_duche;
    UIButton *pb_tietiao;
    UIButton *pb_suixin;
    UIButton *pb_close;
    UILabel *footLable;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [LuJieCommon UIColorFromRGB:0xf2f2f2];
    
    pb_faxian = [[UIButton alloc] initWithFrame:CGRectMake(25, 166, 70, 70)];
    [pb_faxian setBackgroundImage:[UIImage imageNamed:@"pb_faxian"] forState:UIControlStateNormal];
    [pb_faxian addTarget:self action:@selector(pb_faxianAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:pb_faxian];
    
    pb_duche = [[UIButton alloc] initWithFrame:CGRectMake(25 + 70 + 30, 166, 70, 70)];
    [pb_duche setBackgroundImage:[UIImage imageNamed:@"pb_duche"] forState:UIControlStateNormal];
    [pb_duche addTarget:self action:@selector(pb_ducheAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:pb_duche];
    
    pb_tietiao = [[UIButton alloc] initWithFrame:CGRectMake(25 + 70 + 30 + 70 + 30, 166, 70, 70)];
    [pb_tietiao setBackgroundImage:[UIImage imageNamed:@"pb_tietiao"] forState:UIControlStateNormal];
    [pb_tietiao addTarget:self action:@selector(pb_tietiaoAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:pb_tietiao];
    
    pb_suixin = [[UIButton alloc] initWithFrame:CGRectMake(25, 166 + 70 + 48, 70, 70)];
    [pb_suixin setBackgroundImage:[UIImage imageNamed:@"pb_suixin"] forState:UIControlStateNormal];
    [pb_suixin addTarget:self action:@selector(pb_suixinAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:pb_suixin];
    
    footLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    footLable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footLable];
    
    pb_close = [[UIButton alloc] initWithFrame:CGRectMake(148, self.view.bounds.size.height - 34, 24, 24)];
    [pb_close setBackgroundImage:[UIImage imageNamed:@"pb_close"] forState:UIControlStateNormal];
    [pb_close addTarget:self action:@selector(pb_closeAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:pb_close];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pb_closeAction:(id)sender
{
 
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)pb_faxianAction:(id)sender
{
    CheYouFaXianViewController *faxianView = [[CheYouFaXianViewController alloc] init];
    faxianView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:faxianView animated:YES completion: nil];
}

- (void)pb_ducheAction:(id)sender
{
    

}

- (void)pb_tietiaoAction:(id)sender
{
    

}

- (void)pb_suixinAction:(id)sender
{
    

}




@end
