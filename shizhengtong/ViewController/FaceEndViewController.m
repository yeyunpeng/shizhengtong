//
//  FaceEndViewController.m
//  FaceSDK-Collect-Basic-iOS
//
//  Created by mac on 2019/8/8.
//  Copyright © 2019 zhangxiaoqing. All rights reserved.
//

#import "FaceEndViewController.h"
#import <AVFoundation/AVFoundation.h>
#import<JavaScriptCore/JavaScriptCore.h>
#import "SaoMaViewController.h"
#import "ViewController.h"

#define  HT "http://chenyongpeng.xyz"
//#define  HT "http://1o669531n3.imwork.net:42997"
#define  FACE "https://182.50.124.210:9121/api"
@interface FaceEndViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>
@property (strong, nonatomic) JSContext *context;
@property (nonatomic ,strong)WKUserContentController * userCC;
@property(strong,nonatomic) WKWebViewConfiguration *config;
@end

@implementation FaceEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"aaaaaaaa");
    self.config = [[WKWebViewConfiguration alloc] init];
    
    self.config.userContentController = [[WKUserContentController alloc] init];
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:_config];
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"6" ofType:@"html" inDirectory:@"assets"];
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   
    
    NSString * urlString2 = [[NSString stringWithFormat:@"%@?name=%@&num=%@&id=%@",path,[userDefaults valueForKey:@"name"] ,[userDefaults valueForKey:@"num"],[userDefaults valueForKey:@"id"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@",urlString2);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString2 relativeToURL:[NSURL fileURLWithPath:path]]]];
    
    
    [self.view addSubview:_webView];
 
    self.userCC = _config.userContentController;
    
    [self.userCC addScriptMessageHandler:self name:@"Scan"];
    [self.userCC addScriptMessageHandler:self name:@"goLoginBack"];
    [self.userCC addScriptMessageHandler:self name:@"updatePhone"];
    
    
}

   
    




#pragma mark  WKScriptMessageHandler delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if([message.name isEqualToString:@"Scan"]){
    SaoMaViewController *s=[[SaoMaViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:s];
    navi.navigationBarHidden = true;
   

    [self presentViewController:navi animated:YES completion:nil];}
    if([message.name isEqualToString:@"updatePhone"]){
        NSObject *obj = (NSObject*)message.body;
        NSString *phone=[obj valueForKey:@"phone"];
        NSString *password=[obj valueForKey:@"password"];
        NSString *idstr=[obj valueForKey:@"id"];
        NSURLSession *session = [NSURLSession sharedSession];
        // 创建 URL
          NSLog(@"%@",message.body);
        NSLog(@"%@-%@-%@",phone,password,idstr);
        NSString *Str=[NSString stringWithFormat:@"%s/user/updatePhone?",HT];
        NSString *Str2=[NSString stringWithFormat:@"id=%@&password=%@&phone=%@",idstr,password,phone];
        NSLog(@"url****:%@",Str);
        
        NSURL *url = [NSURL URLWithString:Str];
        // 创建 request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        // 请求方法
        request.HTTPMethod = @"POST";
        //            // 请求体
        request.HTTPBody = [Str2 dataUsingEncoding:NSUTF8StringEncoding];
        
        // 创建任务 task
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *sign=[[NSString alloc]init];
            if(data!=NULL){
                int sign=0;
                NSString* strJson=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                
                if([[strJson valueForKey:@"code"]intValue]==401){
                    sign=-2;
                    
                }
                else if([[strJson valueForKey:@"code"]intValue]==200){
                    
                    sign=1;
                }
                else if([[strJson valueForKey:@"code"]intValue]==400){
                    sign=-1;
                }
                else if([[strJson valueForKey:@"code"]intValue]==404){
                    sign=-3;
                }
                else{sign=-100;
                    NSLog(@"aaaaaaaa4");
                }
               
                
            }
            
            NSString *js = [NSString stringWithFormat:@"updatePhoneCallBack('%@')",sign];
            // NSLog(@"%@", js);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                    // NSLog(@"==%@----%@",data, error);
                    // NSLog(@"js get version 2");
                }];
                
            });
        }];
        //启动任务
        [task resume];
    }
    if([message.name isEqualToString:@"goLoginBack"]){
          NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"id"];
        [userDefaults removeObjectForKey:@"num"];
        [userDefaults removeObjectForKey:@"name"];
        [userDefaults removeObjectForKey:@"photo"];
//        [userDefaults removeObjectForKey:@"phone"];
//        [userDefaults removeObjectForKey:@"password"];
        [userDefaults synchronize];
        ViewController* welc = [[ViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:welc];
        navi.navigationBarHidden = true;
        
        
        [self presentViewController:navi animated:YES completion:nil];
    }
    
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
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *js = [NSString stringWithFormat:@"aa('%@')",[userDefaults valueForKey:@"photo"]];
     //NSLog(@"%@", js);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            //NSLog(@"==%@----%@",data, error);
            // NSLog(@"js get version 2");
        }];
        
    });
   
   
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    //NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
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

@end
