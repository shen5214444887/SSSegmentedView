//
//  ViewController.m
//  SSSegmentedViewExample
//
//  Created by xiaobei on 2017/7/12.
//  Copyright © 2017年 xiaobei. All rights reserved.
//

#import "ViewController.h"
#import "SSTestViewController.h"
#import "SSSegmentedView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUI];
}

- (void)setUI{
    NSInteger count = 8;
    NSMutableArray *titleArray = [NSMutableArray array];
    for(int i=0; i<count; i++){
        [titleArray addObject:[NSString stringWithFormat:@"按钮%d",i]];
    }
    NSMutableArray *viewArray = [NSMutableArray array];
    for(int i=0; i<count; i++){
        UIViewController *VC = [[SSTestViewController alloc] init];
        // 这里讲控制器的view添加到当前控制器里
        [self addChildViewController:VC];
        [viewArray addObject:VC.view];
    }
    
    SSSegmentedView *segmentedView = [[SSSegmentedView alloc] initWithFrame:CGRectMake(0, 100, 320, 320) titleArray:titleArray viewArray:viewArray];
    [self.view addSubview:segmentedView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
