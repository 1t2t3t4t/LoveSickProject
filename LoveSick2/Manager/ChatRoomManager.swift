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
        Firestore.firestore().collection("Users").document(suid).getDocument(completion: {(document,error) in
            if error != nil || !(document?.exists)! {
                
            }
            else {
                let fusername = User.currentUser?.displayName as! String
                let data = document?.data()
                let susername = data!["username"]  as! String
                let chatRoomJSON = ChatRoom(chatuid, fuid: fuid, suid: suid,fusername:fusername,susername:susername).toJSON()
                Firestore.firestore().collection("ChatRooms").addDocument(data: [chatuid:chatRoomJSON])
                Firestore.firestore().collection("Users").document(fuid).collection("ChatRooms").addDocument(data: [chatuid:chatRoomJSON])
                Firestore.firestore().collection("Users").document(suid).collection("ChatRooms").addDocument(data: [chatuid:chatRoomJSON])
                Firestore.firestore().collection("ChatRooms").document(chatuid).updateData(["timestamp":Date().timeIntervalSince1970])
                    Firestore.firestore().collection("Users").document(fuid).collection("FriendRequests").document(suid).delete(completion: {error in
                        if error != nil {
                            completion(false)
                        }
                        else {
                            completion(true)
                        }
                    })
                
                
            }
        })
//        Database.database().reference().child("Users/\(suid)/username").observeSingleEvent(of: .value, with: {snap in
//            if snap.exists() {
//                let fusername = User.currentUser?.displayName as! String
//                let susername = snap.value as! String
//                let chatRoomJSON = ChatRoom(chatuid, fuid: fuid, suid: suid,fusername:fusername,susername:susername).toJSON()
//                Database.database().reference().child("ChatRooms/\(chatuid)").setValue(chatRoomJSON)
//                Database.database().reference().child("Users/\(fuid)/ChatRooms/\(chatuid)").setValue(chatRoomJSON)
//                Database.database().reference().child("Users/\(suid)/ChatRooms/\(chatuid)").setValue(chatRoomJSON)
//                Database.database().reference().child("ChatRooms/\(chatuid)/timestamp").setValue("\(Date().timeIntervalSince1970)")
//                Database.database().reference().child("Users/\(fuid)/FriendRequests").child("\(suid)").removeValue(completionBlock: {(error,ref) in
//                    if error != nil {
//                        completion(false)
//                    }
//                    else {
//                        completion(true)
//                    }
//                })
//            }
//            else {
//
//            }
//        })
       
    }
    
    class func getChatRoom(withUID uid:String, completion: @escaping (ChatRoom?) -> Void) {
        Firestore.firestore().collection("ChatRooms").document(uid).getDocument(completion: {(document,error) in
            guard let value = document?.data() else { completion(nil); return }
            let chatroom = MapperManager<ChatRoom>.mapObject(dictionary: value)
            completion(chatroom)
        })
//        Database.database().reference().child("ChatRooms/\(uid)").observeSingleEvent(of: .value) { (snap) in
//            guard let value = snap.value as? [String:Any] else { completion(nil); return }
//            let chatroom = MapperManager<ChatRoom>.mapObject(dictionary: value)
//            completion(chatroom)
//        }
    }
    
    class func messageListener(withUID uid:String, completion: @escaping (Chat?) -> Void) {
        Firestore.firestore().collection("ChatRooms").whereField("chatRoomUID", isEqualTo: uid)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added || diff.type == .modified {
                        if let value = diff.document.data() as? [String:Any] {
                            let chat = MapperManager<Chat>.mapObject(dictionary: value)
                            if chat.senderUID != User.currentUser!.uid! { completion(chat)}
                        }
                    }
  
                }
        }
//        Database.database().reference().child("ChatRooms/\(uid)").observe(.childAdded) { (snap) in
//            if let value = snap.value as? [[String:Any]] {
//                let chat = MapperManager<Chat>.mapObjectArray(array: value)
//                if chat.last?.senderUID != User.currentUser!.uid! { completion(chat.last) }
//            }
//        }
//        Database.database().reference().child("ChatRooms/\(uid)").observe(.childChanged) { (snap) in
//            if let value = snap.value as? [[String:Any]] {
//                let chat = MapperManager<Chat>.mapObjectArray(array: value)
//                if chat.last?.senderUID != User.currentUser!.uid! { completion(chat.last) }
//            }
//        }
    }
}
