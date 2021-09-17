//
//  LaunchVC.m
//  Project
//
//  Created by Chenyi on 2017/3/23.
//  Copyright © 2017年 huxingqin. All rights reserved.
//

#import "LaunchVC.h"
#import "AppDelegate.h"

@interface LaunchVC ()

@end

@implementation LaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image        = [UIImage imageNamed:@"launchImage"];
    [self.view addSubview:imageView];
    
    [self testingDomains];
}
- (void)testingDomains {
    [NetworkManager testingDomainsWithCompleted:^(BOOL validity) {
        if (validity) {
            //app版本信息
            [AppInfo requestVersionWithCompleted:^(NSString *error, BOOL newVersion) {
                [AppInfo checkVersion];
                [self completed];
            }];
        }else {
            [self showTestingDoaminsErrorAlert];
        }
    }];
}
- (void)showTestingDoaminsErrorAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"网络连接失败，请稍后重试", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"重新使用接口池");
        [self testingDomains];
    }];
    [alert addAction:confirmAction];
    [SystemManager.currentVC presentViewController:alert animated:YES completion:nil];
}
- (void)completed {
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = .5;
    [transition setType:kCATransitionFade];
    [transition setSubtype:kCATransitionFromRight];
    [KeyWindow.layer addAnimation:transition forKey:@"animation"];
    KeyWindow.rootViewController = [(AppDelegate *)[UIApplication sharedApplication].delegate tabBarController];
}
#pragma mark - 获取app信息
@end
