//
//  VerificationCodeButton.m
//  Project
//
//  Created by CC on 2020/11/21.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "VerificationCodeButton.h"
@interface VerificationCodeButton () {
    NSInteger countDownSecond;
}
@property (nonatomic, strong) NSTimer *coolingTimer;
@end
@implementation VerificationCodeButton
#pragma mark - Dealloc
- (void)dealloc {
    NSLog(@"dealloc - VerificationCodeButton");
    [self.coolingTimer invalidate];
}
#pragma mark - Set/Get
- (void)setEnabled:(BOOL)enabled {
    if (enabled) {
        int coolingTime = [SystemManager verificationCodeCoolingTime:CoolingTimeTypeVerificationCode];
        [super setEnabled:coolingTime <= 0];
    }else {
        [super setEnabled:enabled];
    }
}
#pragma mark - External
+ (instancetype)defaultInit {
    VerificationCodeButton *button = [VerificationCodeButton buttonWithType:UIButtonTypeCustom];
    button.enabled = NO;
    button.titleLabel.font = Font_Regular(13);
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:COLOR_W(193)] forState:UIControlStateDisabled];
    [button addTarget:button action:@selector(verifyCodeButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [button setAdjustsImageWhenHighlighted:NO];
    [button widthToFitWithIncrease:WIDTH(20)];
    [button heightToFitWithIncrease:WIDTH(10)];
    [button setCornerRadius:WIDTH(3) masksToBounds:YES];
    return button;
}
- (void)startCoolingTime {
    self.enabled = NO;
    countDownSecond = [SystemManager coolingTimes:CoolingTimeTypeVerificationCode];
    [self.coolingTimer setFireDate:[NSDate date]];
    [SystemManager verificationCodeGotTimeMarking:CoolingTimeTypeVerificationCode];
}
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
        __weak typeof(self) weakSelf = self;
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf->countDownSecond <= 0) {
                [timer setFireDate:[NSDate distantFuture]];
                [weakSelf setTitle:@"重新发送" forState:UIControlStateNormal];
                if (self.willEnable) {
                    weakSelf.enabled = self.willEnable();
                }else {
                    weakSelf.enabled = YES;
                }
                return;
            }
            [weakSelf setTitle:[NSString stringWithFormat:@"重新发送(%zd)", strongSelf->countDownSecond] forState:UIControlStateNormal];
            strongSelf->countDownSecond --;
            
        } repeats:YES];
        self.coolingTimer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer setFireDate:[NSDate distantFuture]];
        
        int coolingTime = [SystemManager verificationCodeCoolingTime:CoolingTimeTypeVerificationCode];
        if (coolingTime <= 0) {
            [weakSelf setTitle:@"获取验证码" forState:UIControlStateNormal];
        }else {
            countDownSecond = coolingTime;
            weakSelf.enabled = NO;
            [self.coolingTimer setFireDate:[NSDate date]];
        }
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
- (void)verifyCodeButtonClickedEvent {
    self.clickedHandler ? self.clickedHandler() : nil;
}
#pragma mark - CommonMethods

@end
