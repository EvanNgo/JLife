//
//  City.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/30/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase

class City: NSObject {
    var id:String?
    var name:String?
    var areaID:String?
    var listLines:String?
    init(_ id:String,_ name: String) {
        self.id = id
        self.name = name
    }
    init(_ id:String,_ name: String,_ areaID:String) {
        self.id = id
        self.name = name
        self.areaID = areaID
    }
    override init(){
        
    }
    func saveToFireBase(_ key:String){
        let mReference = FIRDatabase.database().reference().child("arena").child(key).child("cities")
        let values : [String:AnyObject] = ["name":self.name as AnyObject]
        mReference.childByAutoId().updateChildValues(values)
    }
    
    func updateToFireBase(){
        let mReference = FIRDatabase.database().reference().child("arena").child(areaID!).child("cities").child(id!)
        let values : [String:AnyObject] = ["listLines":self.listLines as AnyObject]
        mReference.updateChildValues(values)
    }
}
