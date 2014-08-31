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
#import <QuartzCore/QuartzCore.h>
#import "CAKeyframeAnimation+AHEasing.h"

@interface CheYouPublishViewController ()
@property (weak, nonatomic) IBOutlet UIButton *pb_faxian;
@property (weak, nonatomic) IBOutlet UIButton *pb_duche;
@property (weak, nonatomic) IBOutlet UIButton *pb_tietiao;
@property (weak, nonatomic) IBOutlet UIButton *pb_suixin;
@property (weak, nonatomic) IBOutlet UIButton *pb_close;
@property (weak, nonatomic) IBOutlet UILabel *footLabel;

@end

@implementation CheYouPublishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [LuJieCommon UIColorFromRGB:0xf2f2f2];
    self.pb_faxian.frame = CGRectMake(25, self.view.bounds.size.height, 70, 70);
    self.pb_duche.frame = CGRectMake(25 + 70 + 30, self.view.bounds.size.height, 70, 70);
    self.pb_tietiao.frame =  CGRectMake(25 + 70 + 30 + 70 + 30, self.view.bounds.size.height, 70, 70);
    self.pb_suixin.frame = CGRectMake(25, self.view.bounds.size.height, 70, 70);
    self.pb_close.frame =  CGRectMake(148, self.view.bounds.size.height - 34, 24, 24);
    self.footLabel.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
}

-(void)MakeAn
{
    [self buttonAnimation:self.pb_faxian over:CGPointMake(60, 201)];
    [self buttonAnimation:self.pb_duche over:CGPointMake(160, 201)];
    [self buttonAnimation:self.pb_tietiao over:CGPointMake(260, 201)];
    [self buttonAnimation:self.pb_suixin over:CGPointMake(60, 319)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self performSelector:@selector(MakeAn) withObject:nil afterDelay:0.2f];
}

-(void)viewWillDisappear:(BOOL)animated
{
    CGPoint toPoint = CGPointMake(60, 201);
    [self buttonAnimation:self.pb_faxian over:toPoint];
}

#pragma 绑定按钮事件

- (IBAction)pb_faxianAction:(id)sender {
    
    [self performSegueWithIdentifier:@"faxian_segue" sender:self];
}

- (IBAction)pb_closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)pb_ducheAction:(id)sender {
    
    [self performSegueWithIdentifier:@"duche_segue" sender:self];
}

- (IBAction)pb_tietiaoAction:(id)sender {
    
    [self performSegueWithIdentifier:@"tietiao_segue" sender:self];
}

- (IBAction)pb_suixinAction:(id)sender {
    
    [self performSegueWithIdentifier:@"faxian_segue" sender:self];
}


#pragma 按钮加载动画效果

-(void)buttonAnimation:(UIButton *)button over:(CGPoint)toPoint
{
 	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position" function:CircularEaseOut
                                                                     fromPoint: CGPointMake(button.center.x, button.center.y) toPoint:toPoint keyframeCount:90];
	animation.duration = 0.5;
	[button.layer addAnimation:animation forKey:@"easing"];
    [button setCenter:toPoint];
}

#pragma mark 处理segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"faxian_segue"]) {
        
    }
    
}


@end
