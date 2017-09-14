//
//  User.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/26/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit

class User: NSObject {
    var id:String = ""
    var fb_id:String = ""
    var username:String = ""
    var profile_images_url:String = ""
    var email:String = ""
    var cover_images_url:String = ""
    override init(){
        
    }
    init(id:String,username:String,profile_images_url:String,email:String) {
        self.id = id
        self.username = username
        self.profile_images_url = profile_images_url
        self.email = email
    }
    
    init(username:String,profile_images_url:String,email:String,cover_images_url:String) {
        self.username = username
        self.profile_images_url = profile_images_url
        self.email = email
        self.cover_images_url = cover_images_url
    }
}
