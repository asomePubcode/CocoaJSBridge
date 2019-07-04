//
//  CJViewController.m
//  CocoaJSBridge
//
//  Created by 448654003@qq.com on 04/08/2019.
//  Copyright (c) 2019 448654003@qq.com. All rights reserved.
//

#import "CJViewController.h"
//#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import <WebKit/WebKit.h>
#import "CocoaJSBridge_JS.h"
#import "CocoaJSBridge.h"
@interface CJViewController ()
<
WKNavigationDelegate,
UIScrollViewDelegate,
WKScriptMessageHandler>
@property(nonatomic, strong) WKWebView *webView;

//@property(nonatomic, strong) WebViewJavascriptBridge *bridage;
@property(nonatomic, strong) CocoaJSBridge *cBridge;
@end

@implementation CJViewController

- (WKWebView* )webView {
    if (_webView==nil) {
        _webView =[[WKWebView alloc]initWithFrame:CGRectMake(0, -0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) ];
        
        NSString *base = [[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *userAgent = [NSString stringWithFormat:@"%@++++my userAgent",base];
        [_webView setCustomUserAgent:userAgent];
        
        _webView.navigationDelegate =self;
        _webView.UIDelegate = (id<WKUIDelegate>)self;
        _webView.scrollView.delegate = self;
        [_webView.scrollView setBounces:NO];
        _webView.scrollView.scrollEnabled = NO;
        [self.view addSubview:_webView];
        _webView.allowsLinkPreview = NO;
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            
            self.automaticallyAdjustsScrollViewInsets =NO;
        }
//        [self showConsole];
    }
    return _webView;
}

static double sinit;
static double start;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self registe];
    sinit = CFAbsoluteTimeGetCurrent();
    
    self.navigationItem.rightBarButtonItems =@[[[UIBarButtonItem alloc] initWithTitle:@"oldJSB" style:UIBarButtonItemStyleDone target:self action:@selector(send)],[[UIBarButtonItem alloc] initWithTitle:@"newJSB" style:UIBarButtonItemStyleDone target:self action:@selector(send2)]] ;
    
    [self.cBridge registerHandler:@"send" handler:^(id data, JSBridgeWebsocketCallback callback) {
        NSLog(@"jsbridge 收到数据：%@",data);
    }];
}

- (CocoaJSBridge *)cBridge {
    if (_cBridge == nil) {
        _cBridge = [[CocoaJSBridge alloc] initWithIdentify:@"JSBridge-1"];
    }
    return _cBridge;
}

- (void) send {
    __block int count = 10;
    //    dispatch_queue_t queue = dispatch_queue_create("ehhe", 0);
    //    dispatch_async(queue, ^{
    NSNumber *time2 = @([NSDate date].timeIntervalSince1970 * 1000);
    while (count>0) {
        
        [self.cBridge callHandler:@"send" data:@{@"service":@"test",@"action":@"test2",@"data":@{@"time2":time2,@"index":@(count),@"buf":@"askdaskd;askas;"}}];
        count --;
    }
    //     });
}
- (void) send2 {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"senddata" object:nil];
    
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}
-(void)setFilepath:(NSString *)filepath {
    _filepath = filepath;
    //    [self.webView loadFileURL:[NSURL fileURLWithPath:_filepath] allowingReadAccessToURL:nil];
    //获取bundlePath 路径
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //获取本地html目录 basePath
    //    NSString *basePath = [NSString stringWithFormat: @"%@", kSandboxDucumentPath(kBuildPath)];
    NSString *basePath = [NSString stringWithFormat: @"%@/build", bundlePath];
    //获取本地html目录 baseUrl
    NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
    NSLog(@"%@", baseUrl);
    //html 路径
    NSString *indexPath = [NSString stringWithFormat: @"%@/index.html", basePath];
    //html 文件中内容
    NSString *indexContent = [NSString stringWithContentsOfFile:
                              indexPath encoding: NSUTF8StringEncoding error:nil];
    //显示内容
    [self.webView loadHTMLString: indexContent baseURL: baseUrl];
    
}
- (void)registe {
//    self.bridage = [WebViewJavascriptBridge bridgeForWebView:self.webView];
//    [self.bridage setWebViewDelegate:self];
//    [self.bridage registerHandler:@"send" handler:^(id data, WVJBResponseCallback responseCallback) {
//        //        NSLog(@"wbJSB: %@",data);
//
//        if ([data[@"action"] isEqualToString:@"test"]) {
//            double time = [data[@"time"] longLongValue];
//            double diff = [NSDate date].timeIntervalSince1970 * 1000 - time;
//            NSDictionary *resp = @{@"service":@"test",@"action":@"test",@"data":@{@"time":data[@"time"],@"diff":[NSString stringWithFormat:@"%f",diff],@"time2":@([NSDate date].timeIntervalSince1970 * 1000),@"index":data[@"index"]?:@1}};
//            //        NSString *respstr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:resp options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//            [self.bridage callHandler:@"send" data:resp];
//        }else if ([data[@"action"] isEqualToString:@"test2"]){
//            double time = [data[@"time"] longLongValue];
//            NSTimeInterval nowtime = [NSDate date].timeIntervalSince1970 * 1000;
//            //js- native
//            double js = nowtime - time;
//            double diff = [data[@"diff"] longLongValue];
//            double alltime = nowtime - [data[@"time2"] longLongValue];
//            NSLog(@"原始JSB---------");
//            NSLog(@"js-native 时长：%f",js);
//            NSLog(@"native-js 时长：%f",diff);
//            NSLog(@"整个交互 时长：%f",alltime);
//        }
//    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showConsole {
    NSString *jsCode = @"console.log = (function(oriLogFunc){\
    return function(str)\
    {\
    var message;\
    if(typeof str === 'string') {\
        try{\
            message = JSON.parse(str);\
        } catch(error) {\
            message = str;\
        }\
    }esle {\
        message = str.toString();\
    }\
    window.webkit.messageHandlers.log.postMessage(message);\
    oriLogFunc.call(console,str);\
    }\
    })(console.log);";
    //注册js方法
    //    _webView.configuration.userContentController = [[WKUserContentController alloc]init];
    [_webView.configuration.userContentController addScriptMessageHandler:self name:@"log"];
    [_webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    
}
#pragma mark - WKWebView代理

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //    NSDictionary *msgBody = [[NSDictionary alloc] initWithDictionary:message.body];
    
    //    NSArray *contentArr = [msgBody valueForKey:@"content"];
    //    NSString *contentStr =  [contentArr componentsJoinedByString:@"  "];
    //    contentStr = [contentStr stringByAppendingString:@" \n"];
    NSLog(@"Webview Log:%@",message.body);
    //    [self writeLogTofile:contentStr];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad url:%@",webView.URL);
    start = CFAbsoluteTimeGetCurrent();
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webview初始化 到加载完成 %f",CFAbsoluteTimeGetCurrent() - sinit);
    //    sinit = 0.0000001;
    NSLog(@"webview开始 到加载完成 %f",CFAbsoluteTimeGetCurrent() - start);
    NSLog(@"webViewDidFinishLoad");
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)){
    NSLog(@"内存溢出，白屏问题，重新加载");
    
    [self.webView reload];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [self.webView reload];
    NSLog(@"页面加载失败 error %@",error);
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    //证书认证
    if (serverTrust) {
        //加服务端证书校验
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"CA" ofType:@"der"];//自签名证书
        if (cerPath) {
            NSData* caCert = [NSData dataWithContentsOfFile:cerPath];
            //        NSArray *cerArray = @[caCert];
            
            SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCert);
            NSCAssert(caRef != nil, @"caRef is nil");
            
            NSArray *caArray = @[(__bridge id)(caRef)];
            NSCAssert(caArray != nil, @"caArray is nil");
            //把自签名证书加入到信任列表
            OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
            SecTrustSetAnchorCertificatesOnly(serverTrust,NO);
            CFDataRef exceptions = SecTrustCopyExceptions (serverTrust);
            status = SecTrustSetExceptions (serverTrust, exceptions);
            CFRelease (exceptions);
            CFRelease(caRef);
        }
        completionHandler (NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
    }else {//权限认证
        completionHandler (NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialWithUser:@"asml" password:@"pwd" persistence:NSURLCredentialPersistenceForSession]);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (webView != _webView) { return; }
    NSURL *url = navigationAction.request.URL;
//    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    
    if([url.absoluteString isEqualToString:kBridgeLoad]) {
        NSString *cmd = CocoaJSBridge_js();
        [webView evaluateJavaScript:cmd completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if([url.absoluteString isEqualToString:kBridgeInit]) {
        NSString *cmd = [CocoaJSBridge WebViewJavascriptBridgeInitCommand:self.cBridge.port identify:self.cBridge.identify];
        [webView evaluateJavaScript:cmd completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
//    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
//        [_webViewDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
//    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
//    }
}


@end
