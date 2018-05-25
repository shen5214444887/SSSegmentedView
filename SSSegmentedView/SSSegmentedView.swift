//
//  SSSegmentedView.swift
//  SSSegmentedView
//
//  Created by xiaobei on 2017/8/23.
//  Copyright © 2017年 xiaobei. All rights reserved.
//

import UIKit

enum sliderStyle {
    case normal // 宽度与按钮相同，位置在按钮下面
    case center // 宽度与文字相同，位置在文字下面
}

class SSSegmentedView: UIView, UIScrollViewDelegate {
    
    /// 视图滚动位置回调
    var viewIndex:((_ index: Int) -> ())?
    
    /// 选中当前视图位置
    var selectIndex = 0 {
        didSet {
            if selectIndex >= 0 && selectIndex < Int(subViewCount) {
                btnClick(btn: topViewArray[selectIndex])
            } else {
                print("----当前视图位置越界")
            }
        }
    }
    
    /// 滑动指示器的样式
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
        
        changeBtnState(index: 0)
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
    private func setupSlideView(width: CGFloat) {
        // 底部分割线
        if isShowBottomLine {
            let bottomView = UIView(frame: CGRect(x: 0, y: topScrollView.bounds.height - lineHeight, width: frame.width, height: lineHeight))
            bottomView.backgroundColor = linColor
            addSubview(bottomView)
        }
        
        // 滑动指示器
        slideView = UIView(frame: CGRect(x: 0, y: topScrollView.bounds.height - slideHeight, width: width, height: slideHeight))
        slideView.backgroundColor = slideColor
        topScrollView.addSubview(slideView)
        
        if sliderStyle == .center {
            let attr = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: titleFontSize)]
            let rect = titles[0].size(withAttributes: attr)
            let x = (width - rect.width) * 0.5
            let v = UIView(frame: CGRect(x: x, y: 0, width: rect.width, height: slideHeight))
            v.backgroundColor = slideColor
            
            slideView.frame.origin.y = (topHeight + rect.height) * 0.6
            slideView.backgroundColor = UIColor.clear
            slideView.addSubview(v)
        }
    }
    
    /// 设置标题视图
    private func setupTitles() {
        var width = frame.width / subViewCountMax
        if subViewCount < subViewCountMax {
            width = frame.width / subViewCount
        }
        
        topScrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: topHeight)
        topScrollView.delegate = self
        topScrollView.bounces = isBounces;
        topScrollView.showsVerticalScrollIndicator = false
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.contentSize = CGSize(width: width * subViewCount, height: 0)
        addSubview(topScrollView)
        
        for i in 0..<Int(subViewCount) {
            let btn = UIButton(frame: CGRect(x: CGFloat(i) * width, y: 0, width: width, height: topHeight))
            btn.tag = i
            btn.setTitle(titles[i], for: .normal)
            btn.setTitleColor(titleNomalColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize)
            btn.titleLabel?.textAlignment = .center
            btn.backgroundColor = titleBackgroundColor
            btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            
            topScrollView.addSubview(btn)
            topViewArray.append(btn)
        }
        
        setupSlideView(width: width)
    }
    
    /// 子视图个数
    private var subViewCount: CGFloat = 0
    /// 顶部滚动视图
    private var topScrollView = UIScrollView()
    /// 所有的按钮数组
    private var topViewArray = [UIButton]()
    /// 滑动指示器
    private var slideView = UIView()
    /// 主视图
    private var scrollView = UIScrollView()
    /// 当前视图的位置
    private var currentIndex = 0
    
    // MARK: - 点击事件
    @objc private func btnClick(btn: UIButton) {
        if currentIndex == btn.tag {
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
        if self.subViewCount > subViewCountMax {
            let width = slideView.bounds.width
            var sumStep = width * (CGFloat(index) - subViewCountMax / 2)
            
            if (CGFloat(index) <= subViewCountMax / 2) {
                sumStep = 0
            } else if (CGFloat(index) >= (subViewCount - subViewCountMax/2 - 1)) {
                sumStep = width * (subViewCount - subViewCountMax)
            }
            
            topScrollView.setContentOffset(CGPoint(x: sumStep, y: 0), animated: true)
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
            let index = Int(scrollView.contentOffset.x / bounds.width)
            if index != currentIndex {
                currentIndex = index
                
                viewIndex?(index)
                
                changeBtnState(index: index)
                
                changeTopScollViewPoint(index: index)
            }
            
        }
    }
    
    /// 滑动指示器滚动位置
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            var frame = slideView.frame
            let count = subViewCount > subViewCountMax ? subViewCountMax : subViewCount
            
            frame.origin.x = scrollView.contentOffset.x / count
            slideView.frame = frame
        }
    }
}


