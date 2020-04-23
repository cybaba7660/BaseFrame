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
@property (nonatomic, copy) CallBackBlock refreshBlock;
@property (nonatomic, weak) UILabel *tipsLabel;
@end
@implementation AbnormalView
#pragma mark - Set/Get
#pragma mark - External
- (void)refreshTips:(NSString *)tips {
    self.tipsLabel.text = tips;
}
+ (instancetype)showNetworkErrorInView:(UIView *)inView tips:(NSString *)tips refreshEvent:(CallBackBlock)refreshEvent {
    if (!tips.length) {
        tips = @"暂无网络";
    }
    AbnormalView *figureView = [[AbnormalView alloc] initWithFrame:CGRectMake(0, 0, inView.width, inView.height)];
    figureView.alpha = 0;
    figureView.backgroundColor = UIColor.whiteColor;
    [inView addSubview:figureView];
    figureView.refreshBlock = refreshEvent;
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:figureView action:@selector(panGestureEvent)];
//    [figureView addGestureRecognizer:pan];
    
    CGFloat iconScale = inView.height / kSafeArea_H();
    UIImage *icon = [UIImage imageNamed:@"network_error"];
    CGFloat iconX = (figureView.width - icon.size.width * iconScale) / 2;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, figureView.height / 7, icon.size.width * iconScale, icon.size.height * iconScale)];
    imageV.image = icon;
    [figureView addSubview:imageV];
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(PADDING_HORIZ, imageV.bottom + HEIGHT_NT(12), PADDING_WIDTH, WIDTH(30))];
    Label.text = tips;
    Label.font = Font_Regular(13);
    Label.textColor = COLOR_W(150);
    Label.textAlignment = NSTextAlignmentCenter;
    [figureView addSubview:Label];
    figureView.tipsLabel = Label;
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadButton.frame = CGRectMake((figureView.width - WIDTH(85)) / 2, Label.bottom + HEIGHT_NT(18), WIDTH(85), WIDTH(30));
    [reloadButton setBackgroundColor:MAIN_COLOR];
    reloadButton.titleLabel.font = Font_Regular(14);
    [reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [reloadButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [reloadButton addTarget:figureView action:@selector(reloadButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [reloadButton setAdjustsImageWhenHighlighted:NO];
    [figureView addSubview:reloadButton];
    [reloadButton setCornerRadius:2];
    [figureView show];
    return figureView;
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
#pragma mark - EventMethods
- (void)reloadButtonClickedEvent {
    _refreshBlock ? _refreshBlock(nil) : nil;
    [self dismiss];
}
- (void)panGestureEvent {
    
}
#pragma mark - CommonMethods

@end
