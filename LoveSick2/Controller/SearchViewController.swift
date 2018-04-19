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
        
    }
    @objc func searchFriend() {
        
    }
    
    private func setUpSearchBar() {
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search"
        self.searchBar.tintColor = UIColor.darkGray
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UITextField.self) {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0)
                }
            }
        }
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .done, target: self, action: #selector(SearchViewController.searchFriend))
        self.navigationItem.titleView = self.searchBar
        
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
            }
        }
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fetchPost), userInfo: nil, repeats: false)
    }
    
    @objc private func fetchPost() {
        self.posts.removeAll()
        guard let searchText = self.searchBar.text else { return }
        Firestore.firestore().collection("Posts").order(by: "createdAt").getDocuments(completion: { (snap,error) in
            if error != nil || (snap?.isEmpty)!{
                self.tableView.reloadData()
                return
            }
            
//            guard let value = snap. as? [String:Any] else {
//                self.tableView.reloadData()
//                return
//            }
            for post in (snap?.documents)! {
                let post = MapperManager<Post>.mapObject(dictionary: post.data() as! [String:Any])
                if post.title!.lowercased().contains(searchText.lowercased()) {
                    self.posts.append(post)
                }
            }
//            for post in value {
//                let post = MapperManager<Post>.mapObject(dictionary: post.value as! [String:Any])
//                if post.title!.lowercased().contains(searchText.lowercased()) {
//                    self.posts.append(post)
//                }
//            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.typeCount = 0
            return
        })
//        Database.database().reference().child("Posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value) { (snap) in
//            guard let value = snap.value as? [String:Any] else {
//                self.tableView.reloadData()
//                return
//            }
//            for post in value {
//                let post = MapperManager<Post>.mapObject(dictionary: post.value as! [String:Any])
//                if post.title!.lowercased().contains(searchText.lowercased()) {
//                    self.posts.append(post)
//                }
//            }
//            self.tableView.reloadData()
//            self.refreshControl.endRefreshing()
//            self.typeCount = 0
//            return
//        }
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
        
        
        if self.posts[indexPath.row].isImagePost! {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "topimagepostCell", for: indexPath) as! PostImageTableViewCell
            cell.post = self.posts[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
            cell.post = self.posts[indexPath.row]
            return cell
        }
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
