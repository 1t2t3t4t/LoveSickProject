//
//  SettingViewController.swift
//  LoveSick2
//
//  Created by marky RE on 25/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import MessageUI
class SettingViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
   let settings = [["Profile","Account"],["Invite","Block List"],["Contact Us"],["Log Out"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.tableViewBackgroundColor()

        // Do any additional setup after loading the view.
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
        switch settings[indexPath.section][indexPath.row] {
        case "Log Out":
            SessionManager.logOut(nil)
            self.dismiss(animated: true, completion: nil)
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


