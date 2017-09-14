//
//  LoginViewController.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/25/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FBSDKLoginKit
protocol LoginDelegate {
    func putData(id:String,name:String,url:String)
}

class LoginViewController: UIViewController, CreateDelegate,GIDSignInUIDelegate, GIDSignInDelegate {

    
    let Dataref = FIRDatabase.database().reference()
    var delegate:LoginDelegate? = nil
    let process = UIActivityIndicatorView()
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var rootView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        btnGoogle.backgroundColor = UIColor(rgb: GG_COLOR)
        btnGoogle.layer.cornerRadius = 5.0
        btnGoogle.clipsToBounds = true
        
        btnFacebook.backgroundColor = UIColor(rgb: FB_COLOR)
        btnFacebook.layer.cornerRadius = 5.0
        btnFacebook.clipsToBounds = true
        
        btnLogin.backgroundColor = UIColor(rgb: MAIN_COLOR)
        btnLogin.layer.cornerRadius = 5.0
        btnLogin.clipsToBounds = true
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createAccount" {
            let createVC = segue.destination as! CreateAcccountVC
            createVC.delegate = self
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.tfEmail.text == "" || self.tfPass.text == "" {
            self.createAlert(mTitle: "Lỗi", mMessage: "Vui lòng nhập email và mật khẩu!", mButton: "Đồng ý")
        } else {
            FIRAuth.auth()?.signIn(withEmail: self.tfEmail.text!, password: self.tfPass.text!) { (user, error) in
                if error == nil {
                    if !(user?.isEmailVerified)!{
                        self.createAlert(mTitle: "Lỗi", mMessage: "Tài khoản chưa xác thực Email, vui lòng đến email để xác thực!", mButton: "Đồng ý")
                        return
                    }
                    let uid = user?.uid
                    FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                        print(snapshot)
                        if let dictionary = snapshot.value as? [String: AnyObject]{
                            let user = User()
                            user.setValuesForKeys(dictionary)
                            UserDefaults.standard.setValue(user.profile_images_url, forKey: "profile_images_url")
                            UserDefaults.standard.setValue(user.username, forKey: "user_name")
                            UserDefaults.standard.setValue(user.cover_images_url, forKey: "cover_images_url")
                            self.delegate?.putData(id:user.id,name: user.username, url: user.profile_images_url)
                        }
                    }, withCancel: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.createAlert(mTitle: "Đăng nhập thất bại", mMessage: "Email hoặc mật khẩu không đúng!", mButton: "Đồng ý")
                }
            }
        }
    }
    func putData(email: String, password: String) {
        tfEmail.text = email
        tfPass.text = password
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            return
        }
        let urlImage = user.profile.imageURL(withDimension: 1080)
        let name = user.profile.name
        UserDefaults.standard.setValue(urlImage, forKey: "profile_images_url")
        UserDefaults.standard.setValue(name, forKey: "user_name")
        guard let idToken = user.authentication.idToken else {
            return
        }
        guard let accessToken = user.authentication.accessToken else {
            return
        }
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if  error != nil {
                return
            }
            guard let uid = user?.uid else {
                return
            }
            self.delegate?.putData(id:uid,name: name!, url: String(describing: urlImage))
            if uid != ""{
                let userReference = FIRDatabase.database().reference().child("users").child(uid)
                let values = ["username" : name!, "profile_images_url":urlImage!] as [String : Any]
                userReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: {
                    (error,ref) in if error != nil{
                        return
                    }
                })
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
    @IBAction func loginFacebook(_ sender: Any) {
        rootView.isHidden = false
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self){
            (result, error) in if error != nil{
                print("Error login facebook \(String(describing: error))")
                return
            }
            print("Starting login with FIRAuth")
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else
            {
                print("error accessToken")
                return
            }
            print("Login with FIRAuth success")
            let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
            FIRAuth.auth()?.signIn(with: credentials, completion: {
                (user,error) in if error != nil{
                    self.createAlert(mTitle: "Đăng nhập thất bại", mMessage: "Lỗi không xác định!", mButton: "Đồng ý")
                    print("Error geting infor in Firebase\(String(describing: error))")
                    return
                }
                print("Starting geting infor facebook")
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email,picture.type(large)"]).start{
                    (connection,mResult,error) in
                    
                    if error != nil{
                        print("Facebook login Faild 2",error ?? "")
                        return
                    }
                    print("Geting facebook infor susscess")
                    let dict = mResult as? [String : Any]
                    let fbid = dict?["id"] as? String
                    UserDefaults.standard.setValue(fbid, forKey: "facebook_id")
                    let mName = dict?["name"] as! String
                    let picture = dict?["picture"] as? [String : Any]
                    let data = picture?["data"] as? [String : Any]
                    let image = data?["url"] as! String
                    UserDefaults.standard.setValue("", forKey: "profile_images_url")
                    UserDefaults.standard.setValue("", forKey: "user_name")
                    print("geting UID")
                    let userID = FIRAuth.auth()?.currentUser?.uid
                    print(userID!)
                    if userID != "" && userID != nil{
                        let userReference = self.Dataref.child("users").child(userID!)
                        let values = ["fb_id":fbid!,"username" : mName, "profile_images_url":image] as [String : Any]
                        userReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: {
                            (error,ref) in if error != nil{
                                return
                            }
                            DispatchQueue.main.async(execute: {
                                print("Start geting info user in FireBase")
                                let userID = (user?.uid)!
                                FIRDatabase.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                                    print("Get info user in firebase susscess")
                                    if let dictionary = snapshot.value as? [String: AnyObject]{
                                        let user = User()
                                        user.setValuesForKeys(dictionary)
                                        UserDefaults.standard.setValue(user.cover_images_url, forKey: "cover_images_url")
                                        self.delegate?.putData(id:user.id,name: user.username, url: user.profile_images_url)
                                        DispatchQueue.main.async(execute: {
                                            print("Comeback IndexViewController")
                                            self.delegate?.putData(id:userID,name: mName, url: image)
                                            self.dismiss(animated: true, completion: nil)
                                        })
                                    }
                                }, withCancel: nil)
                            })
                        })
                    }
                }
            })
        }
    }
    
    @IBAction func loginGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func getInfoFacebook(_ userID:String){
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email,picture.type(large)"]).start{
            (connection,mResult,error) in
            if error != nil{
                print("Facebook login Faild 2",error ?? "")
                return
            }
            print("geting facebook infor susscess")
            let dict = mResult as? [String : Any]
            let fbid = dict?["id"] as? String
            UserDefaults.standard.setValue(fbid, forKey: "facebook_id")
            let mName = dict?["name"] as! String
            let picture = dict?["picture"] as? [String : Any]
            let data = picture?["data"] as? [String : Any]
            let image = data?["url"] as! String
            UserDefaults.standard.setValue("", forKey: "profile_images_url")
            UserDefaults.standard.setValue("", forKey: "user_name")
            self.delegate?.putData(id:userID,name: mName, url: image)
            if userID != ""{
                print(userID)
                let userReference = self.Dataref.child("users").child(userID)
                let values = ["fb_id":fbid!,"username" : mName, "profile_images_url":image] as [String : Any]
                userReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: {
                    (error,ref) in if error != nil{
                        return
                    }
                    DispatchQueue.main.async(execute: {
                        print("Login faecbook susccess")
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            }
            
            
        }
    }
    
    func createAlert(mTitle:String,mMessage:String,mButton:String){
        let alertController = UIAlertController(title: mTitle, message: mMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: mButton, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
