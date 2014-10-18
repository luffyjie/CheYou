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
    UIImage *selectedImage = [UIImage imageNamed:@"tab_home"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *unselectedImage = [UIImage imageNamed:@"tab_home_un"];
    unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *hmitem = [[UITabBarItem alloc]initWithTitle:@""image:unselectedImage selectedImage:selectedImage];
    hmNavController.tabBarItem = hmitem;
    hmitem.imageInsets  = UIEdgeInsetsMake(6, -15, -6, 15);
    
    UINavigationController *myNavController = self.viewControllers[1];
    UIImage *tab_my_select = [UIImage imageNamed:@"tab_my"];
    tab_my_select = [tab_my_select imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *untab_my_select = [UIImage imageNamed:@"tab_my_un"];
    untab_my_select = [untab_my_select imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *myitem = [[UITabBarItem alloc]initWithTitle:@""image:untab_my_select selectedImage:tab_my_select];
    myNavController.tabBarItem = myitem;
    myitem.imageInsets  = UIEdgeInsetsMake(6, 15, -6, -15);

    //添加发布按钮
    self.pb_fabu = [[UIButton alloc] initWithFrame:CGRectMake(self.hmtabBar.frame.size.width/2 - 34, 8, 60, 34)];
//    [self.pb_fabu setBackgroundImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
    [self.pb_fabu addTarget:self action:@selector(pb_fabuAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.pb_fabu];
    [self.hmtabBar addSubview:self.pb_fabu];
    
    //实现tab透明
    UIImage *bgImg = [[UIImage alloc] init];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
    [self.tabBar setShadowImage:bgImg];
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] == NSOrderedAscending) {
        [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:127.0/255.0 green:186.0/255.0 blue:235.0/255.0 alpha:1.0]];
        [[UITabBar appearance] setSelectionIndicatorImage:bgImg];
        //上面两个是清除item的背景色跟选中背景色
    }
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
