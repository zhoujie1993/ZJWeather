//
//  AppDelegate.m
//  MojiWeather
//
//  Created by zhoujie on 15/9/15.
//  Copyright (c) 2015年 zhoujie. All rights reserved.
//

#import "AppDelegate.h"
#import "AVOSCloud.h"
#import "AVOSCloudSNS.h"
#import "Common.h"
#import "BaseNavController.h"

#import "ViewController.h"
#import "SceneryViewController.h"
#import "UserViewController.h"



@interface AppDelegate ()
{
    UITabBarController  *tabBar;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    
    //已包含 自动登入
    [AVOSCloud setApplicationId:AppID
                      clientKey:AppKey];
    
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    [AVGeoPoint geoPointForCurrentLocationInBackground:^(AVGeoPoint *geoPoint, NSError *error) {
        AVUser *user=[AVUser currentUser];
        if (user!=nil) {
            [user setObject:geoPoint forKey:@"location"];
            [user save];
        }
    }];
    
    
    
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    
    [self createTabBar];
    
    
    self.window.rootViewController=tabBar;
    
    
    return YES;
}


-(void)createTabBar
{
    
    
    
    ViewController *vc1=[[ViewController alloc]init];
    BaseNavController *nav1=[[BaseNavController alloc]initWithRootViewController:vc1];
    
    
    SceneryViewController *vc2=[[SceneryViewController alloc]init];
    BaseNavController *nav2=[[BaseNavController   alloc]initWithRootViewController:vc2];
    
    UserViewController *vc3=[[UserViewController alloc]init];
    BaseNavController *nav3=[[BaseNavController alloc]initWithRootViewController:vc3];
    
    
    
    UITabBarItem *item1=[[UITabBarItem alloc]initWithTitle:@"天气" image:[UIImage imageNamed:@"tabbar_weather_select.png"] tag:0];
    UITabBarItem *item2=[[UITabBarItem alloc]initWithTitle:@"实景" image:[UIImage imageNamed:@"tabbar_live_select.png"]tag:1];
    UITabBarItem *item3=[[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"tabbar_profile_select.png"] tag:2];
    
    vc1.tabBarItem=item1;
    vc2.tabBarItem=item2;
    vc3.tabBarItem=item3;
    
    
    tabBar=[[UITabBarController alloc]init];
    tabBar.viewControllers=@[nav1,nav2,nav3];
    
    
    
    //    [tabBar.tabBar setBackgroundImage:[UIImage imageNamed:@"mask_detailbar@2x"]];
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
