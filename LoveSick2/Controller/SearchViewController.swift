//
//  SearchViewController.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/15/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {

    private var searchBar:UISearchBar!
    private var timer:Timer?
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts:[Post] = []
    var typeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setUpSearchBar()
        
        //Database.database().reference().child("Posts").removeValue()
    }
    
    private func setUpSearchBar() {
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search here..."
        self.navigationItem.titleView = self.searchBar
    //    var i = 0
     //   let str = ["hello world","yo dude","why the hell"]
//        while i<10000 {
//            i+=1
//            PostManager.post(title: str[Int(arc4random_uniform(3))], content: str[Int(arc4random_uniform(3))], isAnonymous: false)
//        }
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.posts.removeAll()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            return
        }
        if typeCount < 1 {
            typeCount = 1
            self.tableView.setContentOffset(CGPoint(x:0, y:self.tableView.contentOffset.y -         (self.refreshControl.frame.size.height)), animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            self.refreshControl.sendActions(for: .valueChanged)
        })
        self.refreshControl.beginRefreshing()
        if timer != nil {
            
            if timer!.isValid {
                timer!.invalidate()
                //self.refreshControl.endRefreshing()
            }
        }
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fetchPost), userInfo: nil, repeats: false)
    }
    
    @objc private func fetchPost() {
        
        self.posts.removeAll()
        self.tableView.reloadData()
        guard let searchText = self.searchBar.text else { return }
//        Database.database().reference().child("Posts").queryOrdered(byChild: "title").queryStarting(atValue: searchText).queryEnding(atValue: searchText + "\u{f8ff}").observeSingleEvent(of: .value, with: {(snap) in
//            if snap.exists() {
//                print("enter unicode field")
//                guard let value = snap.value as? [String:Any] else {
//                    self.tableView.reloadData()
//                    return
//                }
//                for post in value {
//                    self.posts.append(MapperManager.mapObject(dictionary: post.value as! [String:Any]))
//                }
//                self.posts = self.posts.filter({($0.title?.lowercased().contains(searchText.lowercased()))!})
//                self.tableView.reloadData()
//               self.refreshControl.endRefreshing()
//                self.typeCount = 0
//                return
//            }
//            else{
//                Database.database().reference().child("Posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value) { (snap) in
//                    print("find the word")
//
//                    guard let value = snap.value as? [String:Any] else {
//                        self.tableView.reloadData()
//                        return
//                    }
//                    for post in value {
//                        self.posts.append(MapperManager.mapObject(dictionary: post.value as! [String:Any]))
//                    }
//                    self.posts = self.posts.filter({($0.title?.lowercased().contains(searchText.lowercased()))!})
//                    self.tableView.reloadData()
//                   self.refreshControl.endRefreshing()
//                    self.typeCount = 0
//                    return
//                }
//            }
//        })
        Database.database().reference().child("Posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value) { (snap) in
            print("find the word")
            
            guard let value = snap.value as? [String:Any] else {
                self.tableView.reloadData()
                return
            }
            for post in value {
                let post = MapperManager<Post>.mapObject(dictionary: post.value as! [String:Any])
                if post.title!.lowercased().contains(searchText.lowercased()) {
                    self.posts.append(post)
                }
            }
//            self.posts = self.posts.filter({($0.title?.lowercased().contains(searchText.lowercased()))!})
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.typeCount = 0
            return
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        cell.post = self.posts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.posts.count - 5 {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ViewPostViewController.newInstanceFromStoryboard() as! ViewPostViewController
        viewController.post = self.posts[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
