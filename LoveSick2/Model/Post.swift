//
//  Post.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class Post: Mappable {
    
    var title: String?
    var content: String?
    var imageURL: String?
    var createdAt: Double?
    var isImagePost:Bool?
    var like: Int = 0
    var creatorUID: String?
    var displayName: String?
    var postuid:String?
    var isAnonymous: Bool = false {
        didSet{
            self.displayName = oldValue ? "Anonymous" : self.displayName
        }
    }
    var replies: [Reply] = []
    private var repliesModel:[String:Any]?{
        didSet{
            if repliesModel == nil { return }
            for model in repliesModel! {
                self.replies.append(MapperManager<Reply>.mapObject(dictionary: model.value as! [String:Any]))
            }
        }
    }
    
    init(title:String,content:String) {
        self.title = title
        self.content = content
        self.isImagePost = false
        self.creatorUID = User.currentUser?.uid
        self.like = 0
    }
    init(title:String) {
        self.title = title
        self.isImagePost = true
        self.creatorUID = User.currentUser?.uid
        self.like = 0
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.content <- map["content"]
        self.createdAt <- map["createdAt"]
        self.like <- map["like"]
        self.creatorUID <- map["creatorUID"]
        self.repliesModel <- map["Replies"]
        self.isAnonymous <- map["isAnonymous"]
        self.displayName <- map["displayName"]
        self.postuid <- map["postuid"]
        self.imageURL <- map["imageURL"]
        self.isImagePost <- map["isImagePost"]
    }
    
}
