//
//  ViewController.swift
//  SSSegmentedViewExample
//
//  Created by xiaobei on 2017/8/23.
//  Copyright © 2017年 xiaobei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contentViews = [UIView]()
        let titles = ["标题1", "标题11", "标题111", "标题1111", "标题11111"]
        for _ in 0..<titles.count {
            let vc = testViewController()
            addChildViewController(vc)
            contentViews.append(vc.view)
        }
        
        let frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height)
        let segmentView = SSSegmentedView(frame: frame, titles: titles, contentViews: contentViews)
        segmentView.backgroundColor = UIColor.white
        segmentView.sliderStyle = .center
        segmentView.isShowBottomLine = false
        segmentView.viewIndex = { index in
            print("----滚动位置\(index)")
        }
        
        view.addSubview(segmentView)
        segmentView.selectIndex = 2
        segmentView.topHeight = 100
    }

}

