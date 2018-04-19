//
//  PostPaginator.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation

class PostPaginator {
    
    private var queryValue:Double?
    private var queryType:PostQueryType!
    private var postManager:PostManager = PostManager()
    private var postCategory:PostCategory!
    
    var categoryFilter:String? = nil
    var posts:[Post] = []
    
    init(withType queryType:PostQueryType,category:PostCategory,_ completion:@escaping ([Post],LoveSickError?) -> Void) {
        self.queryType = queryType
        self.postCategory = category
        postManager.queryType = queryType
        postManager.postCategory = category
        self.categoryFilter = category.rawValue
        //let category = self.categoryFilter == nil ? nil : self.categoryFilter!
        self.postManager.queryPostsFirstTen(self.categoryFilter) { (posts, error) in
            
            if error == nil {
                self.updateQueryValue(withLastPost: posts.last)
                self.posts.append(contentsOf: posts)
                completion(posts,error)
            }
        }
    }
    
    func refresh(completion: @escaping (LoveSickError?) -> Void) {
        print("check filter \(self.categoryFilter)")
        self.postManager.queryPostsFirstTen(self.categoryFilter) { (posts, error) in
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
        self.postManager.queryPosts(self.categoryFilter ,withQueryValue: self.queryValue) { (posts, error) in
            if error == nil {
                self.updateQueryValue(withLastPost: posts.last)
                self.posts.append(contentsOf: posts)
                completion(posts,error)
            }
        }
    }
    
    private func updateQueryValue(withLastPost post:Post?) {
        switch self.queryType {
        case .mostRecent:
            self.queryValue = post?.createdAt
            break
        case .mostLiked:
            self.queryValue = post == nil ? nil : Double((post?.like)!)
            break
        default:
            self.queryValue = post?.createdAt
            break
        }
    }
}
