//
//  EditProfileViewController.swift
//  Tutor
//
//  Created by marky RE on 22/3/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import YPImagePicker
import McPicker
import Firebase
import JGProgressHUD
import AAPickerView
import Alamofire
class EditProfileViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var navTitle:String?
    var imageView:UIImageView?
    var genderLabel:UILabel?
    var isSetting = false
    var ageTextField:String?
    let listArr:[[String]] = [["Change Profile picture"],["Username","Gender","Current Status","Birthday","Email"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.endIgnoringInteractionEvents()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.tableViewBgColor()
        self.navigationItem.title = "Edit Profile"
        if isSetting {
            
            let button = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(EditProfileViewController.setProfile))
            self.navigationItem.rightBarButtonItem = button
        }
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView?.image = User.currentUser.profileImg?.af_imageRoundedIntoCircle()
        if let url = User.currentUser.profileURL as? String {
        if let img = ImageCache.cachedImage(for: url) {
            imageView?.image = img.af_imageRoundedIntoCircle()
            return
        }
        if User.currentUser.profileImg == #imageLiteral(resourceName: "profileLoad") {
            Alamofire.request(User.currentUser.profileURL!).responseImage { response in
                if let image = response.result.value {
                    User.currentUser.profileImg = image
                    self.imageView?.image = image.af_imageRoundedIntoCircle()
                    ImageCache.cache(image, for: User.currentUser!.uid!)
                }
            }
        }
        }
      
    }
    @objc func setProfile() {
        if User.currentUser.gender != "" && User.currentUser.currentStatus != "" && User.currentUser.birthday != "" {
            let initialViewController = storyboard?.instantiateViewController(withIdentifier: "tabbar")
            let window = UIWindow()
            window.rootViewController = initialViewController
            window.makeKeyAndVisible()
            self.dismiss(animated: true, completion: nil)
            let notificationName = NSNotification.Name("removeIgnoreTouch")
            NotificationCenter.default.post(name: notificationName, object: nil)
            self.present(initialViewController!, animated: true, completion: nil)
           
        }
        else {
            let alert = UIAlertController(title: "Error",
                                          message: "Please add all information",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
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
            let reference = Storage.storage().reference().child("ProfilePicture/\(String(describing: Auth.auth().currentUser?.uid)).png")
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
                    Firestore.firestore().collection("Users").document(User.currentUser.uid!).updateData(["profileURL":User.currentUser.profileURL])
                    //Database.database().reference().child("Users/\(User.currentUser.uid!)/profileURL").setValue(User.currentUser.profileURL)
                    self.imageView?.image = newImg.af_imageRoundedIntoCircle()
                }
            })
            
            picker.dismiss(animated: true, completion: {self.tableView.reloadData()})
        }
        self.present(picker, animated: true, completion: nil)
    }
    @objc func backPressed() {
        self.navigationController?.popViewController(animated: true)
        
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
            
            
            if data[0].count == 3 {
                User.currentUser.gender = selections[0]!
                Firestore.firestore().collection("Users").document(User.currentUser.uid!).updateData(["gender":User.currentUser.gender])
//                Database.database().reference().child("Users/\(User.currentUser.uid!)/gender").setValue( User.currentUser.gender)
                cell.textLabel?.text = User.currentUser.gender
            }
            else {
                User.currentUser.currentStatus = selections[0]!
                Firestore.firestore().collection("Users").document(User.currentUser.uid!).updateData(["currentStatus":User.currentUser.currentStatus])
               // Database.database().reference().child("Users/\(User.currentUser.uid!)/currentStatus").setValue( User.currentUser.currentStatus)
                cell.textLabel?.text = User.currentUser.currentStatus
            }
            
            self?.tableView.reloadData()
            
           
        })
    }
    
   
    


}
extension EditProfileViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr[section].count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 75
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! UITableViewCell
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
            cell.textLabel?.text = listArr[indexPath.section][indexPath.row]
            cell.accessoryType = .none
            cell.accessoryView = imageView
            return cell
        }
            else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCellWithRightLabel", for: indexPath) as! DetailTableViewCell
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
            cell.textLabel?.text = listArr[indexPath.section][indexPath.row]
            cell.accessoryType = .none
                switch indexPath.row {
                case 0:
                        cell.rightLabel.text = User.currentUser.username
                    break
                case 1:
                    if User.currentUser.gender != "" {
                        cell.rightLabel.text = User.currentUser.gender
                    }
                    else {
                        cell.accessoryType = .disclosureIndicator
                    }
                    break
                case 2:
                    if User.currentUser.currentStatus != "" {
                        cell.rightLabel.text = User.currentUser.currentStatus
                    }
                    else {
                        cell.accessoryType = .disclosureIndicator
                    }
                    break
                case 3:
                    if User.currentUser.birthday != "" {
                        
                        cell.rightLabel.text = User.currentUser.birthday.toDate()
                    }
                    else {
                        cell.accessoryType = .disclosureIndicator
                    }
                    break
                case 4:
                        cell.rightLabel.text = Auth.auth().currentUser?.email!
                    break
                default:
                    break
                }
            return cell
            }
        
        }
    
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                callCamera()
                break
            default:
                break
            }
        }
        else {
            switch indexPath.row {
            case 1:
                let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
                showPicker(cell: cell,data:[["Male", "Female","Others"]])
                break
            case 2:
                let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
                showPicker(cell: cell,data:[["HeartBreak", "Stress","Feeling down","Others"]])
                break
            case 3:
                print("click age")
                let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
                let picker = AAPickerView(frame: CGRect(x: 120, y: 0, width: cell.frame.width - 135, height: cell.frame.height))
                picker.textColor = UIColor.gray
                picker.textAlignment = .right
                picker.pickerType = .DatePicker
                picker.datePicker?.datePickerMode = .date
                picker.dateFormatter.dateFormat = "dd/MM/YYYY"
                cell.addSubview(picker)
                picker.dateDidChange = { date in
                    
                    User.currentUser.birthday = "\(date)"
                    User.currentUser.ageInterval = date.timeIntervalSince1970
//                    let minAge = Calendar.current.date(byAdding: .year, value: -18, to: Date())
//                    print("minAge ",minAge)
                    print("selectedDate ",  date.timeIntervalSince1970 )
                    Firestore.firestore().collection("Users").document(User.currentUser.uid!).updateData(["birthday":User.currentUser.birthday])
                    Firestore.firestore().collection("Users").document(User.currentUser.uid!).updateData(["ageInterval":User.currentUser.ageInterval])
                }
                picker.becomeFirstResponder()
                break
            default:
                break
            }
        }
            

            
            }
}
extension EditProfileViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
