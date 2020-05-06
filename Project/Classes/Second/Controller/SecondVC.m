//
//  SecondVC.m
//  Project
//
//  Created by Chenyi on 2020/3/10.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "SecondVC.h"

@interface SecondVC () {
    
}

@end

@implementation SecondVC
#pragma mark - Dealloc
- (void)dealloc {
    NSLog(@"dealloc - SecondVC");
}
#pragma mark - Set/Get

#pragma mark - LiftCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupNav];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
#pragma mark - Init
- (void)initData {
    
}
- (void)setupNav {
    self.navigationItem.title = @"";
}
#pragma mark - UI
- (void)setupUI {
    
}

#pragma mark - Request
#pragma mark - EventMethods
#pragma mark - CommonMethods

@end
