//
//  XQBackButton.m
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat btnW = 22;
    CGFloat btnY = (contentRect.size.height - btnW) * 0.5;
    return CGRectMake(0, btnY, btnW, btnW);
}

@end
