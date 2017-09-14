//
//  LoginViewController.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/25/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

protocol LoginDelegate {
    func putData(id:String,name:String,url:String)
}

class LoginViewController: UIViewController{

    
    let Dataref = FIRDatabase.database().reference()
    var delegate:LoginDelegate? = nil
    let process = UIActivityIndicatorView()
    let tfPass: UITextField! = nil
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?

    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Đăng Nhập", "Đăng Ký"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    let logo:UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.image = UIImage(named: "logo_app")
        return imv
    }()
    
    let facebookButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.init(rgb: FB_COLOR)
        button.setTitle("Đăng nhập bằng Facebook", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleFacebook), for: .touchUpInside)
        return button
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Đăng Ký", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.init(rgb: MAIN_COLOR), for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControlState())
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        }
    
    let lineEmail:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lineName:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputsContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Tên hiển thị"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Mẩu khẩu"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let textOr: UILabel = {
        let lb = UILabel()
        lb.text = "Hoặc"
        lb.textColor = UIColor(red: 220, green: 220, blue: 220)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(facebookButton)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(textOr)
        view.addSubview(logo)
        
        setUpFacebookButton()
        setupLoginRegisterButton()
        setUpInputView()
        setupLoginRegisterSegmentedControl()
        setupTextOr()
        setupLogo()
    }
    
    func setUpInputView(){
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(lineName)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(lineEmail)
        inputsContainerView.addSubview(passwordTextField)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        lineName.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        lineName.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        lineName.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor,constant: -20).isActive = true
        lineName.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        lineEmail.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        lineEmail.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        lineEmail.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor,constant: -20).isActive = true
        lineEmail.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setUpFacebookButton(){
        facebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookButton.topAnchor.constraint(equalTo: textOr.bottomAnchor, constant: 5).isActive = true
        facebookButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupTextOr(){
        textOr.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textOr.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 5).isActive = true
        textOr.font = UIFont.boldSystemFont(ofSize: 11)
    }
    
    func setupLoginRegisterSegmentedControl() {
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupLogo(){
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 128).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 128).isActive = true
    }
    
    func handleLogin(){
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            self.createAlert(mTitle: "Lỗi", mMessage: "Vui lòng nhập email và mật khẩu!", mButton: "Đồng ý")
        } else {
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
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
                    if let topController = UIApplication.topViewController() {
                        print(topController)
                        if UserDefaults.standard.string(forKey: "city_id") == nil || UserDefaults.standard.string(forKey: "city_id") == ""{
                            let selectorVC = AreaSelectorVC()
                            self.present(selectorVC, animated: true, completion: nil)
                        }else{
                            self.performSegue(withIdentifier: "startIndexActivity", sender: nil)
                        }
                    }
                } else {
                    self.createAlert(mTitle: "Đăng nhập thất bại", mMessage: "Email hoặc mật khẩu không đúng!", mButton: "Đồng ý")
                }
            }
        }
    }
    func handleRegister(){
        let mName = nameTextField.text
        let mEmail = emailTextField.text
        let mPass = passwordTextField.text
        if mName == "" || mEmail == "" || mPass == "" {
            self.createAlert(mTitle: "Đăng ký thất bại", mMessage: "Vui lòng điền đầy đủ các thông tin!", mButton: "Đồng ý")
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    self.createAlert(mTitle: "Đăng ký thấi bại", mMessage: "Email này đã được đăng ký tài khoản!", mButton: "Đồng ý")
                    return
                }
                guard let userid = user?.uid else{
                    return
                }
                let userReference = self.Dataref.child("users").child(userid)
                let values = ["username" : mName ,"email": mEmail, "profile_images_url":""]
                userReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: {
                    (error,ref) in if error != nil{
                        self.createAlert(mTitle: "Đăng ký thấi bại", mMessage: "Lỗi không xác định", mButton: "Thử lại")
                        return
                    }
                    let alert = UIAlertController(title: "Đăng ký thành công", message: "Email xác thực đã được gửi đến email của bạn", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.nameTextField.text = ""
                        self.loginRegisterSegmentedControl.selectedSegmentIndex = 0
                        self.handleLoginRegisterChange()
                        user?.sendEmailVerification(completion: nil)
                        try! FIRAuth.auth()?.signOut()
                    }))
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }

    }
    func handleFacebook(){
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
                    let dict = mResult as? [String : Any]
                    let fbid = dict?["id"] as? String
                    UserDefaults.standard.setValue(fbid, forKey: "facebook_id")
                    let mName = dict?["name"] as! String
                    let picture = dict?["picture"] as? [String : Any]
                    let data = picture?["data"] as? [String : Any]
                    let image = data?["url"] as! String
                    UserDefaults.standard.setValue("", forKey: "profile_images_url")
                    UserDefaults.standard.setValue("", forKey: "user_name")
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
                                let userID = (user?.uid)!
                            FIRDatabase.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                                    if let dictionary = snapshot.value as? [String: AnyObject]{
                                        let user = User()
                                        user.setValuesForKeys(dictionary)
                                        UserDefaults.standard.setValue(user.cover_images_url, forKey: "cover_images_url")
                                        DispatchQueue.main.async(execute: {
                                            if let _ = UIApplication.topViewController() {
                                                if UserDefaults.standard.string(forKey: "city_id") == nil || UserDefaults.standard.string(forKey: "city_id") == ""{
                                                    let selectorVC = AreaSelectorVC()
                                                    self.present(selectorVC, animated: true, completion: nil)
                                                }else{
                                                    self.performSegue(withIdentifier: "startIndexActivity", sender: nil)
                                                }
                                            }
                                            
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
    
    
    func createAlert(mTitle:String,mMessage:String,mButton:String){
        let alertController = UIAlertController(title: mTitle, message: mMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: mButton, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
