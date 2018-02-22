//
//  ChatTableViewCell.swift
//  LoveSick2
//
//  Created by marky RE on 22/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var username:UILabel!
    @IBOutlet weak var message:UILabel!
    @IBOutlet weak var time:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        time.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        time.textColor = UIColor.gray
        profileImage.layer.cornerRadius = profileImage.frame.height/2.0
        profileImage.clipsToBounds = true
        username.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        message.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        message.textColor = UIColor.gray
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
