//
//  Extension.swift
//  LoveSick2
//
//  Created by Nathakorn on 2/7/18.
//  Copyright © 2018 marky RE. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func newInstanceFromStoryboard() -> UIViewController {
        let identifier = String(describing: self)
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}
