//
//  CheYouTabBarViewController.m
//  CheYou
//
//  Created by lujie on 14-8-29.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouTabBarViewController.h"
#import "CheYouPublishViewController.h"

@interface CheYouTabBarViewController ()
@property (nonatomic,strong) UIButton *pb_fabu;
@property (weak, nonatomic) IBOutlet UITabBar *hmtabBar;

@end

@implementation CheYouTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // require iOS 5+
    //设置home页三个功能按钮
    UINavigationController *hmNavController = self.viewControllers[0];
    UITabBarItem *hmitem = [[UITabBarItem alloc] initWithTitle:nil image:nil tag:0];
    [hmitem setFinishedSelectedImage:[UIImage imageNamed:@"tab_home_select"]
              withFinishedUnselectedImage:[UIImage imageNamed:@"tab_home_unselect"]];
    hmNavController.tabBarItem = hmitem;
    hmitem.imageInsets  = UIEdgeInsetsMake(6, -15, -6, 15);
    
    UINavigationController *myNavController = self.viewControllers[1];
    UITabBarItem *myitem = [[UITabBarItem alloc] initWithTitle:nil image:nil tag:1];
    [myitem setFinishedSelectedImage:[UIImage imageNamed:@"tab_my_select"]
           withFinishedUnselectedImage:[UIImage imageNamed:@"tab_my_unselect"]];
    myNavController.tabBarItem = myitem;
    myitem.imageInsets  = UIEdgeInsetsMake(6, 15, -6, -15);

    //添加发布按钮
    self.pb_fabu = [[UIButton alloc] initWithFrame:CGRectMake(self.hmtabBar.frame.size.width/2 - 34, 8, 60, 34)];
    [self.pb_fabu setBackgroundImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
    [self.pb_fabu addTarget:self action:@selector(pb_fabuAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.pb_fabu];
    [self.hmtabBar addSubview:self.pb_fabu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 0){
        
    }else if(item.tag == 1){

    }else {

    }
}

- (void)pb_fabuAction:(id)sender
{
    [self performSegueWithIdentifier:@"pb_segue" sender:self];
}

#pragma mark 处理segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"pb_segue"]) {
        // 设置返回按钮的文本
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"返回"
                                       style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
    }
    
}


@end
