//
//  CheYouAppDelegate.m
//  CheYou
//
//  Created by lujie on 14-8-26.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouAppDelegate.h"
#import "LuJieCommon.h"
#import "MobClick.h"

@implementation CheYouAppDelegate

{
    UIImageView *welcomeImage;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //显示window 为了显示程序欢迎界面
    [self.window makeKeyAndVisible];
    
    //程序欢迎图片
    welcomeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome"]];
    welcomeImage.frame = CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height);
    //very good 用于屏蔽当前自己的点击事件,防止下层视图会响屏幕的点击
    welcomeImage.userInteractionEnabled = YES;
    [self.window  addSubview:welcomeImage];
    
    //设置全局导航栏的背景颜色
    [[UINavigationBar appearance] setBarTintColor: [LuJieCommon UIColorFromRGB:0x354b60]];
   //设置导航栏自定义的按钮的颜色
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    NSDictionary *buttonItemAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                     NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *buttonItemDisabledAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                            NSForegroundColorAttributeName:[LuJieCommon UIColorFromRGB:0x000000 over:0.2]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:buttonItemAttributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:buttonItemDisabledAttributes forState:UIControlStateDisabled];
    // 设置文本的属性
    NSDictionary *barAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                     NSForegroundColorAttributeName:[UIColor blackColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:barAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    //设置全局底部导航栏的背景颜色
    [[UITabBar appearance] setBarTintColor:[LuJieCommon UIColorFromRGB:0xe4e4e4]];

    
    UIImageView *scroll = [[UIImageView alloc] init];
    scroll.frame = CGRectMake(self.window.bounds.size.width - 5.f, self.window.bounds.size.height/2,5, 44);
    scroll.image = [UIImage imageNamed:@"scroll"];
//    
//    [self.window addSubview:scroll];
//    [self.window makeKeyAndVisible];
//    [self.window bringSubviewToFront:scroll];

    welcomeImage.alpha = 8.0f;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration: 2.0f];
    welcomeImage.alpha = 0.0f;
    [UIView commitAnimations];
    
    //友盟统计SDK
    [MobClick startWithAppkey:@"544079c9fd98c585d6010657" reportPolicy:BATCH channelId:@"appStore"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
