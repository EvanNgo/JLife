//
//  EditInfoVC.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/28/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

protocol LogOutDelegate{
    func logOut()
}

class EditInfoVC: UIViewController {

    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var btnSave: UIImageView!
    
    var delegate:LogOutDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        btnBack.isUserInteractionEnabled = true
        btnSave.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let tapSave = UITapGestureRecognizer(target: self, action: #selector(saveClick))
        btnSave.addGestureRecognizer(tapSave)
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(backClick))
        btnBack.addGestureRecognizer(tapBack)
        
        if FBSDKAccessToken.current() != nil{
            btnLogOut.backgroundColor = UIColor(rgb: FB_COLOR)
        }else {
            btnLogOut.backgroundColor = UIColor(rgb: MAIN_COLOR)
        }
        

    }
    
    func backClick(){
        dismiss(animated: true, completion: nil)
    }
    
    func saveClick(){
        print("Save clicked")
    }

    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.setValue("", forKey: "image_profile")
        UserDefaults.standard.setValue("", forKey: "user_name")
        UserDefaults.standard.setValue("", forKey: "facebook_id")
        UserDefaults.standard.setValue("", forKey: "image_cover")
        self.delegate?.logOut()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
