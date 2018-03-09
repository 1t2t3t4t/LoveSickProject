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
    var fuid:String?
    var suid:String?
    private var _fusername:String?
    private var _susername:String?
    var timestamp:String?
    var fusername:String {
        get {
        return _fusername != nil ? _fusername!:""
        }
        set {
            _fusername = newValue
        }
    }
    var susername:String {
        get {
        return _susername != nil ? _susername!:""
        }
        set {
            _susername = newValue
        }
    }
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
    
    init(_ uid:String, fuid:String, suid:String,fusername:String,susername:String) {
        self.chatRoomUID = uid
        self.suid = suid
        self.fuid = fuid
        self.fusername = fusername
        self.susername = susername
        self.timestamp = "\(Date().timeIntervalSince1970)"
    }
    
    func mapping(map: Map) {
        self.chatRoomUID <- map["chatRoomUID"]
        self.messagesModel <- map["messagesModel"]
        self.fuid <- map["fuid"]
        self.suid <- map["suid"]
        self.messages <- map["messages"]
        self.fusername <- map["fusername"]
        self.susername <- map["susername"]
        self.timestamp <- map["timestamp"]
    }
    
    func sendMessage(_ text:String) {
        let chat = Chat(message: text, senderUID: (User.currentUser?.uid)!, timestamp: Date().timeIntervalSince1970)
        self.messages.append(chat)
        Database.database().reference().child("ChatRooms/\(self.chatRoomUID!)").updateChildValues(self.toJSON())
         Database.database().reference().child("ChatRooms/\(self.chatRoomUID!)/timestamp").setValue("\(Date().timeIntervalSince1970)")
    }
    
}
