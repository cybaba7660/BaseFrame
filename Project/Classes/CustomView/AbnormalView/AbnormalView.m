//
//  AbnormalView.m
//  Project
//
//  Created by Chenyi on 2019/11/8.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "AbnormalView.h"
@interface AbnormalView () {
    
}
@property (nonatomic, copy) CommonBlock refreshBlock;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *tipsImageView;
@property (nonatomic, weak) UILabel *tipsLabel;
@property (nonatomic, weak) UIButton *reloadButton;
@end
@implementation AbnormalView
#pragma mark - Set/Get
#pragma mark - External
+ (void)showInView:(UIView *)inView imageName:(NSString *)imageName tips:(NSString *)tips refreshText:(NSString *)refreshText refreshEvent:(CommonBlock)refreshEvent {
    if (!inView) {
        return;
    }
    if (!tips.length) {
        tips = NSLocalizedString(@"暂无网络", nil);
    }
    if (!inView.abnormalView) {
        AbnormalView *view = [[AbnormalView alloc] initWithFrame:CGRectMake(0, 0, inView.width, inView.height)];
        inView.abnormalView = view;
        view.alpha = 0;
        view.backgroundColor = UIColor.whiteColor;
        [inView addSubview:view];
        view.layer.zPosition = 1;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 0)];
        view.contentView = contentView;
        [view addSubview:contentView];
        
        UIImageView *tipsImageView = [[UIImageView alloc] init];
        view.tipsImageView = tipsImageView;
        [contentView addSubview:tipsImageView];
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING_HORIZ, 0, PADDING_WIDTH, 0)];
        tipsLabel.text = tips;
        tipsLabel.numberOfLines = 0;
        tipsLabel.font = Font_Regular(13);
        tipsLabel.textColor = COLOR_W(150);
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:tipsLabel];
        view.tipsLabel = tipsLabel;
        
        UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        view.reloadButton = reloadButton;
        reloadButton.frame = CGRectMake(0, 0, 0, WIDTH(36));
        [reloadButton setBackgroundColor:MAIN_COLOR];
        reloadButton.titleLabel.font = Font_Regular(15);
        [reloadButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [reloadButton addTarget:view action:@selector(reloadButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
        [reloadButton setAdjustsImageWhenHighlighted:NO];
        [contentView addSubview:reloadButton];
        [reloadButton setCornerRadius:5];
        [reloadButton setClipsToBounds:YES];
    }
    
    [inView.abnormalView refreshIcon:imageName];
    [inView.abnormalView refreshTips:tips];
    [inView.abnormalView refreshReloadText:refreshText];
    inView.abnormalView.refreshBlock = refreshEvent;
    [inView.abnormalView show];
}
- (void)show {
    [self gradualDisplay];
}
- (void)dismiss {
    [self gradualDismiss];
    self.superview.abnormalView = nil;
}
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}
#pragma mark - UI
- (void)setupUI {
    
}
- (void)refreshIcon:(NSString *)icon {
    CGFloat iconScale = self.superview.height / kSafeArea_H();
    UIImage *image = [UIImage imageNamed:icon];
    CGFloat iconX = (self.width - image.size.width * iconScale) / 2;
    self.tipsImageView.frame = CGRectMake(iconX, 0, image.size.width * iconScale, image.size.height * iconScale);
    self.tipsImageView.image = image;
    [self refreshOrigin];
}
- (void)refreshTips:(NSString *)tips {
    self.tipsLabel.text = tips;
    [self.tipsLabel heightToFit];
    [self refreshOrigin];
}
- (void)refreshReloadText:(NSString *)text {
    [self.reloadButton setTitle:text forState:UIControlStateNormal];
    CGFloat width = [text calculateWidthWithFont:self.reloadButton.titleLabel.font];
    self.reloadButton.width = width ? width + WIDTH(68) : 0;
    self.reloadButton.left = (self.width - self.reloadButton.width) / 2;
}
- (void)refreshOrigin {
    self.tipsLabel.top = self.tipsImageView.bottom;
    self.reloadButton.top = self.tipsLabel.bottom + HEIGHT_NT(12);
    self.contentView.height = self.reloadButton.bottom;
    self.contentView.centerY = self.height / 2;
}
#pragma mark - EventMethods
- (void)reloadButtonClickedEvent {
    _refreshBlock ? _refreshBlock(nil) : nil;
}
- (void)panGestureEvent {
    
}
#pragma mark - CommonMethods

@end
