//
//  SetupNavigationBar.swift
//  Tutor
//
//  Created by marky RE on 13/3/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import Foundation
import UIKit
class SetupNavigationBar {
    class func setupNavigationBar(navController:UINavigationController,navItem:UINavigationItem,message:String) {
        navController.navigationBar.isTranslucent = false

        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label.text = message
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
        navItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }
    class func setupNavTitle(navController:UINavigationController,navItem:UINavigationItem,message:String){
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy), NSAttributedStringKey.foregroundColor : UIColor.black]
        navController.navigationBar.titleTextAttributes = attributes
        navItem.title = message
    }
}
