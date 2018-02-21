//
//  SessionManager.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation
import Firebase

class SessionManager {
    
    class func checkSignIn(withCompletion completion:@escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else { completion(false); return }
        UserManager.queryUser(withUID: user.uid) { (user) in
            if user == nil { completion(false); return }
            User.currentUser = user
        }
        completion(true)
    }
    
    class func logIn(email:String, password:String, completion:@escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil { completion(false) }
            guard let uid = user?.uid else { completion(false); return }
            UserManager.queryUser(withUID: uid, completion: { (userObject) in
                User.currentUser = userObject
                completion(true)
            })
        }
    }
    
    class func register(email:String, password:String,displayName: String, completion:@escaping (Bool) -> Void) {
        UserManager.queryUser(withUsername: displayName) { (user) in
            if user != nil { completion(false); return }
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error != nil { completion(false) }
                guard let uid = user?.uid else { completion(false); return }
                User.currentUser = User(uid)
                User.currentUser?.email = email
                User.currentUser?.displayName = displayName
                User.currentUser?.username = displayName
                Database.database().reference().child("Users/\(uid)").setValue(User.currentUser?.toJSON())
                completion(true)
            }
        }
    }
    
    class func logOut(_ completion: ((Bool) -> Void)?) {
        do {
            try Auth.auth().signOut()
            completion?(true)
        }catch {
            completion?(false)
        }
    }
}
