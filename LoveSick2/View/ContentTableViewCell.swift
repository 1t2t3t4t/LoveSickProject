//
//  ContentTableViewCell.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ContentTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView:KMPlaceholderTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.tag = 2
        textView.textColor = UIColor.black
        textView.isScrollEnabled = false
        textView.delegate = self
        // Initialization code
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == "Your text post" && textView.textColor == UIColor.gray {
//            textView.text = ""
//            textView.textColor = UIColor.black
//        }
//        else if textView.text == "" && textView.textColor == UIColor.black {
//            textView.textColor = UIColor.gray
//            textView.text = "Your text post"
//        }
//    }

}

extension ContentTableViewCell: PostTextViewDelegate {
    func getText() -> String {
        return self.textView.text
    }
}
