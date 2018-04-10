//
//  DetailTableViewCell.swift
//  Tutor
//
//  Created by marky RE on 22/3/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var rightLabel:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.frame = CGRect(x: (self.textLabel?.frame.origin.x)!, y:(self.textLabel?.frame.origin.y)!, width: 150, height: 21)
        rightLabel.text = ""
        rightLabel.textColor = UIColor.gray
        rightLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
