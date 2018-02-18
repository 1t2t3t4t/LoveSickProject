//
//  TitleTableViewCell.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell,UITextViewDelegate {
    @IBOutlet weak var textView:UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.text = "Title"
        textView.textColor = UIColor.gray
        textView.delegate = self
        // Initialization code
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Title" && textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        else if textView.text == "" && textView.textColor == UIColor.black {
            textView.textColor = UIColor.gray
            textView.text = "Title"
        }
    }

}

extension TitleTableViewCell: PostTextViewDelegate {
    func getText() -> String {
        return self.textView.text
    }
}
