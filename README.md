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