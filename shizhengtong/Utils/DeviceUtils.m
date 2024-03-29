//
//  NSObject+DeviceUtils.m
//  FaceSDK-Collect-Basic-iOS
//
//  Created by mac on 2019/8/19.
//  Copyright © 2019 zhangxiaoqing. All rights reserved.
//

#import "DeviceUtils.h"
#import "sys/utsname.h"
@implementation DeviceUtils

/// 通用唯一识别码UUID

+ (NSString *)getUUID {
    
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
}
//取iPhone名称
+ (NSString *)getiPhoneName {
    
    return [UIDevice currentDevice].name;
    
}

//获取设备版本号
+(NSString *)getDeviceName
{
    struct utsname systemInfo;
    
uname(&systemInfo);
    
    NSString *deviceString=[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";
    
       if([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (GSM)";
    
    if([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (GSM+CDMA)";
    
    if([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (GSM)";
    
  if([deviceString isEqualToString:@"iPhone6,2"])return @"iPhone 5s (GSM+CDMA)";
    
    if([deviceString isEqualToString:@"iPhone7,1"])return @"iPhone 6 Plus";
    
    if([deviceString isEqualToString:@"iPhone7,2"])return @"iPhone 6";
    
    if([deviceString isEqualToString:@"iPhone8,1"])return @"iPhone 6s";
    
    if([deviceString isEqualToString:@"iPhone8,2"])return @"iPhone 6s Plus";
    
    if([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
  
    
    
    
    
    
    
    if([deviceString isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if([deviceString isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if([deviceString isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if([deviceString isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if([deviceString isEqualToString:@"iPod5,1"])return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"]) return @"iPad";
    
    if([deviceString isEqualToString:@"iPad1,2"]) return @"iPad 3G";
    
    if([deviceString isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    
    if([deviceString isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if([deviceString isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,6"]) return @"iPad Mini";
    
    if ([deviceString isEqualToString:@"iPad2,7"]) return @"iPad Mini (GSM+CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    
 if ([deviceString isEqualToString:@"iPad3,2"]) return @"iPad 3 (GSM+CDMA)";
    
 if ([deviceString isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
if ([deviceString isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    
 if ([deviceString isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
 if ([deviceString isEqualToString:@"iPad3,6"]) return @"iPad 4 (GSM+CDMA)";
    
 if ([deviceString isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
    
 if ([deviceString isEqualToString:@"iPad4,2"]) return @"iPad Air (Cellular)";
    
 if ([deviceString isEqualToString:@"iPad4,4"]) return @"iPad Mini 2 (WiFi)";
    
 if ([deviceString isEqualToString:@"iPad4,5"]) return @"iPad Mini 2 (Cellular)";
    
 if ([deviceString isEqualToString:@"iPad4,6"]) return @"iPad Mini 2";
    
 if ([deviceString isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    
if ([deviceString isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    
if ([deviceString isEqualToString:@"iPad4,9"])return @"iPad Mini 3";
    
if ([deviceString isEqualToString:@"iPad5,1"]) return @"iPad Mini 4 (WiFi)";
    
if ([deviceString isEqualToString:@"iPad5,2"]) return @"iPad Mini 4 (LTE)";
    
if ([deviceString isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    
if ([deviceString isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    
if ([deviceString isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    
if ([deviceString isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    
if ([deviceString isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    
if ([deviceString isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    
if ([deviceString isEqualToString:@"i386"])return @"Simulator";
    
if ([deviceString isEqualToString:@"x86_64"])return @"Simulator";
    
return deviceString;
    
}

@end
