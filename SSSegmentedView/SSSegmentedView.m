//
//  SSSegmentedView.m
//  SSSegmentedView
//
//  Created by xiaobei on 2017/7/12.
//  Copyright © 2017年 xiaobei. All rights reserved.
//

#import "SSSegmentedView.h"

#define topHeight 60
#define tabCountMax 5
#define slideHeight 6

@interface SSSegmentedView ()<UIScrollViewDelegate>

// 整个视图的大小
@property (assign, nonatomic) CGRect allFrame;

// 上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViewArray;

// 按钮个数
@property (assign, nonatomic) NSInteger tabCount;

// 上方的ScrollView
@property (weak, nonatomic) UIScrollView *topScrollView;

// 滑块View
@property (weak, nonatomic) UIView *slideView;

// 下方的ScrollView
@property (weak, nonatomic) UIScrollView *scrollView;

@end

@implementation SSSegmentedView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray viewArray:(NSArray *)viewArray{
    if(self = [super initWithFrame:frame]){
        
        _allFrame = frame;
        _topViewArray = [[NSMutableArray alloc] init];
        _tabCount = titleArray.count > viewArray.count ? viewArray.count : titleArray.count;
        
        [self initTopTabWithTitleArray:titleArray];
        
        [self initSlideView];
        
        [self initScrollViewWithViewArray:viewArray];
    }
    return self;
}


#pragma mark -- 实例化ScrollView
-(void)initScrollViewWithViewArray:(NSArray *)viewArray{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topHeight, self.allFrame.size.width, self.allFrame.size.height - topHeight)];
    self.scrollView = scrollView;
    self.scrollView.contentSize = CGSizeMake(self.allFrame.size.width * self.tabCount, self.allFrame.size.height - topHeight);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    for(int i=0; i<self.tabCount; i++){
        if([viewArray[i] class] != [UIView class]) break;
        UIView *view = viewArray[i];
        view.frame = CGRectMake(self.allFrame.size.width * i, 0, self.allFrame.size.width, self.allFrame.size.height - topHeight);
        [self.scrollView addSubview:view];
    }
}

#pragma mark -- 初始化滑动的指示View
-(void) initSlideView{
    CGFloat width = self.allFrame.size.width / tabCountMax;
    if(self.tabCount <= tabCountMax){
        width = self.allFrame.size.width / self.tabCount;
    }
    
    UIView *slideView = [[UIView alloc] initWithFrame:CGRectMake(0, topHeight - slideHeight, width, slideHeight)];
    self.slideView = slideView;
    [self.slideView setBackgroundColor:[UIColor redColor]];
    [self.topScrollView addSubview:self.slideView];
}

#pragma mark -- 实例化顶部的tab
-(void) initTopTabWithTitleArray:(NSArray *)titleArray{
    CGFloat width = self.allFrame.size.width / tabCountMax;
    if(self.tabCount <= tabCountMax){
        width = self.allFrame.size.width / self.tabCount;
    }
    
    // 上面的View
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.allFrame.size.width, topHeight)];
    [self addSubview:topView];
    // 上面的ScrollView
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.allFrame.size.width, topHeight)];
    self.topScrollView = topScrollView;
    self.topScrollView.delegate = self;
    self.topScrollView.contentSize = CGSizeMake(width * self.tabCount, topHeight);
    [topView addSubview:self.topScrollView];
    
    for (int i = 0; i < self.tabCount; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, topHeight)];
        button.tag = i;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [self.topViewArray addObject:button];
        [self.topScrollView addSubview:button];
    }
}


#pragma mark --点击顶部的按钮所触发的方法
-(void)tabButton:(UIButton *)button{
    [self.scrollView setContentOffset:CGPointMake(button.tag * self.allFrame.size.width, 0) animated:YES];
}

- (void)changecolorWithPage:(NSInteger)currentPage{
    for (int i = 0; i < self.topViewArray.count; i ++) {
        UIButton *button = self.topViewArray[i];
        
        if (i == currentPage) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
}


#pragma mark -- scrollView的代理方法
//手势滚动scrollView后的回调
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

// 按钮点击后scrollView滚动后的回调
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.scrollView]) {
        NSInteger currentPage = self.scrollView.contentOffset.x/self.allFrame.size.width;
        currentPage = self.scrollView.contentOffset.x/self.allFrame.size.width;
        [self changecolorWithPage:currentPage];
        
        [self changeTopScrollViewPost:currentPage];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.scrollView isEqual:scrollView]) {
        CGRect frame = self.slideView.frame;
        frame.origin.x = scrollView.contentOffset.x / tabCountMax;
        if (self.tabCount <= tabCountMax) {
            frame.origin.x = scrollView.contentOffset.x / self.tabCount;
        }
        self.slideView.frame = frame;
    }
}

-(void)changeTopScrollViewPost:(NSInteger)index{
    if(self.tabCount > tabCountMax){
        CGFloat width = self.slideView.frame.size.width;
        float sumStep = width * (index - tabCountMax/2);
        if(index <= tabCountMax/2) {
            sumStep = 0;
        }else if (index >= (self.tabCount - tabCountMax/2 - 1)){
            sumStep = width * (self.tabCount - tabCountMax);
        }
        
        [self.topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
    }
}


@end
