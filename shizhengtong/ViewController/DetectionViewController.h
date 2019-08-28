//
//  DetectionViewController.h
//  IDLFaceSDKDemoOC
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "FaceBaseViewController.h"
#import <UIKit/UIKit.h>
@import WebKit;
@interface DetectionViewController : FaceBaseViewController
@property (retain,nonatomic) WKWebView *animaView;
@property NSData *dic;
@end
