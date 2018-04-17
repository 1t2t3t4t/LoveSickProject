//
//  AgeRangeTableViewCell.swift
//  Tutor
//
//  Created by marky RE on 21/3/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import RangeSeekSlider
class AgeRangeTableViewCell: UITableViewCell {

    @IBOutlet weak var ageRangeSlider: RangeSeekSlider!
    @IBOutlet weak var title:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        title.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.heavy)
        ageRangeSlider.colorBetweenHandles = UIColor.blue
        
        ageRangeSlider.handleDiameter = 24.0
        ageRangeSlider.handleColor = UIColor.blue
        ageRangeSlider.lineHeight = 6.0
        ageRangeSlider.minLabelColor = UIColor.gray
        ageRangeSlider.maxLabelColor = UIColor.gray
        ageRangeSlider.maxLabelFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        ageRangeSlider.minLabelFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        ageRangeSlider.tintColor = UIColor.init(white: 0.7, alpha: 0.5)
        setupCell()
        // Initialization code
    }
    func setupCell() {
            ageRangeSlider.minValue = 20
            ageRangeSlider.maxValue = 60
            ageRangeSlider.minDistance = 2.0
            ageRangeSlider.selectedMaxValue = 35
            ageRangeSlider.selectedMinValue = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
