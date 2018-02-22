//
//  PostManager.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation
import Firebase

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
    
    class func post(title:String,content:String,isAnonymous: Bool) {
        let post = Post(title: title, content: content)
        post.createdAt = Date().timeIntervalSince1970
        post.like = Int(arc4random_uniform(3000))
        post.isAnonymous = isAnonymous
        post.creatorUID = User.currentUser?.uid
        post.displayName = User.currentUser?.displayName
        let uid = Database.database().reference().child("Posts").childByAutoId().key
        post.postuid = uid
        Database.database().reference().child("Posts/\(uid)").setValue(post.toJSON())
    }
    class func postImage(title:String,image:UIImage,isAnonymous: Bool) {
        let post = Post(title: title)
        post.createdAt = Date().timeIntervalSince1970
        post.like = Int(arc4random_uniform(3000))
        post.isAnonymous = isAnonymous
        post.creatorUID = User.currentUser?.uid
        post.displayName = User.currentUser?.displayName
        let uid = Database.database().reference().child("Posts").childByAutoId().key
        post.postuid = uid
        UploadPhoto.uploadPostImage(image, completion: {(url) in
            guard let str = url else {
                return
            }
                post.imageURL = str
            Database.database().reference().child("Posts/\(uid)").setValue(post.toJSON())
        })
        
        
    }
    
    class func upvote(postuid:String,completion:@escaping(LoveSickError?) -> Void) {
        Database.database().reference().child("Posts/\(postuid)").observeSingleEvent(of: .value, with: {(snapshot) in
            var numvote = 0
            if snapshot.exists() {
                let post = MapperManager<Post>.mapObject(dictionary: snapshot.value as! [String:Any])
                numvote = post.like+1
            }
            else{
                numvote = 1
            }
            Database.database().reference().child("Posts/\(postuid)/like").setValue(numvote, withCompletionBlock: {(error,ref) in
                if error != nil {
                    completion(nil)
                }
                else{
                    completion(LoveSickError.UpvoteError)
                }
            })
        })
    }
    
    class func downvote(postuid:String,completion:@escaping(LoveSickError?) -> Void) {
        Database.database().reference().child("Posts/\(postuid)").observeSingleEvent(of: .value, with: {(snapshot) in
            var numvote = 0
            if snapshot.exists() {
                let post = MapperManager<Post>.mapObject(dictionary: snapshot.value as! [String:Any])
                numvote = post.like-1
            }
            else{
                numvote = 1
            }
            Database.database().reference().child("Posts/\(postuid)/like").setValue(numvote, withCompletionBlock: {(error,ref) in
                if error != nil {
                    completion(nil)
                }
                else{
                    completion(LoveSickError.UpvoteError)
                }
            })
        })
    }
    
    class func comment(withPID pid:String,reply:Reply) {
        Database.database().reference().child("Posts/\(pid)/Replies").childByAutoId().setValue(reply.toJSON())
    }
    
    func queryPostsFirstTen(completion:@escaping ([Post],LoveSickError?) -> Void) {
        Database.database().reference().child("Posts").queryOrdered(byChild: self.queryType.string).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value as? [String:Any] else { completion([],.PostQueryError); return }
            var posts:[Post] = []
            for post in value {
                posts.append(MapperManager.mapObject(dictionary: post.value as! [String:Any]))
            }
            self.sort(&posts)
            completion(posts,nil)
        }
    }

    func queryPosts(withQueryValue queryValue:Double?,completion:@escaping ([Post],LoveSickError?) -> Void) {
        guard queryValue != nil else { completion([],nil); return }
        Database.database().reference().child("Posts").queryOrdered(byChild: self.queryType.string).queryEnding(atValue: queryValue).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snap) in
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
