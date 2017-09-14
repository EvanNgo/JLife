//
//  UserInforVC.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/28/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase


protocol SetAvatarDelegate {
    func putAvatar()
}
protocol UserLogOutDelegate {
    func userLogOut()
}

class UserInforVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var editedImage:UIImage? = nil
    var imageURL = ""
    var name = ""
    var coverURL = ""
    var setTo = "profile_images"
    var linkName = ""
    
    var delegate:UserLogOutDelegate? = nil
    var mDelegate:SetAvatarDelegate? = nil
    
    let imageCover:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        return img
    }()
    
    let viewBlank:UIView = {
       let view = UIView()
        view.alpha = 0.5
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageAvatar:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 5
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        return img
    }()
    
    let imageEdit:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 5
        img.clipsToBounds = true
        img.backgroundColor = UIColor.init(rgb: FB_COLOR)
        return img
    }()
    
    let imageBack:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "btn_back")

        return img
    }()
    
    let imageLogout:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icon_logout")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let lbName:UILabel = {
        let lb = UILabel()
        lb.text = "Evan Ngô"
        lb.textColor = UIColor.white
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "profile_images_url") == nil || (UserDefaults.standard.string(forKey: "profile_images_url") == "") {
            imageAvatar.image = UIImage(named: "icon_app")
        }else{
            imageAvatar.downloadedFrom(UserDefaults.standard.string(forKey: "profile_images_url")!, nil)
        }
        if UserDefaults.standard.string(forKey: "cover_images_url") == nil || (UserDefaults.standard.string(forKey: "cover_images_url") == "") {
            imageCover.image = UIImage(named: "cover_photo")
        }else{
            imageCover.downloadedFrom(UserDefaults.standard.string(forKey: "cover_images_url")!, nil)
        }
        
        view.backgroundColor = UIColor.white
        view.addSubview(imageCover)
        view.addSubview(viewBlank)
        view.addSubview(imageAvatar)
        view.addSubview(lbName)
        view.addSubview(imageBack)
        
        setImageCover()
        setupBlankView()
        setAvatar()
        setupLabelName()
        setUpBack()
        
        handles()
    }
    
    func handles(){
        imageCover.isUserInteractionEnabled = true
        let tapCover = UITapGestureRecognizer(target: self, action: #selector(handleCover))
        imageCover.addGestureRecognizer(tapCover)
        
        imageAvatar.isUserInteractionEnabled = true
        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(handleAvatar))
        imageAvatar.addGestureRecognizer(tapAvatar)
        
        imageEdit.isUserInteractionEnabled = true
        let tapEdit = UITapGestureRecognizer(target: self, action: #selector(handleEdit))
        imageEdit.addGestureRecognizer(tapEdit)
        
        imageLogout.isUserInteractionEnabled = true
        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(handleLogout))
        imageLogout.addGestureRecognizer(tapLogout)
        
        imageBack.isUserInteractionEnabled = true
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(handleBack))
        imageBack.addGestureRecognizer(tapBack)
    }
    
    func handleCover(){
        setTo = "cover_images"
        linkName = "cover_images_url"
        startPicker()
    }
    
    func handleAvatar(){
        setTo = "profile_images"
        linkName = "profile_images_url"
        startPicker()
    }
    
    func handleEdit(){
        print("Edit clicked")
    }
    
    func handleBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleLogout(){
        let alert = UIAlertController(title: "Chú ý", message: "Bạn có chắc muốn thoát khỏi ứng dụng không?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { (action: UIAlertAction!) in
            if let _ = UIApplication.topViewController()  {
                if FIRAuth.auth()?.currentUser != nil{
                    try! FIRAuth.auth()?.signOut()
                    if FBSDKAccessToken.current() != nil{
                        print("Log out FB")
                        let loginManager = FBSDKLoginManager()
                        loginManager.logOut()
                        FBSDKAccessToken.setCurrent(nil)
                        FBSDKProfile.setCurrent(nil)
                    }
                    UserDefaults.standard.setValue("", forKey: "profile_images_url")
                    UserDefaults.standard.setValue("", forKey: "user_name")
                    UserDefaults.standard.setValue("", forKey: "facebook_id")

                }
                let loginVC = LoginViewController()
                self.present(loginVC, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setUpLoginView(){
        if FBSDKAccessToken.current() != nil{
            if FBSDKAccessToken.current() != nil{
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,picture.type(large)"]).start{
                    (connection,mResult,error) in
                    if error != nil{
                        print("Facebook login Faild 2",error ?? "")
                        return
                    }
                    let dict = mResult as? [String : Any]
                    let id = dict?["id"] as! String
                    UserDefaults.standard.setValue(id, forKey: "facebook_id")
                    let mName = dict?["name"] as! String
                    let picture = dict?["picture"] as? [String : Any]
                    let data = picture?["data"] as? [String : Any]
                    let image = data?["url"] as! String
                    self.imageAvatar.downloadedFrom(image,nil)
                    self.lbName.text = mName
                    self.lbName.sizeToFit()
                    return
                }
            }
        }else {
            imageCover.isUserInteractionEnabled = true
            imageAvatar.isUserInteractionEnabled = true
            let imageURL = UserDefaults.standard.string(forKey: "profile_images_url")!
            self.imageAvatar.downloadedFrom(imageURL,nil)
            self.lbName.text = UserDefaults.standard.string(forKey: "user_name")
            self.lbName.sizeToFit()
        }
    }
    
    func startPicker(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker,animated:true,completion:nil)
    }
    
    
    
    func saveImage(){
        var mURL = ""
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child(setTo).child("\(imageName).png")
        mURL = "\(imageName).png"
        if let uploadData = UIImagePNGRepresentation(editedImage!) {
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    if self.setTo == "profile_images"{
                        mURL = UserDefaults.standard.string(forKey: "profile_images_url")!
                        UserDefaults.standard.setValue(profileImageUrl, forKey: "profile_images_url")
                    }else{
                        mURL = UserDefaults.standard.string(forKey: "cover_images_url")!
                        UserDefaults.standard.setValue(profileImageUrl, forKey: "cover_images_url")
                    }
                    let values = [self.linkName: profileImageUrl]
                    let ref = FIRDatabase.database().reference()
                    let userID = FIRAuth.auth()?.currentUser?.uid
                    let usersReference = ref.child("users").child(userID!)
                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print(err)
                            return
                        }
                    })
                    DispatchQueue.main.async(execute: {
                        if mURL != ""{
                            let imageRef = FIRStorage.storage().reference(forURL: mURL)
                            imageRef.delete { (error) in
                                if error != nil {
                                    print("Delete file error\(String(describing: error))")
                                } else {
                                    print("Delete file success")
                                }
                                
                            }
                        }
                    })
                }
            })
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("imagePickerController \(self.setTo)")
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            print(editedImage.size)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            print(originalImage.size)
            selectedImageFromPicker = originalImage
        }
        
        if self.setTo=="profile_images"{
            self.editedImage = (selectedImageFromPicker?.setAvatar())!
            self.imageAvatar.image = editedImage
        }else{
            self.editedImage = (selectedImageFromPicker?.setCoverImage())!
            imageCover.image = editedImage
        }
        saveImage()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func setAvatar(){
        imageAvatar.leftAnchor.constraint(equalTo: view.leftAnchor, constant:12).isActive = true
        imageAvatar.bottomAnchor.constraint(equalTo: imageCover.bottomAnchor, constant: -12).isActive = true
        imageAvatar.widthAnchor.constraint(equalTo: imageCover.heightAnchor, multiplier: 2/5).isActive = true
        imageAvatar.heightAnchor.constraint(equalTo: imageCover.heightAnchor, multiplier: 2/5).isActive = true
    }
    
    func setImageCover(){
        imageCover.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageCover.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageCover.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageCover.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5).isActive = true
    }
    
    func setupBlankView(){
        viewBlank.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewBlank.bottomAnchor.constraint(equalTo: imageCover.bottomAnchor).isActive = true
        viewBlank.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        viewBlank.heightAnchor.constraint(equalTo: imageAvatar.heightAnchor, multiplier: 3/5).isActive = true
        viewBlank.addSubview(imageLogout)
        
        imageLogout.rightAnchor.constraint(equalTo: viewBlank.rightAnchor,constant: -12).isActive = true
        imageLogout.centerYAnchor.constraint(equalTo: viewBlank.centerYAnchor).isActive = true
        imageLogout.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageLogout.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    func setupLabelName(){
        lbName.leftAnchor.constraint(equalTo: imageAvatar.rightAnchor, constant: 8).isActive = true
        lbName.topAnchor.constraint(equalTo: viewBlank.topAnchor, constant: 4).isActive = true
    }
    
    func setUpBack(){
        imageBack.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 12).isActive = true
        imageBack.topAnchor.constraint(equalTo: view.topAnchor,constant: 25).isActive = true
        imageBack.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageBack.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    
}
