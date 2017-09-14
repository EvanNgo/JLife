//
//  JobPartTimeCell.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/31/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit

class JobPartTimeCell: UITableViewCell {
    
    @IBOutlet weak var process: UIActivityIndicatorView!
    @IBOutlet weak var lblStation: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var viewFBMess: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var viewJmess: UIView!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var iconInfor: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageAvatar.layer.cornerRadius = 4
        imageAvatar.clipsToBounds = true
        bigView.setBorder(4)
        viewFBMess.setBorder(4)
        viewJmess.setBorder(4)
        let fbTap = UITapGestureRecognizer(target: self, action: #selector(fbMess))
        viewFBMess.addGestureRecognizer(fbTap)
        let jTap = UITapGestureRecognizer(target: self, action: #selector(jMess))
        viewJmess.addGestureRecognizer(jTap)
        viewJmess.backgroundColor = UIColor(rgb: MAIN_COLOR)
    }
    
    func fbMess(){
        print("fbMess")
    }
    
    func jMess(){
        print("jmess")
    }
}
