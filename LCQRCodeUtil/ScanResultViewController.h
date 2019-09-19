//
//  ScanResultViewController.h
//  FaceSDK-Collect-Basic-iOS
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 zhangxiaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;
NS_ASSUME_NONNULL_BEGIN

@interface ScanResultViewController : UIViewController
@property (retain,nonatomic) WKWebView *webView;
@property NSDictionary *stringValue;
@end

NS_ASSUME_NONNULL_END
