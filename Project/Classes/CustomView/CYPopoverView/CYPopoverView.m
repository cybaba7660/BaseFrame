//
//  CYPopoverView.m
//  DoubleColorBall
//
//  Created by Chenyi on 17/1/14.
//  Copyright © 2017年 huxingqin. All rights reserved.
//

#import "CYPopoverView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define LengthX 5
#define lengthY 5
#define Length2 20

@interface CYPopoverView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) CGPoint origin;     // 箭头位置
@property (nonatomic, assign) CGFloat height;     // 视图的高度
@property (nonatomic, assign) CGFloat width;      // 视图的宽度
@property (nonatomic, assign) DirectionType type;    // 箭头位置类型
@property (nonatomic, strong) UITableView *tableView;   // 填充的tableview

@end
@implementation CYPopoverView

- (instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(CGFloat)height Type:(DirectionType)type Color:(UIColor *)color
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.origin = origin;
        self.width = width;
        self.height = height;
        self.type = type;
        self.backGoundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, height)];
        self.backGoundView.backgroundColor = color;
        self.backGoundView.layer.cornerRadius = 3;
//        self.backGoundView.layer.borderWidth = 0.8;
//        self.backGoundView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [self addSubview:self.backGoundView];
        [self.backGoundView addSubview:self.tableView];
    }
    return self;
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.type) {
        case DirectionTypeOfUpLeft:
        case DirectionTypeOfUpCenter:
        case DirectionTypeOfUpRight:{
            {
                CGFloat startX = self.origin.x;
                CGFloat startY = self.origin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX + LengthX, startY + lengthY);
                CGContextAddLineToPoint(context, startX - LengthX, startY + lengthY);
            }
            break;
        }
        case DirectionTypeOfDownLeft:
        case DirectionTypeOfDownCenter:
        case DirectionTypeOfDownRight: {
            {
                CGFloat startX = self.origin.x;
                CGFloat startY = self.origin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX - LengthX, startY - lengthY);
                CGContextAddLineToPoint(context, startX + LengthX, startY - lengthY);
            }
            break;
        }
        case DirectionTypeOfLeftUp:
        case DirectionTypeOfLeftCenter:
        case DirectionTypeOfLeftDown: {
            {
                CGFloat startX = self.origin.x;
                CGFloat startY = self.origin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX + LengthX, startY - lengthY);
                CGContextAddLineToPoint(context, startX + LengthX, startY + lengthY);
            }
            break;
        }
        case DirectionTypeOfRightUp:
        case DirectionTypeOfRightCenter:
        case DirectionTypeOfRightDown: {
            {
                CGFloat startX = self.origin.x;
                CGFloat startY = self.origin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX - LengthX, startY - lengthY);
                CGContextAddLineToPoint(context, startX - LengthX, startY + lengthY);
            }
            break;
        }
    }
    CGContextClosePath(context);
    [self.backGoundView.backgroundColor setFill];
//    [self.backgroundColor setStroke];
    CGContextDrawPath(context, kCGPathFill);
}

#pragma mark - popView
- (void)popView
{
    // 同步显示 子控件(views)和(self)
    NSArray *results = [self.backGoundView subviews];
    for (UIView *view in results) {
        [view setHidden:YES];
    }
    UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
    [windowView addSubview:self];
    switch (self.type) {
        case DirectionTypeOfUpLeft: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y + lengthY, 0, 0);
                CGFloat origin_x = self.origin.x - Length2;
                CGFloat origin_y = self.origin.y + lengthY;
                CGFloat size_width = self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfUpCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y + lengthY, 0, 0);
                CGFloat origin_x = self.origin.x - self.width / 2;
                CGFloat origin_y = self.origin.y + lengthY;
                CGFloat size_width = self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfUpRight: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y + lengthY, 0, 0);
                CGFloat origin_x = self.origin.x + Length2;
                CGFloat origin_y = self.origin.y + lengthY;
                CGFloat size_width = -self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfDownLeft: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y - lengthY, 0, 0);
                CGFloat origin_x = self.origin.x - Length2;
                CGFloat origin_y = self.origin.y - lengthY;
                CGFloat size_width = self.width;
                CGFloat size_height = -self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfDownCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y - lengthY, 0, 0);
                CGFloat origin_x = self.origin.x - self.width / 2;
                CGFloat origin_y = self.origin.y - lengthY;
                CGFloat size_width = self.width;
                CGFloat size_height = -self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfDownRight: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y - lengthY, 0, 0);
                CGFloat origin_x = self.origin.x-self.width + Length2;
                CGFloat origin_y = self.origin.y - lengthY;
                CGFloat size_width = self.width;
                CGFloat size_height = -self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfLeftUp: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x + LengthX, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x + LengthX;
                CGFloat origin_y = self.origin.y - Length2;
                CGFloat size_width = self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfLeftCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x + LengthX, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x + LengthX;
                CGFloat origin_y = self.origin.y - self.height / 2;
                CGFloat size_width = self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfLeftDown: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x + LengthX, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x + LengthX;
                CGFloat origin_y = self.origin.y - self.height + Length2;
                CGFloat size_width = self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfRightUp: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x - LengthX, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x - LengthX;
                CGFloat origin_y = self.origin.y - Length2;
                CGFloat size_width = -self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfRightCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x - LengthX, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x - LengthX;
                CGFloat origin_y = self.origin.y - self.height / 2;
                CGFloat size_width = -self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case DirectionTypeOfRightDown: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x - LengthX, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x - LengthX;
                CGFloat origin_y = self.origin.y - self.height + Length2;
                CGFloat size_width = -self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
    }
}

- (void)startAnimateView_x:(CGFloat) x
                        _y:(CGFloat) y
              origin_width:(CGFloat) width
             origin_height:(CGFloat) height
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backGoundView.frame = CGRectMake(x, y, width, height);
    }completion:^(BOOL finished) {
        NSArray *results = [self.backGoundView subviews];
        for (UIView *view in results) {
            [view setHidden:NO];
        }
    }];
}

#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![[touches anyObject].view isEqual:self.backGoundView]) {
        [self dismiss];
    } 
}

#pragma mark -
- (void)dismiss
{
    /**
     * 删除 在backGroundView 上的子控件
     */
//    NSArray *results = [self.backGoundView subviews];
//    for (UIView *view in results) {
//        [view removeFromSuperview];
//    }
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 0;
//        self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    } completion:^(BOOL finished) {
        //
        [self removeFromSuperview];
    }];
}

#pragma mark -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.backGoundView.frame.size.width, self.backGoundView.frame.size.height) style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor grayColor];
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 8, 0, 8)];
        }
    }
    return _tableView;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.row_height == 0) {
        return 38;
    }else{
        return self.row_height;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:self.fontSize];
    cell.textLabel.textColor = self.titleTextColor;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    if (self.images) {
        cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    }
    return cell;
}
#pragma mark - *************调用代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverView:selectIndexPathRow:)]) {
        [self.delegate popoverView:self selectIndexPathRow:indexPath.row];
        [self dismiss];
    }
}

@end
