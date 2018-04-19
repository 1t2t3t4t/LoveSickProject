//
//  ChooseCategoryTableViewCell.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit

enum choosingStyle {
    case category
    case anonymous
}

protocol ChoosingStyleDelegate: class {
    func anonymousChanged(_ value:Bool) -> Void
    func categorySelected(_ value:String) -> Void
}

class ChoosingTableViewCell: UITableViewCell {
    @IBOutlet weak var switcher:UISwitch!
    @IBOutlet weak var label:UILabel!
    var style:choosingStyle!{
        didSet{
            self.setUp()
        }
    }
    
    weak var delegate:ChoosingStyleDelegate?
    
    private func setUp() {
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        if self.style == .anonymous {
            label.text = "Post anonymously"
            switcher.isOn = false
            switcher.addTarget(self, action: #selector(stateChange), for: .valueChanged)
        }
        else{
            switcher.isHidden = true
            label.text = "Choose Category"
            
        }
    }
    
    @objc private func stateChange() {
        self.delegate?.anonymousChanged(self.switcher!.isOn)
    }

}
