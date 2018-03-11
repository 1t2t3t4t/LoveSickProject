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
    
    class func createChatRoom(fuid:String, suid:String,completion: @escaping (Bool) -> Void) {
        let chatuid = Database.database().reference().child("ChatRooms").childByAutoId().key
        Database.database().reference().child("Users/\(suid)/username").observeSingleEvent(of: .value, with: {snap in
            if snap.exists() {
                let fusername = User.currentUser?.displayName as! String
                let susername = snap.value as! String
                let chatRoomJSON = ChatRoom(chatuid, fuid: fuid, suid: suid,fusername:fusername,susername:susername).toJSON()
                Database.database().reference().child("ChatRooms/\(chatuid)").setValue(chatRoomJSON)
                Database.database().reference().child("Users/\(fuid)/ChatRooms/\(chatuid)").setValue(chatRoomJSON)
                Database.database().reference().child("Users/\(suid)/ChatRooms/\(chatuid)").setValue(chatRoomJSON)
                Database.database().reference().child("ChatRooms/\(chatuid)/timestamp").setValue("\(Date().timeIntervalSince1970)")
                Database.database().reference().child("Users/\(fuid)/FriendRequests").child("\(suid)").removeValue(completionBlock: {(error,ref) in
                    if error != nil {
                        completion(false)
                    }
                    else {
                        completion(true)
                    }
                })
            }
            else {
                
            }
        })
       
    }
    
    class func getChatRoom(withUID uid:String, completion: @escaping (ChatRoom?) -> Void) {
        Database.database().reference().child("ChatRooms/\(uid)").observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value as? [String:Any] else { completion(nil); return }
            let chatroom = MapperManager<ChatRoom>.mapObject(dictionary: value)
            completion(chatroom)
        }
    }
    
    class func messageListener(withUID uid:String, completion: @escaping (Chat?) -> Void) {
//        Database.database().reference().child("ChatRooms/\(uid)").observe(.childAdded) { (snap) in
//            if let value = snap.value as? [[String:Any]] {
//                let chat = MapperManager<Chat>.mapObjectArray(array: value)
//                if chat.last?.senderUID != User.currentUser!.uid! { completion(chat.last) }
//            }
//        }
        Database.database().reference().child("ChatRooms/\(uid)").observe(.childChanged) { (snap) in
            if let value = snap.value as? [[String:Any]] {
                let chat = MapperManager<Chat>.mapObjectArray(array: value)
                if chat.last?.senderUID != User.currentUser!.uid! { completion(chat.last) }
            }
        }
    }
}
