//
//  UICollectionView+Helper.m
//  Project
//
//  Created by CC on 2020/8/23.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "UICollectionView+Helper.h"

@implementation UICollectionView (Helper)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(reloadData) with:@selector(ex_reloadData)];
    });
}
- (void)ex_reloadData {
//    [self checkDatasource];
    [self ex_reloadData];
}
- (void)checkDatasource {
    BOOL isEmpty = YES;//flag标示

    id  dataSource = self.dataSource;
    NSInteger sections = 1;//默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sections = [dataSource numberOfSectionsInCollectionView:self];//获取当前TableView组数
    }

    for (NSInteger i = 0; i < sections; i++) {
        NSInteger rows = [dataSource collectionView:self numberOfItemsInSection:i];//获取当前TableView各组行数
        if (rows) {
            isEmpty = NO;//若行数存在，不为空
            break;
        }
    }
    if (isEmpty) {//若为空，加载占位图
        [self showAbnormalViewWithType:AbnormalTypeNoData tips:NSLocalizedString(@"暂无数据", nil) refreshEvent:nil];
    }else {//不为空，隐藏占位图
        [self.abnormalView dismiss];
    }
}
#pragma mark - External
- (void)reloadAndNoDataDetection {
    [self checkDatasource];
    [self ex_reloadData];
}
@end
