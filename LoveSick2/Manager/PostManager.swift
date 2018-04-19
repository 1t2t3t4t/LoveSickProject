//
//  PostManager.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation
import Firebase
import KDCircularProgress

enum PostQueryType {
    case mostRecent
    case mostLiked
    case trending
}

extension PostQueryType {
    var string: String {
        switch self {
        case .mostRecent:
            return "createdAt"
        case .mostLiked:
            return "like"
        case .trending:
            return "like"
        }
    }
}

enum PostTimeFilter {
    case allTime
    case lastWeek
    case lastThreeMonths
    case lastSixMonths
    case lastYear
}

extension PostTimeFilter {
    var time: Double {
        switch self {
        case .allTime:
            return 0.0
        case .lastWeek:
            return 10000.0
        case .lastThreeMonths:
            return 20000.0
        case .lastSixMonths:
            return 30000.0
        case .lastYear:
            return 60000.0
        }
    }
}

class PostManager {
    
    var queryType:PostQueryType!
    var postCategory:PostCategory!
    
    class func post(title:String,content:String,isAnonymous: Bool,category: String) {
        let post = Post(title: title, content: content)
        post.createdAt = Date().timeIntervalSince1970
        post.like = Int(arc4random_uniform(3000))
        post.isAnonymous = isAnonymous
        post.creatorUID = User.currentUser?.uid
        post.displayName = User.currentUser?.displayName
        post.postcategory = category
       // let uid = Database.database().reference().child("Posts").childByAutoId().key
       // post.postuid = uid
        let query = Firestore.firestore().collection("Posts").document()
        post.postuid = query.documentID
        query.setData(post.toJSON())
        Firestore.firestore().collection("Users").document(String(describing: User.currentUser.uid!)).collection("Posts").addDocument(data: [query.documentID:query.documentID])
//        Database.database().reference().child("Posts/\(uid)").setValue(post.toJSON())
//           Database.database().reference().child("Users/\(String(describing: Auth.auth().currentUser?.uid))/Posts").setValue(uid)
    }
    
    class func postImage(title:String,image:UIImage,progressView:KDCircularProgress,isAnonymous: Bool,completion:@escaping(Bool?) -> Void) {
        let post = Post(title: title)
        post.createdAt = Date().timeIntervalSince1970
        post.like = Int(arc4random_uniform(3000))
        post.isAnonymous = isAnonymous
        guard let useruid = Auth.auth().currentUser?.uid else {
            return
        }
        post.creatorUID = useruid
        post.displayName = User.currentUser?.displayName
//        let uid = Database.database().reference().child("Posts").childByAutoId().key
//        post.postuid = uid
        let query = Firestore.firestore().collection("Posts").document()
        post.postuid = query.documentID
        UploadPhoto.uploadPostImage(image,progressView, completion: {(url) in
            guard let str = url else {
                completion(false)
                return
            }
                post.imageURL = str
            query.setData(post.toJSON())
//            Database.database().reference().child("Posts/\(uid)").setValue(post.toJSON())
           
            Firestore.firestore().collection("Users").document(useruid).collection("Posts").addDocument(data: [query.documentID:query.documentID])
            completion(true)
//            print("check uid man \(useruid))")
//            Database.database().reference().child("Users/\( useruid)/Posts").child(uid).setValue(uid)
//            completion(true)
        })
        
    }
    
    class func upvote(postuid:String,completion:@escaping(LoveSickError?) -> Void) {
        let query = Firestore.firestore().collection("Posts").document(postuid)
        query.getDocument(completion: {(document,error) in
            var numvote = 0
            if error != nil || !(document?.exists)!{
                numvote = 1
            }
            else {
                let post = MapperManager<Post>.mapObject(dictionary:(document?.data())!)
                numvote = post.like + 1
            }
            query.updateData(["like":numvote], completion: {error in
                if error != nil {
                    completion(nil)
                    return
                }
            })
        })
    
//        Database.database().reference().child("Posts/\(postuid)").observeSingleEvent(of: .value, with: {(snapshot) in
//            var numvote = 0
//            if snapshot.exists() {
//                let post = MapperManager<Post>.mapObject(dictionary: snapshot.value as! [String:Any])
//                numvote = post.like+1
//            }
//            else{
//                numvote = 1
//            }
//            Database.database().reference().child("Posts/\(postuid)/like").setValue(numvote, withCompletionBlock: {(error,ref) in
//                if error != nil {
//                    completion(nil)
//                }
//                else{
//                    completion(LoveSickError.UpvoteError)
//                }
//            })
//        })
  //  }
    }
    
    class func downvote(postuid:String,completion:@escaping(LoveSickError?) -> Void) {
        let query = Firestore.firestore().collection("Posts").document(postuid)
        query.getDocument(completion: {(document,error) in
            var numvote = 0
            if error != nil || !(document?.exists)!{
                numvote = 1
            }
            else {
                let post = MapperManager<Post>.mapObject(dictionary:(document?.data())!)
                numvote = post.like - 1
            }
            query.updateData(["like":numvote], completion: {error in
                if error != nil {
                    completion(nil)
                    return
                }
            })
        })
//        Database.database().reference().child("Posts/\(postuid)").observeSingleEvent(of: .value, with: {(snapshot) in
//            var numvote = 0
//            if snapshot.exists() {
//                let post = MapperManager<Post>.mapObject(dictionary: snapshot.value as! [String:Any])
//                numvote = post.like-1
//            }
//            else{
//                numvote = 1
//            }
//            Database.database().reference().child("Posts/\(postuid)/like").setValue(numvote, withCompletionBlock: {(error,ref) in
//                if error != nil {
//                    completion(nil)
//                }
//                else{
//                    completion(LoveSickError.UpvoteError)
//                }
//            })
//        })
    }
    
    class func comment(withPID pid:String,reply:Reply) {
        Firestore.firestore().collection("Posts").document(pid).collection("Replies").addDocument(data: reply.toJSON())
//        Database.database().reference().child("Posts/\(pid)/Replies").childByAutoId().setValue(reply.toJSON())
        
    }
    
    func querySelfPostsFirstTen(_ completion:@escaping ([Post],LoveSickError?) -> Void) {
        Firestore.firestore().collection("Users").document(User.currentUser.uid!).collection("Posts").getDocuments(completion: {(documents,error) in
            if error != nil || (documents?.isEmpty)! {
                print("self post error \(error) \(documents?.count)")
                completion([],.PostQueryError); return
            }
            var posts:[Post] = []
            
            for document in (documents?.documents)! {
                let data = document.data()
                var count = 0
                for value in data {
                    Firestore.firestore().collection("Posts").document(value.value as! String).getDocument(completion: {(document,error) in
                        
                        if error != nil || !(document?.exists)! {
                            return
                        }
                        count+=1
                        posts.append(MapperManager.mapObject(dictionary: document?.data() as! [String:Any]))
                        if count == data.count {
                            self.sort(&posts)
                            completion(posts,nil)
                            return
                        }
                    })
                }
            }
           
        })
//        Database.database().reference().child("Users/\(Auth.auth().currentUser?.uid)/Posts").queryOrdered(byChild: self.queryType.string).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snap) in
//            guard let value = snap.value as? [String:Any] else { completion([],.PostQueryError); return }
//            var posts:[Post] = []
//            for post in value {
//                posts.append(MapperManager.mapObject(dictionary: post.value as! [String:Any]))
//            }
//            self.sort(&posts)
//            completion(posts,nil)
//        }
    }
    
    func querySelfPosts(withQueryValue queryValue:Double?,completion:@escaping ([Post],LoveSickError?) -> Void) {
        guard queryValue != nil else { completion([],nil); return }
        Firestore.firestore().collection("Users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid).end(at: [queryValue]).order(by: self.queryType.string).limit(to: 10).getDocuments(completion: {(documents,error) in
            if error != nil || (documents?.isEmpty)! {
                completion([],.PostQueryError); return
            }
            var posts:[Post] = []
            for document in (documents?.documents)! {
                posts.append(MapperManager.mapObject(dictionary: document.data() ))
                
            }
            self.sort(&posts)
            posts.removeFirst()
            completion(posts,nil)
        })
        Database.database().reference().child("Users/\(Auth.auth().currentUser?.uid)/Posts").queryOrdered(byChild: self.queryType.string).queryEnding(atValue: queryValue).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value as? [String:Any] else { completion([],.PostQueryError); return }
            var posts:[Post] = []
            for post in value {
                posts.append(MapperManager.mapObject(dictionary: post.value as! [String:Any]))
            }
            self.sort(&posts)
            posts.removeFirst()
            completion(posts,nil)
        }
    }
    
    func queryPostsFirstTen(_ category: String?,completion:@escaping ([Post],LoveSickError?) -> Void) {
         print("check cateogry Filter \(category)")
        guard let categoryValue = category else {
            return
        }
       
         if categoryValue == "Any" {
        Firestore.firestore().collection("Posts").order(by: self.queryType.string).limit(to: 10).getDocuments(completion: {(documents,error) in
            if error != nil || (documents?.isEmpty)! {
                completion([],.PostQueryError); return
            }
             var posts:[Post] = []
            for document in (documents?.documents)! {
                posts.append(MapperManager.mapObject(dictionary: document.data() as! [String:Any]))
                
            }
            self.sort(&posts)
            completion(posts,nil)
        })
        }
         else {
            print("not any")
            Firestore.firestore().collection("Posts").whereField("postcategory", isEqualTo: categoryValue).order(by: self.queryType.string).limit(to: 10).getDocuments(completion: {(documents,error) in
                print("error doc \(error) \(documents?.documents.count)")
                if error != nil || (documents?.isEmpty)! {
                    completion([],.PostQueryError); return
                }
                var posts:[Post] = []
                for document in (documents?.documents)! {
                    posts.append(MapperManager.mapObject(dictionary: document.data() as! [String:Any]))
                    
                }
                self.sort(&posts)
                completion(posts,nil)
            })
        }
//        Database.database().reference().child("Posts").queryOrdered(byChild: self.queryType.string).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snap) in
//            guard let value = snap.value as? [String:Any] else { completion([],.PostQueryError); return }
//            var posts:[Post] = []
//            for post in value {
//                posts.append(MapperManager.mapObject(dictionary: post.value as! [String:Any]))
//            }
//            self.sort(&posts)
//            completion(posts,nil)
//        }
    }

    func queryPosts(_ category: String?,withQueryValue queryValue:Double?,completion:@escaping ([Post],LoveSickError?) -> Void) {
        
        guard queryValue != nil else { completion([],nil); return }
        guard let categoryValue = category else {
            return
        }
        if categoryValue == "Any" {
        Firestore.firestore().collection("Posts").end(at: [queryValue]).order(by: self.queryType.string).limit(to: 10).getDocuments(completion: {(documents,error) in
            if error != nil || (documents?.isEmpty)! {
                completion([],.PostQueryError); return
            }
            var posts:[Post] = []
            for document in (documents?.documents)! {
                posts.append(MapperManager.mapObject(dictionary: document.data() ))
                
            }
            self.sort(&posts)
            posts.removeFirst()
            completion(posts,nil)
        })
        }
        else {
            Firestore.firestore().collection("Posts").end(at: [queryValue]).whereField("postcategory", isEqualTo: categoryValue).order(by: self.queryType.string).limit(to: 10).getDocuments(completion: {(documents,error) in
                if error != nil || (documents?.isEmpty)! {
                    completion([],.PostQueryError); return
                }
                var posts:[Post] = []
                for document in (documents?.documents)! {
                    posts.append(MapperManager.mapObject(dictionary: document.data() ))
                    
                }
                self.sort(&posts)
                posts.removeFirst()
                completion(posts,nil)
            })
        }
//        Database.database().reference().child("Posts").queryOrdered(byChild: self.queryType.string).queryEnding(atValue: queryValue).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snap) in
//            guard let value = snap.value as? [String:Any] else { completion([],.PostQueryError); return }
//            var posts:[Post] = []
//            for post in value {
//                posts.append(MapperManager.mapObject(dictionary: post.value as! [String:Any]))
//            }
//            self.sort(&posts)
//            posts.removeFirst()
//            completion(posts,nil)
//        }
    }

    
    private func sort(_ posts:inout [Post]) {
        switch self.queryType {
        case .mostRecent:
            posts.sort(by: {$0.createdAt! >= $1.createdAt!})
            break
        case .mostLiked:
            posts.sort(by: {$0.like >= $1.like})
            break
        default:
            posts.sort(by: {$0.createdAt! >= $1.createdAt!})
        }
    }
}
