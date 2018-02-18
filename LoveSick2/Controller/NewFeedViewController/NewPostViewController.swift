//
//  NewPostViewController.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import UIEmptyState
class NewPostViewController: UIViewController , IndicatorInfoProvider, UIEmptyStateDataSource, UIEmptyStateDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    
    var type:PostQueryType!
    private var paginator:PostPaginator!
    
    var emptyStateImage: UIImage? {
        return UIImage()
    }
    
    var emptyStateImageViewTintColor: UIColor? {
        return UIColor.gray
    }
    
    var emptyStateTitle: NSAttributedString {
        let attrs = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22)]
        return NSAttributedString(string: "There are no post!", attributes: attrs)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "New")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.paginator = PostPaginator(withType: .mostRecent, { (posts, error) in
            self.tableView.reloadData()
        })
        tableView.tableFooterView = UIView()
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        self.reloadEmptyStateForTableView(tableView)
    }

}
extension NewPostViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paginator.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newpostCell", for: indexPath) as! PostTableViewCell
        let post = self.paginator.posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == paginator.posts.count - 5 {
            self.paginator.nextPage { (posts, error) in
                if posts.count != 0 {
                    self.reloadEmptyStateForTableView(tableView)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ViewPostViewController.newInstanceFromStoryboard() as! ViewPostViewController
        viewController.post = self.paginator.posts[indexPath.row]
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
