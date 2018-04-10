//
//  FilterViewController.swift
//  LoveSick2
//
//  Created by marky RE on 10/4/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    let listArr = ["Gender","Feeling Status"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(FilterViewController.searchFriend))

        // Do any additional setup after loading the view.
    }
    @objc func searchFriend() {
        let view = SearchViewController.newInstanceFromStoryboard() as! SearchViewController
        self.navigationController?.pushViewController(view, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FilterViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        
        default:
        break
    }
    return cell
    }
}
