//
//  User.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation
import ObjectMapper
import Firebase

class User: Mappable {
    
    var username: String?
    var displayName: String?
    var email: String?
    var uid: String?
    var pushId: String?
    var thumbnailProfileURL: String?
    var profileURL: String?
    var friendlist:[String]?
    
    static var currentUser:User?
    
    required init?(map: Map) {
        
    }
    
    init(_ uid:String) {
        self.uid = uid
    }
    
    func mapping(map: Map) {
        self.username <- map["username"]
        self.displayName <- map["displayName"]
        self.email <- map["email"]
        self.uid <- map["uid"]
        self.pushId <- map["uid"]
        self.friendlist <- map["friendlist"]
        self.thumbnailProfileURL <- map["thumbnailProfileURL"]
        self.profileURL <- map["profileURL"]
    }
    
    class func getProfilePic(withCompletion completion: @escaping (UIImage) -> Void ) {
        let localURL = URL(string: "path/to/image")!
        Storage.storage().reference().child("profilePic/rkoep").write(toFile: localURL) { (url, error) in
            print(url)
        }
    }
    
    class func uploadProfilePic(withCompletion completion: @escaping () -> Void,_ image : UIImage) {
        guard let data = UIImagePNGRepresentation(image) else { return }
        Storage.storage().reference().child("profilePic/rkoep").putData(data, metadata: nil) { (meta, error) in
            completion()
        }
    }
    
}
