//
//  FirebaseUserManager.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation
import Firebase
import Alamofire
import AlamofireImage
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
            guard let url = user.profileURL else { User.currentUser.profileImg = #imageLiteral(resourceName: "profileLoad"); return }
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    User.currentUser.profileImg = image
                }
            }
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
    
    class func queryUser(withEmail email:String, completion: @escaping queryCompletion<User>) {
        Database.database().reference().child("Users").queryEqual(toValue: email, childKey: "email").observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value as? [String:Any] else {
                completion(nil)
                return
            }
            let user = MapperManager<User>.mapObject(dictionary: value)
            completion(user)
        }
    }
    
    class func addFriend(withUID uid:String,completion: @escaping (Bool) -> Void) {
        Database.database().reference().child("Users/\(uid)/FriendRequests/\(User.currentUser!.uid!)").setValue(User.currentUser?.toJSON(), withCompletionBlock: {(error,ref) in
            if error != nil {
                completion(false)
            }
            else{
                completion(true)
            }
        })//setValue(User.currentUser?.toJSON())
    }
    
    class func queryFriendrequest(completion: @escaping queryCompletion<[User]> ) {
        Database.database().reference().child("Users/\(Auth.auth().currentUser?.uid)").observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value as? [String:Any] else {
                return
            }
            let user = MapperManager<User>.mapObject(dictionary: value)
            completion(user.friendrequest)
        }
    }
}
