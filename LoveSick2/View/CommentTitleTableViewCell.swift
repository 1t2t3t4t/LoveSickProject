//
//  CommentTitleTableViewCell.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/8/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit

class CommentTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        // Initialization code
    }

}
