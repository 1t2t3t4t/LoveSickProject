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
import Fusuma
import Alamofire
import AlamofireImage
import Firebase
import YPImagePicker
import JGProgressHUD
class SettingViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var nibViews:SettingHeaderView?
    
   let settings = [["Edit Profile","Account"],["Invite"],["Contact Us"],["Log Out"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.tableViewBgColor()
        self.navigationItem.title = "Edit Profile"
       // tableView.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)//UIColor.tableViewBackgroundColor()
        nibViews = Bundle.main.loadNibNamed("SettingHeaderView", owner: self, options: nil)?.first as! SettingHeaderView
        nibViews?.delegate = self
        
        //CGRect(x: 0, y: 0, width: nibViews?.frame.width, height: nibViews?.frame.height)
        //self.tableView.tableHeaderView = nibViews
        // Do any additional setup after loading the view.
        
    }
    func showAccountAcSheet() {
        let messageAttrString = NSMutableAttributedString(string: "Select your options", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular),NSAttributedStringKey.foregroundColor:UIColor.darkGray])
        let actionSheet = UIAlertController(title:nil, message: "", preferredStyle: .actionSheet)
        actionSheet.setValue(messageAttrString, forKey: "attributedMessage")
        actionSheet.addAction(UIAlertAction(title: "Change Email", style: .destructive, handler: {_ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Reset password", style: .destructive, handler: {_ in
  
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(actionSheet, animated: true, completion: nil)
        
    }

    func logout() {
        
        let messageAttrString = NSMutableAttributedString(string: "Are you sure you want to logout?", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular),NSAttributedStringKey.foregroundColor:UIColor.darkGray])
        let actionSheet = UIAlertController(title:nil, message: "", preferredStyle: .actionSheet)
        actionSheet.setValue(messageAttrString, forKey: "attributedMessage")
        actionSheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {_ in
            SessionManager.logOut({(success) in
                let view = LoginViewController.newInstanceFromStoryboard() as! LoginViewController
                let window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                window.rootViewController = initialViewController
                //window?.makeKeyAndVisible()
                self.present(view, animated: true, completion: nil)
                window.makeKeyAndVisible()
                //self.dismiss(animated: true, completion: nil)
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
    func showInviteAC() {
          let messageAttrString = NSMutableAttributedString(string: "Select your options", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular),NSAttributedStringKey.foregroundColor:UIColor.darkGray])
        let actionSheet = UIAlertController(title:nil, message: "", preferredStyle: .actionSheet)
        actionSheet.setValue(messageAttrString, forKey: "attributedMessage")
        actionSheet.addAction(UIAlertAction(title: "SMS ", style: .default, handler: {_ in
            self.sendSMSText()
        }))
            actionSheet.addAction(UIAlertAction(title: "Email", style: .default, handler: {_ in
                self.sendEmail(body:"Yo dude, download this app.")
            }))
                actionSheet.addAction(UIAlertAction(title: "Cancel ", style: .cancel, handler: {_ in
                    self.dismiss(animated: true, completion: nil)
                }))
        self.present(actionSheet, animated: true, completion: nil)
    }
}
extension SettingViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nibViews
        }
        
        return nil
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section != 0 {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
        return 140.0
        }
        return 20.0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingcell") as! UITableViewCell
        cell.textLabel?.text = settings[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        switch settings[indexPath.section][indexPath.row] {
        case "Edit Profile":
            let view = EditProfileViewController.newInstanceFromStoryboard() as! EditProfileViewController
            self.navigationController?.pushViewController(view, animated: true)
            break
        case "Account":
            showAccountAcSheet()
            break
        case "Invite":
            self.showInviteAC()
            break
        case "Contact Us":
            self.sendEmail(body: "")
        case "Log Out":
            logout()
            break
        default:
            return
        }
    }
    
}
extension SettingViewController:MFMailComposeViewControllerDelegate {
    func sendEmail(body:String) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        if body != "" {
            composeVC.setMessageBody(body, isHTML: false)
        }
        else {
        composeVC.setToRecipients(["stellateamdev@gmail.com"])
        }
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
    func callCamera() {
        var config = YPImagePickerConfiguration()
        config.onlySquareImagesFromLibrary = true
        config.onlySquareImagesFromCamera = true
        config.libraryTargetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = true
        config.shouldSaveNewPicturesToAlbum = true
        // config.albumName = "MyGreatAppName"
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.videoFromLibraryTimeLimit = 20
        //config.showsCrop = .rectangle(ratio: (1/1))
        config.wordings.libraryTitle = "Library"
        config.wordings.cameraTitle = "Camera"
        config.hidesStatusBar = false
        let picker = YPImagePicker(configuration: config)
        picker.didSelectImage = { [unowned picker] img in
            let newImg = img.af_imageScaled(to: img.size.applying(CGAffineTransform(scaleX: 0.1, y: 0.1)))
            User.currentUser.profileImg = newImg
            guard let imageData = UIImagePNGRepresentation(newImg) else {
                print("cast png error")
                return
            }
            let reference = Storage.storage().reference().child("ProfileImages/\(User.currentUser.uid != "" ? User.currentUser.uid : Auth.auth().currentUser!.uid).png")
            let hud = JGProgressHUD(style: .dark)
            let viewController = self
            hud.textLabel.text = "Uploading.."
            hud.show(in:viewController.view)
            reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
                hud.dismiss()
                if let error = error {
                    print("upload error")
                    assertionFailure(error.localizedDescription)
                }
                else {
                    hud.dismiss()
                    User.currentUser.profileURL = (metadata?.downloadURL()?.absoluteString)!
                    self.nibViews?.profileImage.image = newImg.af_imageRoundedIntoCircle()
                }
            })
            
            picker.dismiss(animated: true, completion: {self.tableView.reloadData()})
        }
        self.present(picker, animated: true, completion: nil)
    }
}
extension SettingViewController:SettingHeaderViewDelegate {
    func edit() {
        let messageAttrString = NSMutableAttributedString(string: "Select your options", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular),NSAttributedStringKey.foregroundColor:UIColor.darkGray])
        let actionSheet = UIAlertController(title:nil, message: "", preferredStyle: .actionSheet)
        actionSheet.setValue(messageAttrString, forKey: "attributedMessage")
        actionSheet.addAction(UIAlertAction(title: "Choose image ", style: .default, handler: {_ in
            self.callCamera()
//            let fusuma = FusumaViewController()
//            fusuma.delegate = self // To allow for video capturing with .library and .camera available by default
//            fusuma.cropHeightRatio = 1
//            fusumaCameraRollTitle = "Library"
//            fusumaCameraTitle = "Camera"// Height-to-width ratio. The default value is 1, which means a squared-size photo.
//            fusuma.allowMultipleSelection = false// You can select multiple photos from the camera roll. The default value is false.
//            self.present(fusuma, animated: true, completion: nil)
            }))
    actionSheet.addAction(UIAlertAction(title: "Delete image", style: .destructive, handler: {_ in
        self.nibViews?.profileImage.image = #imageLiteral(resourceName: "profileLoad")
        self.tableView.reloadData()
        Database.database().reference().child("Users/\(User.currentUser?.uid)/profileURL").removeValue()
    }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
}
extension SettingViewController:FusumaDelegate {
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }
    
    func fusumaCameraRollUnauthorized() {
        
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y:0, width: 80, height: 80))
        activity.center = CGPoint(x: self.view.center.x, y: self.view.center.y - (self.navigationController?.navigationBar.frame.height)! - 40 + (self.tabBarController?.tabBar.frame.height)!)
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.hidesWhenStopped = true
        activity.backgroundColor = UIColor.gray
        activity.layer.cornerRadius = 5
        activity.clipsToBounds = true
        self.tableView.addSubview(activity)
        self.tableView.bringSubview(toFront: activity)
        activity.startAnimating()
        let newimg = image.af_imageScaled(to: image.size.applying(CGAffineTransform(scaleX: 0.1, y: 0.1)))
        
        guard let imageData = UIImagePNGRepresentation(newimg) else {
            print("cast png error")
            activity.stopAnimating()
            return
        }
        let autoid = Database.database().reference().childByAutoId().key
        let reference = Storage.storage().reference().child("ProfilePicture/\(User.currentUser!.uid!).png")
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            
            if let error = error {
                activity.stopAnimating()
                print("upload error")
                assertionFailure(error.localizedDescription)
            }
            else{
                Database.database().reference().child("Users/\(User.currentUser!.uid!)/profileURL").setValue(metadata?.downloadURL()?.absoluteString, withCompletionBlock: {(error,ref) in
                    activity.stopAnimating()
                    if error == nil {
                        
                        self.nibViews?.profileImage.image = newimg
                         self.tableView.reloadData()
                    }
                })//setValue(metadata?.downloadURL()?.absoluteString)
               
            }
        })
        
    }
}

