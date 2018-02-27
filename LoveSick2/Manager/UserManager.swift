//
//  FirebaseUserManager.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation
import Firebase

typealias queryCompletion<T> = (T?) -> Void

class UserManager {
    
    class func queryUser(withUID uid:String, completion:@escaping queryCompletion<User>) {
        Database.database().reference().child("Users/\(uid)").observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value as? [String:Any] else {
                completion(nil)
                return
            }
            let user = MapperManager<User>.mapObject(dictionary: value)
            completion(user)
        }
    }
    
    class func queryUser(withUsername username:String, completion: @escaping queryCompletion<User>) {
        Database.database().reference().child("Users").queryEqual(toValue: username, childKey: "username").observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value as? [String:Any] else {
                completion(nil)
                return
            }
            let user = MapperManager<User>.mapObject(dictionary: value)
            completion(user)
        }
    }
    
    class func addFriend(withUID uid:String) {
        Database.database().reference().child("Users/\(uid)/FriendRequests/\(User.currentUser!.uid!)").setValue(User.currentUser?.toJSON())
    }
}
