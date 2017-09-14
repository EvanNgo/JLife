//
//  FuDouSanViewController.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 6/24/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit

class HousingViewController: UIViewController {
    let blankView = UIView()
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor(rgb: MAIN_COLOR)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBlackView(){
        if let window = UIApplication.shared.keyWindow {
            blankView.backgroundColor = UIColor(white:0 , alpha:0.7)
            window.addSubview(blankView)
            blankView.frame = window.frame
            blankView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {self.blankView.alpha = 1})
        }
    }

}
