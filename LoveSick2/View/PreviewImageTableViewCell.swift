//
//  PreviewImageTableViewCell.swift
//  LoveSick2
//
//  Created by marky RE on 23/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
protocol PreviewImageTableViewCellDelegate:class {
    func deletePhoto() -> Void
}
class PreviewImageTableViewCell: UITableViewCell {
    @IBOutlet weak var contentImg:UIImageView!
    @IBOutlet weak var delete:UIButton!
    
    weak var delegate:PreviewImageTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        delete.backgroundColor = UIColor.gray
        delete.layer.cornerRadius = delete.frame.size.height/2.0
        delete.clipsToBounds = true
        delete.setTitle("", for: .normal)
        delete.setImage(UIImage(named:"delete"), for: .normal)
        delete.tintColor = UIColor.white
        contentImg.contentMode = .scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                contentImg.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                contentImg.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    func setCustomImage(image : UIImage) {
        
        let aspect = image.size.width / image.size.height
        
        let constraint = NSLayoutConstraint(item: contentImg, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: contentImg, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        
        aspectConstraint = constraint
        
        contentImg.image = image
    }
    @IBAction func deletePhoto() {
        self.delegate?.deletePhoto()
    }

}
