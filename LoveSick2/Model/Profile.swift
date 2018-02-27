//
//  Profile.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/27/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import Foundation
import Firebase

class Profile {
    static func getUserProfile(uid:String,withCompletion completion:@escaping ([String:Any]?) -> Void) {
        var user:[String:Any] = [:]
        Database.database().reference().child("Users/\(uid)").observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.exists() {
                let snap = snapshot.value as! [String:Any]
                for value in snap {
                    if value.key == "Posts" && value.value != nil {
                        guard let val = value.value as? [String:String] else {
                            break
                        }
                        user.updateValue(val, forKey: value.key)
                    }
                    else {
                    user.updateValue("\(value.value)", forKey: value.key)
                    }
                }
                completion(user)
            }
            else {
                completion(nil)
            }
        })
        
    }
}
