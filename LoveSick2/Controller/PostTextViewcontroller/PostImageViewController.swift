//
//  PostImageViewController.swift
//  LoveSick2
//
//  Created by marky RE on 22/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import Fusuma
import KDCircularProgress

protocol PostImageViewDelegate:class {
    func getText() -> String
}

class PostImageViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var progressView:KDCircularProgress!
    
    var tabBar:UITabBarController?
    var contentCell: UITableViewCell = UITableViewCell()
    
    private var anonymously:Bool = false
    private var postImage:UIImage?
    
    weak var titleDelegate:PostTextViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.isHidden = true
        progressView.glowMode = .noGlow
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.backgroundColor = UIColor.gray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.init(white: 0.5, alpha: 0.15)
        let leftBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(PostImageViewController.dismissView))
        let rightBtn = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(PostImageViewController.post))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = rightBtn
        self.navigationItem.title = "Image Post"
        tableView.tableFooterView = UIView()
        
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        guard let title = self.titleDelegate?.getText() else {
            print("title is null")
            return
        }
        guard let image = self.postImage else {
            print("image is null")
            return
        }
        self.progressView.isHidden = false
        PostManager.postImage(title: title, image: image, progressView: progressView, isAnonymous: anonymously, completion: {success in
            if success! {
                guard let bar = self.tabBar else {
                    return
                }
                self.progressView.isHidden = true
                bar.selectedIndex = 0
                let notificationName1 = NSNotification.Name("ChangeViewToNew")
                NotificationCenter.default.post(name: notificationName1, object: nil)
                let notificationName2 = NSNotification.Name("NewPostReloadData")
                NotificationCenter.default.post(name: notificationName2, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}

extension PostImageViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! ChoosingTableViewCell
            cell.style = .anonymous
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! ChoosingTableViewCell
            cell.style = .category
            cell.delegate = self
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as!
            TitleTableViewCell
            self.titleDelegate = cell
            cell.textView.delegate = self
            return cell
        default:
            if postImage == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "choosePhotoCell", for: indexPath) as!
            ChoosePhotoTableViewCell
            cell.delegate = self
            contentCell = cell
            let indent:CGFloat = 10000
            cell.separatorInset = UIEdgeInsetsMake(0, indent, 0, 0)
            cell.indentationWidth = indent * -1
            cell.indentationLevel = 1
            return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "previewPhotoCell", for: indexPath) as!
                PreviewImageTableViewCell
                cell.setCustomImage(image: postImage!)
                cell.delegate = self
                contentCell = cell
                let indent:CGFloat = 10000
                cell.separatorInset = UIEdgeInsetsMake(0, indent, 0, 0)
                cell.indentationWidth = indent * -1
                cell.indentationLevel = 1
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        }
        else{
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
}
extension PostImageViewController:PreviewImageTableViewCellDelegate {
    func deletePhoto() {
        print("press deletephoto")
        postImage = nil
       self.tableView.reloadData()
    }
}
extension PostImageViewController:ChoosePhotoTableViewCellDelegate {
    func chooseImage() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self // To allow for video capturing with .library and .camera available by default
        fusuma.cropHeightRatio = 1
        fusumaCameraRollTitle = "Library"
        fusumaCameraTitle = "Camera"// Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = false// You can select multiple photos from the camera roll. The default value is false.
        self.present(fusuma, animated: true, completion: nil)
    }
    
    
}
extension PostImageViewController: ChoosingStyleDelegate {
    func anonymousChanged(_ value: Bool) {
        self.anonymously = value
    }
    
    func categorySelected(_ value: String) {
        
    }
    
}

extension PostImageViewController:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
           
            let currentOffset = tableView.contentOffset
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.setContentOffset(currentOffset, animated: false)
        
    }
    
}

extension PostImageViewController:FusumaDelegate {
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }
    
    func fusumaCameraRollUnauthorized() {
        
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        postImage = image.af_imageScaled(to: image.size.applying(CGAffineTransform(scaleX: 0.1, y: 0.1)))
        self.tableView.reloadData()
    }
}


