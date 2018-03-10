//
//  NewFeedsViewController.swift
//  LoveSick2
//
//  Created by marky RE on 21/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class NewFeedsViewController: ButtonBarPagerTabStripViewController {
    var isReload = false
    
    override func viewDidLoad() {
        // set up style before super view did load is executed
        self.view.backgroundColor = UIColor.red
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .blue
        //-
        super.viewDidLoad()
        print("pagerstrip \(self.view.frame.height) \(buttonBarView.frame.height)")
        
        let notificationName = NSNotification.Name("ChangeViewToNew")
        NotificationCenter.default.addObserver(self, selector: #selector(NewFeedsViewController.changePageViaNoti(notification:)), name: notificationName, object: nil)
        buttonBarView.removeFromSuperview()
        navigationController?.navigationBar.addSubview(buttonBarView)
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor(white: 0.5, alpha: 1)
            newCell?.label.textColor = UIColor.black //.white
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            } else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
       buttonBarView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        buttonBarView.isHidden = false
        
    }
    @objc func changePageViaNoti(notification: NSNotification) {
        self.moveToViewController(at: 1)
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let child_1 = storyboard.instantiateViewController(withIdentifier: "toppost") as! TopPostViewController
        let child_2 = storyboard.instantiateViewController(withIdentifier: "newpost") as! NewPostViewController
        guard isReload else {
            return [child_1, child_2]
        }
        
        var childViewControllers = [child_1, child_2]
        
        for index in childViewControllers.indices {
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                childViewControllers.swapAt(index, n)
            }
        }
        let nItems = 1 + (arc4random() % 8)
        return Array(childViewControllers.prefix(Int(nItems)))
    }
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
    
    override func configureCell(_ cell: ButtonBarViewCell, indicatorInfo: IndicatorInfo) {
        super.configureCell(cell, indicatorInfo: indicatorInfo)
        cell.backgroundColor = .clear
    }
    
}

