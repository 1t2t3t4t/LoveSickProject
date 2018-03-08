//
//  FriendRequestTableViewCell.swift
//  LoveSick2
//
//  Created by Nathakorn on 3/7/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Firebase
protocol FriendRequestTableViewCellDelegate:class {
    func addFriend(row:Int,cell:FriendRequestTableViewCell) -> Void
    func cancelRequest(row:Int,cell:FriendRequestTableViewCell) -> Void
}
class FriendRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var add:UIButton!
    @IBOutlet weak var cancel:UIButton!
    @IBOutlet weak var username:UILabel!
    var user:User!
    var indexPath:IndexPath!
    weak var delegate:FriendRequestTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2.0
        profileImage.clipsToBounds = true
        profileImage.image = #imageLiteral(resourceName: "profileLoad")
        username.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        add.backgroundColor = UIColor.red
        cancel.backgroundColor = UIColor.gray
        add.tintColor = UIColor.white
        add.layer.cornerRadius = 5.0
        add.addTarget(self, action: #selector(FriendRequestTableViewCell.addFriend), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(FriendRequestTableViewCell.cancelRequest), for: .touchUpInside)
        cancel.layer.cornerRadius = 5.0
        cancel.tintColor = UIColor.white
        add.setTitle("Accept", for: .normal)
        add.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        cancel.setTitle("Cancel", for: .normal)
//        Database.database().reference().child("Users/\(self.user.uid)/")
//        self.profileImage.af_setImage(withURL: URL(string:self.user.profileURL!)!, placeholderImage: #imageLiteral(resourceName: "grayBackground"), filter: nil, progress: {progress in
//        }
//            , imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: {(response) in
////                if let image = response.result.value{
////                }
//
//        })
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func addFriend() {
        
        self.delegate?.addFriend(row: self.indexPath.row,cell: self)
        
    }
    @objc func cancelRequest() {
        self.delegate?.cancelRequest(row: self.indexPath.row,cell: self)
    }

}
