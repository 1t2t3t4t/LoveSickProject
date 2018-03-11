//
//  Extension.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/7/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import Foundation
import UIKit
extension UInt64 {
    
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
    
}
extension UIViewController {
    class func newInstanceFromStoryboard() -> UIViewController {
        let identifier = String(describing: self)
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}

extension String {
    func words() -> [String] {
        var byWords:[String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) {
            guard let word = $0 else { return }
            print($1,$2,$3)
            byWords.append(word)
        }
        return byWords
    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
}
class TimeInterval {
    class func stringFromTimeInterval(interval: Double) -> String {
        let date = Date(timeIntervalSince1970: interval)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        let initialDate = dayTimePeriodFormatter.string(from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date12 = dateFormatter.date(from: initialDate)
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.string(from: date12!)
        
        return date24//dayTimePeriodFormatter.string(from:date)
        
    }
}



extension UIImage {
    func compressImage(image:UIImage) -> Data {
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = image.size.height
        let maxWidth : CGFloat = image.size.width
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                compressionQuality = 1;
            }
        }
        
        let rect = CGRect.init(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in:rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality);
        UIGraphicsEndImageContext();
        
        return imageData!
    }
}
