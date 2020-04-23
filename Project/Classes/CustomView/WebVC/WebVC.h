//
//  WebVC.h
//  Project
//
//  Created by Chenyi on 2019/9/11.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WebVC : BaseViewController 
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *HTMLString;
@property (nonatomic, assign) BOOL showBottomToolBar;
@property (nonatomic, assign) BOOL landscapeMode;
@property (nonatomic, assign) BOOL fullScreen;
@property (nonatomic, assign) BOOL allowScaling;
@property (nonatomic, assign) BOOL allowBounces;
@property (nonatomic, assign) BOOL showCloseItemIfNeeded;
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfig;
//@property (nonatomic, copy) NSDictionary *formData;
@property (nonatomic, copy) CallBackBlock callBack;
- (instancetype)initWithHidesBottomBar:(BOOL)hide;
- (void)refreshNavBarWithOrientationIsLandscape:(BOOL)isLandscape;
- (void)loadLink;
- (void)reloadWebView;
- (void)autoFitContent;
@end

NS_ASSUME_NONNULL_END
