//
//  NSObject+DeviceUtils.h
//  FaceSDK-Collect-Basic-iOS
//
//  Created by mac on 2019/8/19.
//  Copyright © 2019 zhangxiaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DeviceUtils :NSObject
//取iPhone名称
+(NSString *)getiPhoneName;
//获取设备版本号
+(NSString *)getDeviceName;
//// 获取当前设备IP
//+(NSString *)getDeviceIPAdress;
// 通用唯一识别码UUID
+(NSString *)getUUID;
@end


