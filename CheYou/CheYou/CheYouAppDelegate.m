//
//  CheYouAppDelegate.m
//  CheYou
//
//  Created by lujie on 14-8-26.
//  Copyright (c) 2014年 CheYou. All rights reserved.
//

#import "CheYouAppDelegate.h"
#import "LuJieCommon.h"
#import "CheYouViewController.h"
#import "CheYouPublishViewController.h"

@implementation CheYouAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //设置全局导航栏的背景颜色
    [[UINavigationBar appearance] setBarTintColor: [LuJieCommon UIColorFromRGB:0x37D077]];
   //设置导航栏自定义的按钮的颜色
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    NSDictionary *barItemAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                     NSForegroundColorAttributeName:[UIColor blackColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barItemAttributes forState:UIControlStateNormal];
    // 设置文本的属性
    NSDictionary *barAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                     NSForegroundColorAttributeName:[UIColor blackColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:barAttributes];

    //设置全局底部导航栏的背景颜色
    [[UITabBar appearance] setBarTintColor:[LuJieCommon UIColorFromRGB:0xe4e4e4]];

    
    UIImageView *scroll = [[UIImageView alloc] init];
    scroll.frame = CGRectMake(self.window.bounds.size.width - 5.f, self.window.bounds.size.height/2,5, 44);
    scroll.image = [UIImage imageNamed:@"scroll"];
//    
//    [self.window addSubview:scroll];
//    [self.window makeKeyAndVisible];
//    [self.window bringSubviewToFront:scroll];

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

@end
