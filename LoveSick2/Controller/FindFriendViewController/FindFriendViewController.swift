//
//  FindFriendViewController.swift
//  LoveSick2
//
//  Created by marky RE on 17/4/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import McPicker
import RangeSeekSlider
class FindFriendViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    let filterArr = ["Gender","Age Range","Current Status"]
    let filter = UserFilter()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        filter.minAge = 18
        filter.maxAge = 35
        self.tableView.tableFooterView = UIView()
        SetupNavigationBar.setupNavigationBar(navController: self.navigationController!, navItem: self.navigationItem, message: "Discovery")
        let rightBth = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(FindFriendViewController.nextView))
        rightBth.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBth
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func nextView(){
        let gender = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! DetailTableViewCell
        let currentStatus = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DetailTableViewCell
        if gender.rightLabel.text == "" || currentStatus.rightLabel.text == "" {
            let alert = UIAlertController(title: "Please enter all the information",
                                          message: nil,
                preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(submitAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        filter.gender = gender.rightLabel?.text!
        filter.currentStatus = currentStatus.rightLabel?.text!
        let view = DiscoverViewController.newInstanceFromStoryboard() as! DiscoverViewController
        print("check filter0 \(self.filter.currentStatus) \(self.filter.maxAge) \(self.filter.gender) \(self.filter.minAge)")
        view.filter = self.filter
        self.navigationController?.pushViewController(view, animated: true)
        
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
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0:
            let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
            showPicker(cell:cell , data: [["Male","Female","Others","Any"]])
            break
        case 2:
            let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
            showPicker(cell:cell , data: [["HeartBreak", "Stress","Feeling down","Others"]])
            break
        default:
            break
        }
    }
}
extension FindFriendViewController:RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
            filter.minAge = Int(minValue)
            filter.maxAge = Int(maxValue)
        }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue: CGFloat) -> String? {
        if stringForMaxValue == slider.maxValue {
            return "\(Int(stringForMaxValue))+"
        }
        return "\(Int(stringForMaxValue))"
    }
}


