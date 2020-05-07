//
//  MeVC.m
//  Project
//
//  Created by Chenyi on 2020/3/10.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "MeVC.h"

@interface MeVC () {
    
}

@end

@implementation MeVC
#pragma mark - Dealloc
- (void)dealloc {
    NSLog(@"dealloc - MeVC");
    [NotificationCenter removeObserver:self];
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
    [NotificationCenter addObserver:self selector:@selector(userloginNotificationEvent) name:kUserLoginNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(userlogoutNotificationEvent) name:kUserLogoutNotification object:nil];
}
- (void)setupNav {
    self.navigationItem.title = @"";
}
#pragma mark - UI
- (void)setupUI {
    
}

#pragma mark - Request
#pragma mark - EventMethods
- (void)userloginNotificationEvent {
    
}
- (void)userlogoutNotificationEvent {
    
}
#pragma mark - CommonMethods

@end
