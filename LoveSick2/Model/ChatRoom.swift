//
//  ChatRoom.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/28/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import Foundation
import ObjectMapper

class ChatRoom: Mappable {
    
    var messages: [Chat] = []
    var chatRoomUID:String?
    private var messagesModel:[String:Any]?{
        didSet{
            if messagesModel == nil { return }
            for model in messagesModel! {
                self.messages.append(MapperManager<Chat>.mapObject(dictionary: model.value as! [String:Any]))
            }
        }
    }
    
    required init?(map: Map) {
        
    }
    
    init(_ uid:String) {
        self.chatRoomUID = uid
    }
    
    func mapping(map: Map) {
        self.chatRoomUID <- map["chatRoomUID"]
        self.messagesModel <- map["messagesModel"]
    }
    
}
