//
//  FriendRequestTableViewController.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/28/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit
import Firebase

class FriendRequestTableViewController: UITableViewController {

    private var currentUser = User.currentUser!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  currentUser.friendrequest.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentUser.friendrequest[indexPath.row].displayName!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        ChatRoomManager.createChatRoom(fuid: currentUser.uid!, suid: currentUser.friendrequest[indexPath.row].uid!)
        Database.database().reference().child("Users/\(currentUser.uid)/FriendRequests/\(currentUser.friendrequest[indexPath.row].uid!)").removeValue()
        User.currentUser?.friendrequest.remove(at: indexPath.row)
    }


}
