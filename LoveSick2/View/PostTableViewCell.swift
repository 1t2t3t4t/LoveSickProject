//
//  TopPostTableViewCell.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
class PostTableViewCell: UITableViewCell,UITextViewDelegate{
    
    @IBOutlet weak var profileImg:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var category:UILabel!
    @IBOutlet weak var more:UIButton!
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var upvote:UIButton!
    @IBOutlet weak var downvote:UIButton!
    @IBOutlet weak var numvote:UILabel!
    @IBOutlet weak var comment:UIButton!
    @IBOutlet weak var share:UIButton!
    
    var post:Post! {
        didSet{
            self.setUpCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        profileImg.image = #imageLiteral(resourceName: "profileLoad")
        numvote.textAlignment = .center
        numvote.textColor = UIColor.lightGray
        more.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        more.tintColor = UIColor.gray
        more.tintColor = UIColor.gray
        more.setTitle("", for: .normal)
        upvote.setImage(#imageLiteral(resourceName: "upvote"), for: .normal)
        upvote.tintColor = UIColor.lightGray
        upvote.setTitle("", for: .normal)
        downvote.setImage(#imageLiteral(resourceName: "downvote"), for: .normal)
        downvote.tintColor = UIColor.lightGray
        downvote.setTitle("", for: .normal)
        category.text = "Category"
        addattributeText(button:comment,image: #imageLiteral(resourceName: "message"),text: " 0")
        comment.tintColor = UIColor.gray
        addattributeText(button:share,image: #imageLiteral(resourceName: "share"),text: " Share")
        share.tintColor = UIColor.gray
        
    }

    func setUpCell() {
        self.title.text = self.post.title
        self.name.text = self.post.displayName
        let numLike = self.post.like >  999 ? "\(self.post.like/1000)k" : "\(self.post.like)"
        addattributeText(button:comment,image: #imageLiteral(resourceName: "message"),text: " \(self.post.replies.count)")
        self.numvote.text = numLike
    }
    
    @IBAction func upVote(_ sender: Any) {
        PostManager.upvote(postuid: self.post.postuid!) { (error) in
            if error != nil {
                self.upvote.tintColor = UIColor.green
                self.post.like += 1
                self.numvote.text = "\(self.post.like)"
            }
        }
    }
    
    @IBAction func downVote(_ sender: Any) {
        PostManager.downvote(postuid: self.post.postuid!) { (error) in
            if error != nil {
                self.downvote.tintColor = UIColor.red
                self.post.like -= 1
                self.numvote.text = "\(self.post.like)"
            }
        }
    }
    
    
    func addattributeText(button:UIButton,image:UIImage,text:String) {
        let fullString = NSMutableAttributedString(string: "")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = image
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        let textStr = NSAttributedString(string: text)
        fullString.append(textStr)
        button.setAttributedTitle(fullString, for: .normal)
    }
    
}
