//
//  ViewController.swift
//  LoveSick2
//
//  Created by marky RE on 20/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import ILLoginKit

class LoginViewController: UIViewController {
    
    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController: self)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginCoordinator.start()
    }

}

