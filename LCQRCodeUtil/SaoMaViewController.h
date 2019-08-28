//
//  SaoMaViewController.h
//  EBOT
//
//  Created by yeyunpeng on 2018/3/14.
//  Copyright © 2018年 yien. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol passValue <NSObject>
-(void)passedValue:(NSString *)inputValue;
@end
@interface SaoMaViewController : UIViewController
@property(nonatomic, weak) id<passValue> delegate;
@end
