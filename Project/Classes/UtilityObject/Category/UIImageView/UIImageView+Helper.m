//
//  UIImageView+Helper.m
//  Project
//
//  Created by Chenyi on 2019/9/23.
//  Copyright © 2019 Chenyi. All rights reserved.
//

#import "UIImageView+Helper.h"

@implementation UIImageView (Helper)
static const void *kNormalImage = &kNormalImage;
- (void)setNormalImage:(UIImage *)normalImage {
    objc_setAssociatedObject(self, kNormalImage, normalImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.selected) {
        self.image = normalImage;
    }
}
- (UIImage *)normalImage {
    return objc_getAssociatedObject(self, kNormalImage) ? : self.image;
}

static const void *kSelectedImage = &kSelectedImage;
- (void)setSelectedImage:(UIImage *)selectedImage {
    objc_setAssociatedObject(self, kSelectedImage, selectedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.selected) {
        self.image = selectedImage;
    }
}
- (UIImage *)selectedImage {
    return objc_getAssociatedObject(self, kSelectedImage);
}

static const void *kSelectedStatus = &kSelectedStatus;
- (void)setSelected:(BOOL)selected {
    objc_setAssociatedObject(self, kSelectedStatus, [NSNumber numberWithBool:selected], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (selected && self.selectedImage) {
        self.image = self.selectedImage;
    }else if (!selected && self.normalImage) {
        self.image = self.normalImage;
    }
}
- (BOOL)selected {
    return [objc_getAssociatedObject(self, kSelectedStatus) boolValue];
}
- (void)addLongPressToSaveImage {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否保存图片到相册" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UILongPressGestureRecognizer *longPress = sender;
            if ([(UIImageView *)longPress.view image]) {
                UIImageWriteToSavedPhotosAlbum([(UIImageView *)longPress.view image], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
        [alert addAction:confirmAction];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancleAction];
        [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
    [self addGestureRecognizer:longPress];
}
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [MBProgressHUD showMessage:@"保存失败，请确认已打开 APP 相册使用权限再重试" inView:KeyWindow];
    }else {
        [MBProgressHUD showMessage:@"图片已保存到相册" inView:KeyWindow];
    }
}
@end
