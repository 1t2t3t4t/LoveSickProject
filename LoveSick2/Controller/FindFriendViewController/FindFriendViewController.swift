//
//  FindFriendViewController.swift
//  LoveSick2
//
//  Created by marky RE on 17/4/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import McPicker
class FindFriendViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    let filterArr = ["Gender","Age Range","Current Status"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        SetupNavigationBar.setupNavigationBar(navController: self.navigationController!, navItem: self.navigationItem, message: "Discovery")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(getter: FindFriendViewController.next))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func next(){
        
    }
    func showPicker(cell:DetailTableViewCell,data:[[String]]) {
        // let data = [["Male", "Female","Others"]]
        let mcPicker = McPicker(data: data)
        mcPicker.toolbarItemsFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        mcPicker.toolbarButtonsColor = UIColor.blue
        mcPicker.toolbarBarTintColor = .white
        mcPicker.backgroundColor = .white
        mcPicker.backgroundColorAlpha = 0.50
        mcPicker.pickerBackgroundColor = .white
        mcPicker.show(doneHandler: { [weak self] (selections: [Int : String]) -> Void in
            cell.rightLabel.text = selections[0]
            self?.tableView.reloadData()
            
            
        })
    }

}
extension FindFriendViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 120
        }
        else{
            return 55
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ageRangeCell", for: indexPath) as! AgeRangeTableViewCell
            cell.title.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
            cell.title.text = "Age Range"
            return cell
            break
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCellWithRightLabel", for: indexPath) as! DetailTableViewCell
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
            cell.textLabel?.text = filterArr[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
        switch indexPath.row {
        case 0:
            showPicker(cell:cell , data: [["Male","Female","Others"]])
            break
        case 2:
            showPicker(cell:cell , data: [["HeartBreak", "Stress","Feeling down","Others"]])
            break
        default:
            break
        }
    }
}
