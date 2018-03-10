//
//  PostImageTableViewCell.swift
//  LoveSick2
//
//  Created by marky RE on 22/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage
import KDCircularProgress
protocol PostImageTableViewCellDelegate: class {
    func report() -> Void
}
class PostImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImg:UIImageView!
    @IBOutlet weak var progressView:KDCircularProgress!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var contentImg:UIImageView!
    @IBOutlet weak var category:UILabel!
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var more:UIButton!
    @IBOutlet weak var upvote:UIButton!
    @IBOutlet weak var downvote:UIButton!
    @IBOutlet weak var numvote:UILabel!
    @IBOutlet weak var comment:UIButton!
    @IBOutlet weak var share:UIButton!
    
     weak var delegate:PostTableViewCellDelegate?
    
    var post:Post! {
        didSet{
            self.setUpCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.glowMode = .noGlow
        name.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        name.textColor = UIColor.gray
        name.isUserInteractionEnabled = true
        name.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostImageTableViewCell.showProfile)))
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
        profileImg.image = #imageLiteral(resourceName: "profileLoad")
        profileImg.contentMode = .scaleAspectFill
        numvote.textAlignment = .center
        numvote.textColor = UIColor.gray
        more.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        more.tintColor = UIColor.gray
        more.tintColor = UIColor.gray
        profileImg.layer.cornerRadius = profileImg.frame.size.height/2.0
        profileImg.clipsToBounds = true
        more.setTitle("", for: .normal)
        upvote.setImage(#imageLiteral(resourceName: "upvote"), for: .normal)
        upvote.tintColor = UIColor.lightGray
        upvote.setTitle("", for: .normal)
        downvote.setImage(#imageLiteral(resourceName: "downvote"), for: .normal)
        downvote.tintColor = UIColor.lightGray
        downvote.setTitle("", for: .normal)
        category.text = "Category"
        category.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        category.textColor = UIColor.gray
        addattributeText(button:comment,image: #imageLiteral(resourceName: "message"),text: " 0")
        comment.tintColor = UIColor.gray
        addattributeText(button:share,image: #imageLiteral(resourceName: "share"),text: " Share")
        share.tintColor = UIColor.gray
       
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
        self.profileImg.image = nil
        self.name.text = ""
        self.title.text = ""
        self.category.text = ""
        self.numvote.text = ""
        self.contentImg.image = nil
    }
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                contentImg.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                contentImg.addConstraint(aspectConstraint!)
            }
        }
    }
    

    
    func setCustomImage(image : UIImage) {
        aspectConstraint = nil
        let aspect = image.size.width / image.size.height
        let constraint = NSLayoutConstraint(item: contentImg, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: contentImg, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        aspectConstraint = constraint
        contentImg.image = image
        }
    
    func setUpCell() {
        
        self.name.text = self.post.displayName
        self.title.text = self.post.title
        let numLike = self.post.like >  999 ? "\(self.post.like/1000)k" : "\(self.post.like)"
        addattributeText(button:comment,image: #imageLiteral(resourceName: "message"),text: " \(self.post.replies.count)")
        self.numvote.text = numLike
        setCustomImage(image: #imageLiteral(resourceName: "grayBackground"))
        if let img = ImageCache.cachedImage(for: self.post.imageURL!) {
            self.contentImg.image = img
            self.setCustomImage(image: img)
            return
        }
        self.contentImg.af_setImage(withURL: URL(string:self.post.imageURL!)!, placeholderImage: #imageLiteral(resourceName: "grayBackground"), filter: nil, progress: {progress in
                            self.progressView.angle = progress.fractionCompleted*360.0
                        }
                            , imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: {(response) in
                                self.progressView.isHidden = true
                                if let image = response.result.value{
                                    ImageCache.cache(image, for: self.post.imageURL!)
                                    self.contentImg.image = image
                                    self.setCustomImage(image: image)
                                }
                                
        })
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
    @IBAction func report(_ sender:Any) {
        self.delegate?.report()
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
    @objc func showProfile(sender:UITapGestureRecognizer) {
        print("hello world showprofile")
        guard let uid = self.post.creatorUID else {
            return
        }
        self.delegate?.showProfile(uid:uid)
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
//    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
//        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.font = font
//        label.text = text
//        label.sizeToFit()
//
//        return label.frame.height
//    }
    
}

