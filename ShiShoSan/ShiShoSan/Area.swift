//
//  Area.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/30/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase

class Area: NSObject {
    let itemRef:FIRDatabaseReference?
    var id:String?
    var name:String?
    var cities : [City] = []
    var lines : [Line] = []
    var stations : [Station] = []
    var collapsed: Bool
    
    override init() {
        self.collapsed = false
        self.itemRef = nil
    }
    
    init(_ id:String,_ name: String,_ cities: [City]) {
        self.id = id
        self.name = name
        self.cities = cities
        self.collapsed = false
        self.itemRef = nil
    }
    
    
    func saveToFirebase(){
        let mReference = FIRDatabase.database().reference().child("arena")
        let key = mReference.childByAutoId().key
        print(key)
        let values : [String:AnyObject] = ["name":self.name as AnyObject]
        mReference.child(key).updateChildValues(values)
        for city in self.cities {
            city.saveToFireBase(key)
        }
    }
}
