//
//  DiscoverViewController.swift
//  LoveSick2
//
//  Created by marky RE on 19/4/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var filter:UserFilter!
    var users:[User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupNavigationBar.setupNavTitle(navController: self.navigationController!, navItem: self.navigationItem, message: "Discovery")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        queryData()
        

        // Do any additional setup after loading the view.
    }
    func queryData() {
        UserManager.queryUserFilter(filter: filter, completion: {users in
            if users != nil {
            self.users = users!
            self.tableView.reloadData()
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension DiscoverViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell", for: indexPath) as! DiscoverTableViewCell
        cell.user = self.users[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let view = ProfileViewController.newInstanceFromStoryboard() as! ProfileViewController
        view.userid = self.users[indexPath.row].uid!
        self.navigationController?.pushViewController(view, animated: true)
    }
}
