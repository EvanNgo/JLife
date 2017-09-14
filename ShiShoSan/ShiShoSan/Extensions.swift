//
//  Extensions.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/28/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func downloadedFrom(_ urlString: String,_ view:UIView?) {
        if urlString == "" {
            return
        }
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        if view != nil{
            view?.isHidden = false
        }
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                    if view != nil{
                        view?.isHidden = true
                    }
                }
            })
        }).resume()
    }
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    
}



extension UIImage {
    func setCoverImage() -> UIImage {
        print("setCoverImage")
        guard let cgimage = self.cgImage else { return self }
        let contextImage: UIImage = UIImage(cgImage:cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cropWidth: CGFloat = self.size.width
        var cropHeight: CGFloat = self.size.height
        let aspectSize:CGFloat = 2.5
        if (self.size.width/self.size.height) > 2.5 {
            cropHeight = contextSize.height
            cropWidth = contextSize.height * aspectSize
            posX = (contextSize.width - cropWidth) / 2
        } else {
            cropWidth = contextSize.width
            cropHeight = contextSize.width / aspectSize
            posY = (contextSize.height - cropHeight) / 2
        }
        let rect: CGRect = CGRect(x:posX,y:posY,width: cropWidth,height: cropHeight)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        UIGraphicsBeginImageContextWithOptions(CGSize(width:cropWidth,height:cropHeight), true, self.scale)
        cropped.draw(in: CGRect(x:0,y: 0,width: cropWidth,height: cropHeight))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized!
    }
    func setAvatar() -> UIImage{
        print("setAvatar")
        guard let cgimage = self.cgImage else { return self }
        let contextImage: UIImage = UIImage(cgImage:cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cropWidth: CGFloat = self.size.width
        var cropHeight: CGFloat = self.size.height
        if cropWidth > cropHeight{
            cropHeight = contextSize.height
            cropWidth = contextSize.height
            posX = (contextSize.width - cropWidth) / 2
        } else {
            cropWidth = contextSize.width
            cropHeight = contextSize.width
            posY = (contextSize.height - cropHeight) / 2
        }
        let rect: CGRect = CGRect(x:posX,y:posY,width: cropWidth,height: cropHeight)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        UIGraphicsBeginImageContextWithOptions(CGSize(width:cropWidth,height:cropHeight), true, self.scale)
        cropped.draw(in: CGRect(x:posX,y: posY,width: cropWidth,height: cropHeight))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized!
    }
    
    func resizeImage() -> UIImage? {
        var scaleWidth:CGFloat = 540
        var scaleHeight:CGFloat = 960
        let width = self.size.width
        let height = self.size.height
        if width > 540{
            let scale = scaleWidth / width
            scaleHeight = height * scale
        }
        if height > 960{
            let scale = scaleHeight / height
            scaleWidth = width * scale
        }
        UIGraphicsBeginImageContext(CGSize(width: scaleWidth, height: scaleHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: scaleWidth, height: scaleHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension String{
    func saveToFireBase(key:String){
        let mReference = FIRDatabase.database().reference().child("lines").child(key).child("sta_ids")
        let values : [String:AnyObject] = ["sta_id":self as AnyObject]
        mReference.updateChildValues(values)
    }
    
    func saveLocationJob(key : String){
        let mReference = FIRDatabase.database().reference().child("job").child(key).child("locations")
        let values : [String:AnyObject] = ["id":self as AnyObject]
        mReference.childByAutoId().updateChildValues(values)
    }
    
    func saveImageJob(key : String){
        let mReference = FIRDatabase.database().reference().child("job").child(key).child("images")
        let values : [String:AnyObject] = ["link":self as AnyObject]
        mReference.childByAutoId().updateChildValues(values)
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
    }
}

extension UIView{
    func setBorder(_ number:CGFloat){
        self.layer.cornerRadius = number
        self.clipsToBounds = true	
    }
    func setCircle(){
        self.layer.cornerRadius = self.bounds.width/2
        self.clipsToBounds = true
    }
}





extension UInt {
    var toInt: Int { return Int(self) }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}




////// xoa trung 
//var mList = DataManagar.shared.querryAllStation()
//while mList.count > 0 {
//    var have:Bool = false
//    let sta = mList[0]
//    mList.remove(at: 0)
//    var j = 0
//    while mList.count > j {
//        if sta.name == mList[j].name {
//            listStations.append(mList[j])
//            mList.remove(at: j)
//            have = true
//            
//        }else{
//            j += 1
//        }
//    }
//    if have {
//        listStations.append(sta)
//    }
//}
//listStations = listStations.sorted(by: { $0.name > $1.name })
//listLine = DataManagar.shared.querryLine()
//var stringCode = ""
//while listStations.count > 0 {
//    let mStation = listStations[0]
//    //            stringCode = "\(stringCode)@@@@@\(mStation.id)"
//    listStations.remove(at: 0)
//    var i = 0
//    while listStations.count > i {
//        if mStation.name == listStations[0].name{
//            stringCode = "\(stringCode)$_$_$_$\(listStations[0].id)"
//            for i in 0 ..< listLine.count{
//                listLine[i].sta_ids = listLine[i].sta_ids.replacingOccurrences(of: listStations[0].id, with: mStation.id)
//            }
//            listStations.remove(at: 0)
//        }else{
//            i = listStations.count + 1
//        }
//        
//    }
//}
//for i in 0 ..< listLine.count{
//    _ = DataManagar.shared.updateLine(newLine: listLine[i])
//}
//print(stringCode)


















