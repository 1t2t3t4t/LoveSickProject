//
//  ChatRoom.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/28/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import Foundation
import ObjectMapper
import Firebase

class ChatRoom: Mappable {
    
    var messages: [Chat] = []
    var chatRoomUID:String?
    private var fuid:String?
    private var suid:String?
    var userUID:String? {
        return User.currentUser!.uid == fuid ? suid : fuid
    }
    private var messagesModel:[String:Any]? = [: ]{
        didSet{
            if messagesModel == nil { return }
            for model in messagesModel! {
                self.messages.append(MapperManager<Chat>.mapObject(dictionary: model.value as! [String:Any]))
            }
        }
    }
    
    required init?(map: Map) {
        
    }
    
    init(_ uid:String, fuid:String, suid:String) {
        self.chatRoomUID = uid
        self.suid = suid
        self.fuid = fuid
        let chatuid = Database.database().reference().child("ChatRooms").childByAutoId().key
        let chatRoomJSON = ChatRoom(chatuid, fuid: fuid, suid: suid).toJSON()
        Database.database().reference().child("ChatRooms/\(chatuid)").setValue(chatRoomJSON)
        Database.database().reference().child("Users/\(fuid)/ChatRooms/\(chatuid)").setValue(chatRoomJSON)
        Database.database().reference().child("Users/\(suid)/ChatRooms/\(chatuid)").setValue(chatRoomJSON)
    }
    
    func mapping(map: Map) {
        self.chatRoomUID <- map["chatRoomUID"]
        self.messagesModel <- map["messagesModel"]
        self.fuid <- map["fuid"]
        self.suid <- map["suid"]
        self.messages <- map["messages"]
    }
    
    func sendMessage(_ text:String) {
        let chat = Chat(message: text, senderUID: (User.currentUser?.uid)!, timestamp: Date().timeIntervalSince1970)
        self.messages.append(chat)
        Database.database().reference().child("ChatRooms/\(self.chatRoomUID!)").updateChildValues(self.toJSON())
    }
    
}
