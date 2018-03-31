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
import AlamofireImage

enum PostCategory:String {
    case HealthProblem = "Health problem category"
    case LovingProblem = "Loving problem category"
    case Generic = "Generic category"
}

extension PostCategory {
    static func getCategory(_ string:String?) -> PostCategory {
        switch string {
        case self.HealthProblem.rawValue? :
            return .HealthProblem
        case self.LovingProblem.rawValue?:
            return .LovingProblem
        default:
            return .Generic
        }
        
    }
}

class Post: Mappable {
    
    var title: String?
    var content: String?
    var imageURL: String?
    var createdAt: Double?
    var isImagePost:Bool?
    var like: Int = 0
    var creatorUID: String?
    var postcategory:String? = PostCategory.Generic.rawValue
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
        self.postcategory <- map["postcategory"]
        self.isImagePost <- map["isImagePost"]
    }
}
