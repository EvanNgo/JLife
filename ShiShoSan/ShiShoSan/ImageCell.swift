//
//  ImageCell.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 8/15/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var viewCover: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    func configureImage (_ image:UIImage){
        imageView.image = image
    }
}
