//
//  testViewController.swift
//  SSSegmentedViewExample
//
//  Created by xiaobei on 2017/8/23.
//  Copyright © 2017年 xiaobei. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(colorLiteralRed: Float(arc4random_uniform(255))/255.0, green: Float(arc4random_uniform(255))/255.0, blue: Float(arc4random_uniform(255))/255.0, alpha: 1)
    }

}
