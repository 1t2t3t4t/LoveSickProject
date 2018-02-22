//
//  ChoosePhotoTableViewCell.swift
//  LoveSick2
//
//  Created by marky RE on 22/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
protocol ChoosePhotoTableViewCellDelegate:class {
    func chooseImage() -> Void
}
class ChoosePhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var photoButton:UIButton!
    @IBOutlet weak var cameraLabel:UILabel!
    weak var delegate:ChoosePhotoTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        cameraLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
        cameraLabel.text = "Upload photo"
        cameraLabel.textAlignment = .center
        photoButton.backgroundColor = UIColor.gray
        photoButton.layer.cornerRadius = photoButton.frame.height/2.0
        photoButton.clipsToBounds = true
        photoButton.setImage(UIImage(named:"camera"), for: .normal)
        photoButton.tintColor = UIColor.white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func chooseImage(_ sender:Any) {
        self.delegate?.chooseImage()
    }

}
