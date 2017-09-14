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
import GoogleSignIn


protocol SetAvatarDelegate {
    func putAvatar()
}
protocol UserLogOutDelegate {
    func userLogOut()
}

class UserInforVC: UIViewController,LogOutDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var editedImage:UIImage? = nil
    var imageURL = ""
    var name = ""
    var coverURL = ""
    var setTo = "profile_images"
    var linkName = ""
    
    @IBOutlet weak var btnback: UIImageView!
    @IBOutlet weak var btnSetting: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var blankView: UIView!
    
    var delegate:UserLogOutDelegate? = nil
    var mDelegate:SetAvatarDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blankView.isHidden = true
        tfName.isUserInteractionEnabled = false
        btnSetting.isUserInteractionEnabled = true
        btnback.isUserInteractionEnabled = true
        cover.isUserInteractionEnabled = true
        avatar.isUserInteractionEnabled = true
        avatar.contentMode = .scaleAspectFit
        cover.contentMode = .scaleAspectFit
        if coverURL != "" {
            cover.downloadedFrom(coverURL,blankView)
        }
        if imageURL != "" {
            avatar.downloadedFrom(imageURL,nil)
        }
        if name != "" {
            tfName.text = name
        }
        avatar.layer.cornerRadius = 5
        avatar.clipsToBounds = true
        let tapSetting = UITapGestureRecognizer(target: self, action: #selector(settingClick))
        btnSetting.addGestureRecognizer(tapSetting)
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(backClick))
        btnback.addGestureRecognizer(tapBack)
        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(avatarClick))
        avatar.addGestureRecognizer(tapAvatar)
        let tapCover = UITapGestureRecognizer(target: self, action: #selector(coverClick))
        cover.addGestureRecognizer(tapCover)
        let cover_images_url = UserDefaults.standard.string(forKey: "cover_images_url")
        if cover_images_url != "" && cover_images_url != nil{
            cover.downloadedFrom(UserDefaults.standard.string(forKey: "cover_images_url")!,blankView)
        }
        
        
        
        setUpLoginView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editInfoVC" {
            let infoVC = segue.destination as! EditInfoVC
            infoVC.delegate = self
        }
    }
    
    func logOut() {
        print("user info vc log out")
        delegate?.userLogOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    func backClick(){
        let url = UserDefaults.standard.string(forKey: "profile_images_url")
        if url != "" || url != nil {
            mDelegate?.putAvatar()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func avatarClick(){
        setTo = "profile_images"
        linkName = "profile_images_url"
        startPicker()
        
    }
    func coverClick(){
        setTo = "cover_images"
        linkName = "cover_images_url"
        startPicker()
    }
    
    func settingClick(){
        performSegue(withIdentifier: "editInfoVC", sender: nil)
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
                    self.avatar.downloadedFrom(image,nil)
                    self.tfName.text = mName
                    self.tfName.sizeToFit()
                    return
                }
            }
        }else if GIDSignIn.sharedInstance().currentUser != nil{
            print("setup Google +")
        }else {
            cover.isUserInteractionEnabled = true
            avatar.isUserInteractionEnabled = true
            let imageURL = UserDefaults.standard.string(forKey: "profile_images_url")!
            self.avatar.downloadedFrom(imageURL,nil)
            self.tfName.text = UserDefaults.standard.string(forKey: "user_name")
            self.tfName.sizeToFit()
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
            self.avatar.image = editedImage
        }else{
            self.editedImage = (selectedImageFromPicker?.setCoverImage())!
            cover.image = editedImage
        }
        saveImage()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
