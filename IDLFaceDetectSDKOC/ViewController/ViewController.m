//
//  ViewController.m
//  IDLFaceSDKDemoOC
//
//  Created by Tong,Shasha on 2017/5/15.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "ViewController.h"
#import "DetectionViewController.h"
#import <IDLFaceSDK/IDLFaceSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


#pragma mark - Button Action

- (IBAction)DetectAction:(id)sender {
    
    DetectionViewController* dvc = [[DetectionViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:dvc];
    navi.navigationBarHidden = true;
    [self presentViewController:navi animated:YES completion:nil];
    
    
}


@end
