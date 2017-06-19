//
//  AppDelegate.m
//  BLETest
//
//  Created by Allan Liu on 16/9/23.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "AppDelegate.h"
#import "BLENavigationController.h"
#import "BLHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 配置
    NSDictionary *config = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_config"];
    if (!config) {
        NSDictionary *config = @{@"model":@"90060SL01",@"serial":@"DVA1A0001",@"mac":@"84:B1:53:7A:15:A1",@"firmware":@"V1.5.2",@"hardware":@"V1.5", @"manufacture":@"DGC Tech"};
        [[NSUserDefaults standardUserDefaults] setObject:config forKey:@"default_config"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BLHomeViewController *vc = [BLHomeViewController new];
    BLENavigationController *nav = [[BLENavigationController alloc] initWithRootViewController:vc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    
    //NSLog(@"%@", [self hexStringFromString:@"ATDIS0"]);
    //NSLog(@"%@", [self hexStringFromString:@"0x10"]);
    
//    NSString
//    *str = @"0x10";
    
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    
//    unsigned long red
//    = strtoul([str UTF8String],0,16);
//    
//    //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
//    NSLog(@"转换完的数字为：%lx",red);
    
//    unsigned long red1
//    = strtoul([@"0x10"UTF8String],0,0);
    
//    NSLog(@"转换完的数字为：%lx",red1);
//    NSLog(@"%@", [self convertHexStrToData:@"4A"]);
//    Byte b = 0x4A;
//    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
//    NSLog(@"%@", data);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
