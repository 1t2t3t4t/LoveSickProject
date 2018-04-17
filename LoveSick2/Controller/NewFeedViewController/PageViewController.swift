//
//  PageViewController.swift
//  LoveSick2
//
//  Created by marky RE on 11/3/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import Pageboy
import Tabman
import McPicker

class PageViewController: TabmanViewController, PageboyViewControllerDataSource {
    
    var child_1 :TopPostViewController!
    var child_2:NewPostViewController!
    var viewControllers:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupNavigationBar.setupNavigationBar(navController: self.navigationController!, navItem: self.navigationItem, message: "New Feeds")
        self.navigationController?.hidesBarsOnSwipe = true
      let filter = UIBarButtonItem(image: UIImage(named: "filter"), style: .done, target: self, action: #selector(PageViewController.showCategory))
      let search = UIBarButtonItem(image: UIImage(named: "search"), style: .done, target: self, action: #selector(PageViewController.showSearch))
    self.navigationItem.rightBarButtonItems = [search,filter]
        
        self.bar.style = .buttonBar
        self.bar.location = .top
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.child_1 = storyboard.instantiateViewController(withIdentifier: "toppost") as! TopPostViewController
        self.child_2 = storyboard.instantiateViewController(withIdentifier: "newpost") as! NewPostViewController
        viewControllers.append(child_1)
        viewControllers.append(child_2)
        
        self.dataSource = self
        
        // configure the bar
        self.bar.items = [Item(title: "Top"),
                          Item(title: "New")]
        self.bar.appearance?.text.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
    }
    
    @objc func showCategory() {
        let data = [[PostCategory.Generic.rawValue,PostCategory.Heartbreak.rawValue,PostCategory.AnyType.rawValue]]
        let mcPicker = McPicker(data: data)
        mcPicker.toolbarItemsFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        mcPicker.toolbarBarTintColor = .white
        mcPicker.backgroundColor = .white
        mcPicker.backgroundColorAlpha = 0.50
        mcPicker.pickerBackgroundColor = .white
        mcPicker.show(doneHandler: { [weak self] (selections: [Int : String]) -> Void in
                // selections[0]
            let filter = selections.first?.value
            self?.child_1.paginator?.categoryFilter = filter
            self?.child_2.paginator?.categoryFilter = filter
            self?.child_1.refresh()
        })
//        let view = CategoryTableViewController.newInstanceFromStoryboard() as! CategoryTableViewController
//        self.navigationController?.pushViewController(view, animated: true)
    }
    @objc func showSearch() {
        let view = SearchViewController.newInstanceFromStoryboard() as! SearchViewController
        self.navigationController?.pushViewController(view, animated: true)
    }
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.first
    }
   
}
//extension PageViewController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText == "" {
//            self.posts.removeAll()
//            self.tableView.reloadData()
//            self.refreshControl.endRefreshing()
//            return
//        }
//        if typeCount < 1 {
//            typeCount = 1
//            self.tableView.setContentOffset(CGPoint(x:0, y:self.tableView.contentOffset.y -         (self.refreshControl.frame.size.height)), animated: true)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
//            self.refreshControl.sendActions(for: .valueChanged)
//        })
//        self.refreshControl.beginRefreshing()
//        if timer != nil {
//            if timer!.isValid {
//                timer!.invalidate()
//            }
//        }
//        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fetchPost), userInfo: nil, repeats: false)
//    }
//
//    @objc private func fetchPost() {
//        self.posts.removeAll()
//        guard let searchText = self.searchBar.text else { return }
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
//    }
//}
