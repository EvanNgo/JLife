//
//  AreaSelectorVC.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/30/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase

class AreaSelectorVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ExpandableHeaderViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnStart: UIButton!

    var listArea: [Area] = []
    var cityID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        listArea = DataManagar.shared.queryAllArea()
        btnStart.layer.cornerRadius = 5
        btnStart.clipsToBounds = true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return listArea.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listArea[section].cities.count
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (listArea[indexPath.section].collapsed){
            return 50
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: listArea[section].name!, section: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked \(indexPath.section)")
        cityID = listArea[indexPath.section].cities[indexPath.row].id!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaCell", for: indexPath)
        let text = listArea[indexPath.section].cities[indexPath.row].name
        cell.textLabel?.text = text
        cell.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        return cell
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        print("toggleSection \(section)")
        listArea[section].collapsed = !listArea[section].collapsed
        self.tableView.beginUpdates()
        for i in 0 ..< listArea[section].cities.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        self.tableView.endUpdates()
    }
    
    
    @IBAction func start(_ sender: Any) {
        if (cityID==""){
            return
        }
        UserDefaults.standard.setValue(cityID, forKey: "city_id")
        performSegue(withIdentifier: "locationPickedStartApp", sender: nil)
    }
    
}
