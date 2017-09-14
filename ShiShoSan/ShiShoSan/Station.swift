//
//  Station.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 8/4/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase
class Station: NSObject {
    var id:String = ""
    var name:String = ""
    var areaID:String = ""
    override init() {
        
    }
    
    init(_ name:String) {
        self.name = name
    }
    
    init(_ id:String,_ name:String) {
        self.id = id
        self.name = name
    }
    
    func saveToFireBase() -> String{
        let mReference = FIRDatabase.database().reference().child("stations")
        let key = mReference.childByAutoId().key
        let values : [String:AnyObject] = ["name":self.name as AnyObject]
        mReference.child(key).updateChildValues(values)
        return key
    }
    
    func saveToFireBase(idArea:String){
        let mReference = FIRDatabase.database().reference().child("arena").child(idArea).child("stations")
        let values : [String:AnyObject] = ["name":self.name as AnyObject]
        mReference.childByAutoId().updateChildValues(values)
    }
    
    func deleteFromFireBase(){
        let mReference = FIRDatabase.database().reference().child("stations")
        mReference.child(id).removeValue()
    }
}
