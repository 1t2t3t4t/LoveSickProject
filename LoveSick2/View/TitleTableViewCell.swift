//
//  TitleTableViewCell.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class TitleTableViewCell: UITableViewCell,UITextViewDelegate {
    
    @IBOutlet weak var textView:KMPlaceholderTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        //textView.delegate = self
        textView.isScrollEnabled = false
        
        textView.tag = 1
        // Initialization code
    }

//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == "Title" && textView.textColor == UIColor.gray {
//            textView.text = ""
//            textView.textColor = UIColor.black
//        }
//        else if textView.text == "" && textView.textColor == UIColor.black {
//            textView.textColor = UIColor.gray
//            textView.text = "Title"
//        }
//    }

}

extension TitleTableViewCell: PostTextViewDelegate {
    func getText() -> String {
        return self.textView.text
    }
}
