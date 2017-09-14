//
//  Line.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 8/4/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase
class Line: NSObject {
    var id:String = ""
    var name:String = ""
    var stations:[Station] = []
    var listStation:String = ""
    var company:String = ""
    var areaID:String = ""
    var collapse:Bool = false
    
    init(_ id:String,_ name:String,_ company:String,_ listStation:String){
        self.id = id
        self.name = name
        self.company = company
        self.listStation = listStation
    }
    
    init(_ name:String,_ stations:[Station],_ company:String){
        self.name = name
        self.stations = stations
        self.company = company
        
    }
    init(_ name:String,_ company:String){
        self.name = name
        self.company = company
    }
    
    override init(){
        
    }
    
    func saveToFirebase(idArea:String){
        let mReference = FIRDatabase.database().reference().child("arena").child(idArea).child("lines")
        let values : [String:AnyObject] = ["name":self.name as AnyObject,"company":self.company as AnyObject,"listStation":self.listStation as AnyObject]
        mReference.childByAutoId().updateChildValues(values)
    }
    
    func updatLine(){
        let mReference = FIRDatabase.database().reference().child("lines").child(id)
        let values : [String:AnyObject] = ["sta_ids":listStation as AnyObject]
        mReference.updateChildValues(values)
    }
    func saveStationGetKey(){
        for station in self.stations {
            let key = station.saveToFireBase()
            listStation = "\(listStation)@$\(key)"
        }
        updatLine()
        print(listStation)
    }
}
