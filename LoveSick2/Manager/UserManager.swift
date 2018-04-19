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
//        Database.database().reference().child("Users/\(uid)").observeSingleEvent(of: .value) { (snap) in
//            guard let value = snap.value as? [String:Any] else {
//                completion(nil)
//                return
//            }
//            let user = MapperManager<User>.mapObject(dictionary: value)
//            completion(user)
//            guard let url = user.profileURL else { User.currentUser.profileImg = #imageLiteral(resourceName: "profileLoad"); return }
//            Alamofire.request(url).responseImage { response in
//                if let image = response.result.value {
//                    User.currentUser.profileImg = image
//                    ImageCache.cache(image, for: User.currentUser!.uid!)
//                }
//            }
//        }
        Firestore.firestore().collection("Users").document(uid).getDocument(completion: {(document,error) in
            if error != nil || !(document?.exists)!{
                completion(nil)
                return
            }
            guard let value = document?.data() else {
                completion(nil)
                return
            }
            let user = MapperManager<User>.mapObject(dictionary: value)
                        completion(user)
                        guard let url = user.profileURL else { user.profileImg = #imageLiteral(resourceName: "profileLoad"); return }
                        Alamofire.request(url).responseImage { response in
                            if let image = response.result.value {
                                user.profileImg = image
                                ImageCache.cache(image, for: user.uid!)
                            }
                        }
        })
        
        
    }
    class func queryUserFilter(filter:UserFilter,completion: @escaping queryCompletion<[User]>) {
        let minAge = Calendar.current.date(byAdding: .year, value: filter.minAge * -1, to: Date())
        let minInterval:Double = (minAge?.timeIntervalSince1970)!
        let maxAge = Calendar.current.date(byAdding: .year, value: filter.maxAge * -1, to: Date())
        let maxInterval:Double = (maxAge?.timeIntervalSince1970)!
        Firestore.firestore().collection("Users").whereField("currentStatus", isEqualTo: filter.currentStatus!).whereField("gender", isEqualTo: filter.gender!).whereField("ageInterval", isLessThanOrEqualTo: minInterval).whereField("ageInterval", isGreaterThanOrEqualTo: maxInterval).getDocuments(completion: {(documents,error) in
            
            if error != nil || (documents?.isEmpty)! {

                completion(nil)
            }
            else {
                var users:[User] = []
                for document in (documents?.documents)! {
                    print(document.data())
                    let value = document.data()
                        users.append(MapperManager<User>.mapObject(dictionary: value))
                }
                completion(users)
            }
            
            
        })
    }
    class func queryUser(withUsername username:String, completion: @escaping queryCompletion<User>) {
         Firestore.firestore().collection("Users").whereField("username", isEqualTo: username).getDocuments(completion: {snap,error in
            print("enter query \(snap) \(error)")
            if error != nil {
                print("error")
                completion(nil)
                return
            }
            guard let documents = snap?.documents else {
                print("error doc" )
                            completion(nil)
                            return
            }
            for document in documents {
                print("for loop")
                let user = MapperManager<User>.mapObject(dictionary: document.data())
                completion(user)
            }
            completion(nil)
            
         })
//        Database.database().reference().child("Users").queryEqual(toValue: username, childKey: "username").observeSingleEvent(of: .value) { (snap) in
//            guard let value = snap.value as? [String:Any] else {
//                completion(nil)
//                return
//            }
//            let user = MapperManager<User>.mapObject(dictionary: value)
//            completion(user)
//        }
    }
    
    class func queryUser(withEmail email:String, completion: @escaping queryCompletion<User>) {
        Firestore.firestore().collection("Users").whereField("email", isEqualTo: email).getDocuments(completion: {snap,error in
            if error != nil {
                completion(nil)
                return
            }
            
            guard let documents = snap?.documents else {
                completion(nil)
                return
            }
            for document in documents {
                let user = MapperManager<User>.mapObject(dictionary: document.data())
                completion(user)
            }
            
        })
//        Database.database().reference().child("Users").queryEqual(toValue: email, childKey: "email").observeSingleEvent(of: .value) { (snap) in
//            guard let value = snap.value as? [String:Any] else {
//                completion(nil)
//                return
//            }
//            let user = MapperManager<User>.mapObject(dictionary: value)
//            completion(user)
//        }
    }
    
    class func addFriend(withUID uid:String,completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("Users").document(uid).collection("FriendRequest").document(User.currentUser!.uid!).setData((User.currentUser?.toJSON())!, completion: { error in
            if error != nil {
                completion(false)
            }
            else{
                completion(true)
            }
        })
//        Database.database().reference().child("Users/\(uid)/FriendRequests/\(User.currentUser!.uid!)").setValue(User.currentUser?.toJSON(), withCompletionBlock: {(error,ref) in
//            if error != nil {
//                completion(false)
//            }
//            else{
//                completion(true)
//            }
//        })//setValue(User.currentUser?.toJSON())
    }
    
    class func queryFriendrequest(completion: @escaping queryCompletion<[User]> ) {
        Firestore.firestore().collection("Users").document((Auth.auth().currentUser?.uid)!).getDocument(completion: {(document,error) in
            if error != nil {
                completion(nil)
                return
            }
            guard let value = document?.data() else {
                completion(nil)
                return
            }
            let user = MapperManager<User>.mapObject(dictionary: value)
            completion(user.friendrequest)
        })
//        Database.database().reference().child("Users/\(Auth.auth().currentUser?.uid)").observeSingleEvent(of: .value) { (snap) in
//            guard let value = snap.value as? [String:Any] else {
//                return
//            }
//            let user = MapperManager<User>.mapObject(dictionary: value)
//            completion(user.friendrequest)
//        }
    }
}
