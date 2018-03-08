//
//  MessageViewController.swift
//  LoveSick2
//
//  Created by marky RE on 22/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.navigationItem.title = "Chats"
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
        cell.username.text = User.currentUser?.chatRoom[indexPath.row-1].userUID
        cell.message.text = User.currentUser?.chatRoom[indexPath.row-1].messages.last?.message
        cell.time.text = "14:26"
        return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let viewController = FriendRequestTableViewController.newInstanceFromStoryboard() as! FriendRequestTableViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
        let viewController = ChatViewController.newInstanceFromStoryboard() as! ChatViewController
        viewController.chatRoom = User.currentUser?.chatRoom[indexPath.row-1]
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
