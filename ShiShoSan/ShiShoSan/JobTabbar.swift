//
//  JobTabbar.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 8/2/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit

class JobTabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(rgb: MAIN_COLOR)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(rgb: 0xAEAEAE)], for: .normal)
        
        
    }
}
