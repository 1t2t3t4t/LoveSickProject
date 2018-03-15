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
import Firebase
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    var stretchyHeader: GSKStretchyHeaderView!
    var userid:String?
    var userProfile:[String:Any]?
    var nibViews:ProfileHeaderView?
    var addBtn = UIButton()
    
    private var paginator:SelfPostPaginator!
    override func viewWillAppear(_ animated: Bool) {
        self.extendedLayoutIncludesOpaqueBars = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
       // self.tabBarController?.tabBar.isHidden = true
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
       // self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        addBtn = view
        if userid != User.currentUser?.uid {
            print("check name \(User.currentUser!.uid!) \(userid!)")
            Database.database().reference().child("Users/\(userid!)/FriendRequests/\(User.currentUser!.uid!)").observeSingleEvent(of: .value, with: {snap in
                if snap.exists() {
                    print("have friend request")
                    view.setTitle("Added", for: .normal)
                    view.backgroundColor = UIColor.gray
                
                }
                else {
                    print("not have friend req")
                    view.setTitle("+ Add", for: .normal)
                    view.backgroundColor = UIColor.red
                }
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
            })
        }
        nibViews = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)?.first as! ProfileHeaderView
        
        self.stretchyHeader = nibViews //nibViews.first as! GSKStretchyHeaderView
        self.stretchyHeader.contentExpands = false
        self.stretchyHeader.contentShrinks = true
        self.stretchyHeader.expansionMode = .topOnly
        //self.stretchyHeader.stretchDelegate = self // this is completely optional
        self.stretchyHeader.minimumContentHeight = 84
        self.stretchyHeader.contentAnchor = .bottom
        self.stretchyHeader.maximumContentHeight = 130
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
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y:0, width: 80, height: 80))
        activity.center = CGPoint(x: self.view.center.x, y: self.view.center.y - (self.navigationController?.navigationBar.frame.height)! - 40)
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.hidesWhenStopped = true
        activity.backgroundColor = UIColor.gray
        activity.layer.cornerRadius = 5
        activity.clipsToBounds = true
        self.view.addSubview(activity)
        self.view.bringSubview(toFront: activity)
        
        if addBtn.currentTitle != "Added"{
        activity.startAnimating()
        UserManager.addFriend(withUID: self.userid!,completion: {success in
            activity.stopAnimating()
            if !success {
                let alert = UIAlertController(title: "Error", message: "Cannot add friend, please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in
                    alert.dismiss(animated: true, completion: nil)}))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.addBtn.setTitle("Added", for: .normal)
                self.addBtn.backgroundColor = UIColor.gray
            }
        })
        }
        else {
            let messageAttrString = NSMutableAttributedString(string: "Are you sure you want to remove friend request?", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular),NSAttributedStringKey.foregroundColor:UIColor.darkGray])
            let actionSheet = UIAlertController(title:nil, message: "", preferredStyle: .actionSheet)
            actionSheet.setValue(messageAttrString, forKey: "attributedMessage")
            actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: {_ in
//                SessionManager.logOut({(success) in
//                    let view = LoginViewController.newInstanceFromStoryboard() as! LoginViewController
//                    self.present(view, animated: true, completion: nil)
//                })
                activity.startAnimating()
                Database.database().reference().child("Users/\(self.userid!)/FriendRequests/\(User.currentUser!.uid!)").removeValue(completionBlock: {(error,ref) in
                    activity.stopAnimating()
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: "Cannot remove friend request, please try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in
                            alert.dismiss(animated: true, completion: nil)}))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        self.addBtn.setTitle("+ Add", for: .normal)
                        self.addBtn.backgroundColor = UIColor.red
                    }
            
                })
                
                self.dismiss(animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(actionSheet, animated: true, completion: nil)
        }
       // activity.stopAnimating()
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

