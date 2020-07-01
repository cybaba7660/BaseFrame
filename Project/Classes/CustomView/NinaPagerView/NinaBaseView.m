// The MIT License (MIT)
//
// Copyright (c) 2015-2016 RamWire ( https://github.com/RamWire )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "NinaBaseView.h"
#import "UIParameter.h"

@implementation NinaBaseView
{
    UIView *lineBottom;
    UIView *topTabBottomLine;
    NSMutableArray *btnArray;
    NSMutableArray *topTabArray;
    NSMutableArray *bottomLineWidthArray;
    NSInteger topTabType;
    UIView *ninaMaskView;
}

- (instancetype)initWithFrame:(CGRect)frame WithTopTabType:(NSInteger)topTabNum
{
    self = [super initWithFrame:frame];
    topTabType = topTabNum;
    return self;
}

#pragma mark - SetMethod
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self baseViewLoadData];
}

- (void)setTopTabHiddenEnable:(BOOL)topTabHiddenEnable {
    _topTabHiddenEnable = topTabHiddenEnable;
    CGFloat minusDistance = _topTabHiddenEnable?_topHeight:0;
    [UIView animateWithDuration:0.3 animations:^{
        self.topTab.frame = CGRectMake(0, 0 - minusDistance, self.topTab.width, self.topHeight);
        self.scrollView.frame = CGRectMake(0, self.topHeight - minusDistance, self.scrollView.width, self.frame.size.height - (self.topHeight - minusDistance));
    }];
}

- (void)reloadTabItems:(NSArray *)newTitles {
    self.titleArray = newTitles;
    for (UIView *subView in self.topTab.subviews) {
        [subView removeFromSuperview];
    }
    _scrollView.contentOffset = CGPointMake(0, 0);
    _topTab.contentOffset = CGPointMake(0, 0);
    [self updateScrollViewUI];
    [self updateTopTabUI];
    [self initUI];
}

#pragma mark - LazyLoad
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.tag = 318;
        _scrollView.backgroundColor = UIColorFromRGB(0xfafafa);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIScrollView *)topTab {
    if (!_topTab) {
        _topTab = [[UIScrollView alloc] init];
        _topTab.delegate = self;
        if (_topTabColor) {
            _topTab.backgroundColor = _topTabColor;
        }else {
            _topTab.backgroundColor = [UIColor whiteColor];
        }
        _topTab.tag = 917;
        _topTab.scrollEnabled = YES;
        _topTab.alwaysBounceHorizontal = YES;
        _topTab.showsHorizontalScrollIndicator = NO;
        _topTab.showsVerticalScrollIndicator = NO;
        _topTab.bounces = NO;
        _topTab.scrollsToTop = NO;
        [self updateTopTabUI];
        if (@available(iOS 11.0, *)) {
            _topTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _topTab;
}

#pragma mark - BtnMethod
- (void)touchAction:(UIButton *)button {
    [_scrollView setContentOffset:CGPointMake(_scrollView.width * button.tag, 0) animated:YES];
    self.currentPage = _scrollView.contentOffset.x / _scrollView.width;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 318) {
        NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x + 1) / scrollView.width);
        self.currentPage = currentPage;
        UIButton *button = [_topTab viewWithTag:self.currentPage];
        if (_topTab.contentSize.width > _topTab.width) {
            CGFloat offset_x = button.centerX - _topTab.width / 2;
            if (offset_x < 0) {
                offset_x = 0;
            }else if (offset_x > _topTab.contentSize.width - _topTab.width) {
                offset_x = _topTab.contentSize.width - _topTab.width;
            }
            [_topTab setContentOffset:CGPointMake(offset_x, 0) animated:YES];
        }
        
        if (topTabType == 0 || topTabType == 2) {
            if (_btnSelectColor) {
                [btnArray[currentPage] setTitleColor:_btnSelectColor forState:UIControlStateNormal];
            }else {
                [btnArray[currentPage] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            if (_topArray.count == _titleArray.count && _changeTopArray.count == _titleArray.count) {
                UIButton *customTopButton = btnArray[currentPage];
                for (UIView *view in customTopButton.subviews) {
                    if ([view isKindOfClass:[UIView class]]) {
                        [view removeFromSuperview];
                    }
                }
                if (![customTopButton.subviews isKindOfClass:[UIView class]]) {
                    UIView *whites = _changeTopArray[currentPage];
                    whites.frame = customTopButton.bounds;
                    whites.userInteractionEnabled = NO;
                    whites.exclusiveTouch = NO;
                    [btnArray[currentPage] addSubview:whites];
                }
            }
            UIButton *changeButton = btnArray[currentPage];
            if (_titleScale > 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    changeButton.transform = CGAffineTransformMakeScale(_titleScale, _titleScale);
                }];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    changeButton.transform = CGAffineTransformMakeScale(1.15, 1.15);
                }];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 318) {
        CGFloat currentPage = scrollView.contentOffset.x / scrollView.width;
        NSInteger fromPage = floorf(currentPage);
        NSInteger toPage = ceilf(currentPage);
        UIButton *fromItem = [_topTab viewWithTag:fromPage];
        UIButton *toItem = [_topTab viewWithTag:toPage];
        CGFloat percent = currentPage - fromPage;
        CGFloat moveLength = toItem.left - fromItem.left;
        CGFloat lineBottomLeft = fromItem.left + moveLength * percent;
        CGFloat lineBottomWidth = fromItem.width + (toItem.width - fromItem.width) * percent;
        if (topTabType == 1) {
            ninaMaskView.left = - lineBottomLeft;
        }
        lineBottom.left = lineBottomLeft;
        lineBottom.width = lineBottomWidth;
        for (NSInteger i = 0;  i < btnArray.count; i++) {
            if (topTabType == 0 || topTabType == 2) {
                if (_btnUnSelectColor) {
                    [btnArray[i] setTitleColor:_btnUnSelectColor forState:UIControlStateNormal];
                }else {
                    [btnArray[i] setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
                if (_topArray.count == _titleArray.count && _changeTopArray.count == _titleArray.count && (topTabType == 0 || topTabType == 2)) {
                    UIView *customTopView = _topArray[i];
                    UIButton *customTopButton = btnArray[i];
                    for (NSInteger i = [customTopButton.subviews count] - 1; i>=0; i--) {
                        if ([[customTopButton.subviews objectAtIndex:i] isKindOfClass:[UIView class]]) {
                            [[customTopButton.subviews objectAtIndex:i] removeFromSuperview];
                        }
                    }
                    customTopView.frame = customTopButton.bounds;
                    customTopView.userInteractionEnabled = NO;
                    customTopView.exclusiveTouch = NO;
                    [customTopButton addSubview:customTopView];
                }
            }
            UIButton *changeButton = btnArray[i];
            [UIView animateWithDuration:0.3 animations:^{
                changeButton.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }
    }
}

#pragma mark - Load scrollview and toptab
- (void)updateScrollViewUI {
    _scrollView.contentSize = CGSizeMake(_scrollView.width * _titleArray.count, 0);
    if (!_slideEnabled) {
        _scrollView.scrollEnabled = NO;
    }
}

- (void)updateTopTabUI {
    for (UIView *view in _topTab.subviews) {
        [view removeFromSuperview];
    }
    
    btnArray = [NSMutableArray array];
    bottomLineWidthArray = [NSMutableArray array];
    topTabArray = [NSMutableArray array];
    CGFloat buttonLeft = _tabContentEdgeInsets.left;
    CGFloat buttonTop = _tabContentEdgeInsets.top;
    CGFloat buttonHeight = _topHeight - _tabContentEdgeInsets.top - _tabContentEdgeInsets.bottom;
    CGFloat buttonWidth = 0;
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        if (_tabItemsBorderWidth) {
            [button setBorderWidth:_tabItemsBorderWidth borderColor:_tabItemsBorderColor];
            [button setCornerRadius:_cornerRadius];
        }
        NSString *buttonTitle = _titleArray[i];
        if (_tabItemsDistributionType == 0) {
            buttonWidth = (self.width - _tabContentEdgeInsets.left - _tabContentEdgeInsets.right) / _titleArray.count;
        }else if (_tabItemsDistributionType == 1) {
            buttonWidth = [buttonTitle calculateWidthWithFont:[UIFont systemFontOfSize:_titlesFont]] + _tabItemsContentEdgeInsets.left + _tabItemsContentEdgeInsets.right;
        }
        button.frame = CGRectMake(buttonLeft, buttonTop, buttonWidth, buttonHeight);
        buttonLeft += buttonWidth + _tabItemsSpacing;
        if (_topArray.count == _titleArray.count && _changeTopArray.count == _titleArray.count && (topTabType == 0 || topTabType == 2)) {
            UIView *customTopView = _topArray[i];
            customTopView.frame = button.bounds;
            customTopView.userInteractionEnabled = NO;
            customTopView.exclusiveTouch = NO;
            [topTabArray addObject:customTopView];
            [button addSubview:customTopView];
        }else {
            button.titleLabel.font = [UIFont systemFontOfSize:_titlesFont];
            if ([buttonTitle isKindOfClass:[NSString class]]) {
                [bottomLineWidthArray addObject:@(buttonWidth)];
                [button setTitle:buttonTitle forState:UIControlStateNormal];
                button.titleLabel.numberOfLines = 0;
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
            }else {
                NSLog(@"Your title%li not fit for topTab,please correct it to NSString!",(long)i + 1);
            }
        }
        [_topTab addSubview:button];
        [button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:button];
        if (i == 0 && (topTabType == 0 || topTabType == 2)) {
            if (_btnSelectColor) {
                [button setTitleColor:_btnSelectColor forState:UIControlStateNormal];
            }else {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            if (_titleScale > 0) {
                button.transform = CGAffineTransformMakeScale(_titleScale, _titleScale);
            }
            if (_topArray.count == _titleArray.count && _changeTopArray.count == _titleArray.count) {
                for (NSInteger i = [button.subviews count] - 1; i >= 0; i--) {
                    if ([[button.subviews objectAtIndex:i] isKindOfClass:[UIView class]]) {
                        [[button.subviews objectAtIndex:i] removeFromSuperview];
                    }
                }
                if (![button.subviews isKindOfClass:[UIView class]]) {
                    UIView *whites = _changeTopArray[0];
                    whites.frame = button.bounds;
                    whites.userInteractionEnabled = NO;
                    whites.exclusiveTouch = NO;
                    [btnArray[0] addSubview:whites];
                }
            }
        } else {
            if (_btnUnSelectColor) {
                [button setTitleColor:_btnUnSelectColor forState:UIControlStateNormal];
            }else {
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
        if (i == _titleArray.count - 1) {
            CGFloat contentW = button.right + _tabContentEdgeInsets.right;
            if (contentW < self.width && _tabsAlignmentCenter) {
                _topTab.width = contentW;
                _topTab.left = (self.width - contentW) / 2;
            }else {
                _topTab.width = self.width;
            }
            _topTab.contentSize = CGSizeMake(contentW, 0);
//            [_topTab setBorderWidth:3 borderColor:UIColor.redColor];
        }
    }
    
    //Create Toptab bottomline.
    lineBottom = [UIView new];
    lineBottom.backgroundColor = _underlineBlockColor ? : UIColorFromRGB(0xff6262);
    lineBottom.clipsToBounds = YES;
    lineBottom.userInteractionEnabled = YES;
    [_topTab addSubview:lineBottom];
    //Create ninaMaskView.
    if (topTabType == 1) {
        ninaMaskView = [[UIView alloc] initWithFrame:CGRectMake(-_tabContentEdgeInsets.left, 0, _topTab.contentSize.width, lineBottom.height)];
        ninaMaskView.backgroundColor = [UIColor clearColor];
        for (NSInteger j = 0; j < _titleArray.count; j++) {
            UIButton *button = [_topTab viewWithTag:j];
            UILabel *maskLabel = [UILabel new];
            maskLabel.frame = button.frame;
            maskLabel.top = 0;
            maskLabel.text = _titleArray[j];
            maskLabel.textColor = _btnSelectColor?_btnSelectColor:[UIColor whiteColor];
            maskLabel.numberOfLines = 0;
            maskLabel.textAlignment = NSTextAlignmentCenter;
            maskLabel.font = [UIFont systemFontOfSize:_titlesFont];
            [ninaMaskView addSubview:maskLabel];
        }
        [lineBottom addSubview:ninaMaskView];
    }
    if (topTabType == 2) {
        lineBottom.hidden = YES;
    }
}

#pragma mark - LoadData
- (void)baseViewLoadData {
//    self.topTab.frame = CGRectMake(0, 0, self.width, _topHeight);
    self.topTab.height = _topHeight;
    self.scrollView.frame = CGRectMake(0, _topHeight, self.width, self.height - _topHeight);
    [self addSubview:self.topTab];
    [self addSubview:self.scrollView];
    [self initUI];
    [self updateScrollViewUI];
}

- (void)initUI {
    NSInteger defaultPage = (_baseDefaultPage < _titleArray.count)?_baseDefaultPage:0;
    UIButton *button = [_topTab viewWithTag:defaultPage];
    if (topTabType == 0) {
        lineBottom.frame = CGRectMake(button.left, _topHeight - _bottomLineHeight, button.width, _bottomLineHeight);
    }else if (topTabType == 1) {
        lineBottom.frame = button.frame;
        if (_cornerRadius > 0) {
            lineBottom.layer.cornerRadius = _cornerRadius;
        }
    }
    if (!_topTabUnderLineHidden) {
        topTabBottomLine = [UIView new];
        topTabBottomLine.backgroundColor = UIColorFromRGB(0xcecece);
        [self addSubview:topTabBottomLine];
        topTabBottomLine.frame = CGRectMake(0, _topHeight - 1, self.width, 1);
    }
}

@end
