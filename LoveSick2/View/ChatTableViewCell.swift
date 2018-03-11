//
//  ChatTableViewCell.swift
//  LoveSick2
//
//  Created by marky RE on 22/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Firebase
class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var username:UILabel!
    @IBOutlet weak var message:UILabel!
    @IBOutlet weak var time:UILabel!
    var chatRoom:ChatRoom! {
        didSet {
            setupCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        time.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        time.textColor = UIColor.gray
        profileImage.layer.cornerRadius = profileImage.frame.height/2.0
        profileImage.clipsToBounds = true
        username.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        message.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        time.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        message.textColor = UIColor.gray
       
        
        
        // Initialization code
    }
    func setupCell() {
        
        guard let uid = (chatRoom?.fuid == User.currentUser?.uid ? self.chatRoom?.suid:self.chatRoom?.fuid) else {
            return
        }
        Database.database().reference().child("Users/\(uid)/profileURL").observeSingleEvent(of: .value, with: {snap in
            if snap.exists() {
                print("snap exist man")
                guard let url = snap.value as? String else {
                    print("snap exist man url fail")
                    return
                }
                print("snap exist man url fin")
                        self.profileImage.af_setImage(withURL: URL(string: url)!, placeholderImage: #imageLiteral(resourceName: "grayBackground"), filter: nil, progress: {progress in
                        }
                            , imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: {(response) in
                                if let image = response.result.value{
                                    User.currentUser.chatRoom[ChatRoom.getIndex(uid: self.chatRoom.chatRoomUID!)].simg = image
                                    }
                                     //self.chatRoom.sprofileImg = image
                                })
                self.profileImage.af_setImage(withURL: URL(string: url)!)
            }
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
