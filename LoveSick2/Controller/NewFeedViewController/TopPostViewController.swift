//
//  TopPostViewController.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import UIEmptyState
import Hokusai
import Alamofire
import KDCircularProgress

class TopPostViewController: UIViewController, IndicatorInfoProvider, UIEmptyStateDataSource, UIEmptyStateDelegate {
    
    @IBOutlet weak var tableView:UITableView!
   

    var type:PostQueryType!
     var rowHeights:[Int:CGFloat] = [:]
    var currentTypeIndex:Int!
    public var changeCurrentIndexProgressive: ((_ oldCell: ButtonBarViewCell?, _ newCell: ButtonBarViewCell?, _ progressPercentage: CGFloat, _ changeCurrentIndex: Bool, _ animated: Bool) -> Void)?
    
    private var paginator:PostPaginator!
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refresh),for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    
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
        return IndicatorInfo(title: "Top")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(self.refreshControl)
       
      //  tableView.tableFooterView = UIView()
//        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height, 0)
//        self.tableView.contentInset = adjustForTabbarInsets
//        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        self.reloadEmptyStateForTableView(tableView)
        self.paginator = PostPaginator(withType:.mostLiked , { (posts, error) in
                self.tableView.reloadData()
        })
        
        tableView.tableFooterView = UIView()
        
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        
    }
    
    @objc func refresh() {
        self.paginator.refresh { (error) in
            if error == nil {
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
  
}

extension TopPostViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paginator.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = self.paginator.posts[indexPath.row]
        if post.isImagePost! {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topimagepostCell", for: indexPath) as! PostImageTableViewCell
            cell.post = post
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toppostCell", for: indexPath) as! PostTableViewCell
            cell.post = post
            return cell
        }
        
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
//        if let height = self.rowHeights[indexPath.row]{
//            return height
//        }else{
//            return UITableViewAutomaticDimension
//        }

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500

    }
    
    
}
extension TopPostViewController:PostTableViewCellDelegate {
    func report() {

            let hokusai = Hokusai()
            hokusai.cancelButtonTitle = "Cancel"
            hokusai.fontName = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold).fontName
            
            hokusai.colorScheme = HOKColorScheme.tsubaki
            hokusai.addButton("Report"){
            }
            hokusai.show()
        
    }
    
    
}
