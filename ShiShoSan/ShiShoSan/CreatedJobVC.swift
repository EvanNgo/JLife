//
//  CreatedJobVC.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 8/11/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit

class CreatedJobVC: UIViewController {
    @IBOutlet weak var btnMenu: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
    }
}
