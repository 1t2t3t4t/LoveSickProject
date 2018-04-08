//
//  ViewPostViewController.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/7/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit
import Hokusai
import Firebase
class ViewPostViewController: UIViewController {

    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var upvote: UIButton!
    @IBOutlet weak var downvote: UIButton!
    @IBOutlet weak var numlikeLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var spacing: NSLayoutConstraint!
    
    @IBOutlet weak var replyTableView: UITableView!
    
    private var initialCenter = CGFloat()
    
    var post:Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpPost()
        
        let rightBth = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ViewPostViewController.report))
        self.navigationItem.rightBarButtonItem = rightBth
        self.replyTableView.delegate = self
        self.replyTableView.dataSource = self
        self.replyTableView.tableFooterView = UIView()
        self.replyTableView.reloadData()
        let tapGesture =  UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 3
        tapGesture.addTarget(self, action: #selector(dismissView))
        self.view.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeHandling))
        self.view.addGestureRecognizer(panGesture)
        self.replyTableView.addGestureRecognizer(panGesture)
    }

    @objc private func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func swipeHandling(pan: UIPanGestureRecognizer) {
        if self.post.replies.count <= 0 { return }
        let piece = pan.view!
        let translation = pan.translation(in: piece.superview)
        if pan.state == .began {
            self.initialCenter = translation.y
        }
        if pan.state != .cancelled {
            let movement = (translation.y-initialCenter)*0.1
            if movement < 0 {
                if self.replyTableView.indexPathsForVisibleRows?.last?.row == self.post.replies.count { return }
                if self.replyTableView.frame.origin.y <= 64 {
                    self.replyTableView.frame.origin.y -= movement
                    self.replyTableView.frame.size.height += movement
                }
            }else {
                if self.replyTableView.frame.origin.y <= 64 {
                    self.replyTableView.frame.origin.y += movement
                    self.replyTableView.frame.size.height -= movement
                }
                if self.spacing.constant > 0 { self.spacing.constant = 0 }
            }
            self.spacing.constant = self.spacing.constant+movement
        }
    }

    @IBAction func favoriteClicked(_ sender: Any) {
    }
    
    
    @objc private func report() {
        let hokusai = Hokusai()
        hokusai.cancelButtonTitle = "Cancel"
        hokusai.fontName = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold).fontName
        hokusai.colorScheme = HOKColorScheme.tsubaki
        hokusai.addButton("Report"){
        }
        if self.post.creatorUID == User.currentUser?.uid {
            hokusai.addButton("Delete post"){
                Database.database().reference().child("Posts/\(self.post.postuid)").removeValue()
                Database.database().reference().child("Users/\(self.post.creatorUID)/\(self.post.postuid)").removeValue()
                self.navigationController?.popViewController(animated: true)
            }
        }
        hokusai.show()
    }
    
    private func setUpPost() {
        self.usernameLabel.text = self.post.displayName
        self.detailLabel.text = "Posted \(timeAgoSince(Date(timeIntervalSince1970: self.post.createdAt!)))"
        self.title = self.post.title
        self.postTitle.text = self.post.title
        self.postContent.text = self.post.content
        self.postContent.isScrollEnabled = false
        self.numlikeLabel.text = self.post.like < 1000 ? "\(self.post.like)" : String(format: "%.1f", Double(self.post.like)/1000,"k")
        self.displayPicture.image = #imageLiteral(resourceName: "profileLoad")
    }
    
    @IBAction func gotoComment() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "postCommentView") as! CommentViewController
        view.delegate = self
        let nav = UINavigationController(rootViewController: view)
        self.present(nav, animated: true, completion: nil)
    }
}

extension ViewPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.post.replies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CommentTableViewCell
        cell.reply = self.post.replies[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}

extension ViewPostViewController: CommentViewDelegate {
    func getComment(_ text: String?) {
        guard let comment = text else { return }
        let reply = Reply(content: comment)
        PostManager.comment(withPID: self.post.postuid!, reply: reply)
        self.post.replies.append(reply)
        self.replyTableView.reloadData()
    }
}

