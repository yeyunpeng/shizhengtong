//
//  AppDelegate.m
//  IDLFaceDetectSDKOC
//
//  Created by v_zhangxiaoqing01 on 2018/10/29.
//  Copyright © 2018年 zhangxiaoqing. All rights reserved.
//

#import "AppDelegate.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "FaceParameterConfig.h"
#import "FaceEndViewController.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
    NSLog(@"version = %@",[[FaceVerifier sharedInstance] getVersion]);
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"name"]) {
        FaceEndViewController *face=[[FaceEndViewController alloc]init];
//        UINavigationController *na=[[UINavigationController alloc]initWithRootViewController:face];
        self.window.rootViewController=face;
    }else{
         ViewController *vie=[[ViewController alloc]init];
         self.window.rootViewController=vie;
    }
//    FaceEndViewController *f=[[FaceEndViewController alloc]init];
//    UINavigationController *na=[[UINavigationController alloc]initWithRootViewController:f];
//    self.window.rootViewController=na;
   [self.window makeKeyWindow];
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
