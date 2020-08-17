//
//  WebVC.m
//  Project
//
//  Created by Chenyi on 2019/9/11.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "WebVC.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#define TAG_ITEM 1000
@interface WebVC () <WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate> {
    
}
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) UIProgressView *progressView;
@end
@implementation WebVC
#pragma mark - dealloc
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [NotificationCenter removeObserver:self];
}
#pragma mark - Set/Get
- (WKWebViewConfiguration *)webViewConfig {
    if (!_webViewConfig) {
        WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
        webViewConfig.userContentController = [[WKUserContentController alloc] init];
        WKPreferences *preference = [[WKPreferences alloc]init];
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        webViewConfig.preferences = preference;
        _webViewConfig = webViewConfig;
    }
    return _webViewConfig;
}
- (void)setUrl:(NSString *)url {
//    NSString *safeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *safeUrl = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    _url = safeUrl;
    _url = url;
}
#pragma mark - External
- (void)loadLink {
    if (self.url.length) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:request];
        NSLog(@"初次加载地址:%@", self.url);
    }else if (self.HTMLString.length) {
        [self.webView loadHTMLString:self.HTMLString baseURL:nil];
    }
}
- (void)reloadWebView {
    [self.webView reload];
}
- (void)autoFitContent {
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.webViewConfig.userContentController addUserScript:wkUScript];
}
#pragma mark - Init
- (instancetype)initWithHidesBottomBar:(BOOL)hide {
    if (self = [super initWithHidesBottomBar:hide]) {
        [self initSettings];
    }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        [self initSettings];
    }
    return self;
}
- (void)initSettings {
    self.showBottomToolBar = NO;
    self.landscapeMode = NO;
    self.fullScreen = NO;
    self.allowScaling = NO;
    self.allowBounces = YES;
    self.showCloseItemIfNeeded = NO;
    [NotificationCenter addObserver:self selector:@selector(handleStatusBarOrientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(handleStatusBarOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}
- (void)setupNav {
    if (self.showCloseItemIfNeeded) {
        [self resetBackBarButtonItem];
    }
}
- (void)resetBackBarButtonItem {
    UIImage *backImage = [[UIImage imageNamed:@"nav_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *goBackItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(goBackItemClickedEvent)];
    self.navigationItem.leftBarButtonItems = @[goBackItem];
}
- (void)setupLeftBarButtonItemsWithCloseItem {
    UIImage *backImage = [[UIImage imageNamed:@"nav_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *goBackItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(goBackItemClickedEvent)];
    UIImage *closeImage = [[UIImage imageNamed:@"nav_close_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClickedEvent)];
    self.navigationItem.leftBarButtonItems = @[goBackItem, closeItem];
}
#pragma mark - LiftCycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.fullScreen) {
//        [self.navigationController setNavigationBarHidden:YES animated:animated];
        self.navigationController.navigationBar.hidden = YES;
    }
    if (self.landscapeMode) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate setAllowLandscape:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [(AppDelegate *)[UIApplication sharedApplication].delegate setAllowLandscape:NO];
    [self setupInterfaceOrientation:UIInterfaceOrientationPortrait];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupNav];
    [self initUI];
}
#pragma mark - UI
- (void)initUI {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webViewConfig];
    self.webView = webView;
    
//    [self autoFitContent];
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    if (self.allowScaling) {
        webView.scrollView.delegate = self;
        webView.scrollView.maximumZoomScale = 1.5;
        webView.scrollView.minimumZoomScale = 1;
    }
    webView.scrollView.bounces = self.allowBounces;
    webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:webView];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView = progressView;
    progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    progressView.progressTintColor = UIColor.lightGrayColor;
    progressView.trackTintColor = UIColor.clearColor;
    [self.view addSubview:progressView];
    [self refreshWebViewFrameWithIsLandscape:NO animatedDuration:0];
    if (self.showBottomToolBar) {
        UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(webView.frame), SCREEN_WIDTH, kTabBar_H)];
        [self.view addSubview:bottomToolBar];
        
        CGFloat button_w = SCREEN_WIDTH / 5;
        NSArray *icons = @[@"web_goBack", @"web_goForward", @"web_reload", @"web_clear", @"web_home"];
        for (int i = 0; i < 5; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(button_w * i, 0, button_w, bottomToolBar.bounds.size.height);
            btn.tag = TAG_ITEM + i;
            [btn setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickedEvent:) forControlEvents:UIControlEventTouchUpInside];
            [bottomToolBar addSubview:btn];
        }
    }
    [self loadLink];
}
- (void)refreshNavBarWithOrientationIsLandscape:(BOOL)isLandscape {
    
}
#pragma mark - Request

#pragma mark - EventMethods
- (void)clickedEvent:(UIButton *)button {
    if (button.tag == TAG_ITEM) {
        //后退
        [self.webView goBack];
    }else if (button.tag == TAG_ITEM + 1) {
        //前进
        [self.webView goForward];
    }else if (button.tag == TAG_ITEM + 2) {
        //刷新
        [self.webView reload];
    }else if (button.tag == TAG_ITEM + 3) {
        //清理
        [self clearCacheAtWebView];
    }else if (button.tag == TAG_ITEM + 4) {
        //首页
        WKBackForwardList *list = [self.webView backForwardList];
        NSArray *backList = list.backList;
        if (backList.count) {
            [self.webView goToBackForwardListItem:backList.firstObject];
        }
    }
}

- (void)goBackItemClickedEvent {
    WKBackForwardList *list = [self.webView backForwardList];
    NSArray *backList = list.backList;
    if (backList.count) {
        [self.webView goBack];
    }else {
        [self closeItemClickedEvent];
    }
}
- (void)closeItemClickedEvent {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 横竖屏设置
- (void)refreshWebViewFrameWithIsLandscape:(BOOL)isLandscape animatedDuration:(CGFloat)animatedDuration {
    CGFloat navBar_H = 0;
    if (!self.fullScreen) {
        if (self.navigationController) {
            navBar_H = kStatusBarAndNavBar_H;
        }else {
            navBar_H = kStatusBar_H;
        }
    }
    
    CGFloat tabbar_H = 0;
    if (!self.fullScreen) {
        tabbar_H += kBottomMargin;
    }
    if (!self.hidesBottomBarWhenPushed && self.tabBarController) {
        tabbar_H += kTabBar_H;
    }
    
    CGFloat toolBar_H = (self.showBottomToolBar ? kTabBar_H : 0);
    
    CGFloat webView_w = isLandscape ? SCREEN_MAX : SCREEN_MIN;
    CGFloat webView_h = isLandscape ? SCREEN_MIN - tabbar_H - toolBar_H - navBar_H : SCREEN_MAX - tabbar_H - toolBar_H - navBar_H;
    
    CGFloat webView_y = 0;
    if (!self.fullScreen) {
        if (!self.navigationController) {
            webView_y = kStatusBar_H;
        }else {
            webView_y = 0;
        }
    }
    [UIView animateWithDuration:0 animations:^{
        self.webView.frame = CGRectMake(0, webView_y, webView_w, webView_h);
        self.progressView.top = self.webView.top;
    }];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    BOOL isLandscape = size.width == SCREEN_MAX;
    [self refreshWebViewFrameWithIsLandscape:isLandscape animatedDuration:coordinator.transitionDuration];
//    [[SystemTipsView showingView] setNeedsLayout];
    [self refreshNavBarWithOrientationIsLandscape:isLandscape];
}
- (void)handleStatusBarOrientationWillChange:(NSNotification *)notification {
    UIInterfaceOrientation interfaceOrientation = [notification.userInfo[UIApplicationStatusBarOrientationUserInfoKey] integerValue];
}
- (void)handleStatusBarOrientationDidChange:(NSNotification *)notification {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
}
- (BOOL)shouldAutorotate {
    return self.landscapeMode;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.landscapeMode ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.landscapeMode ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
}
#pragma mark - 状态栏设置
- (BOOL)prefersStatusBarHidden {
    return self.fullScreen;
}
#pragma mark - CommonMethods
- (void)clearCacheAtWebView {
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >= 9.0) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache];
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            [MBProgressHUD showMessage:@"清理成功" inView:self.view];
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progressView.alpha = 1.0f;
        [self.progressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:.3f
                                  delay:.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.progressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    [self.view showAbnormalViewWithType:AbnormalTypeNetWorkError tips:error.userInfo[@"NSLocalizedDescription"] refreshEvent:^(id obj) {
        if (self.url && [self.url isKindOfClass:[NSString class]]) {
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }else {
            [webView loadHTMLString:self.HTMLString baseURL:nil];
        }
    }];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView.scrollView endRefresh];
    if (self.showCloseItemIfNeeded) {
        WKBackForwardList *list = [self.webView backForwardList];
        NSArray *backList = list.backList;
        if (backList.count) {
            [self setupLeftBarButtonItemsWithCloseItem];
        }else {
            [self resetBackBarButtonItem];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.landscapeMode) {
            [self setupInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
    });
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] inView:self.view];
}
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didReceiveServerRedirect");
}
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"跳转地址：%@", navigationAction.request.URL);
    NSURLRequest *request        = navigationAction.request;
    NSString     *scheme      = request.URL.scheme;
    // decode for all URL to avoid url contains some special character so that it wasn't load.
    NSString *urlStr = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"] && ![scheme isEqualToString:@"about"]) {
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
            [[UIApplication sharedApplication] openURL:request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }else if ([urlStr containsString:@"txia89"]) {
        NSLog(@"");
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString *urlStr = navigationResponse.response.URL.absoluteString;
//
//    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:urlStr];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    for (NSURLQueryItem *item in urlComponents.queryItems) {
//        [params setObject:item.value forKey:item.name];
//    }
//
//    NSString *schemes = params[@"scheme"];
//    if (schemes.length) {
//        NSURL *alipayURL = [NSURL URLWithString:schemes];
//        if ([[UIApplication sharedApplication] canOpenURL:alipayURL]) {
//            [[UIApplication sharedApplication] openURL:alipayURL];
//        }
//    }
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        if (challenge.previousFailureCount == 0) {
//            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
//        } else {
//            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//        }
//    }
//}
#pragma mark - WKUIDelegate
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"消息" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews.firstObject;
}
@end

