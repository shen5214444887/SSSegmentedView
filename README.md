##UC头条，今日头条，百思不得姐的分段滚动视图

- 效果图

![SSSegmentedView
](https://github.com/shen5214444887/SSSegmentedView/blob/master/%E7%A4%BA%E4%BE%8B%E5%9B%BE%E7%89%87.gif?raw=true)

----

### 实现功能
- 视图切换后闭包回调
- 主动选中及滚动到某个界面
- 可以更改标题样式

----
##使用方法
- 将SSSegmentedView文件夹直接拖到项目中

##直接上代码
```SWift
	let count = 7
   	let frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height)
	var contentViews = [UIView]()
	var titles = [String]()
	for i in 0..<count {
		let vc = testViewController()
		addChildViewController(vc)
		contentViews.append(vc.view)
            
		titles.append("标题\(i)")
	}
        
	let segmentView = SSSegmentedView(frame: frame, titles: titles, contentViews: contentViews)
	segmentView.viewIndex = {index in
		print("----滚动位置\(index)")
	}
        
	view.addSubview(segmentView)
```

----

###标题样式自定义
	/// 滑动指示器的样式，(normal, center)两种样式
    var sliderStyle: sliderStyle = .normal
    
    /// 最大标题数，超过此值，标题视图就会滚动
    var subViewCountMax: CGFloat = 5

    /// 视图标题数组
    var titles = [String]()
    
    /// 视图数组
    var contentViews = [UIView]()
    
    /// 标题视图高度
    var topHeight: CGFloat = 50
    /// 滑动指示器高度
    var slideHeight: CGFloat = 2
    /// 底部分割线高度
    var lineHeight: CGFloat = 1
    
    /// 标题按钮字体大小
    var titleFontSize: CGFloat = 17
    /// 标题按钮背景颜色（普通状态）
    var titleBackgroundColor = UIColor.white
    /// 标题按钮背景颜色（选中状态）
    var titleSelectBackgroundColor = UIColor.white
    /// 标题按钮字体颜色（普通状态）
    var titleNomalColor = UIColor.lightGray
    /// 标题按钮字体颜色（选中状态）
    var titleSelectColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    /// 滑动指示器颜色
    var slideColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    /// 底部分割线颜色
    var linColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    /// 是否允许手势滚动
    var isScrollEnabled = true
    /// 是否显示底部分割线
    var isShowBottomLine = true
    /// 是否使用弹簧效果
    var isBounces = false

###视图切换后闭包回调
```Swift
	segmentView.viewIndex = {index in
		print("----滚动位置\(index)")
	}
```
###主动选中及滚动到某个界面
```Swift
	segmentView.selectedIndex = 1 // 选中第2个视图
```

----

###更新记录
- 2.0 Swift重写 
- 1.0 OC基本功能实现