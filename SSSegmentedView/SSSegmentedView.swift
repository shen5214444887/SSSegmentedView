//
//  SSSegmentedView.swift
//  SSSegmentedView
//
//  Created by xiaobei on 2017/8/23.
//  Copyright © 2017年 xiaobei. All rights reserved.
//

import UIKit

enum sliderStyle {
    /// 位置在按钮下面
    case normal
    /// 位置在文字下面
    case center
}

class SSSegmentedView: UIView, UIScrollViewDelegate {
    
    /// 视图滚动位置回调
    var viewIndex:((_ index: Int) -> ())?
    
    /// 选中当前视图位置
    var selectIndex = 0 {
        didSet {
            if selectIndex >= 0 && selectIndex < Int(subViewCount) {
                btnClick(topViewArray[selectIndex])
            } else {
                print("----当前视图位置越界")
            }
        }
    }
    
    /// 滑动指示器的样式
    var sliderStyle: sliderStyle = .normal
    
    /// 视图标题数组
    var titles = [String]()
    
    /// 视图数组
    var contentViews = [UIView]()
    
    /// 标题视图高度
    var topHeight: CGFloat = 50 {
        didSet {
            var frame = scrollView.frame
            frame.origin.y = topHeight
            frame.size.height = self.frame.size.height - topHeight
            scrollView.frame = frame
            topScrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: topHeight)
            if topHeight > 0 {
                setupTitles()
            }
        }
    }
    /// 滑动指示器高度
    var slideHeight: CGFloat = 2
    /// 底部分割线高度
    var lineHeight: CGFloat = 1
    /// 标题按钮左右两边的距离
    var titleMargin: CGFloat = 10
    
    /// 标题按钮字体
    var titleFont: UIFont = UIFont.systemFont(ofSize: 17)
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
    var isScrollEnabled = true {
        didSet {
            scrollView.isScrollEnabled = isScrollEnabled
        }
    }
    /// 是否显示底部分割线
    var isShowBottomLine = false
    /// 是否使用弹簧效果
    var isBounces = false
    
    /// 初始化方法
    convenience init(frame: CGRect, titles: [String], contentViews: [UIView], sliderStyle: sliderStyle = .normal) {
        self.init(frame: frame)
        
        self.titles = titles
        self.contentViews = contentViews
        self.sliderStyle = sliderStyle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    // TODO: - 设置UI
    private func setupUI() {
        subViewCount = CGFloat(titles.count > contentViews.count ? contentViews.count : titles.count)
        
        if subViewCount == 0 {
            print("----视图或者标题为0!!!")
            return
        }
        
        setupTitles()
        setupContenViews()
        changeBtnState(index: selectIndex)
        changeTopScollViewPoint(index: selectIndex)
        scrollView.setContentOffset(CGPoint(x: CGFloat(selectIndex) * bounds.width, y: 0), animated: false)
    }
    
    /// 设置滚动主视图
    private func setupContenViews() {
        scrollView.frame = CGRect(x: 0, y: topHeight, width: bounds.width, height: bounds.height - topHeight)
        scrollView.contentSize = CGSize(width: bounds.width * subViewCount, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = isScrollEnabled
        scrollView.bounces = isBounces
        scrollView.delegate = self
        addSubview(scrollView)
        
        for i in 0..<Int(subViewCount) {
            let v = contentViews[i]
            v.frame = CGRect(x: bounds.width * CGFloat(i), y: 0, width: bounds.width, height: scrollView.frame.height)
            scrollView.addSubview(v)
        }
    }
    
    
    /// 设置滑动指示View
    private func setupSlideView() {
        // 底部分割线
        if isShowBottomLine {
            let bottomView = UIView(frame: CGRect(x: 0, y: topScrollView.bounds.height - lineHeight, width: frame.width, height: lineHeight))
            bottomView.backgroundColor = linColor
            addSubview(bottomView)
        }
        
        // 滑动指示器初始化的宽
        let width = self.titleWidthArray[selectIndex]
        // 滑动指示器
        var x: CGFloat = 0
        for i in 0..<selectIndex {
            x += self.titleWidthArray[i]
        }
        x = x + self.titleMargin
        let slideFrame = CGRect(x: x, y: topScrollView.bounds.height - slideHeight, width: width - self.titleMargin * 2, height: slideHeight)
        slideView.removeFromSuperview()
        slideView = UIView(frame: slideFrame)
        slideView.backgroundColor = slideColor
        topScrollView.addSubview(slideView)
        
        if sliderStyle == .center {
            let rect = titles[0].ss_size(withFont: titleFont)
            slideView.frame.origin.y = (topHeight + rect.height) * 0.6
        }
    }
    
    /// 设置标题视图
    private func setupTitles() {
        self.titleWidthArray.removeAll()
        var allWidth: CGFloat = 0
        for title in titles {
            let width = title.ss_size(withFont: titleFont).width + self.titleMargin * 2
            self.titleWidthArray.append(width)
            allWidth += width
        }
        self.titleAllWidth = allWidth
        
        topScrollView.removeFromSuperview()
        topScrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: topHeight)
        topScrollView.clipsToBounds = true
        topScrollView.delegate = self
        topScrollView.bounces = isBounces;
        topScrollView.showsVerticalScrollIndicator = false
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.contentSize = CGSize(width: allWidth, height: 0)
        addSubview(topScrollView)
        
        _ = topScrollView.subviews.map { $0.removeFromSuperview() }
        var x: CGFloat = 0
        for i in 0..<Int(subViewCount) {
            let btn = UIButton(frame: CGRect(x: x, y: 0, width: self.titleWidthArray[i], height: topHeight))
            btn.tag = i
            btn.setTitle(titles[i], for: .normal)
            btn.setTitleColor(titleNomalColor, for: .normal)
            btn.titleLabel?.font = titleFont
            btn.titleLabel?.textAlignment = .center
            btn.backgroundColor = titleBackgroundColor
            btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            x += self.titleWidthArray[i]
            
            topScrollView.addSubview(btn)
            topViewArray.append(btn)
        }
        
        setupSlideView()
    }
    
    /// 子视图个数
    private var subViewCount: CGFloat = 0
    /// 顶部滚动视图
    private var topScrollView = UIScrollView()
    /// 所有的按钮数组
    private var topViewArray = [UIButton]()
    /// 所有的按钮标题宽度数组
    private var titleWidthArray = [CGFloat]()
    /// 标题数组的最大宽度
    private var titleAllWidth: CGFloat = 0
    /// 滑动指示器
    private var slideView = UIView()
    /// 主视图
    private var scrollView = UIScrollView()
    
    // MARK: - 点击事件
    @objc private func btnClick(_ btn: UIButton) {
        if selectIndex == btn.tag {
            return
        }
        
        scrollView.setContentOffset(CGPoint(x: CGFloat(btn.tag) * bounds.width, y: 0), animated: true)
    }
    
    /// 改变按钮的状态
    private func changeBtnState(index: Int) {
        for i in 0..<topViewArray.count {
            let btn = topViewArray[i]
            
            if i == index {
                btn.setTitleColor(titleSelectColor, for: .normal)
            } else {
                btn.setTitleColor(titleNomalColor, for: .normal)
            }
        }
    }
    
    /// 改变标题 ScrollView 滚动位置
    private func changeTopScollViewPoint(index: Int) {
        if self.titleAllWidth <= self.bounds.width {
            return
        }
        
        var x: CGFloat = 0
        for i in 0..<index {
            x += self.titleWidthArray[i]
        }
        x += self.titleWidthArray[index] * 0.5 // 滚动到中间
        if x > self.bounds.width * 0.5 {
            var offsetx = x - self.bounds.width * 0.5
            if x > (self.titleAllWidth - self.bounds.width * 0.5) { // 避免滚动过头
                offsetx = self.titleAllWidth - self.bounds.width
            }
            self.topScrollView.setContentOffset(CGPoint(x: offsetx, y: 0), animated: true)
        } else {
            self.topScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    // TODO: - UIScrollViewDelegate
    /// 手势滚动 scrollView 的回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    /// 按钮点击后 scrollView 滚动后的回调
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.isEqual(self.scrollView) {
            // 加0.5防止不到1
            let index = Int(scrollView.contentOffset.x / bounds.width + 0.5)
            if index != selectIndex {
                selectIndex = index
                var x: CGFloat = 0
                for i in 0..<index {
                    x += self.titleWidthArray[i]
                }
                
                var f: CGRect = self.slideView.frame
                f.origin.x = x + self.titleMargin
                f.size.width = self.titleWidthArray[index] - self.titleMargin * 2
                self.slideView.frame = f
                
                viewIndex?(selectIndex)
                
                changeBtnState(index: selectIndex)
                
                changeTopScollViewPoint(index: selectIndex)
            }
            
        }
    }
    
    /// 滑动指示器滚动位置
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        if scrollView == self.scrollView {
        //            var frame = slideView.frame
        //            let index = scrollView.contentOffset.x / self.bounds.width
        //            GMLog("--index: \(index),--selectIndex:\(selectIndex)")
        //            if index > CGFloat(selectIndex) { // 往右边跑
        //                let sWidth = (self.titleWidthArray[selectIndex] + self.titleWidthArray[selectIndex + 1]) * 0.5
        //                let x = self.tempSlideFrame.origin.x + (index - CGFloat(selectIndex)) * sWidth
        //                frame.origin.x = x
        //                self.slideView.frame = frame
        //            } else { // 往左边跑
        //
        //            }
        //            frame.origin.x = scrollView.contentOffset.x / count
        //            slideView.frame = frame
        //        }
    }
}

extension String {
    
    /// 根据字体计算尺寸
    func ss_size(withFont font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: attributes)
    }
}

