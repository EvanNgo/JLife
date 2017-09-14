//
//  JobViewController.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 6/24/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SetAvatarDelegate {
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var btnName: UIButton!
    var arrayCellID:[String] = ["jobCell","houseCell"]
    var arrayCellName:[String] = ["Việc Làm","Nhà Đất"]
    let mainColor = UIColor(red: 115, green: 198, blue: 255, alpha: 1)
    
    @IBOutlet weak var menuTable: UITableView!
    var avatarURL = ""
    var cover = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let infoVC = UserInforVC()
        infoVC.mDelegate = self
        self.revealViewController().rearViewRevealWidth = 240
        mImage.isUserInteractionEnabled = true
        mImage.layer.cornerRadius = 5
        mImage.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLogin))
        mImage.addGestureRecognizer(tapGestureRecognizer)
        menuTable.delegate = self
        menuTable.dataSource = self
        if FIRAuth.auth()?.currentUser?.uid == nil {
            UserDefaults.standard.setValue("", forKey: "profile_images_url")
            UserDefaults.standard.setValue("", forKey: "user_name")
            UserDefaults.standard.setValue("", forKey: "image_cover")
            self.dismiss(animated: true, completion: nil)
        }
        getCurrenLogin()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: arrayCellID[indexPath.row], for: indexPath)
        
        cell.textLabel?.text = arrayCellName[indexPath.row]
        
        return cell
    }
    
    func putAvatar() {
        mImage.downloadedFrom(UserDefaults.standard.string(forKey: "profile_images_url")!, nil)
    }
    
    func getCurrenLogin(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            mImage.image = UIImage(named: "guess")
            btnName.setTitle("Đăng Nhập", for: .normal)
        }else{
            setUpLoginView((FIRAuth.auth()?.currentUser?.uid)!)
        }
    }

    func setUpLoginView(_ userID:String){
        if FBSDKAccessToken.current() != nil{
            if FBSDKAccessToken.current() != nil{
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"name,picture.type(large)"]).start{
                    (connection,mResult,error) in
                    if error != nil{
                        return
                    }
                    let dict = mResult as? [String : Any]
                    let mName = dict?["name"] as! String
                    let picture = dict?["picture"] as? [String : Any]
                    let data = picture?["data"] as? [String : Any]
                    let image = data?["url"] as! String
                    self.mImage.downloadedFrom(image,nil)
                    self.btnName.setTitle(mName, for: .normal)
                    self.btnName.sizeToFit()
                    let currentName = UserDefaults.standard.string(forKey: "user_name")
                    let currentImage = UserDefaults.standard.string(forKey: "profile_images_url")
                    
                    if mName != currentName || image != currentImage {
                        UserDefaults.standard.setValue(image, forKey: "profile_images_url")
                        UserDefaults.standard.setValue(mName, forKey: "user_name")
                        if userID != ""{
                            print(userID)
                            let userReference = FIRDatabase.database().reference().child("users").child(userID)
                            let values = ["username" : mName, "profile_images_url":image] as [String : Any]
                            userReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: {
                                (error,ref) in if error != nil{
                                    return
                                }
                            })
                        }
                    }
                    return
                }
            }
        }else {
            FIRDatabase.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let user = User()
                    user.setValuesForKeys(dictionary)
                    UserDefaults.standard.setValue(user.profile_images_url, forKey: "profile_images_url")
                    UserDefaults.standard.setValue(user.username, forKey: "user_name")
                    let imageURL = user.profile_images_url
                    if imageURL != "" {
                        self.mImage.downloadedFrom(imageURL,nil)
                    }
                    self.btnName.setTitle(user.username, for: .normal)
                    self.btnName.sizeToFit()
                    return
                }
            }, withCancel: nil)
        }
    }
    
    func putData(id: String, name: String, url: String) {
        self.mImage.downloadedFrom(url,nil)
        self.btnName.setTitle(name, for: .normal)
        self.btnName.sizeToFit()
    }
    
    func handleLogin() {
        if FIRAuth.auth()?.currentUser != nil{
            let userInfoVC = UserInforVC()
            present(userInfoVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        handleLogin()
    }
}
