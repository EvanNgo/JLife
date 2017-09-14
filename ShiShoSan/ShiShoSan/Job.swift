//
//  Job.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 8/14/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase

class Job: NSObject {
    var id:String = ""
    var jobType = ""
    var title:String = ""
    var details:String = ""
    var jobGroup = ""
    var ortherJobGroup = ""
    var salary:String = ""
    var detailsalary:String = ""
    var time = ""
    var detailsTime = ""
    var benefit = ""
    var fee = ""
    var detailsFee = ""
    var language = ""
    var detailLanguage = ""
    
    var userID:String = ""
    var userImage:String = ""
    var userName:String = ""
    
    var locations:[String] = []
    var images:[String] = []


    override init() {
        
    }
    
    func saveToFireBase(_ viewLoad:UIView,_ viewRoot:UIView){
        let mReference = FIRDatabase.database().reference().child("job")
        let key = mReference.childByAutoId().key
        let values : [String:AnyObject] = ["jobType":self.jobType as AnyObject,
                                    "title":self.title as AnyObject,
                                    "details":self.details as AnyObject,
                                    "jobGroup":self.jobGroup as AnyObject,
                                    "ortherJobGroup":self.ortherJobGroup as AnyObject,
                                    "salary":self.salary as AnyObject,
                                    "detailsalary":self.detailsalary as AnyObject,
                                    "time":self.time as AnyObject,
                                    "detailsTime":self.detailsTime as AnyObject,
                                    "benefit":self.benefit as AnyObject,
                                    "fee":self.fee as AnyObject,
                                    "detailsFee":self.detailsFee as AnyObject,
                                    "language":self.language as AnyObject,
                                    "detailLanguage":self.detailLanguage as AnyObject,
                                    "userID":self.userID as AnyObject,
                                    "userImage":self.userImage as AnyObject,
                                    "userName":self.userName as AnyObject]
        mReference.child(key).updateChildValues(values)
        print("successfully")
        for i in 0 ..< self.locations.count {
            locations[i].saveLocationJob(key: key)
        }
        for i in 0 ..< self.images.count {
            images[i].saveImageJob(key: key)
        }
        DispatchQueue.main.async(execute: {
            viewLoad.isHidden = true
            viewRoot.isHidden = true
        })
    }
}
