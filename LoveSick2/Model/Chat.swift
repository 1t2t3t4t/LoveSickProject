//
//  Chat.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/28/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import Foundation
import ObjectMapper

class Chat: Mappable {
    
    var message:String?
    var senderUID:String?
    var timestamp: Double?
    
    required init?(map: Map) {
        
    }
    
    init(message:String, senderUID:String, timestamp:Double) {
        self.message = message
        self.senderUID = senderUID
        self.timestamp = timestamp
    }
    
    func mapping(map: Map) {
        self.message <- map["message"]
        self.senderUID <- map["senderUID"]
        self.timestamp <- map["timestamp"]
        
    }
    
}
