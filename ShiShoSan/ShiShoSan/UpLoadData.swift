//
//  UpLoadData.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 8/4/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase

class UpLoadData: UITableViewController,ExpandableHeaderViewDelegate{
    var ref : FIRDatabaseReference! = nil
    var listLine:[Line] = []
    var clicked:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference().child("lines").childByAutoId()
        //listLine = DataManagar.shared.queryAllLine()
        //let fullList = listDeleteStation.components(separatedBy: "$_$_$_$")
//        var listStation:[Station] = []
//        for i in 0 ..< fullList.count{
//            let sta = Station(fullList[i],fullList[i])
//            listStation.append(sta)
//        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return listLine.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listLine[section].stations.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (listLine[indexPath.section].collapse){
            return 50
        } else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: listLine[section].name, section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaCell", for: indexPath)
        let text = listLine[indexPath.section].stations[indexPath.row].name
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listLine[indexPath.section].listStation)
        print(listLine[indexPath.section].id)
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        listLine[section].collapse = !listLine[section].collapse
        self.tableView.beginUpdates()
        for i in 0 ..< listLine[section].stations.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        self.tableView.endUpdates()
    }
    
  
    

    
    func parseStringToListStation(_ string:String) -> [Station]{
        var mList:[Station] = []
        let fullList = string.components(separatedBy: "_")
        print(fullList.count)
        for i in 0 ..< fullList.count{
            let sta = Station(fullList[i])
            mList.append(sta)
        }
        return mList
    }

    func editString(string:String) -> String{
        var result = string.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
        result = result.replacingOccurrences(of: "", with: "")
        result = result.replacingOccurrences(of: "/", with: "")
        result = result.replacingOccurrences(of: " ", with: "")
        result = result.replacingOccurrences(of: "a", with: "")
        result = result.replacingOccurrences(of: "b", with: "")
        result = result.replacingOccurrences(of: "c", with: "")
        result = result.replacingOccurrences(of: "d", with: "")
        result = result.replacingOccurrences(of: "e", with: "")
        result = result.replacingOccurrences(of: "f", with: "")
        result = result.replacingOccurrences(of: "g", with: "")
        result = result.replacingOccurrences(of: "h", with: "")
        result = result.replacingOccurrences(of: "i", with: "")
        result = result.replacingOccurrences(of: "j", with: "")
        result = result.replacingOccurrences(of: "k", with: "")
        result = result.replacingOccurrences(of: "l", with: "")
        result = result.replacingOccurrences(of: "m", with: "")
        result = result.replacingOccurrences(of: "n", with: "")
        result = result.replacingOccurrences(of: "o", with: "")
        result = result.replacingOccurrences(of: "p", with: "")
        result = result.replacingOccurrences(of: "q", with: "")
        result = result.replacingOccurrences(of: "r", with: "")
        result = result.replacingOccurrences(of: "s", with: "")
        result = result.replacingOccurrences(of: "t", with: "")
        result = result.replacingOccurrences(of: "u", with: "")
        result = result.replacingOccurrences(of: "v", with: "")
        result = result.replacingOccurrences(of: "w", with: "")
        result = result.replacingOccurrences(of: "x", with: "")
        result = result.replacingOccurrences(of: "y", with: "")
        result = result.replacingOccurrences(of: "z", with: "")
        result = result.replacingOccurrences(of: "-", with: "")
        result = result.replacingOccurrences(of: "=", with: "")
        result = result.replacingOccurrences(of: "0", with: "")
        result = result.replacingOccurrences(of: "1", with: "")
        result = result.replacingOccurrences(of: "2", with: "")
        result = result.replacingOccurrences(of: "3", with: "")
        result = result.replacingOccurrences(of: "4", with: "")
        result = result.replacingOccurrences(of: "5", with: "")
        result = result.replacingOccurrences(of: "6", with: "")
        result = result.replacingOccurrences(of: "7", with: "")
        result = result.replacingOccurrences(of: "8", with: "")
        result = result.replacingOccurrences(of: "9", with: "")
        result = result.replacingOccurrences(of: "()", with: "_")
        result = result.replacingOccurrences(of: ")", with: "")
        result = result.replacingOccurrences(of: "(", with: "")
        return result
    }
}







