//
//  ViewController.m
//  IDLFaceSDKDemoOC
//
//  Created by Tong,Shasha on 2017/5/15.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "ViewController.h"
#import "DetectionViewController.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import<JavaScriptCore/JavaScriptCore.h>
#import "FaceEndViewController.h"
#import "DeviceUtils.h"
#import "HttpUtils.H"
//#define  HT "http://1o669531n3.imwork.net:42997"
//#define  HT "http://chenyongpeng.xyz"
//#define  FACE "https://182.50.124.210:9121/api"

@interface ViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>
@property (strong, nonatomic) JSContext *context;
@property (nonatomic ,strong)WKUserContentController * userCC;
@property(strong,nonatomic) WKWebViewConfiguration *config;
@property NSData *data2;
@property NSData *dataStr;
@end

@implementation ViewController

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

    NSLog(@"222222222222222");
        NSString * pathString = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"html" inDirectory:@"assets"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pathString]]];
    
    [self.view addSubview:self.webView];
    
    
    
    self.userCC = _config.userContentController;
    
    [self.userCC addScriptMessageHandler:self name:@"isLogin"];
    [self.userCC addScriptMessageHandler:self name:@"Camera"];
    [self.userCC addScriptMessageHandler:self name:@"Reg"];
    [self.userCC addScriptMessageHandler:self name:@"setPwd"];
    [self.userCC addScriptMessageHandler:self name:@"goto6"];
    [self.userCC addScriptMessageHandler:self name:@"goLoginBack"];
    [self.userCC addScriptMessageHandler:self name:@"updatePhone"];
    [self.userCC addScriptMessageHandler:self name:@"goFkBack"];
    //此处相当于监听了JS中callFunction这个方法
    
   // [self.userCC addScriptMessageHandler:self name:@"callFunction"];
    
    
}

//当JS发出callFunction这个方法指令的时候， WKScriptMessageHandler的协议方法中我们就会收到这个消息
#pragma mark  WKScriptMessageHandler delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
   
    
 
 
//
    //这个回调里面， message.name代表方法名（‘本例为 callFunction’）， message.body代表JS给我们传过来的参数

        //NSObject *obj = (NSObject*)message.body;
    if([message.name isEqualToString:@"goFkBack"]){
        
        [self.webView goBack];
        
    }
        if([message.name isEqualToString:@"isLogin"])
        {
            
             NSObject *obj = (NSObject*)message.body;
            NSString *uasername=[obj valueForKey:@"uasername"];
              NSString *password=[obj valueForKey:@"password"];
            NSURLSession *session = [NSURLSession sharedSession];
            // 创建 URL
            
            NSString *Str=[NSString stringWithFormat:@"%@/user/login",HttpUtils.getHttpMsg];
            NSString *Str2=[NSString stringWithFormat:@"password=%@&phone=%@&",password,uasername];
            
            NSLog(@"url****:%@",Str);
          
            NSURL *url = [NSURL URLWithString:Str];
            // 创建 request
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            // 请求方法
            request.HTTPMethod = @"POST";
//            // 请求体
           request.HTTPBody =[Str2 dataUsingEncoding:NSUTF8StringEncoding];
            
            // 创建任务 task
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSString *sign=[[NSString alloc]init];
                NSString* strJson=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"wwww%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                if(strJson!=NULL){
                    self.dataStr=data;
                    NSString* strJsonData=[strJson valueForKey:@"data"];
                     NSString* strJsonDataId=[strJsonData valueForKey:@"id"];
                    NSString* strJsonDataname=[strJsonData valueForKey:@"name"];
                    NSString* strJsonDatanum=[strJsonData valueForKey:@"idNumber"];
                    NSLog(@"%@-%@-%@",strJsonDataId,strJsonDataname,strJsonDatanum);
                    if([[strJson valueForKey:@"msg"]isEqualToString:@"ok"]){
                        if([strJson valueForKey:@"data"]==NULL){
                            sign=[sign stringByAppendingFormat:@"ok-no-%@",strJsonDataId];
                            NSLog(@"ceshi:::::::%@",sign);
                        }else{
                            if([[strJsonData valueForKey:@"status"]integerValue]==0){
                                sign=[sign stringByAppendingFormat:@"ok-no-%@",strJsonDataId];
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                [userDefaults setObject: [strJsonData valueForKey:@"phone"] forKey:@"phone"];
                                [userDefaults setObject: [strJsonData valueForKey:@"password"] forKey:@"password"];
                                 [userDefaults synchronize];
                            }else{
                            sign=[sign stringByAppendingFormat:@"ok-yes-%@-%@-%@",strJsonDataname,strJsonDatanum,strJsonDataId];
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                [userDefaults setObject: strJsonDataname forKey:@"name"];
                                [userDefaults setObject: strJsonDatanum forKey:@"num"];
                                [userDefaults setObject: strJsonDataId forKey:@"id"];
                                [userDefaults setObject: [strJsonData valueForKey:@"photo"] forKey:@"photo"];
                                [userDefaults synchronize];
                                NSLog(@"ceshi2:::::::%@",sign);}
                        }
                    }else {
                        // 登录失败
                        sign=@"no-no";
                    }
                }else{
                    sign=@"x-x";
                 
                }
               
                NSString *js = [NSString stringWithFormat:@"isLoginCallBack('%@')",sign];
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
    //注册用户
    if([message.name isEqualToString:@"Reg"]){
         NSObject *obj = (NSObject*)message.body;
        NSString *uasername=[obj valueForKey:@"uasername"];
        NSString *password=[obj valueForKey:@"password"];
//        NSString *macid=[obj valueForKey:@"macid"];
//        NSString *imei1=[obj valueForKey:@"imei1"];
//        NSString *imei2=[obj valueForKey:@"imei2"];
//        NSString *imsi1=[obj valueForKey:@"imsi1"];
//         NSString *imsi2=[obj valueForKey:@"imsi2"];
//         NSString *deviceinfo=[obj valueForKey:@"deviceinfo"];
        NSURLSession *session = [NSURLSession sharedSession];
        // 创建 URL
       
        NSString *Str=[NSString stringWithFormat:@"%@/user/reg",HttpUtils.getHttpMsg];
        NSString *Str2=[NSString stringWithFormat:@"password=%@&phone=%@&macid=%@&imei1=%@&imei2=%@&imsi1=%@&imsi2=%@&androidid=%@&deviceinfo=%@",password,uasername,NULL,NULL,NULL,NULL,NULL, DeviceUtils.getUUID,DeviceUtils.getDeviceName];
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
           int sign=0;
            NSString* strJson=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
            if(strJson!=NULL){
                
                if([[strJson valueForKey:@"code"]intValue]==401){
                    sign=401;
                    
                }
                    else if([[strJson valueForKey:@"code"]intValue]==200){
                        NSLog(@"aaaaaaaaa");
                        sign=200;
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        NSLog(@"1111%@",strJson);
                        [userDefaults setObject: [strJson valueForKey:@"phone"] forKey:@"phone"];
                        [userDefaults setObject:  [strJson valueForKey:@"password"]  forKey:@"password"];
                  
                        [userDefaults synchronize];
                    }
                    else if([[strJson valueForKey:@"code"]intValue]==400){
                        sign=400;
                    }
                else{sign=400;
                     NSLog(@"aaaaaaaa4");
                }
            }
            NSString *js = [NSString stringWithFormat:@"RegCallBack('%d')",sign];
            // NSLog(@"%@", js);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                    NSLog(@"==%@----%@",data, error);
                    // NSLog(@"js get version 2");
                }];
                
            });
        }];
        //启动任务
        [task resume];
    }
    //改密码
    if([message.name isEqualToString:@"setPwd"]){
        NSObject *obj = (NSObject*)message.body;
        NSString *uasername=[obj valueForKey:@"uasername"];
        NSString *password=[obj valueForKey:@"password"];
        NSURLSession *session = [NSURLSession sharedSession];
        // 创建 URL
        
        NSString *Str=[NSString stringWithFormat:@"%@/user/resetPwd",HttpUtils.getHttpMsg];
        NSString *Str2=[NSString stringWithFormat:@"password=%@&phone=%@",password,uasername];
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
            int sign=0;
            NSString* strJson=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
            if(strJson!=NULL){
               
                
                if([[strJson valueForKey:@"code"]intValue]==200){
                    sign=1;}
               
                else if([[strJson valueForKey:@"code"]intValue]==400){
                    sign=2;}
                else if([[strJson valueForKey:@"code"]intValue]==401){
                    sign=3;}
            }else{sign=0;}
            NSString *js = [NSString stringWithFormat:@"setPwdCallBack('%d')",sign];
            // NSLog(@"%@", js);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                    
                }];
                
            });
        }];
        //启动任务
        [task resume];
    }
    //免认证登录跳转
    if([message.name isEqualToString:@"goto6"])
    {
       
       
        NSLog(@"1111111111");
        FaceEndViewController* welc = [[FaceEndViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:welc];
        navi.navigationBarHidden = true;
       
        
        [self presentViewController:navi animated:YES completion:nil];
       
     
    }
    //人脸识别
    if([message.name isEqualToString:@"Camera"]){
        DetectionViewController* dvc = [[DetectionViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:dvc];
        navi.navigationBarHidden = true;
       dvc.dic=message.body;
   
        NSLog(@"**********:%@",dvc.dic);
        [self presentViewController:navi animated:YES completion:nil];
    }
    if([message.name isEqualToString:@"goLoginBack"]){
        NSLog(@"hahahahaha");
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"phone"];
        [userDefaults removeObjectForKey:@"password"];
        
        [userDefaults synchronize];
        ViewController* welc = [[ViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:welc];
        navi.navigationBarHidden = true;
        
        
        [self presentViewController:navi animated:YES completion:nil];
    }

    if([message.name isEqualToString:@"updatePhone"]){
        NSObject *obj = (NSObject*)message.body;
        NSString *phone=[obj valueForKey:@"phone"];
        NSString *password=[obj valueForKey:@"password"];
        NSString *idstr=[obj valueForKey:@"id"];
        NSURLSession *session = [NSURLSession sharedSession];
        // 创建 URL
        NSLog(@"%@",message.body);
        NSLog(@"%@-%@-%@",phone,password,idstr);
        NSString *Str=[NSString stringWithFormat:@"%@/user/updatePhone",HttpUtils.getHttpMsg];
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
            NSString* strJson=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
               int sign2=0;
            if(strJson!=NULL){
                
             
                
                
                if([[strJson valueForKey:@"code"]intValue]==401){
                    sign2=-2;
                     NSLog(@"aaaaaaaa4");
                }
                else if([[strJson valueForKey:@"code"]intValue]==200){
                    
                    sign2=1;
                }
                else if([[strJson valueForKey:@"code"]intValue]==400){
                    sign2=-1;
                }
                else if([[strJson valueForKey:@"code"]intValue]==404){
                    sign2=-3;
                }
                else{sign2=-100;
                   
                }
                
                
            }
            
            NSString *js = [NSString stringWithFormat:@"updatePhoneCallBack('%d')",sign2];
             NSLog(@"%@", js);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                     NSLog(@"==%@----%@",data, error);
                    // NSLog(@"js get version 2");
                }];
                
            });
        }];
        //启动任务
        [task resume];
    }
   
   
}

//最后， VC销毁的时候一定要把handler移除
-(void)dealloc
{
    
     [self.config.userContentController removeScriptMessageHandlerForName:@"isLogin"];
     [self.config.userContentController removeScriptMessageHandlerForName:@"Camera"];
     [self.config.userContentController removeScriptMessageHandlerForName:@"Reg"];
     [self.config.userContentController removeScriptMessageHandlerForName:@"setPwd"];
     [self.config.userContentController removeScriptMessageHandlerForName:@"goto6"];
     [self.config.userContentController removeScriptMessageHandlerForName:@"goLoginBack"];
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

#pragma mark - Button Action






@end
