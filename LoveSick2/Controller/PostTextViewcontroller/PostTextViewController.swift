//
//  PostTextViewController.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import McPicker

protocol PostTextViewDelegate:class {
    func getText() -> String
}

class PostTextViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    var tabBar:UITabBarController?
    
    weak var titleDelegate:PostTextViewDelegate?
    weak var contentDelegate:PostTextViewDelegate?
    
    private var category:String = "Generic"
    
    private var anonymously:Bool = false
    
    var contentCell: UITableViewCell = UITableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let leftBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(PostTextViewController.dismissView))
        let rightBtn = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(PostTextViewController.post))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = rightBtn
        self.navigationItem.title = "Text Post"
         tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }

    @objc func dismissView() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ChoosingTableViewCell
        print("check text \(self.titleDelegate?.getText()) \(self.contentDelegate?.getText()) \(cell.label?.text)")
        guard let title = self.titleDelegate?.getText(), let content = self.contentDelegate?.getText(), let categoryTitle = cell.label?.text else {
            let alert = UIAlertController(title: "Error",
                                          message: "Please fill all the information.",
                                          preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(submitAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
       
        if categoryTitle == "Choose Category" || title == "" || content == "" {
            let alert = UIAlertController(title: "Error",
                                          message: "Please fill all the information.",
                                          preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(submitAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        PostManager.post(title: title, content: content, isAnonymous: anonymously, category: self.category)
        guard let bar = tabBar else {
            return
        }
        bar.selectedIndex = 0
        let notificationName1 = NSNotification.Name("ChangeViewToNew")
        NotificationCenter.default.post(name: notificationName1, object: nil)
        let notificationName2 = NSNotification.Name("NewPostReloadData")
        NotificationCenter.default.post(name: notificationName2, object: nil)
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    func showCategory() {
        
        let data = [[PostCategory.Generic.rawValue,PostCategory.Heartbreak.rawValue]]
        let mcPicker = McPicker(data: data)
        mcPicker.toolbarItemsFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        mcPicker.toolbarBarTintColor = .white
        mcPicker.backgroundColor = .white
        mcPicker.backgroundColorAlpha = 0.50
        mcPicker.pickerBackgroundColor = .white
        mcPicker.show(doneHandler: { [weak self] (selections: [Int : String]) -> Void in
            let cell = self?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ChoosingTableViewCell
            cell.label.text = selections[0]
            self?.category = selections[0]!
        })
    }

}
extension PostTextViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! ChoosingTableViewCell
            
            cell.style = .category
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as!
            TitleTableViewCell
            self.titleDelegate = cell
            cell.textView.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as!
            ContentTableViewCell
            self.contentDelegate = cell
            contentCell = cell
            cell.textView.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! ChoosingTableViewCell
            cell.style = .anonymous
           // cell.delegate = self
            return cell
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 1:
            self.view.endEditing(true)
            showCategory()
            //easy.toggleView()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 {
            return 60
        }
        else{
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

//extension PostTextViewController: ChoosingStyleDelegate, EasyPickerDelegate {
//    func anonymousChanged(_ value: Bool) {
//        self.anonymously = value
//    }
//
//    func categorySelected(_ value: String) {
//
//    }
//
//    func didSelectCell(_ easyPickerView: EasyPickerView, at indexPath: IndexPath) {
//        let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ChoosingTableViewCell
//        cell.label.text = easyPickerView.selectedValue.rawValue
//    }
//}

extension PostTextViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
    
}

