//
//  TopPostViewController.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import UIEmptyState
import Hokusai
import KDCircularProgress
import Firebase
import AlamofireImage
import Alamofire
import JGProgressHUD
class TopPostViewController: UIViewController, UIEmptyStateDataSource, UIEmptyStateDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    var type:PostQueryType!
    var rowHeights:[Int:CGFloat] = [:]
    var currentTypeIndex:Int!
    var viewHeight:CGFloat?
    var hud:JGProgressHUD?
    
    
    private var paginator:PostPaginator?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(self.refreshControl)
        let notificationName = NSNotification.Name("NewPostReloadData")
        NotificationCenter.default.addObserver(self, selector: #selector(TopPostViewController.notiRefresh(notification:)), name: notificationName, object: nil)
        self.hud = JGProgressHUD(style: .dark)
        hud?.show(in:self.view)
        self.reloadEmptyStateForTableView(tableView)
        tableView.tableFooterView = UIView()
       
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        let notificationName2 = NSNotification.Name("removeIgnoreTouch")
        NotificationCenter.default.addObserver(self, selector: #selector(TopPostViewController.beginTouch(notification:)), name: notificationName2, object: nil)
        
        
    }
    @objc func beginTouch(notification:NSNotification) {
        hud?.dismiss()
        
        self.paginator = PostPaginator(withType:.mostLiked , { (posts, error) in
            UIApplication.shared.endIgnoringInteractionEvents()
            self.tableView.reloadData()
        })
        
    }
    @objc func notiRefresh(notification: NSNotification) {
        refreshControl.beginRefreshing()
        refresh()
    }
    @objc func refresh() {
        self.paginator?.refresh { (error) in
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
        return self.paginator != nil ? self.paginator!.posts.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = self.paginator?.posts[indexPath.row]
        if (post?.isImagePost!)! {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topimagepostCell", for: indexPath) as! PostImageTableViewCell
            cell.post = post
            cell.delegate = self
            if cell.post.displayName != "Anonymous" {
                if let img = ImageCache.cachedImage(for: (post?.creatorUID!)!) {
                    cell.progressView.isHidden = true
                    cell.profileImg.image = img
                }else{
                    Database.database().reference().child("Users/\(post?.creatorUID!)/profileURL").observeSingleEvent(of: .value, with: {snap in
                        if snap.exists() {
                            print("snap exist man")
                            guard let url = snap.value as? String else {
                                print("snap exist man url fail")
                                cell.profileImg.image = #imageLiteral(resourceName: "profileLoad")
                                return
                            }
                            cell.profileImg.af_setImage(withURL: URL(string: url)!, placeholderImage: #imageLiteral(resourceName: "profileLoad"), filter: nil, progress: nil, imageTransition: .noTransition, runImageTransitionIfCached: true, completion: {image in
                                ImageCache.cache(cell.profileImg.image!, for: (post?.creatorUID!)!)
                            })
                        }
                    })
                }
                return cell
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toppostCell", for: indexPath) as! PostTableViewCell
            cell.post = post
            cell.delegate = self
            if cell.post.displayName != "Anonymous"{
                if let img = ImageCache.cachedImage(for: (post?.creatorUID!)!) {
                    cell.profileImg.image = img
                }else{
                    Database.database().reference().child("Users/\(post?.creatorUID!)/profileURL").observeSingleEvent(of: .value, with: {snap in
                        if snap.exists() {
                            print("snap exist man")
                            guard let url = snap.value as? String else {
                                cell.profileImg.image = #imageLiteral(resourceName: "profileLoad")
                                print("snap exist man url fail")
                                return
                            }
                            print("snap exist man url fin")
                            cell.profileImg.af_setImage(withURL: URL(string: url)!, placeholderImage: #imageLiteral(resourceName: "profileLoad"), filter: nil, progress: nil, imageTransition: .noTransition, runImageTransitionIfCached: true, completion: {image in
                                ImageCache.cache(cell.profileImg.image!, for: (post?.creatorUID!)!)
                            })
                        }
                    })
                }
                return cell
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (paginator?.posts.count)! - 5 {
            self.paginator?.nextPage { (posts, error) in
                if posts.count != 0 {
                    self.reloadEmptyStateForTableView(tableView)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let viewController = ViewPostViewController.newInstanceFromStoryboard() as! ViewPostViewController
        viewController.post = self.paginator?.posts[indexPath.row]
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
        
    }
    
    
}
extension TopPostViewController:PostTableViewCellDelegate {
    
    func showProfile(uid:String) {
        
        let view = ProfileViewController.newInstanceFromStoryboard() as! ProfileViewController
        view.userid = uid
        view.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(view, animated: true)
    }
    
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

