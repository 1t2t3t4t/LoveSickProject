//
//  ChatRoomManager.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/28/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import Foundation
import Firebase

class ChatRoomManager {
    
    class func createChatRoom(fuid:String, suid:String) {
        let chatuid = Database.database().reference().child("ChatRooms").childByAutoId().key
        let chatRoomJSON = ChatRoom(chatuid).toJSON()
        Database.database().reference().child("ChatRooms/\(chatuid)").setValue(chatRoomJSON)
        Database.database().reference().child("Users/\(fuid)/ChatRooms/\(chatuid)").setValue(chatRoomJSON)
        Database.database().reference().child("Users/\(suid)/ChatRooms/\(chatuid)").setValue(chatRoomJSON)
    }
}
