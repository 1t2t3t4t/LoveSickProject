//
//  CommentTableViewCell.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/8/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var display: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var content: UILabel!
    
    var reply:Reply?{
        didSet{
            self.displayName.text = reply?.displayName
            self.content.text = reply?.content
            self.display.image = #imageLiteral(resourceName: "profileLoad")
        }
    }

}
