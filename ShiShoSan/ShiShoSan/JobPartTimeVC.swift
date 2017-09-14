//
//  JobPartTimeVC.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/29/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit

class JobPartTimeVC: UIViewController {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "アルバイト"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.init(rgb: 0xFFFFFF)]
        self.navigationController?.navigationBar.titleTextAttributes = (titleDict as! [String : Any])
    }
}
