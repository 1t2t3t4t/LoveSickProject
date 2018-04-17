//
//  SelfPostPaginator.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/27/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import Foundation

class SelfPostPaginator {
    
    private var queryValue:Double?
    private var postManager:PostManager = PostManager()
    
    var posts:[Post] = []
    
    init(_ completion:@escaping ([Post],LoveSickError?) -> Void) {
        postManager.queryType = .mostRecent
        self.postManager.querySelfPostsFirstTen { (posts, error) in
            if error == nil {
                self.updateQueryValue(withLastPost: posts.last)
                self.posts.append(contentsOf: posts)
                completion(posts,error)
            }
        }
    }
    
    func refresh(completion: @escaping (LoveSickError?) -> Void) {
        self.postManager.querySelfPostsFirstTen { (posts, error) in
            if error == nil {
                self.updateQueryValue(withLastPost: posts.last)
                self.posts.removeAll()
                self.posts.append(contentsOf: posts)
                completion(nil)
            }
            completion(error)
        }
    }
    
    func nextPage(_ completion:@escaping ([Post],LoveSickError?) -> Void) {
        self.postManager.querySelfPosts( withQueryValue: self.queryValue) { (posts, error) in
            if error == nil {
                self.updateQueryValue(withLastPost: posts.last)
                self.posts.append(contentsOf: posts)
                completion(posts,error)
            }
        }
    }
    
    private func updateQueryValue(withLastPost post:Post?) {
        self.queryValue = post?.createdAt
    }
}
