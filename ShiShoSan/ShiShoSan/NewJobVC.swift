//
//  NewJobVC.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 8/13/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import Firebase

class NewJobVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,JobListDelegate,UITextViewDelegate{
    var imagesArray :[UIImage] = []
    var imageUrls:[String] = []
    var locationIDs:[String] = []
    var language:String = "N5"
    let cellSize = CGSize(width: 100, height: 100)
    var partTimeClicked = true
    let cellImageViewTag = 1
    
    
    
    @IBOutlet weak var containerView: UIView!

    //////////  btn job & collectionview
    @IBOutlet weak var btnFulTime: UIButton!
    @IBOutlet weak var btnPartTime: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    ///////// job info
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var titleCount: UILabel!
    @IBOutlet weak var viewJobType: UIView!
    @IBOutlet weak var lblJobType: UILabel!
    @IBOutlet weak var tfOrtherJobType: UITextField!
    @IBOutlet weak var ortherjobTopconstant: NSLayoutConstraint!
    @IBOutlet weak var constantHeightJobOrther: NSLayoutConstraint!
    @IBOutlet weak var tvJobDetails: UITextView!
    @IBOutlet weak var constantJobDetails: NSLayoutConstraint!
    
    //////// Detail
    @IBOutlet weak var tfSalary: UITextField!
    @IBOutlet weak var btnHour: UILabel!
    @IBOutlet weak var btnDay: UILabel!
    @IBOutlet weak var btnMonth: UILabel!
    @IBOutlet weak var btnYear: UILabel!
    @IBOutlet weak var tvDetalsSalary: UITextView!
    @IBOutlet weak var heightSalary: NSLayoutConstraint!

    //////// Time
    @IBOutlet weak var tfTime: UITextField!
    @IBOutlet weak var btnMorning: UILabel!
    @IBOutlet weak var btnNap: UILabel!
    @IBOutlet weak var btnEvening: UILabel!
    @IBOutlet weak var btnNight: UILabel!
    @IBOutlet weak var tvDetailTime: UITextView!
    @IBOutlet weak var heightTime: NSLayoutConstraint!
    
    //////// Location
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var viewLocation: UIView!

    //////// Benefit
    @IBOutlet weak var tvBenefit: UITextView!
    @IBOutlet weak var heightBenefit: NSLayoutConstraint!
    
    //////// Fee
    @IBOutlet weak var swFee: UISwitch!
    @IBOutlet weak var tvDetailFee: UITextView!
    @IBOutlet weak var heightFee: NSLayoutConstraint!
    
    @IBOutlet weak var feeBotconstant: NSLayoutConstraint!
    @IBOutlet weak var feeTopconstant: NSLayoutConstraint!
    
    //////// More information
    @IBOutlet weak var btnN5: UILabel!
    @IBOutlet weak var btnN4: UILabel!
    @IBOutlet weak var btnN3: UILabel!
    @IBOutlet weak var btnN2: UILabel!
    @IBOutlet weak var btnN1: UILabel!
    @IBOutlet weak var heightMoreInfo: NSLayoutConstraint!
    @IBOutlet weak var tvMoreInfo: UITextView!
    
    
    //////// View loading
    var rootView = UIView()
    var viewLoading = UIView ()
    var indicatorView = UIActivityIndicatorView ()
    
    var textLoading = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        imagesArray.append(UIImage(named: "icon_add_image")!)
        setUpviewSalay()
        setUpviewTime()
        setupViewFee()
        setupViewJobType()

        self.hideKeyboardWhenTappedAround()
        setupLoadingView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        tvBenefit.delegate = self
        tvDetailFee.delegate = self
        tvMoreInfo.delegate = self
        tfTitle.delegate = self
        tvJobDetails.delegate = self
        tvDetalsSalary.delegate = self
        resizeTextView(tvDetalsSalary)

    
    }
    func dismissLoadingView(){
        rootView.isHidden = true
        viewLoading.isHidden = true
    }
    func showLoadingView(){
        rootView.isHidden = false
        viewLoading.isHidden = false
    }
    
    func setupLoadingView(){
        let window = UIApplication.shared.keyWindow!
        rootView.frame = CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height)
        window.addSubview(rootView)
        rootView.alpha = 0.2
        rootView.isUserInteractionEnabled = true
        rootView.backgroundColor = UIColor.black
        viewLoading.frame = CGRect(x: window.frame.width/8, y: window.frame.height/2 - 20, width: window.frame.width * 3 / 4, height: 80)
        window.addSubview(viewLoading)
        viewLoading.layer.cornerRadius = 5
        viewLoading.clipsToBounds = true
        viewLoading.alpha = 0.8
        viewLoading.backgroundColor = UIColor.black
        indicatorView.frame = CGRect(x: viewLoading.frame.width/2 - 10, y: 15, width: 20, height: 20)
        viewLoading.addSubview(indicatorView)
        indicatorView.startAnimating()
        textLoading.frame = CGRect(x: 0, y: 40, width: viewLoading.frame.width, height: 20)
        viewLoading.addSubview(textLoading)
        textLoading.textColor = UIColor.white
        textLoading.textAlignment = NSTextAlignment.center
        textLoading.text = "Please wait a seacond..."
        dismissLoadingView()
    }

    func startPickingPhoto(){
        let picker:UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        if newLength <= 64{
            self.titleCount.text = "\(newLength)/64"
            return true
        }else{
            return false
        }
    }
    
    func handleJobTypeButton(){
        if partTimeClicked{
            btnPartTime.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
            btnFulTime.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR)
        }else{
            btnFulTime.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
            btnPartTime.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedimage = (info[UIImagePickerControllerOriginalImage] as? UIImage){
            imagesArray.append(pickedimage)
        }
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func saveImageToFB(){
        var count = 0
        for _ in 0 ..< imagesArray.count-1{
            self.imageUrls.append("")
        }
        for i in 1 ..< imagesArray.count{
            imagesArray[i] = imagesArray[i].resizeImage()!
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("job_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(imagesArray[i]) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if let error = error {
                        print(error)
                        self.dismissLoadingView()
                        return
                    }
                    if let image_url = metadata?.downloadURL()?.absoluteString {
                        DispatchQueue.main.async(execute: {
                            self.imageUrls[i-1] = image_url
                            count += 1
                            if count == self.imagesArray.count-1 {
                                print("starting public")
                                self.publicJob()
                            }
                        })
                    }
                })
            }
        }
    }
    
    func publicJob(){
        print("public")
        let job = Job()
        job.images = imageUrls
        job.title = tfTitle.text!
        job.details = tvJobDetails.text!
        job.jobType = lblJobType.text!
        job.ortherJobGroup = tfOrtherJobType.text!
        job.salary = "\(tfSalary.text ?? "")/\(salaryType)"
        job.time = tfTime.text!
        job.detailsTime = tvDetailTime.text!
        locationIDs.append("asdasd1")
        locationIDs.append("asdasd2")
        locationIDs.append("asdasd3")
        locationIDs.append("asdasd4")
        job.locations = locationIDs
        job.benefit = tvBenefit.text!
        job.detailsFee = tvDetailFee.text!
        job.language = language
        job.detailLanguage = tvMoreInfo.text!
        job.userID = (FIRAuth.auth()?.currentUser?.uid)!
        job.userName = UserDefaults.standard.string(forKey: "user_name")!
        job.userImage = UserDefaults.standard.string(forKey: "profile_images_url")!
        job.saveToFireBase(rootView,viewLoading)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100 , height: 100);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0 && imagesArray.count <= 11{
            let vc = BSImagePickerViewController()
            vc.maxNumberOfSelections = 11 - imagesArray.count
            bs_presentImagePickerController(vc, animated: true,
                                            select: { (asset: PHAsset) -> Void in
            }, deselect: { (asset: PHAsset) -> Void in
                
            }, cancel: { (assets: [PHAsset]) -> Void in
                
            }, finish: { (assets: [PHAsset]) -> Void in
                for i in 0 ..< assets.count{
                    let image = self.getAssetThumbnail(asset: assets[i])
                    DispatchQueue.main.async {
                        self.imagesArray.append(image)
                        collectionView.reloadData()
                    }
                }
            }, completion: nil)
        }else{
            showBottomSheetImage(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.backgroundColor = UIColor.red
        cell.configureImage(imagesArray[indexPath.row])
        cell.imageView.contentMode = .scaleAspectFit
        if indexPath.row == 0 {
            cell.viewBackground.backgroundColor = UIColor.white
            cell.textTitle.isHidden = true
            cell.viewCover.isHidden = true
        }else if indexPath.row > 1{
            cell.viewBackground.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
            cell.textTitle.isHidden = true
            cell.viewCover.isHidden = true
        }else{
            cell.viewBackground.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
            cell.textTitle.isHidden = false
            cell.viewCover.isHidden = false
        }
        
        return cell
        
    }
    
    ///////// Fee
    func setupViewFee(){
        heightFee.constant = 0
        feeTopconstant.constant = 0
        feeBotconstant.constant = 0
        
    }

    @IBAction func swFee(_ sender: Any) {
        if swFee.isOn{
            tvDetailFee.text = "Chi tiết phí giới thiệu"
            resizeTextView(tvDetailFee)
            tvDetailFee.textColor = UIColor.init(rgb: UNCLICKED_COLOR)
            feeBotconstant.constant = 8
            feeBotconstant.constant = 8
            return
        }
        heightFee.constant = 0
        feeTopconstant.constant = 0
        feeBotconstant.constant = 0
        view.endEditing(true)
    }
    
    @IBAction func swPhone(_ sender: Any) {
    }
    @IBAction func swFacebook(_ sender: Any) {
    }
    @IBAction func actionPartime(_ sender: Any) {
        if partTimeClicked{
            return
        }
        partTimeClicked = true
        handleJobTypeButton()
    }
    
    @IBAction func actionFullTime(_ sender: Any) {
        if !partTimeClicked{
            return
        }
        partTimeClicked = false
        handleJobTypeButton()
    }
    
    @IBAction func actionBack(_ sender: Any) {
    }

    @IBAction func actionSubmit(_ sender: Any) {
        if tfTitle.text == "" || tvJobDetails.text == "" || tfTime.text == ""{
            createAlert(mTitle: "Lỗi",mMessage: "Vui lòng điền đầy đủ thông tin",mButton: "Đã hiểu")
            return
        }
        if lblJobType.text == "Khác" && tfOrtherJobType.text == ""{
            createAlert(mTitle: "Lỗi",mMessage: "Vui lòng điền đầy đủ thông tin",mButton: "Đã hiểu")
            return
        }
        if swFee.isOn && tvDetailFee.text == ""{
            createAlert(mTitle: "Lỗi",mMessage: "Vui lòng điền đầy đủ thông tin",mButton: "Đã hiểu")
            return
        }
        showLoadingView()
        saveImageToFB()
    }
    
    func createAlert(mTitle:String,mMessage:String,mButton:String){
        let alertController = UIAlertController(title: mTitle, message: mMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: mButton, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        
        return thumbnail
    }
    
    func showBottomSheetImage(_ position:Int){
        let optionMenu = UIAlertController(title: nil, message: "Lựa chọn", preferredStyle: .actionSheet)
        
        let setCover = UIAlertAction(title: "Đặt ảnh bìa", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let imgTemp = self.imagesArray[position]
            self.imagesArray[position] = self.imagesArray[1]
            self.imagesArray[1] = imgTemp
            self.collectionView.reloadData()
        })
        
        let deleteImage = UIAlertAction(title: "Xóa ảnh", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagesArray.remove(at: position)
            self.collectionView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        if position != 1{
            optionMenu.addAction(setCover)
        }
        optionMenu.addAction(deleteImage)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    ////////////////////// setup Time view
    var moring:Bool = true
    var nap:Bool = false
    var evening:Bool = false
    var night:Bool = false
    
    func setUpviewTime(){
        setupTfTime()
        tvDetailTime.delegate = self
        resizeTextView(tvDetailTime)
        let morningTap = UITapGestureRecognizer(target: self, action:  #selector(morningClick))
        self.btnMorning.addGestureRecognizer(morningTap)
        self.btnMorning.isUserInteractionEnabled = true
        let napTap = UITapGestureRecognizer(target: self, action: #selector(napClick))
        self.btnNap.addGestureRecognizer(napTap)
        self.btnNap.isUserInteractionEnabled = true
        let eveningTap = UITapGestureRecognizer(target: self, action:  #selector(eveningClick))
        self.btnEvening.addGestureRecognizer(eveningTap)
        self.btnEvening.isUserInteractionEnabled = true
        let nightTap = UITapGestureRecognizer(target: self, action:  #selector(nightClick))
        self.btnNight.addGestureRecognizer(nightTap)
        self.btnNight.isUserInteractionEnabled = true
        
        let N5 = UITapGestureRecognizer(target: self, action:  #selector(n5click))
        self.btnN5.addGestureRecognizer(N5)
        self.btnN5.isUserInteractionEnabled = true
        let N4 = UITapGestureRecognizer(target: self, action:  #selector(n4click))
        self.btnN4.addGestureRecognizer(N4)
        self.btnN4.isUserInteractionEnabled = true
        let N3 = UITapGestureRecognizer(target: self, action:  #selector(n3click))
        self.btnN3.addGestureRecognizer(N3)
        self.btnN3.isUserInteractionEnabled = true
        let N2 = UITapGestureRecognizer(target: self, action:  #selector(n2click))
        self.btnN2.addGestureRecognizer(N2)
        self.btnN2.isUserInteractionEnabled = true
        let N1 = UITapGestureRecognizer(target: self, action:  #selector(n1click))
        self.btnN1.addGestureRecognizer(N1)
        self.btnN1.isUserInteractionEnabled = true
    }
    
    func n5click(){
        language = "N5"
        handleLanguage()
    }
    func n4click(){
        language = "N4"
        handleLanguage()
    }
    func n3click(){
        language = "N3"
        handleLanguage()
    }
    func n2click(){
        language = "N2"
        handleLanguage()
    }
    func n1click(){
        language = "N1"
        handleLanguage()
    }
    
    func handleLanguage(){
        if language == "N5"{
            btnN5.backgroundColor = UIColor.init(rgb: SELECTED_COLOR )
            btnN4.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN3.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN2.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN1.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            return
        }
        if language == "N4"{
            btnN5.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN4.backgroundColor = UIColor.init(rgb: SELECTED_COLOR )
            btnN3.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN2.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN1.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            return
        }
        if language == "N3"{
            btnN5.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN4.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN3.backgroundColor = UIColor.init(rgb: SELECTED_COLOR )
            btnN2.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN1.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            return
        }
        if language == "N2"{
            btnN5.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN4.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN3.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN2.backgroundColor = UIColor.init(rgb: SELECTED_COLOR )
            btnN1.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            return
        }
        if language == "N1"{
            btnN5.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN4.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN3.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN2.backgroundColor = UIColor.init(rgb: UNCLICKED_COLOR )
            btnN1.backgroundColor = UIColor.init(rgb: SELECTED_COLOR )
            return
        }
    }
    
    func morningClick(){
        if moring{
            moring = false
            btnMorning.backgroundColor = nil
        }else{
            moring = true
            btnMorning.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
        }
        setupTfTime()
    }
    
    func napClick(){
        if nap{
            nap = false
            btnNap.backgroundColor = nil
        }else{
            nap = true
            btnNap.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
        }
        setupTfTime()
    }
    
    func eveningClick(){
        if evening{
            evening = false
            btnEvening.backgroundColor = nil
        }else{
            evening = true
            btnEvening.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
        }
        setupTfTime()
    }
    
    func nightClick(){
        if night{
            night = false
            btnNight.backgroundColor = nil
        }else{
            night = true
            btnNight.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
        }
        setupTfTime()
    }
    
    func setupTfTime(){
        var time = ""
        if moring{
            time = "Sáng"
        }
        if nap {
            time = "\(time),Trưa"
        }
        if evening {
            time = "\(time),Chiều"
        }
        if night {
            time = "\(time),Tối"
        }
        if time == "Sáng,Trưa,Chiều,Tối"{
            time = "Cả ngày"
        }
        if time != "" && time[0] == ","{
            time.remove(at: time.startIndex)
        }
        tfTime.text = time
    }
    
    var salaryType = ""
    ////////////////////// set Up Salary view
    func setUpviewSalay(){
        self.btnHour.isUserInteractionEnabled = true
        let hourTap = UITapGestureRecognizer(target: self, action:  #selector(btnHourClick))
        self.btnHour.addGestureRecognizer(hourTap)
        let dayTap = UITapGestureRecognizer(target: self, action: #selector(btnDayClick))
        self.btnDay.addGestureRecognizer(dayTap)
        self.btnDay.isUserInteractionEnabled = true
        let monthTap = UITapGestureRecognizer(target: self, action:  #selector(btnMonthClick))
        self.btnMonth.addGestureRecognizer(monthTap)
        self.btnMonth.isUserInteractionEnabled = true
        let yearTap = UITapGestureRecognizer(target: self, action:  #selector(btnYearClick))
        self.btnYear.addGestureRecognizer(yearTap)
        self.btnYear.isUserInteractionEnabled = true
        handleClickSalaryType(btnHour)
    }
    
    func btnHourClick(){
        handleClickSalaryType(btnHour)
    }
    func btnDayClick(){
        handleClickSalaryType(btnDay)
    }
    func btnMonthClick(){
        handleClickSalaryType(btnMonth)
    }
    func btnYearClick(){
        handleClickSalaryType(btnYear)
    }
    
    func handleClickSalaryType(_ lb:UILabel){
        if lb == btnHour{
            salaryType = "Giờ"
            btnHour.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
            btnDay.backgroundColor = nil
            btnMonth.backgroundColor = nil
            btnYear.backgroundColor = nil
            return
        }
        
        if lb == btnDay{
            salaryType = "Ngày"
            btnHour.backgroundColor = nil
            btnDay.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
            btnMonth.backgroundColor = nil
            btnYear.backgroundColor = nil
            return
        }
        
        if lb == btnMonth{
            salaryType = "Tháng"
            btnHour.backgroundColor = nil
            btnDay.backgroundColor = nil
            btnMonth.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
            btnYear.backgroundColor = nil
            return
        }
        
        if lb == btnYear{
            salaryType = "Năm"
            btnHour.backgroundColor = nil
            btnDay.backgroundColor = nil
            btnMonth.backgroundColor = nil
            btnYear.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
            return
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == tvDetalsSalary{
            if tvDetalsSalary.text == "Chi tiết lương (phụ cấp, tăng ca...)"{
                tvDetalsSalary.textColor = UIColor.black
                tvDetalsSalary.text = ""
            }
        }
        if textView == tvDetailTime{
            if tvDetailTime.text == "Chi tiết thời gian làm việc"{
                tvDetailTime.textColor = UIColor.black
                tvDetailTime.text = ""
            }
        }
        if textView == tvBenefit{
            if tvBenefit.text == "Phúc lợi (phí giao thông, buổi ăn,...)"{
                tvBenefit.textColor = UIColor.black
                tvBenefit.text = ""
            }
        }
        if textView == tvDetailFee{
            if tvDetailFee.text == "Chi tiết phí giới thiệu"{
                tvDetailFee.textColor = UIColor.black
                tvDetailFee.text = ""
            }
        }
        if textView == tvMoreInfo{
            if tvMoreInfo.text == "Yêu cầu thêm"{
                tvMoreInfo.textColor = UIColor.black
                tvMoreInfo.text = ""
            }
        }
        if textView == tvJobDetails{
            if tvJobDetails.text == "Chi tiết công việc"{
                tvJobDetails.textColor = UIColor.black
                tvJobDetails.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == tvDetalsSalary{
            if tvDetalsSalary.text == ""{
                tvDetalsSalary.textColor = UIColor.init(rgb: UNCLICKED_COLOR)
                tvDetalsSalary.text = "Chi tiết lương (phụ cấp, tăng ca...)"
            }
        }
        if textView == tvDetailTime{
            if tvDetailTime.text == ""{
                tvDetailTime.textColor = UIColor.init(rgb: UNCLICKED_COLOR)
                tvDetailTime.text = "Chi tiết thời gian làm việc"
            }
        }
        if textView == tvBenefit{
            if tvBenefit.text == ""{
                tvBenefit.textColor = UIColor.init(rgb: UNCLICKED_COLOR)
                tvBenefit.text = "Phúc lợi (phí giao thông, buổi ăn,...)"
            }
        }
        if textView == tvDetailFee{
            if tvDetailFee.text == ""{
                tvDetailFee.textColor = UIColor.init(rgb: UNCLICKED_COLOR)
                tvDetailFee.text = "Chi tiết phí giới thiệu"
            }
        }
        if textView == tvMoreInfo{
            if tvMoreInfo.text == ""{
                tvMoreInfo.textColor = UIColor.init(rgb: UNCLICKED_COLOR)
                tvMoreInfo.text = "Yêu cầu thêm"
            }
        }
        
        if textView == tvJobDetails{
            if tvJobDetails.text == ""{
                tvJobDetails.textColor = UIColor.init(rgb: UNCLICKED_COLOR)
                tvJobDetails.text = "Chi tiết công việc"
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        resizeTextView(textView)
    }
    
    func resizeTextView(_ textView: UITextView){
        if textView == tvDetalsSalary{
            let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if size.height != heightSalary.constant && size.height != textView.frame.size.height{
                heightSalary.constant = size.height
            }
        }
        if textView == tvDetailTime{
            let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if size.height != heightTime.constant && size.height != textView.frame.size.height{
                heightTime.constant = size.height
            }
        }
        if textView == tvBenefit{
            let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if size.height != heightBenefit.constant && size.height != textView.frame.size.height{
                heightBenefit.constant = size.height
            }
        }
        if textView == tvDetailFee{
            let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if size.height != heightFee.constant && size.height != textView.frame.size.height{
                heightFee.constant = size.height
            }
        }
        if textView == tvMoreInfo{
            let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if size.height != heightMoreInfo.constant && size.height != textView.frame.size.height{
                heightMoreInfo.constant = size.height
            }
        }
        
        if textView == tvJobDetails{
            let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if size.height != constantJobDetails.constant && size.height != textView.frame.size.height{
                constantJobDetails.constant = size.height
            }
        }
    }
    ////////////////////// set Up job type
    func setupViewJobType(){
        viewJobType.isUserInteractionEnabled = true
        ortherjobTopconstant.constant = 0
        constantHeightJobOrther.constant = 0
        tfOrtherJobType.layoutIfNeeded()
        let jobtypeTap = UITapGestureRecognizer(target: self, action:  #selector(jobtypeClick))
        self.viewJobType.addGestureRecognizer(jobtypeTap)
        handleOrtherJobType()
    }
    func putJobType(_ jobType: String) {
        lblJobType.text = jobType
        handleOrtherJobType()
    }
    func jobtypeClick(){
        let vc = JobListViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func handleOrtherJobType(){
        if lblJobType.text  == "Khác"{
            ortherjobTopconstant.constant = 8
            constantHeightJobOrther.constant = 30
            tfOrtherJobType.layoutIfNeeded()
        }else{
            ortherjobTopconstant.constant = 0
            constantHeightJobOrther.constant = 0
            tfOrtherJobType.layoutIfNeeded()
        }
    }

}
