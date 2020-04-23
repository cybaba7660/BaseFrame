//
//  GuidanceViewController.m
//  ProjectGuanJia
//
//  Created by 韩陈义 on 16/11/21.
//  Copyright © 2016年 韩陈义. All rights reserved.
//

#import "GuidanceViewController.h"
#import "BaseTabBarController.h"
#import "AppDelegate.h"

//引导页数
static NSInteger pageNumber = 2;

@interface GuidanceViewController () <UIScrollViewDelegate>
{
    UIScrollView *scroView;
    UIPageControl *pageControl;
}
@end

@implementation GuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadGuidance];
}

- (void)loadGuidance
{
    scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scroView.delegate = self;
    scroView.pagingEnabled = YES;
    scroView.showsHorizontalScrollIndicator = NO;
    scroView.bounces = NO;
    scroView.contentSize = CGSizeMake(SCREEN_WIDTH * pageNumber, SCREEN_HEIGHT);
    [self.view addSubview:scroView];
    for (NSInteger i = 0; i < pageNumber; i ++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"02b0%zd.png",i + 1]];
        [scroView addSubview:imgView];
        if (i == pageNumber - 1) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * (pageNumber - 1) + (SCREEN_WIDTH / 2 - 60), SCREEN_HEIGHT - HEIGHT(108), HEIGHT(118), HEIGHT(36))];
            [btn setTitle:@"开始体验" forState:UIControlStateNormal];
            [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE(15) weight:UIFontWeightSemibold]];
            [btn addTarget:self action:@selector(goToMainView) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setCornerRadius:6];
            [btn.layer setBorderWidth:1];
            [btn.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
            [scroView addSubview:btn];
        }
    }
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT(24))];
    pageControl.centerY = SCREEN_HEIGHT - 25;
    pageControl.numberOfPages = pageNumber;
    pageControl.backgroundColor = RGBACOLOR(246, 246, 246, 0.2);
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    [self.view addSubview:pageControl];
}
- (void)goToMainView
{
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = .5;
    [transition setType:kCATransitionReveal];
    [transition setSubtype:kCATransitionFromRight];
    [KeyWindow.layer addAnimation:transition forKey:@"animation"];
    KeyWindow.rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarController;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControl.currentPage = scroView.contentOffset.x/scroView.bounds.size.width;
}

@end
