//
//  ViewController.h
//  IDLFaceSDKDemoOC
//
//  Created by Tong,Shasha on 2017/5/15.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;
@interface ViewController : UIViewController
@property(nonatomic,strong) IBOutlet WKWebView *webView;
@property (strong,nonatomic) WKWebView *uiWebView;

@end

