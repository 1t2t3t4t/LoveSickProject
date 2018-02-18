//
//  PostTextViewController.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit

protocol PostTextViewDelegate:class {
    func getText() -> String
}

class PostTextViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    weak var titleDelegate:PostTextViewDelegate?
    weak var contentDelegate:PostTextViewDelegate?
    
    var contentCell: UITableViewCell = UITableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let leftBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(PostTextViewController.dismissView))
        let rightBtn = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(PostTextViewController.post))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = rightBtn
        self.navigationItem.title = "Text Post"
         tableView.tableFooterView = UIView()

    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        guard let title = self.titleDelegate?.getText() else {
            return
        }
        guard let content = self.contentDelegate?.getText() else {
            return
        }
        PostManager.post(title: title, content: content, isAnonymous: false)
        self.dismiss(animated: true, completion: nil)
    }

}
extension PostTextViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! ChooseCategoryTableViewCell
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as!
            TitleTableViewCell
            self.titleDelegate = cell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as!
            ContentTableViewCell
            self.contentDelegate = cell
            contentCell = cell
            cell.textView.delegate = self
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        }
        else if indexPath.row == 1 {
            return 100
        }
        else{
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension PostTextViewController:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 1 {
            let currentOffset = tableView.contentOffset
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.setContentOffset(currentOffset, animated: false)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Your text post" && textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        else if textView.text == "" && textView.textColor == UIColor.black {
            textView.textColor = UIColor.gray
            textView.text = "Your text post"
        }
    }
  
}

