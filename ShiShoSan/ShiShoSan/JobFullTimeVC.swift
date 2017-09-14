//
//  JobFullTimeVC.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/29/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit

class JobFullTimeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var viewSort: UIView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "仕事"

        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.init(rgb: 0xFFFFFF)]
        self.navigationController?.navigationBar.titleTextAttributes = (titleDict as! [String : Any])
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("JobPartTimeCell", owner: self, options: nil)?.first as! JobPartTimeCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //indexPath.row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = Bundle.main.loadNibNamed("JobPartTimeCell", owner: self, options: nil)?.first as! JobPartTimeCell
        let titleHeight = cell.lblTitle.bounds.height
        return 228-20.5+titleHeight
    }

    @IBAction func createAction(_ sender: Any) {
    }
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sortHandle(){
        
    }
    
    func filterHandle(){
        
    }
}
