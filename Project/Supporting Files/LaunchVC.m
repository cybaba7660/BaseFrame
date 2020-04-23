//
//  LaunchVC.m
//  bldfh
//
//  Created by huxingqin on 2017/3/23.
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KeyWindow.rootViewController = [(AppDelegate *)[UIApplication sharedApplication].delegate tabBarController];
    });
}

@end
