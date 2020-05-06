//
//  BaseNavicationController.h
//  Project
//
//  Created by Chenyi on 2018/1/13.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationControllerDelegate <NSObject>
@optional
- (BOOL)shouldPopOnBackButtonPress;
@end

@interface BaseNavigationController : UINavigationController

@end
