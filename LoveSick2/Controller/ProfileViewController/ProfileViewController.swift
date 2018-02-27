//
//  ProfileViewController.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/27/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView
import Hokusai
import ZAlertView
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    var stretchyHeader: GSKStretchyHeaderView!
    var userid:String?
    var userProfile:[String:Any]?
    var nibViews:ProfileHeaderView?
    
    private var paginator:SelfPostPaginator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Profile"
        
        let view = UIButton(frame: CGRect(x:0,y:0,width:50,height:30))
        view.layer.cornerRadius = 5.0
        view.titleLabel?.textAlignment = .center
        view.clipsToBounds = true
        
        view.setTitle("+ Add", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
        view.setTitleColor(UIColor.white, for: .normal)
        view.backgroundColor = UIColor.red
        view.addTarget(self, action: #selector(ProfileViewController.addFriend), for: .touchUpInside)
        if userid != User.currentUser?.uid {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
        }
        
        nibViews = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)?.first as! ProfileHeaderView
        
        self.stretchyHeader = nibViews //nibViews.first as! GSKStretchyHeaderView
        self.stretchyHeader.contentExpands = false
        self.stretchyHeader.contentShrinks = true
        self.stretchyHeader.expansionMode = .topOnly
        //self.stretchyHeader.stretchDelegate = self // this is completely optional
        self.stretchyHeader.minimumContentHeight = 84
        self.stretchyHeader.contentAnchor = .bottom
        self.stretchyHeader.maximumContentHeight = 120
        self.tableView.addSubview(self.stretchyHeader)
        //ProfileHeaderView
        self.paginator = SelfPostPaginator({ (posts, error) in
            self.tableView.reloadData()
        })
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        Profile.getUserProfile(uid: userid!, withCompletion: { result in
            if result != nil {
                self.userProfile = result
                let username = self.userProfile!["displayName"] as! String
                self.navigationItem.title = username
                self.nibViews?.username.text = username
                self.nibViews?.totalPost.text = "\(self.paginator.posts.count) Posts"
            }
        })
    }
    
    @objc func addFriend() {
        print("enter add friend")
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y:0, width: 60, height: 60))
        activity.center = CGPoint(x: self.view.center.x, y: self.view.center.y - (self.navigationController?.navigationBar.frame.height)! - 30)
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.hidesWhenStopped = true
        activity.backgroundColor = UIColor.gray
        activity.layer.cornerRadius = 5
        activity.clipsToBounds = true
        self.view.addSubview(activity)
        self.view.bringSubview(toFront: activity)
        activity.startAnimating()
        UserManager.addFriend(withUID: self.userid!)
        activity.stopAnimating()
    }

}
extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
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
            cell.delegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toppostCell", for: indexPath) as! PostTableViewCell
            cell.post = post
            cell.delegate = self
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
        tableView.deselectRow(at: indexPath, animated: false)
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    
}
extension ProfileViewController:PostTableViewCellDelegate {
    
    func showProfile(uid:String) {
        
        let view = ProfileViewController.newInstanceFromStoryboard() as! ProfileViewController
        view.userid = uid
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func report() {
        let hokusai = Hokusai()
        hokusai.cancelButtonTitle = "Cancel"
        hokusai.fontName = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold).fontName
        
        hokusai.colorScheme = HOKColorScheme.tsubaki
        hokusai.addButton("Delete"){
        }
        hokusai.show()
        
    }
    
    
}

