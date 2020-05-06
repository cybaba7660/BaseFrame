//
//  RegisterVC.m
//  Project
//
//  Created by Chenyi on 2019/9/5.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "RegisterVC.h"
@interface RegisterVC () {
    
}
@end
@implementation RegisterVC
#pragma mark - Dealloc
- (void)dealloc {
    NSLog(@"dealloc - RegisterVC");
}
#pragma mark - Set/Get

#pragma mark - LiftCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupNav];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark - Init
- (void)setupNav {
    self.navigationItem.title = @"用户注册";
}
#pragma mark - UI
- (void)setupUI {
    
}

#pragma mark - Request

#pragma mark - EventMethods
#pragma mark - CommonMethods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
