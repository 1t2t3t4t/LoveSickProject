//
//  SettingViewController.swift
//  LoveSick2
//
//  Created by marky RE on 25/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import MessageUI
import ZAlertView
class SettingViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
   let settings = [["Profile","Account"],["Invite","Friend Requests"],["Contact Us"],["Log Out"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.tableViewBackgroundColor()

        // Do any additional setup after loading the view.
    }

    func logout() {
        
        let messageAttrString = NSMutableAttributedString(string: "Are you sure you want to logout?", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular),NSAttributedStringKey.foregroundColor:UIColor.darkGray])
        let actionSheet = UIAlertController(title:nil, message: "", preferredStyle: .actionSheet)
        actionSheet.setValue(messageAttrString, forKey: "attributedMessage")
        actionSheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {_ in
            SessionManager.logOut({(success) in
                let view = LoginViewController.newInstanceFromStoryboard() as! LoginViewController
                
                self.present(view, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            })
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(actionSheet, animated: true, completion: nil)
//        let dialog = ZAlertView(title: "Are you sure you want to log out?", message: "", alertType: .confirmation)
//        dialog.addButton("Log Out", touchHandler: {_ in
//            SessionManager.logOut(nil)
//            self.dismiss(animated: true, completion: nil)
//
//        })
//        dialog.addButton("Cancel", touchHandler: {_ in dialog.dismissAlertView()})
//        dialog.show()
        
    }
}
extension SettingViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingcell") as! UITableViewCell
        cell.textLabel?.text = settings[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        switch settings[indexPath.section][indexPath.row] {
        case "Friend Requests":
            self.performSegue(withIdentifier: "toFriendRequest", sender: self)
        case "Log Out":
            logout()
        default:
            return
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}
extension SettingViewController:MFMailComposeViewControllerDelegate {
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["stellateamdev@gmail.com"])
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: {
        })
    }
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion:{})
    }
}
extension SettingViewController:MFMessageComposeViewControllerDelegate {
    func sendSMSText() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Yo dude. Download this app"
            controller.recipients = []
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}


