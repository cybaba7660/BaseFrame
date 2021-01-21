//
//  HomeCyCleViewCell.m
//  Project
//
//  Created by Chenyi on 2019/9/5.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "HomeCyCleViewCell.h"

NSString *const kHomeCyCleViewCellID = @"kHomeCyCleViewCellID";
@interface HomeCyCleViewCell ()
{
    
}
@end
@implementation HomeCyCleViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
    _contentImageView = imageView;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:imageView];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentImageView.frame = self.contentView.bounds;
}
@end
