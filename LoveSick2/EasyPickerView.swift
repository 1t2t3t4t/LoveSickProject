//
//  EasyPickerView.swift
//  LoveSick2
//
//  Created by Nathakorn on 3/24/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit

protocol EasyPickerDelegate: class {
    func didSelectCell(_ easyPickerView:EasyPickerView, at indexPath:IndexPath)
}

class EasyPickerView: UITableView {

    private var fullSizeFrame:CGRect!
    private var smallSizeFrame:CGRect!
    private var isToggled:Bool = false
    
    weak var easyDelegate:EasyPickerDelegate?
    
    var selectedValue:PostCategory = .Generic
    
    private var categorySet:[PostCategory] = []//[ [.Generic,.HealthProblem,.LovingProblem]]
    
    override init(frame: CGRect, style: UITableViewStyle) {
        self.fullSizeFrame = CGRect(x: frame.origin.x, y: frame.origin.y+64+(2*frame.height), width: frame.width, height: 44*3)
        self.smallSizeFrame = CGRect(x: frame.origin.x, y: frame.origin.y+64+(2*frame.height), width: frame.width, height: 0)
        super.init(frame: self.smallSizeFrame, style: style)
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
    }
    
    func toggleView() {
        if isToggled {
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = self.smallSizeFrame
            })
        }else {
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = self.fullSizeFrame
            })
        }
        self.isToggled = !self.isToggled
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EasyPickerView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(forAutoLayout: ())
        cell.textLabel?.text = self.categorySet[indexPath.row].rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedValue = self.categorySet[indexPath.row]
        self.easyDelegate?.didSelectCell(self, at: indexPath)
        self.toggleView()
    }
}
