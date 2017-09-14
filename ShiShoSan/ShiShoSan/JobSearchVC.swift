//
//  ViewController.swift
//  test
//
//  Created by ゴ　ハイ　バン on 2017/08/10.
//  Copyright © 2017 ゴ　ハイ　バン. All rights reserved.
//

import UIKit
import Firebase

class JobSearchVC: UIViewController {
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    var colorClicked:Int = 0x1C547A
    var colorUnClick:Int = 0x2573a8
    var viewStationHeight: NSLayoutConstraint?
    var marrginStationHeight: NSLayoutConstraint?
    var buttonFullTime:Bool = true
    let blackView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewDetails : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(rgb: 0xFCBA2C)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewCity : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func handleCityClick(){
        print("City Click")
    }
    let cityTitle:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Vùng tìm kiếm"
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let textCity:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Tất cả"
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    let imgSearchCity:UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage(named: "icon_search")
        imgv.translatesAutoresizingMaskIntoConstraints = false
        return imgv
    }()
    
    let view3 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewLanguage : UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func handleLanguage(){
        print("Language Clicked")
    }
    
    let languageTitle:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.baselineAdjustment = .alignCenters
        lb.text = "Tiếng Nhật"
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }()
    
    let textLanguage:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.baselineAdjustment = .alignCenters
        lb.text = "N5"
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let lineLanguage : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewFee : UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func handleFee(){
        print("Fee clicked")
    }
    
    let feeTitle:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Phí giới thiệu"
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }()
    
    let textFee:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Tất cả"
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let lineFee : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewMyNumber : UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func handleMyNumber() {
        print("MyNumber Clicked")
    }
    
    let myNumberTitle:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "My Number"
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }()
    
    let textMyNumber:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Tất cả"
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let view4 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewJobType : UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func handleJobType(){
        print("Job Type clicked")
    }
    
    let jobTypeTitle:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Công việc"
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    let textJobType:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Tất cả"
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    let viewTimer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func handleTimer(){
        print("Timer clicked")
    }
    
    let timerTitle:UILabel = {
        let lb = UILabel()
        
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Thời gian"
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    let textTimer:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Cả ngày"
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()

    
    let textTitle:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.init(rgb: 0x1C547A)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Tìm Việc Toàn T.Gian"
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let textSmall:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.init(rgb: 0x1C547A)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Nhập vị trí để việc tìm kiếm dễ dàng hơn"
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    let btnFullTime: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitle("Toàn T.Gian", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(fullTimeClick),for: .touchUpInside)
        return btn
    }()
    
    let btnSearch: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.init(rgb: 0x1C547A)
        btn.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        btn.setTitle("Tìm kiếm", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let btnPartTime: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitle("Bán T.Gian", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(partTimeClick), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addSubview(blackView)
        view.addSubview(contentView)
        setUpBlackView()
        setupBlueView()
        handles()
    }
    
    
    func fullTimeClick(){
        if buttonFullTime{
            return
        }
        buttonFullTime = true
        handleTagChoose()
    }
    func partTimeClick(){
        if !buttonFullTime{
            return
        }
        buttonFullTime = false
        handleTagChoose()
    }
    func handleTagChoose(){
        if buttonFullTime {
            btnFullTime.backgroundColor = UIColor.init(rgb: colorClicked)
            btnPartTime.backgroundColor = UIColor.init(rgb: colorUnClick)
            textTitle.text = "Tìm Việc Toàn T.Gian"
        }else{
            btnPartTime.backgroundColor = UIColor.init(rgb: colorClicked)
            btnFullTime.backgroundColor = UIColor.init(rgb: colorUnClick)
            textTitle.text = "Tìm Việc Bán T.Gian"
        }
    }
    
    func handles(){
        viewTimer.isUserInteractionEnabled = true
        let tapTimer = UITapGestureRecognizer(target: self, action: #selector(handleTimer))
        viewTimer.addGestureRecognizer(tapTimer)
        viewCity.isUserInteractionEnabled = true
        let tapCity = UITapGestureRecognizer(target: self, action: #selector(handleCityClick))
        viewCity.addGestureRecognizer(tapCity)
        viewLanguage.isUserInteractionEnabled = true
        let tapLanguage = UITapGestureRecognizer(target: self, action: #selector(handleLanguage))
        viewLanguage.addGestureRecognizer(tapLanguage)
        viewFee.isUserInteractionEnabled = true
        let tapFee = UITapGestureRecognizer(target: self, action: #selector(handleFee))
        viewFee.addGestureRecognizer(tapFee)
        viewMyNumber.isUserInteractionEnabled = true
        let tapMyNumber = UITapGestureRecognizer(target: self, action: #selector(handleMyNumber))
        viewMyNumber.addGestureRecognizer(tapMyNumber)
        viewJobType.isUserInteractionEnabled = true
        let tapJobType = UITapGestureRecognizer(target: self, action: #selector(handleJobType))
        viewJobType.addGestureRecognizer(tapJobType)
        
        
    }
    
    func handleSearch(){
        print("Search Clicked")
    }
    
    func setupBlueView(){
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -36).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 286).isActive = true
        contentView.addSubview(btnFullTime)
        contentView.addSubview(btnPartTime)
        contentView.addSubview(textTitle)
        contentView.addSubview(textSmall)
        contentView.addSubview(viewDetails)
        contentView.addSubview(btnSearch)

        btnFullTime.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        btnFullTime.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        btnFullTime.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2).isActive = true
        btnFullTime.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        btnPartTime.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        btnPartTime.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        btnPartTime.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2).isActive = true
        btnPartTime.heightAnchor.constraint(equalToConstant: 35).isActive = true
        handleTagChoose()
        
        textTitle.topAnchor.constraint(equalTo: btnPartTime.bottomAnchor,constant: 5).isActive = true
        textTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        textSmall.topAnchor.constraint(equalTo: textTitle.bottomAnchor,constant: 3).isActive = true
        textSmall.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textSmall.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        btnSearch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8).isActive = true
        btnSearch.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        btnSearch.widthAnchor.constraint(equalTo: contentView.widthAnchor,constant:-16).isActive = true
        btnSearch.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        setUpViewDetails()
    }
    
    func setUpViewDetails(){
        viewDetails.topAnchor.constraint(equalTo: textSmall.bottomAnchor,constant: 5).isActive = true
        viewDetails.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        viewDetails.widthAnchor.constraint(equalTo: contentView.widthAnchor,constant:-16).isActive = true
        viewDetails.heightAnchor.constraint(equalToConstant: 143).isActive = true
        
        viewDetails.addSubview(viewCity)
        viewDetails.addSubview(view3)
        viewDetails.addSubview(view4)
        
        viewCity.centerXAnchor.constraint(equalTo: viewDetails.centerXAnchor).isActive = true
        viewCity.widthAnchor.constraint(equalTo: viewDetails.widthAnchor).isActive = true
        viewCity.heightAnchor.constraint(equalToConstant: 45).isActive = true
        viewCity.topAnchor.constraint(equalTo: viewDetails.topAnchor).isActive = true
        viewCity.addSubview(cityTitle)
        viewCity.addSubview(textCity)
        viewCity.addSubview(imgSearchCity)
        
        imgSearchCity.centerYAnchor.constraint(equalTo: viewCity.centerYAnchor).isActive = true
        imgSearchCity.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imgSearchCity.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imgSearchCity.rightAnchor.constraint(equalTo: viewCity.rightAnchor,constant:-10).isActive = true
        cityTitle.topAnchor.constraint(equalTo: viewCity.topAnchor).isActive = true
        cityTitle.leftAnchor.constraint(equalTo: viewCity.leftAnchor,constant: 10).isActive = true
        cityTitle.rightAnchor.constraint(equalTo: imgSearchCity.leftAnchor,constant:-10).isActive = true
        cityTitle.heightAnchor.constraint(equalTo: viewCity.heightAnchor,multiplier:1/2).isActive = true
        textCity.bottomAnchor.constraint(equalTo: viewCity.bottomAnchor).isActive = true
        textCity.leftAnchor.constraint(equalTo: viewCity.leftAnchor,constant: 18).isActive = true
        textCity.rightAnchor.constraint(equalTo: imgSearchCity.leftAnchor,constant:-10).isActive = true
        textCity.heightAnchor.constraint(equalTo: viewCity.heightAnchor,multiplier:1/2).isActive = true
        
    
        setupView3()
        setupView4()
        
    }
    
    func setupView3(){
        view3.centerXAnchor.constraint(equalTo: viewDetails.centerXAnchor).isActive = true
        view3.widthAnchor.constraint(equalTo: viewDetails.widthAnchor).isActive = true
        view3.heightAnchor.constraint(equalToConstant: 45).isActive = true
        view3.topAnchor.constraint(equalTo: viewCity.bottomAnchor,constant:4).isActive = true
        view3.addSubview(viewLanguage)
        view3.addSubview(lineLanguage)
        view3.addSubview(viewFee)
        view3.addSubview(lineFee)
        view3.addSubview(viewMyNumber)
        
        viewLanguage.topAnchor.constraint(equalTo: view3.topAnchor).isActive = true
        viewLanguage.leftAnchor.constraint(equalTo: view3.leftAnchor).isActive = true
        viewLanguage.bottomAnchor.constraint(equalTo: view3.bottomAnchor).isActive = true
        viewLanguage.widthAnchor.constraint(equalTo: view3.widthAnchor, multiplier: 1/3).isActive = true
        viewLanguage.addSubview(languageTitle)
        viewLanguage.addSubview(textLanguage)
        languageTitle.topAnchor.constraint(equalTo: viewLanguage.topAnchor).isActive = true
        languageTitle.leftAnchor.constraint(equalTo: viewLanguage.leftAnchor,constant: 10).isActive = true
        languageTitle.rightAnchor.constraint(equalTo: viewLanguage.rightAnchor,constant:-5).isActive = true
        languageTitle.heightAnchor.constraint(equalTo: viewLanguage.heightAnchor,multiplier:1/2).isActive = true
        textLanguage.bottomAnchor.constraint(equalTo: viewLanguage.bottomAnchor).isActive = true
        textLanguage.leftAnchor.constraint(equalTo: viewLanguage.leftAnchor,constant: 18).isActive = true
        textLanguage.rightAnchor.constraint(equalTo: viewLanguage.rightAnchor,constant:-5).isActive = true
        textLanguage.heightAnchor.constraint(equalTo: viewLanguage.heightAnchor,multiplier:1/2).isActive = true
        
        
        lineLanguage.topAnchor.constraint(equalTo: view3.topAnchor,constant:4).isActive = true
        lineLanguage.leftAnchor.constraint(equalTo: viewLanguage.rightAnchor).isActive = true
        lineLanguage.bottomAnchor.constraint(equalTo: view3.bottomAnchor,constant: -4).isActive = true
        lineLanguage.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        viewFee.topAnchor.constraint(equalTo: view3.topAnchor).isActive = true
        viewFee.leftAnchor.constraint(equalTo: viewLanguage.rightAnchor).isActive = true
        viewFee.bottomAnchor.constraint(equalTo: view3.bottomAnchor).isActive = true
        viewFee.widthAnchor.constraint(equalTo: view3.widthAnchor, multiplier: 1/3).isActive = true
        viewFee.addSubview(feeTitle)
        viewFee.addSubview(textFee)
        feeTitle.topAnchor.constraint(equalTo: viewFee.topAnchor).isActive = true
        feeTitle.leftAnchor.constraint(equalTo: viewFee.leftAnchor,constant: 10).isActive = true
        feeTitle.rightAnchor.constraint(equalTo: viewFee.rightAnchor,constant:-5).isActive = true
        feeTitle.heightAnchor.constraint(equalTo: viewFee.heightAnchor,multiplier:1/2).isActive = true
        textFee.bottomAnchor.constraint(equalTo: viewFee.bottomAnchor).isActive = true
        textFee.leftAnchor.constraint(equalTo: viewFee.leftAnchor,constant: 18).isActive = true
        textFee.rightAnchor.constraint(equalTo: viewFee.rightAnchor,constant:-5).isActive = true
        textFee.heightAnchor.constraint(equalTo: viewFee.heightAnchor,multiplier:1/2).isActive = true
        
        lineFee.topAnchor.constraint(equalTo: view3.topAnchor,constant:4).isActive = true
        lineFee.leftAnchor.constraint(equalTo: viewFee.rightAnchor).isActive = true
        lineFee.bottomAnchor.constraint(equalTo: view3.bottomAnchor,constant: -4).isActive = true
        lineFee.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        viewMyNumber.topAnchor.constraint(equalTo: view3.topAnchor).isActive = true
        viewMyNumber.leftAnchor.constraint(equalTo: viewFee.rightAnchor).isActive = true
        viewMyNumber.bottomAnchor.constraint(equalTo: view3.bottomAnchor).isActive = true
        viewMyNumber.widthAnchor.constraint(equalTo: view3.widthAnchor, multiplier: 1/3).isActive = true
        viewMyNumber.addSubview(myNumberTitle)
        viewMyNumber.addSubview(textMyNumber)
        myNumberTitle.topAnchor.constraint(equalTo: viewMyNumber.topAnchor).isActive = true
        myNumberTitle.leftAnchor.constraint(equalTo: viewMyNumber.leftAnchor,constant: 10).isActive = true
        myNumberTitle.rightAnchor.constraint(equalTo: viewMyNumber.rightAnchor,constant:-5).isActive = true
        myNumberTitle.heightAnchor.constraint(equalTo: viewMyNumber.heightAnchor,multiplier:1/2).isActive = true
        textMyNumber.bottomAnchor.constraint(equalTo: viewMyNumber.bottomAnchor).isActive = true
        textMyNumber.leftAnchor.constraint(equalTo: viewMyNumber.leftAnchor,constant: 18).isActive = true
        textMyNumber.rightAnchor.constraint(equalTo: viewMyNumber.rightAnchor,constant:-5).isActive = true
        textMyNumber.heightAnchor.constraint(equalTo: viewMyNumber.heightAnchor,multiplier:1/2).isActive = true
    }
    
    func setupView4(){
        view4.centerXAnchor.constraint(equalTo: viewDetails.centerXAnchor).isActive = true
        view4.widthAnchor.constraint(equalTo: viewDetails.widthAnchor).isActive = true
        view4.heightAnchor.constraint(equalToConstant: 45).isActive = true
        view4.topAnchor.constraint(equalTo: view3.bottomAnchor,constant:4).isActive = true
        view4.addSubview(viewTimer)
        view4.addSubview(viewJobType)
        
        viewJobType.topAnchor.constraint(equalTo: view4.topAnchor).isActive = true
        viewJobType.leftAnchor.constraint(equalTo: view4.leftAnchor).isActive = true
        viewJobType.bottomAnchor.constraint(equalTo: view4.bottomAnchor).isActive = true
        viewJobType.widthAnchor.constraint(equalTo: view4.widthAnchor, multiplier: 1/2, constant:-2).isActive = true
        viewJobType.addSubview(jobTypeTitle)
        viewJobType.addSubview(textJobType)
        jobTypeTitle.topAnchor.constraint(equalTo: viewJobType.topAnchor).isActive = true
        jobTypeTitle.leftAnchor.constraint(equalTo: viewJobType.leftAnchor,constant: 10).isActive = true
        jobTypeTitle.rightAnchor.constraint(equalTo: viewJobType.rightAnchor,constant:-5).isActive = true
        jobTypeTitle.heightAnchor.constraint(equalTo: viewJobType.heightAnchor,multiplier:1/2).isActive = true
        textJobType.bottomAnchor.constraint(equalTo: viewJobType.bottomAnchor).isActive = true
        textJobType.leftAnchor.constraint(equalTo: viewJobType.leftAnchor,constant: 18).isActive = true
        textJobType.rightAnchor.constraint(equalTo: viewJobType.rightAnchor,constant:-5).isActive = true
        textJobType.heightAnchor.constraint(equalTo: viewJobType.heightAnchor,multiplier:1/2).isActive = true
        
        viewTimer.topAnchor.constraint(equalTo: view4.topAnchor).isActive = true
        viewTimer.rightAnchor.constraint(equalTo: view4.rightAnchor).isActive = true
        viewTimer.bottomAnchor.constraint(equalTo: view4.bottomAnchor).isActive = true
        viewTimer.widthAnchor.constraint(equalTo: view4.widthAnchor, multiplier: 1/2, constant:-2).isActive = true
        viewTimer.addSubview(timerTitle)
        viewTimer.addSubview(textTimer)
        timerTitle.topAnchor.constraint(equalTo: viewTimer.topAnchor).isActive = true
        timerTitle.leftAnchor.constraint(equalTo: viewTimer.leftAnchor,constant: 10).isActive = true
        timerTitle.rightAnchor.constraint(equalTo: viewTimer.rightAnchor,constant:-5).isActive = true
        timerTitle.heightAnchor.constraint(equalTo: viewTimer.heightAnchor,multiplier:1/2).isActive = true
        textTimer.bottomAnchor.constraint(equalTo: viewTimer.bottomAnchor).isActive = true
        textTimer.leftAnchor.constraint(equalTo: viewTimer.leftAnchor,constant: 18).isActive = true
        textTimer.rightAnchor.constraint(equalTo: viewTimer.rightAnchor,constant:-5).isActive = true
        textTimer.heightAnchor.constraint(equalTo: viewTimer.heightAnchor,multiplier:1/2).isActive = true
    }

    
    func setUpBlackView(){
        blackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    @IBAction func actionCreateJob(_ sender: Any) {
        if FIRAuth.auth()?.currentUser == nil {
            return
        }
        self.performSegue(withIdentifier: "createJobIdent", sender: nil)
    }
}

