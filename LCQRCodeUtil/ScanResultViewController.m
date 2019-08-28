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
//#define  HT "http://139.217.12.228:12002"
#define  HT "http://chenyongpeng.xyz"
#define  FACE "https://182.50.124.210:9121/api"
@interface ScanResultViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>
@property (strong, nonatomic) JSContext *context;
@property (nonatomic ,strong)WKUserContentController * userCC;
@property(strong,nonatomic) WKWebViewConfiguration *config;

@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.config = [[WKWebViewConfiguration alloc] init];
    
    self.config.userContentController = [[WKUserContentController alloc] init];
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:_config];
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    //_webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    
    
    
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"10" ofType:@"html" inDirectory:@"assets"];

    [self HttpUtil];
    
    NSString * urlString2 = [[NSString stringWithFormat:@"%@?id=%@",path,[self.stringValue valueForKey:@"id"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString2 relativeToURL:[NSURL fileURLWithPath:path]]]];
    NSLog(@"2:%@",urlString2);
    
    [self.view addSubview:_webView];
    self.userCC = _config.userContentController;
    
   [self.userCC addScriptMessageHandler:self name:@"goBack"];
}
-(void)HttpUtil{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *uid=[userDefaults valueForKey:@"id"];
    NSLog(@"uid:%@",uid);
    NSURLSession *session = [NSURLSession sharedSession];
    // 创建 URL
    
    NSString *Str=[NSString stringWithFormat:@"%s/user/scan",HT];
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
    
     FaceEndViewController *sr=[[FaceEndViewController alloc]init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:sr];
    [navi setNavigationBarHidden:YES animated:YES];

    [self presentViewController:navi animated:YES completion:nil];

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
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    decisionHandler(WKNavigationActionPolicyCancel);
}
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
