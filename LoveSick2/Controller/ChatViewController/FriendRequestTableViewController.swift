//
//  FriendRequestTableViewController.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/28/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import Alamofire

class FriendRequestTableViewController: UITableViewController {

    private var friendrequest:[User] = []
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.hidesBackButton = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendrequest = User.currentUser.friendrequest
        UserManager.queryFriendrequest { (users) in
            self.friendrequest = users!
            self.tableView.reloadData()
        }
        self.tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.friendrequest.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendrequestcell", for: indexPath) as! FriendRequestTableViewCell
        cell.username.text = self.friendrequest[indexPath.row].displayName!
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadData()
    }
}

extension FriendRequestTableViewController:FriendRequestTableViewCellDelegate {
    
    func addFriend(row: Int,cell:FriendRequestTableViewCell) {
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y:0, width: 80, height: 80))
        activity.center = CGPoint(x: self.view.center.x, y: self.view.center.y - (self.navigationController?.navigationBar.frame.height)! - 40)
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.hidesWhenStopped = true
        activity.backgroundColor = UIColor.gray
        activity.layer.cornerRadius = 5
        activity.clipsToBounds = true
        self.tableView.addSubview(activity)
        self.tableView.bringSubview(toFront: activity)
        activity.startAnimating()
        ChatRoomManager.createChatRoom(fuid: User.currentUser.uid!, suid: self.friendrequest[row].uid!,completion:{success in
            activity.stopAnimating()
            if !success {
                let alert = UIAlertController(title: "Error", message: "Cannot accept friend request, please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in
                    alert.dismiss(animated: true, completion: nil)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                User.currentUser?.friendrequest.remove(at: row)
                cell.add.setTitle("Accepted", for: .normal)
                let notificationName = NSNotification.Name("FriendRequestReloadData")
                NotificationCenter.default.post(name: notificationName, object: nil)
                cell.add.backgroundColor = UIColor.gray
            }
        })
    }
    
    func cancelRequest(row: Int,cell:FriendRequestTableViewCell) {
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y:0, width: 80, height: 80))
        activity.center = CGPoint(x: self.view.center.x, y: self.view.center.y - (self.navigationController?.navigationBar.frame.height)! - 40)
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.hidesWhenStopped = true
        activity.backgroundColor = UIColor.gray
        activity.layer.cornerRadius = 5
        activity.clipsToBounds = true
        self.view.addSubview(activity)
        self.view.bringSubview(toFront: activity)
        activity.startAnimating()
        Database.database().reference().child("Users/\(User.currentUser!.uid)/FriendRequests/\(self.friendrequest[row].uid!)").removeValue(completionBlock: {(error,ref) in
            activity.stopAnimating()
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Cannot cancel friend request, please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in
                    alert.dismiss(animated: true, completion: nil)}))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.friendrequest.remove(at: row)
                let notificationName = NSNotification.Name("FriendRequestReloadData")
                NotificationCenter.default.post(name: notificationName, object: nil)
                self.tableView.reloadData()
            
            }
        })
    }
}

