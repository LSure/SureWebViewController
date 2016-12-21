//
//  SureWebViewController.m
//  SureWebViewController
//
//  Created by 刘硕 on 2016/12/13.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "SureWebViewController.h"
#import <WebKit/WebKit.h>
static CGFloat const NAVI_HEIGHT = 64;
@interface SureWebViewController ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *wk_WebView;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;

@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;

@property (nonatomic, strong) id <UIGestureRecognizerDelegate>delegate;

@end

@implementation SureWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createWebView];
    
    [self createNaviItem];
    
    [self loadRequest];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        self.delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(popGestureRecognizer:)];
    }
}

- (void)popGestureRecognizer:(UIGestureRecognizer*)gesture {
    if ([_webView canGoBack] || [_wk_WebView canGoBack]) {
        [_webView goBack];
        [_wk_WebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self.delegate;
}

- (void)dealloc {
    NSLog(@"界面销毁");
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (void)createWebView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [self.view addSubview:self.wk_WebView];
    } else {
        [self.view addSubview:self.webView];
    }
}

- (UIWebView*)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - NAVI_HEIGHT)];
        _webView.delegate = self;
    }
    return _webView;
}

- (WKWebView*)wk_WebView {
    if (!_wk_WebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.preferences = [[WKPreferences alloc]init];
        config.userContentController = [[WKUserContentController alloc]init];
        _wk_WebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - NAVI_HEIGHT) configuration:config];
        _wk_WebView.navigationDelegate = self;
        _wk_WebView.UIDelegate = self;
    }
    return _wk_WebView;
}

- (void)createNaviItem {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self showLeftBarButtonItem];
    [self showRightBarButtonItem];
}

- (void)showLeftBarButtonItem {
    if ([_webView canGoBack] || [_wk_WebView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    }
}

- (void)showRightBarButtonItem {

}

- (UIBarButtonItem*)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem*)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        _closeBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    }
    return _closeBarButtonItem;
}

- (void)back:(UIBarButtonItem*)item {
    if ([_webView canGoBack] || [_wk_WebView canGoBack]) {
        [_webView goBack];
        [_wk_WebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close:(UIBarButtonItem*)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadRequest {
    if (![self.url hasPrefix:@"http"]) {
        self.url = [NSString stringWithFormat:@"http://%@",self.url];
    }
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [_wk_WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    } else {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

#pragma mark webViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString.lowercaseString hasSuffix:@".png"]||[request.URL.absoluteString.lowercaseString hasSuffix:@".jpg"]||[request.URL.absoluteString.lowercaseString hasSuffix:@".gif"]) {
        NSLog(@"%@",request.URL.absoluteString);
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self showLeftBarButtonItem];
}

#pragma mark WKNavigationDelegate

#pragma mark 加载状态回调
//页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

//页面内容开始返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
}
//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    //标题
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        self.navigationItem.title = obj;
    }];
    
    [self showLeftBarButtonItem];
    
    [webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"URL"]) {
        NSLog(@"%@",change[@"new"]);
        SureWebViewController *surevc = [[SureWebViewController alloc]init];
        surevc.url = [change[@"new"] absoluteString];
        [self.navigationController pushViewController:surevc animated:NO];
    }
}
//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}
#pragma mark 页面跳转回调
/*
//接收到服务器跳转请求
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{

}
//发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
}
//收到响应，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
}
*/
/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{

}

/*
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{

}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)){

}
 
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
