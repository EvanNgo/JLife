//
//  ExpandableHeaderView.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/30/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header:ExpandableHeaderView,section:Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate : ExpandableHeaderViewDelegate?
    var section : Int!
    let customView = UIView()
    let textlb = UILabel()
    let imageView = UIImageView()
    func customInit(title:String, section: Int,delegate:ExpandableHeaderViewDelegate){
        self.textlb.text = title
        self.section = section
        self.delegate = delegate
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectHeaderAction(gestureRecognizer:UITapGestureRecognizer){
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        customView.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height-2)
        customView.backgroundColor = UIColor.init(rgb: MAIN_COLOR)
        customView.layer.cornerRadius = 5
        customView.clipsToBounds = true
        imageView.frame = CGRect(x: customView.bounds.width - 31, y: customView.bounds.height/2-13, width: 26, height: 26)
        imageView.image = UIImage(named: "icon_expandable")
        customView.addSubview(imageView)
        textlb.frame = CGRect(x: 2, y: customView.bounds.height/2-15, width: customView.bounds.width - 40, height: 30)
        textlb.textColor = UIColor.white
        customView.addSubview(textlb)
        self.contentView.addSubview(customView)
        
    }

}
