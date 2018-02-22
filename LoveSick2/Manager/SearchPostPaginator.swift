//
//  SearchPostPaginator.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/22/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import Foundation
import Firebase

class SearchPostPaginator {
    
    var posts:[Post] = []
    
    private var searchText:String!
    private var postManager = PostManager()
    
    init() {
        
    }
    
    func queryPostFirstTen(withText searchText:String, completion:@escaping ([Post],LoveSickError?) -> Void ) {
        Database.database().reference().child("Posts").queryOrdered(byChild: "title").queryStarting(atValue: searchText).queryEnding(atValue: searchText + "\u{f8ff}").queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snap) in
            self.posts.removeAll()
            guard let value = snap.value as? [String:Any] else { completion([],.PostQueryError); return }
            for post in value {
                self.posts.append(MapperManager.mapObject(dictionary: post.value as! [String:Any]))
            }
            completion(self.posts,nil)
        }
    }
    
    func queryPosts(withText searchText:String,completion:@escaping ([Post],LoveSickError?) -> Void) {
        Database.database().reference().child("Posts").queryOrdered(byChild: "title").queryStarting(atValue: searchText).queryEnding(atValue: searchText + "\u{f8ff}").queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value as? [String:Any] else { completion([],.PostQueryError); return }
            var posts:[Post] = []
            for post in value {
                posts.append(MapperManager.mapObject(dictionary: post.value as! [String:Any]))
            }
            posts.removeFirst()
            self.posts.append(contentsOf: posts)
            completion(posts,nil)
        }
    }
    
}
