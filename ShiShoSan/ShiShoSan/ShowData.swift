//
//  ShowData.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 8/6/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase

class ShowData: UITableViewController {
    var listStations:[Station] = []
    var listLine:[Line] = []
    var mList:[Station] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
//        listStations = DataManagar.shared.querryAllStation()
//        var mList = DataManagar.shared.querryAllStation()
//        while mList.count > 0 {
//            var have:Bool = false
//            let sta = mList[0]
//            mList.remove(at: 0)
//            var j = 0
//            while mList.count > j {
//                if sta.name == mList[j].name {
//                    listStations.append(mList[j])
//                    mList.remove(at: j)
//                    have = true
//                    
//                }else{
//                    j += 1
//                }
//            }
//            if have {
//                listStations.append(sta)
//            }
//        }
//        listStations = listStations.sorted(by: { $0.name > $1.name })
//        listLine = DataManagar.shared.querryLine()
//        var stringCode = ""
//        while listStations.count > 0 {
//            let mStation = listStations[0]
////            stringCode = "\(stringCode)@@@@@\(mStation.id)"
//            listStations.remove(at: 0)
//            var i = 0
//            while listStations.count > i {
//                if mStation.name == listStations[0].name{
//                    stringCode = "\(stringCode)$_$_$_$\(listStations[0].id)"
//                    for i in 0 ..< listLine.count{
//                        listLine[i].listStation = listLine[i].listStation.replacingOccurrences(of: listStations[0].id, with: mStation.id)
//                    }
//                    listStations.remove(at: 0)
//                }else{
//                    i = listStations.count + 1
//                }
//                
//            }
//        }
//        for i in 0 ..< listLine.count{
//            _ = DataManagar.shared.updateLine(newLine: listLine[i])
//        }
//        print(stringCode)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = listStations[indexPath.row].name

        return cell
    }
    @IBAction func click(_ sender: Any) {
//        while mList.count > 0 {
//            var have:Bool = false
//            let sta = mList[0]
//            mList.remove(at: 0)
//            var j = 0
//            while mList.count > j {
//                if sta.name == mList[j].name {
//                    listStations.append(mList[j])
//                    mList.remove(at: j)
//                    have = true
//                }else{
//                    j += 1
//                        }
//                    }
//                if have {
//                listStations.append(sta)
//            }
//        }
//        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadData(){
        let ref = FIRDatabase.database().reference().child("arena").child("-KqFSMwA2mO-7mozdpf_").child("stations")
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            print(dictionary)
            let station = Station()
            station.id = snapshot.key
            station.name = dictionary["name"] as! String
            self.mList.append(station)
            DispatchQueue.main.async(execute: {
                self.mList = self.mList.sorted(by: { $0.name > $1.name })
            })
        })
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("id \(listStations[indexPath.row].id)")
    }
}

