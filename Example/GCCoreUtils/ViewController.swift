//
//  ViewController.swift
//  GCCoreUtils
//
//  Created by 1137576021@qq.com on 11/23/2021.
//  Copyright (c) 2021 1137576021@qq.com. All rights reserved.
//

import UIKit
import GCCoreUtils

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let times = [
            Timestamp.seconds(1577811600),
            Timestamp.seconds(1546275600),
            Timestamp.seconds(1199120400),
            Timestamp.seconds(2051193600),
            Timestamp.seconds(2524579200),
            Timestamp.seconds(1643558400),
            Timestamp.seconds(1633017600),
        ]
        
        let date = Timestamp.interval(Date().timeIntervalSince1970 + 3681)
        print(DateUtil.string(from: date, formatterType: .cn_yyyyMMddHHmmss))
        print(HumanizeTimeUtil.shared.shortString(for: date))
        print(HumanizeTimeUtil.shared.fullString(for: date))
        print("\n")
        
        times.forEach { time in
            print(DateUtil.string(from: time, formatterType: .cn_yyyyMMddHHmmss))
            print(HumanizeTimeUtil.shared.shortString(for: time))
            print(HumanizeTimeUtil.shared.fullString(for: time))
            print("\n")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

