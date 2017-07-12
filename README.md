#UC头条，今日头条，百思不得姐的标题导航栏

- 将需要添加的控制器的view直接添加到viewArray里即可显示
- 效果图，放一张图片上去感受一下即可

![SSSegmentedView
](https://github.com/shen5214444887/SSSegmentedView/blob/master/Screenshot.PNG?raw=true)

----
#使用方法
- 将SSSegmentedView文件夹直接拖到项目中

#直接上代码
```
	NSInteger count = 8;
    NSMutableArray *titleArray = [NSMutableArray array];
    for(int i=0; i<count; i++){
        [titleArray addObject:[NSString stringWithFormat:@"按钮%d",i]];
    }
    NSMutableArray *viewArray = [NSMutableArray array];
    for(int i=0; i<count; i++){
        UIViewController *VC = [[SSTestViewController alloc] init];
        [self addChildViewController:VC];
        [viewArray addObject:VC.view];
    }
    
    SSSegmentedView *segmentedView = [[SSSegmentedView alloc] initWithFrame:CGRectMake(0, 100, 320, 320) titleArray:titleArray viewArray:viewArray];
    [self.view addSubview:segmentedView];
```
