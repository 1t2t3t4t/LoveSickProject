//
//  TutorListTableViewCell.swift
//  Tutor
//
//  Created by marky RE on 18/3/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class DiscoverTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var username:UILabel!
    @IBOutlet weak var message:UILabel!
    @IBOutlet weak var rate:UILabel!
    var user:User? {
        didSet {
            setupCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.image = #imageLiteral(resourceName: "profileLoad").af_imageRoundedIntoCircle()
        profileImage.layer.cornerRadius = profileImage.frame.height/2.0
        profileImage.clipsToBounds = true
        username.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        message.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        rate.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)
        rate.isHidden = true
        rate.textColor = UIColor.black
        message.textColor = UIColor.gray

    }
    func setupCell() {
        
        username.text = user?.username
        let date = Date(timeIntervalSince1970: (user?.ageInterval)!)
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: currentDate)
        message.text = "Age: \(currentYear - year)"
        if let img = ImageCache.cachedImage(for: (user?.profileURL)!) {
            profileImage.image = img.af_imageRoundedIntoCircle()
        }
        Alamofire.request((user?.profileURL!)!).responseImage { response in
                if let image = response.result.value {
                    self.user?.profileImg = image
                    self.profileImage.image = image.af_imageRoundedIntoCircle()
                    ImageCache.cache(image, for: (self.user?.uid!)!)
                }
            }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

