//
//  ProfileHeaderView.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/27/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView
class ProfileHeaderView: GSKStretchyHeaderView {
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var username:UILabel!
    @IBOutlet weak var totalPost:UILabel!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    var imgWidth:CGFloat!
    var imgHeight:CGFloat!
    override func awakeFromNib() {
        username.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        username.textColor = UIColor.black
        username.lineBreakMode = .byWordWrapping
        username.numberOfLines = 0
        totalPost.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        totalPost.textColor = UIColor.gray
        totalPost.numberOfLines = 0
        totalPost.lineBreakMode = .byWordWrapping
        imageView.layer.cornerRadius = imageView.frame.height/2.0
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "profileLoad")
        imgWidth = imageView.frame.width
        imgHeight = imageView.frame.height
        print("stretchFactor \(imageView.frame.width) \(imageView.frame.height)")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        super.didChangeStretchFactor(stretchFactor)
        
        let fontSizeUsername = CGFloatTranslateRange(min(1, stretchFactor), 0, 1,18, 28)
        let fontSizePost = CGFloatTranslateRange(min(1, stretchFactor), 0, 1,14, 24)
        if abs(fontSizeUsername - self.username.font.pointSize) > 0.05 { // to avoid changing the font too often, this could be more precise though
            self.username.font = UIFont.monospacedDigitSystemFont(ofSize: fontSizeUsername, weight: UIFont.Weight.heavy)
            self.totalPost.font = UIFont.monospacedDigitSystemFont(ofSize: fontSizePost, weight: UIFont.Weight.heavy)
            var factor:CGFloat = 0.0
            factor = stretchFactor
            if stretchFactor > 1.0 {
                factor = 1.0
            }
            else if stretchFactor < 0.65 {
                factor = 0.65
            }
           
            imageViewHeight.constant = round( imgHeight * factor)
            imageViewWidth.constant = round(imgWidth * factor)
            imageView.layer.cornerRadius = round(imgWidth * factor)/2.0
             print("stretchFactor \(imageView.frame.width)) \(imageView.frame.height))")
           // self.imageView.frame = CGRect(x: self.imageView.frame.origin.x, y: self.imageView.frame.origin.y, width: imgWidth * factor, height: imgHeight * factor)
            
            
            
        }
    }
}
