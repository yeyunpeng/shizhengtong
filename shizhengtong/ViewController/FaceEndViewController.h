//
//  FaceEndViewController.h
//  FaceSDK-Collect-Basic-iOS
//
//  Created by mac on 2019/8/8.
//  Copyright © 2019 zhangxiaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
@import WebKit;
NS_ASSUME_NONNULL_BEGIN

@interface FaceEndViewController : UIViewController
@property (strong,nonatomic) WKWebView *webView;
@property NSData *peopleDic;
@property NSString *photo;

@end

NS_ASSUME_NONNULL_END
