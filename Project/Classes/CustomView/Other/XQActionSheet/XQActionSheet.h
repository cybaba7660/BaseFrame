//
//  XQActionSheet.h
//  biaoqing
//
//  Created by ufuns on 16/1/22.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQActionSheet;
@protocol XQActionSheetDelegate <NSObject>

@optional
/**
 *  ActionSheet按钮点击事件处理
 */
- (void)actionSheetButtonDidClick:(XQActionSheet *)actionSheet ButtonType:(int)buttonType;
/**
 *  ActionSheet已经消失 
 */
- (void)actionSheetWasHidden;
@end

@interface XQActionSheet : UIView

@property (nonatomic, assign) id<XQActionSheetDelegate> delegate;

/**
 *  创建普通button的ActionSheetView 
 *  @parameter : title                   标题
 *  @parameter : delegate                代理
 *  @parameter : cancelButtonTitle       "取消"按钮的标题
 *  @parameter : destructiveButtonTitle  "不可恢复"按钮的标题
 *  @parameter : otherButtonTitles, ...  可变参数 可传入多个字符串，必须以nil结尾
 */
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<XQActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...;

/**
 *  创建带有自定义view的ActionSheetView
 *  @parameter : view                    自定义View
 *  @parameter : delegate                代理
 *  @parameter : cancelButtonTitle       "取消"按钮的标题
 *  @parameter : destructiveButtonTitle  "不可恢复"按钮的标题
 *  @parameter : otherButtonTitles, ...  可变参数 可传入多个字符串，必须以nil结尾
 */
- (instancetype)initWithCustomView:(UIView *)view
                          Delegate:(id<XQActionSheetDelegate>)delegate
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                 otherButtonTitles:(NSString *)otherButtonTitles, ...;

/**
 * 显示actionSheet
 *  @parameter : view 在哪个view中显示
 */
- (void)showInView:(UIView *)view;

/**
 *  设置标题颜色
 */
- (void)setTitleColor:(UIColor *)color;

/**
 * 隐藏ActionSheet
 */
- (void)hideActionSheet;
@end
