//
//  TabBarController.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import Hokusai
class TabBarController: UITabBarController{
    var previousIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self

        // Do any additional setup after loading the view.
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 2 {
            
            print("enter tag 2")
           
             let hokusai = Hokusai()
            hokusai.cancelButtonTitle = "Cancel"
            
            hokusai.cancelButtonAction = {
                 self.selectedIndex = self.previousIndex
            }
            hokusai.fontName = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold).fontName
            
            hokusai.colorScheme = HOKColorScheme.inari
            hokusai.addButton("Text") {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyBoard.instantiateViewController(withIdentifier: "postText") as! PostTextViewController
                let nav = UINavigationController(rootViewController: view)
                self.present(nav, animated: true, completion: nil)
                 self.selectedIndex = self.previousIndex
            }
            hokusai.addButton("Image"){
                 self.selectedIndex = self.previousIndex
            }
            hokusai.show()
        }
        else{
            previousIndex = item.tag
        }
    }

}
extension TabBarController:UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == self.tabBarController?.viewControllers![2] {
            return false
        }
        return true
    }
}

