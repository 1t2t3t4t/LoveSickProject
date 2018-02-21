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
    
    var style:choosingStyle!{
        didSet{
            self.setUp()
        }
    }
    
    weak var delegate:ChoosingStyleDelegate?
    
    private var switcher:UISwitch?
    
    private func setUp() {
        if self.style == .anonymous {
            self.switcher = UISwitch(frame: self.bounds)
            self.switcher?.frame.origin.x += 10
            self.switcher?.frame.origin.y += -((self.switcher?.frame.origin.y)!/2)+(self.switcher?.frame.size.height)!/2
            self.switcher?.addTarget(self, action: #selector(stateChange), for: .valueChanged)
            self.addSubview(self.switcher!)
        }
    }
    
    @objc private func stateChange() {
        self.delegate?.anonymousChanged(self.switcher!.isOn)
    }

}
