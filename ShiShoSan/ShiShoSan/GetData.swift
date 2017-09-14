//
//  GetData.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 8/8/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit

class GetData: UIViewController {

    @IBOutlet weak var tfHTML: UITextField!
    
    @IBOutlet weak var tfCompany: UITextField!
    @IBOutlet weak var tfIDCity: UITextField!
    @IBOutlet weak var tfIDVung: UITextField!
    @IBOutlet weak var tfLine: UITextField!
    var line = Line()
    var listSta:[String] = []
    var stations:[Station] = []
    var editedString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tfIDVung.text = "-KqFSMwA2mO-7mozdpf_"
        
        
    }
    
    
    @IBAction func actionUpload(_ sender: Any) {
        let city = City()
        city.areaID = tfIDVung.text
        city.id = tfIDCity.text
        city.listLines = editedString
        city.updateToFireBase()
        editedString = ""
        tfIDCity.text = ""
        
    }
    @IBAction func actionParsse(_ sender: Any) {
        if editedString == "" {
            editedString = (editString(string: tfHTML.text!))
        }else{
            editedString = "\(editedString)\(editString(string: tfHTML.text!))"
        }
        tfHTML.text = ""
        print(editedString)
        listSta = parseString(editedString)
        print(listSta.count)
    }
    
    func parseString(_ string:String) -> [String]{
        var mList:[String] = []
        let fullList = string.components(separatedBy: "_")
        for i in 0 ..< fullList.count{
            mList.append(fullList[i])
        }
        return mList
    }
    @IBAction func showTable(_ sender: Any) {
        //self.performSegue(withIdentifier: "showTable", sender: nil)
    }
    
    func editString(string:String) -> String{
        var result = string.replacingOccurrences(of: "\t", with: "", options: .regularExpression)
        result = result.replacingOccurrences(of: "\"", with: "")
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
        result = result.replacingOccurrences(of: "[]", with: "")
        result = result.replacingOccurrences(of: "<", with: "")
        result = result.replacingOccurrences(of: ">", with: "")
        return result
    }
    
    //parse line and station
    
//    @IBAction func actionUpload(_ sender: Any) {
//        let fullList = editedString.components(separatedBy: "_")
//        for i in 0 ..< fullList.count{
//            var have = false
//            for var j in 0 ..< listSta.count{
//                if listSta[j] == fullList[i] {
//                    have = true
//                    j = listSta.count + 1
//                }
//            }
//            if !have{
//                listSta.append(fullList[i])
//                stations.append(Station(fullList[i]))
//            }
//        }
//        let areaID = tfIDVung.text!
//        line.saveToFirebase(idArea: areaID)
//        for i in 0 ..< stations.count{
//            stations[i].saveToFireBase(idArea: areaID)
//        }
//        tfHTML.text = ""
//        tfLine.text = ""
//        
//    }
//    @IBAction func actionParsse(_ sender: Any) {
//        stations.removeAll()
//        editedString = editString(string: tfHTML.text!)
//        tfHTML.text = editedString
//        line.name = tfLine.text!
//        line.company = tfCompany.text!
//        line.listStation = editedString
//        print(listSta.count)
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
