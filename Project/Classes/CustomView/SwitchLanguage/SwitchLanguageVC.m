//
//  SwitchLanguageVC.m
//  Project
//
//  Created by Chenyi on 2020/5/9.
//  Copyright © 2020 Chenyi. All rights reserved.
//

#import "SwitchLanguageVC.h"
#import <LanguageManager.h>
#import "BaseTabBarController.h"
#import "LanguageModel.h"

@interface SwitchLanguageVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSArray *languages;
    NSUInteger originalIndex;
    NSUInteger selectedIndex;
}

@end
@implementation SwitchLanguageVC
#pragma mark - Dealloc
- (void)dealloc {
    NSLog(@"dealloc - SwitchLanguageVC");
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
    NSMutableArray *languagesArrm = @[NSLocalizedString(@"跟随系统", nil)].mutableCopy;
    NSArray<LanguageModel *> *languageList = [LanguageModel languageList];
    for (LanguageModel *model in languageList) {
        [languagesArrm addObject:model.name];
    }
    languages = languagesArrm;
    
    if (LanguageManager.isUsedSystemLanguage) {
        selectedIndex = 0;
    }else {
        NSString *currentLanguage = LanguageManager.currentLanguageName;
        [languageList enumerateObjectsUsingBlock:^(LanguageModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([currentLanguage hasPrefix:obj.identy]) {
                selectedIndex = idx + 1;
                if (!obj.usable.boolValue) {
                    for (NSInteger i = 0; i < languageList.count; i ++) {
                        LanguageModel *model = languageList[i];
                        if (model.moren.boolValue) {
                            selectedIndex = i + 1;
                            break;
                        }
                    }
                }
                *stop = YES;
            }
        }];
        originalIndex = selectedIndex;
    }
}
- (void)setupNav {
    self.navigationItem.title = NSLocalizedString(@"语言设置", nil);
}
- (void)setNavigationBarStyle {
    UIButton *completedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completedButton.frame = CGRectMake(0, 0, 60, 25);
    [completedButton setBackgroundColor:MAIN_COLOR];
    completedButton.titleLabel.font = Font_Regular(14);
    [completedButton setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [completedButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [completedButton addTarget:self action:@selector(completedButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [completedButton setAdjustsImageWhenHighlighted:NO];
    [completedButton setCornerRadius:WIDTH(3)];
    CGFloat width = [completedButton.currentTitle calculateWidthWithFont:completedButton.titleLabel.font] + WIDTH(10);
    completedButton.width = width;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:completedButton];
//    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark - UI
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeArea_H()) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.tableFooterView = tableFooterView;
    [self.view addSubview:tableView];
}

#pragma mark - Request

#pragma mark - EventMethods
- (void)completedButtonClickedEvent {
    if (originalIndex == selectedIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        
        NSString *lastLanguage = LanguageManager.currentLanguageName;
        if (self->selectedIndex == 0) {
            [LanguageManager resetToSystemLanguage];
        }else {
            NSArray<LanguageModel *> *languageList = [LanguageModel languageList];
            LanguageModel *model = languageList[self->selectedIndex - 1];
            if (!model.usable.boolValue) {
                for (NSInteger i = 0; i < languageList.count; i ++) {
                    LanguageModel *model_1 = languageList[i];
                    if (model_1.moren.boolValue) {
                        model = model_1;
                        break;
                    }
                }
            }
            [LanguageManager switchLanguage:model.shortString];
        }
        NSString *currentLanguage = LanguageManager.currentLanguageName;
        if ([lastLanguage containsString:currentLanguage] || [currentLanguage containsString:lastLanguage]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            __block UIViewController *oldRootVC = KeyWindow.rootViewController;
            BaseTabBarController *tabBarC = [[BaseTabBarController alloc] init];
            tabBarC.selectedIndex = 3;
            UINavigationController *navC = (UINavigationController *)tabBarC.selectedViewController;
            SwitchLanguageVC *languageVC = [[SwitchLanguageVC alloc] initWithHidesBottomBar:YES];
            [navC pushViewController:languageVC animated:NO];
            KeyWindow.rootViewController = tabBarC;
            oldRootVC = nil;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [navC popViewControllerAnimated:YES];
            });
        }
    });
}
#pragma mark - CommonMethods

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return languages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"language_sel"]];
        cell.accessoryView = imageView;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = languages[indexPath.row];
    cell.accessoryView.hidden = indexPath.row != selectedIndex;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *kNormalHeadId = @"kNormalHeadId";
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kNormalHeadId];
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kNormalHeadId];
    }
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WIDTH(60);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.02;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.02;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == selectedIndex) {
//        return;
//    }
    UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    lastSelectedCell.accessoryView.hidden = YES;
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryView.hidden = NO;
    selectedIndex = indexPath.row;
    
    [self completedButtonClickedEvent];
}
@end
