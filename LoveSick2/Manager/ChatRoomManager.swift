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
        let chatRoomJSON = ChatRoom(chatuid, fuid: fuid, suid: suid).toJSON()
        Database.database().reference().child("ChatRooms/\(chatuid)").setValue(chatRoomJSON)
        Database.database().reference().child("Users/\(fuid)/ChatRooms/\(chatuid)").setValue(chatRoomJSON)
        Database.database().reference().child("Users/\(suid)/ChatRooms/\(chatuid)").setValue(chatRoomJSON)
    }
    
    class func getChatRoom(withUID uid:String, completion: @escaping (ChatRoom?) -> Void) {
        Database.database().reference().child("ChatRooms/\(uid)").observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value as? [String:Any] else { completion(nil); return }
            let chatroom = MapperManager<ChatRoom>.mapObject(dictionary: value)
            completion(chatroom)
        }
    }
}
