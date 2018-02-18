//
//  File.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation
import ObjectMapper

class Reply: Mappable {
    
    var content: String?
    var creatorUID: String?
    var displayName: String?
    var createdAt: Double?
    
    required init?(map: Map) {
        
    }
    
    init(content: String) {
        self.content = content
        self.createdAt = Date().timeIntervalSince1970
        self.creatorUID = User.currentUser?.uid
        self.displayName = User.currentUser?.displayName
    }
    
    func mapping(map: Map) {
        self.content <- map["content"]
        self.creatorUID <- map["creatorUID"]
        self.createdAt <- map["createdAt"]
        self.displayName <- map["displayName"]
    }
    
    
    
}
