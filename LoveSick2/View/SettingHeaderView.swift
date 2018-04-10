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
        username.numberOfLines = 0
        username.lineBreakMode = .byWordWrapping
        self.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
       profileImage.layer.cornerRadius = profileImage.frame.height/2.0
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.image = User.currentUser.profileImg != nil ? User.currentUser.profileImg : #imageLiteral(resourceName: "profileLoad")//.af_imageRoundedIntoCircle()
        editProfile.setTitle("Change Profile Picture", for: .normal)
       // editProfile.isHidden = true
        username.isHidden = true
        editProfile.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        if let profileimg = ImageCache.cachedImage(for: Auth.auth().currentUser!.uid) {
            self.profileImage.image = profileimg
            User.currentUser.profileImg = profileimg
            
        }
        Database.database().reference().child("Users/\(User.currentUser!.uid!)/profileURL").observeSingleEvent(of: .value, with: {snap in
            if snap.exists() {
                print("snap exist man")
            guard let url = snap.value as? String else {
                print("snap exist man url fail")
                return
            }
               // self.profileImage.af_setImage(withURL: URL(string: url)!)
                
                self.profileImage.af_setImage(withURL: URL(string: url)!, placeholderImage: #imageLiteral(resourceName: "profileLoad"), filter: nil, progress: nil, imageTransition: .noTransition, runImageTransitionIfCached: true, completion: {response in
                    if let image = response.result.value {
                        self.profileImage.image = image.af_imageRoundedIntoCircle()
                        User.currentUser.profileImg = image
                            ImageCache.cache(self.profileImage.image!, for: User.currentUser!.uid!)
                    }
                    else{
                        print("damn sad \(response.result)")
                    }

                })
            //self.profileImage.af_setImage(withURL: URL(string: url)!)
            }
        })
        
    }
    @IBAction func edit() {
        self.delegate?.edit()
    }

    

}
