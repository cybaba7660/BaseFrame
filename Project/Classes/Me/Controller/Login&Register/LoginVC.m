//
//  LoginVC.m
//  Project
//
//  Created by Chenyi on 2019/9/5.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
@interface LoginVC () <UITextFieldDelegate> {
}
@end
@implementation LoginVC
#pragma mark - Dealloc
- (void)dealloc {
    NSLog(@"dealloc - LoginVC");
}
#pragma mark - Set/Get

#pragma mark - LiftCycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
}
#pragma mark - UI
- (void)setupUI {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:bgImageView];

}

#pragma mark - Request

#pragma mark - EventMethods

#pragma mark - CommonMethods
- (void)dealUserInfo:(NSDictionary *)info psw:(NSString *)psw {
    NSDictionary *user = info[@"user"];
    UserInfoModel *model = [UserInfoModel modelWithDictionary:user];
    [model saveUserInfoWithUserName:@"" psw:psw];
    [UserInfoModel setRememberPswStatus:YES];
    [NotificationCenter postNotificationName:kUserLoginNotification object:model];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
