//
//  CommentViewController.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/8/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit


protocol CommentViewDelegate:class {
    func getComment(_ text:String?) -> Void
}

class CommentViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    weak var delegate:CommentViewDelegate?
    var contentCell: CommentTextTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CommentViewController.closeView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(CommentViewController.postComment))
    }
    
    @objc func closeView() {
        self.delegate?.getComment(nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func postComment() {
        self.delegate?.getComment(self.contentCell.textView.text)
        closeView()
    }
    
}
extension CommentViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentTitleCell", for: indexPath) as! CommentTitleTableViewCell
            cell.titleLabel.text = " Title"
            return cell
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentTextCell", for: indexPath) as!
            CommentTextTableViewCell
            contentCell = cell
            cell.textView.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension CommentViewController:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 2 {
            let currentOffset = tableView.contentOffset
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.setContentOffset(currentOffset, animated: false)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Your Comment.." && textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        else if textView.text == "" && textView.textColor == UIColor.black {
            textView.textColor = UIColor.gray
            textView.text = "Your comment.."
        }
    }
    
}

