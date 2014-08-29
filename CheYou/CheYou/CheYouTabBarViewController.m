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

@end

@implementation CheYouTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // require iOS 5+
    //设置home页三个功能按钮
    UINavigationController *publishNavController = self.viewControllers[0];
    
    UITabBarItem *publishitem = [[UITabBarItem alloc] initWithTitle:nil image:nil tag:0];
    [publishitem setFinishedSelectedImage:[UIImage imageNamed:@"tab_home_select"]
              withFinishedUnselectedImage:[UIImage imageNamed:@"tab_home_unselect"]];
    publishNavController.tabBarItem = publishitem;
    publishitem.imageInsets  = UIEdgeInsetsMake(6, -15, -6, 15);
    
    UINavigationController *mineNavController = self.viewControllers[1];
    UITabBarItem *mineitem = [[UITabBarItem alloc] initWithTitle:nil image:nil tag:2];
    [mineitem setFinishedSelectedImage:[UIImage imageNamed:@"tab_my_select"]
           withFinishedUnselectedImage:[UIImage imageNamed:@"tab_my_unselect"]];
    mineNavController.tabBarItem = mineitem;
    mineitem.imageInsets  = UIEdgeInsetsMake(6, 15, -6, -15);
    
    self.pb_fabu = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 30, self.view.bounds.size.height-40, 60, 34)];
    [self.pb_fabu setBackgroundImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
    [self.pb_fabu addTarget:self action:@selector(pb_fabuAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.pb_fabu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 1){
        
    }else if(item.tag == 2){

    }else {

    }
}

- (void)pb_fabuAction:(id)sender
{
//    CheYouPublishViewController *pb = [[CheYouPublishViewController alloc] init];
//    pb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self presentViewController:pb animated:YES completion: nil];
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
