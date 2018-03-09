//
//  SettingHeaderView.swift
//  LoveSick2
//
//  Created by Nathakorn on 3/9/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import Alamofire
protocol SettingHeaderViewDelegate:class {
    func edit() -> Void
}
class SettingHeaderView: UIView{
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var editProfile:UIButton!
    @IBOutlet weak var username:UILabel!
    weak var delegate:SettingHeaderViewDelegate?
    //    @IBOutlet weak var profileImageHeight: NSLayoutConstraint!
//    @IBOutlet weak var profileImageWidth: NSLayoutConstraint!
    
    //    @IBOutlet weak var : NSLayoutConstraint!
//    @IBOutlet weak var yyy: NSLayoutConstraint!
//    @IBOutlet weak var profileImageWidth: NSLayoutConstraint!
//    @IBOutlet weak var profileImageHeight: NSLayoutConstraint!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        username.text = User.currentUser?.displayName
        username.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.heavy)
        username.textColor = UIColor.black
        self.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1.0)
        profileImage.layer.cornerRadius = profileImage.frame.height/2.0
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.image = #imageLiteral(resourceName: "profileLoad")
        editProfile.setTitle("Edit", for: .normal)
        editProfile.titleLabel?.font =  UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        Database.database().reference().child("Users/\(User.currentUser!.uid!)/profileURL").observeSingleEvent(of: .value, with: {snap in
            if snap.exists() {
                print("snap exist man")
            guard let url = snap.value as? String else {
                print("snap exist man url fail")
                return
            }
                print("snap exist man url fin")
            self.profileImage.af_setImage(withURL: URL(string: url)!)
            }
        })
        
    }
    @IBAction func edit() {
        self.delegate?.edit()
    }

    

}
