//
//  PageViewController.swift
//  LoveSick2
//
//  Created by marky RE on 11/3/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import Pageboy
import Tabman
class PageViewController: TabmanViewController, PageboyViewControllerDataSource {
    var viewControllers:[UIViewController] = []
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.automaticallyAdjustsChildScrollViewInsets = true
        
        self.bar.style = .buttonBar
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let child_1 = storyboard.instantiateViewController(withIdentifier: "toppost") as! TopPostViewController
        let child_2 = storyboard.instantiateViewController(withIdentifier: "newpost") as! NewPostViewController
        viewControllers.append(child_1)
        viewControllers.append(child_2)
        
        self.dataSource = self
        
        // configure the bar
        self.bar.items = [Item(title: "Top"),
                          Item(title: "New")]
    }
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.first
    }
}
