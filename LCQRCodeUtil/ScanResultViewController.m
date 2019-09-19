//
//  ScanResultViewController.m
//  FaceSDK-Collect-Basic-iOS
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 zhangxiaoqing. All rights reserved.
//

#import "ScanResultViewController.h"
#import <AVFoundation/AVFoundation.h>
#import<JavaScriptCore/JavaScriptCore.h>
#import "FaceEndViewController.h"
#import "FaceViewController.h"
#import "HttpUtils.h"
@interface ScanResultViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>
@property (strong, nonatomic) JSContext *context;
@property (nonatomic ,strong)WKUserContentController * userCC;
@property(strong,nonatomic) WKWebViewConfiguration *config;

@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 60, 60);
    
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.config = [[WKWebViewConfiguration alloc] init];
    
    self.config.userContentController = [[WKUserContentController alloc] init];
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:_config];
    // UI代理
    self.webView.UIDelegate = self;
    // 导航代理
    self.webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    
    
    
    
  
    
//     NSString *path = @"http://www.110passport.com/elecidenty_iospay/pay.html";
//     NSString * webUrl = [NSString stringWithFormat:@"%@?id=%@",path,[self.stringValue valueForKey:@"id"]];
//    NSURL *url = [NSURL URLWithString:webUrl];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
     NSString * path = [[NSBundle mainBundle] pathForResource:@"10_2" ofType:@"html" inDirectory:@"assets"];

   
        NSURL *url = [NSURL fileURLWithPath:path];
    
    
   

    NSString * urlString2 = [[NSString stringWithFormat:@"%@?id=%@",path,[self.stringValue valueForKey:@"id"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
   
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString2 relativeToURL:url]]];
   
    
    [self.view addSubview:_webView];
    
    self.userCC = _config.userContentController;
    
    [self.userCC addScriptMessageHandler:self name:@"goBackmian"];
    [self.userCC addScriptMessageHandler:self name:@"iOSPay"];
  
}
-(void)back{
    NSLog(@"qqq");
    
    FaceEndViewController *sr=[[FaceEndViewController alloc]init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:sr];
    [navi setNavigationBarHidden:YES animated:YES];
    
    [self presentViewController:navi animated:YES completion:nil];
    
}
-(void)HttpUtil{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *uid=[userDefaults valueForKey:@"id"];
    NSLog(@"uid:%@",uid);
    NSURLSession *session = [NSURLSession sharedSession];
    // 创建 URL
    
    NSString *Str=[NSString stringWithFormat:@"%@/user/scan",HttpUtils.getHttpMsg];
    NSLog(@"url****:%@",Str);
    
    NSURL *url = [NSURL URLWithString:Str];
    // 创建 request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    // 请求方法
    request.HTTPMethod = @"POST";
//      NSString *Str2=[NSString stringWithFormat:@"uid=%@&hId=%@&htype=%@&status=%d&macid=%@&phoneX=%@",uid,[self.stringValue valueForKey:@"id"],@"application/json",1,NULL,NULL];
    //            // 请求体
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setValue:uid forKey:@"uid"];
    [dict setValue:[self.stringValue valueForKey:@"id"] forKey:@"hid"];
    [dict setValue:[self.stringValue valueForKey:@"type"] forKey:@"htype"];
    [dict setValue:@1 forKey:@"status"];
    [dict setValue:@"" forKey:@"macid"];
    [dict setValue:@""forKey:@"phoneX"];
    BOOL isYes = [NSJSONSerialization isValidJSONObject:dict];
    
    if (isYes) {
        NSLog(@"可以转换");
        
        /* JSON data for obj, or nil if an internal error occurs. The resulting data is a encoded in UTF-8.
         */
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
        NSString   *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
    request.HTTPBody = jsonData;
       }
    // 创建任务 task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
//        NSString *js = [NSString stringWithFormat:@"setPwdCallBack('%@')",sign];
//        // NSLog(@"%@", js);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
//
//            }];
//
//        });
    }];
    //启动任务
    [task resume];
}
//当JS发出callFunction这个方法指令的时候， WKScriptMessageHandler的协议方法中我们就会收到这个消息
#pragma mark  WKScriptMessageHandler delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
  
    if([message.name isEqualToString:@"goBackmian"]){
        NSLog(@"qqq");
        
        [self HttpUtil];
        FaceEndViewController *sr=[[FaceEndViewController alloc]init];
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:sr];
        [navi setNavigationBarHidden:YES animated:YES];
        
        [self presentViewController:navi animated:YES completion:nil];
    }
    if([message.name isEqualToString:@"iOSPay"]){
        NSLog(@"qqq2");
    
        NSObject *obj = (NSObject*)message.body;
        NSLog(@"3:%@",obj);
                NSURLSession *session = [NSURLSession sharedSession];
                // 创建 URL
        
                NSString *Str=[NSString stringWithFormat:@"http://eiapp.110passport.com/weixin/ios-order"];
        NSString *attach=[NSString stringWithFormat:@"a,%@,%@,%@",[obj valueForKey:@"uid"],[obj valueForKey:@"hid"],[obj valueForKey:@"totalFee"]];
                NSString *Str2=[NSString stringWithFormat:@"uid=%@&hid=%@&totalFee=%@&attach=%@",[obj valueForKey:@"uid"],[obj valueForKey:@"hid"],[obj valueForKey:@"totalFee"],attach];
                NSLog(@"url222****:%@",Str);
        
                NSURL *url = [NSURL URLWithString:Str];
                // 创建 request
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                // 请求方法
                request.HTTPMethod = @"POST";
                //            // 请求体
                request.HTTPBody = [Str2 dataUsingEncoding:NSUTF8StringEncoding];
        
                // 创建任务 task
                NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
                        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                     id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                    NSString *payUrl=[obj valueForKey:@"mweb_url"];
                      NSString *payUrlResult=[NSString stringWithFormat:@"%@&Referer=%@",payUrl,@"http://eiapp.110passport.com"];
                    [self WeiXinPay:payUrl];
                }];
                //启动任务
                [task resume];
    }
//

//    }
//    FaceEndViewController *sr=[[FaceEndViewController alloc]init];
//
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:sr];
//    [navi setNavigationBarHidden:YES animated:YES];
//
//    [self presentViewController:navi animated:YES completion:nil];

}
-(void)WeiXinPay:(NSString*)payUrlResult
{
    NSLog(@"%@",payUrlResult);
    NSString *newStr2 = payUrlResult.stringByRemovingPercentEncoding;
    
       NSURL *newUrl = [NSURL URLWithString:payUrlResult];
//   
//    
//
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:newUrl];

//    
   [request addValue:@"www.110passport.com" forHTTPHeaderField:@"Referer"];
//    
//    NSLog(@"5:%@",request.allHTTPHeaderFields);
    dispatch_async(dispatch_get_main_queue(), ^{
    //[[UIApplication sharedApplication] openURL:request.URL];
      [self.webView loadRequest:request];
//
//
//        [self.view addSubview:self.webView];
//        FaceViewController *sr=[[FaceViewController alloc]init];
//
//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:sr];
//
//        sr.referer=payUrlResult;
//            [self presentViewController:navi animated:YES completion:nil];
    });
   
    
}
//最后， VC销毁的时候一定要把handler移除
-(void)dealloc
{
    
}
+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
- (void)webViewDidFinishLoad:(WKWebView *)webView {
    
}




#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
   // NSURLRequest *request = navigationAction.request;
    NSString *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    // 拦截WKWebView加载的微信支付统一下单链接, 将redirect_url参数修改为唤起自己App的URLScheme
//    if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] && ![absoluteString hasSuffix:[NSString stringWithFormat:@"redirect_url=a1.company.com://wxpaycallback/"]]) {
//        decisionHandler(WKNavigationActionPolicyCancel);
//        NSString *redirectUrl = nil;
//        if ([absoluteString containsString:@"redirect_url="]) {
//            NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url"];
//            redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=a1.company.com://wxpaycallback/"]];
//        } else {
//            redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"redirect_url=a1.company.com://wxpaycallback/"]];
//        }
//        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
//        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
//        newRequest.URL = [NSURL URLWithString:redirectUrl];
//        [webView loadRequest:newRequest];
//        return;
//    }
    
    //拦截重定向的跳转微信的 URL Scheme, 打开微信
    if ([absoluteString hasPrefix:@"weixin://"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
                [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            } else {
                //未安装微信, 自行处理
            }
        });
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    return;
}
- (void)webView:(WKWebView *)webView
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition
                            disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
    }
    
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
//    NSLog(@"%@",navigationAction.request.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationActionPolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationActionPolicyCancel);
//}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
#pragma mark -  Alert弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -  Confirm弹框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -  TextInput弹框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text ? : @"");
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
////获取手机唯一标示
//-(NSString*)getClientID{
//    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"deviceIdentifier" accessGroup:nil];
//    NSString *uuidString = [wrapper objectForKey:(id)kSecAttrAccount];
//    if (uuidString.length > 0) {
//        return uuidString;
//    }else{
//        NSString *newUUID = [[NSUserDefaults standardUserDefaults] stringForKey:@"uuidString"];
//        [wrapper setObject:newUUID forKey:(id)kSecAttrAccount];
//        return newUUID;
//    }
//}



@end
