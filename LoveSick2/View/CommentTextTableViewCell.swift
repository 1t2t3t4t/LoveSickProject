//
//  CommentTextTableViewCell.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/8/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit

class CommentTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textView:UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.text = "Your Comment.."
        textView.tag = 2
        textView.textColor = UIColor.gray
        textView.isScrollEnabled = false
    }

}

