//
//  MessageViewController.swift
//  LoveSick2
//
//  Created by marky RE on 22/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage
class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        //self.edgesForExtendedLayout = UIRectEdge.bottom
        self.navigationItem.title = "Chats"
        let notificationName = NSNotification.Name("FriendRequestReloadData")
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.notiRefresh(notification:)), name: notificationName, object: nil)
    }
    @objc func notiRefresh(notification:NSNotification) {
        self.tableView.reloadData()
    }
}

extension MessageViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if User.currentUser?.chatRoom != nil {
        return User.currentUser!.chatRoom.count+1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "frdrequestcell", for: indexPath)
            cell.textLabel?.text = "Friend Request"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        cell.profileImage.image = #imageLiteral(resourceName: "profileLoad")
            
            cell.chatRoom =  User.currentUser!.chatRoom[indexPath.row-1]
            cell.username.text =  User.currentUser?.chatRoom[indexPath.row-1].susername == User.currentUser?.displayName ? User.currentUser?.chatRoom[indexPath.row-1].fusername : User.currentUser?.chatRoom[indexPath.row-1].susername
        cell.message.text = User.currentUser?.chatRoom[indexPath.row-1].messages.last?.message
        cell.time.text = TimeInterval.stringFromTimeInterval( interval: ((User.currentUser?.chatRoom[indexPath.row-1].timestamp)?.toDouble()!)!) //String.stringFromTimeInterval( Double(User.currentUser?.chatRoom[indexPath.row-1].timestamp)) //User.currentUser?.chatRoom[indexPath.row-1].timestamp
        return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let viewController = FriendRequestTableViewController.newInstanceFromStoryboard() as! FriendRequestTableViewController
            viewController.hidesBottomBarWhenPushed = true
        
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
        let viewController = ChatViewController.newInstanceFromStoryboard() as! ChatViewController
        viewController.chatRoom = User.currentUser?.chatRoom[indexPath.row-1]
            viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }
        return 80
    }
    
}
