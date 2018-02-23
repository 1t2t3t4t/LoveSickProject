//
//  UploadPhoto.swift
//  LoveSick2
//
//  Created by marky RE on 23/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import Foundation
import Firebase
import KDCircularProgress
class UploadPhoto {
    
    static func uploadPostImage(_ image: UIImage,_ progressView:KDCircularProgress, completion: @escaping (String?) -> Void) {
//        let temp = compressImage(image: image)
//        guard let img = UIImage(data: temp) else {
//            return
//        }
        guard let imageData = UIImagePNGRepresentation(image) else {
            print("cast png error")
            return completion(nil)
        }
        let autoid = Database.database().reference().childByAutoId().key
        let reference = Storage.storage().reference().child("PostImages/\(autoid).png")
       let uploadTask =  reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("upload error")
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            completion(metadata?.downloadURL()?.absoluteString)
        })
        uploadTask.observe(.progress, handler: {snapshot in
            progressView.angle = (Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)) * 360
            print("snapshot.progress \(snapshot.progress)")
        })
    }
    static func compressImage(image:UIImage) -> Data {
        // Reducing file size to a 10th
        
        let actualHeight : CGFloat = image.size.height
        let actualWidth : CGFloat = image.size.width
       
        let compressionQuality : CGFloat = 0.5
       
        
        let rect = CGRect.init(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in:rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality);
        UIGraphicsEndImageContext();
        
        return imageData!
    }
}
