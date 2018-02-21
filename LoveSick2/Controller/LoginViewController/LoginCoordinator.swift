//
//  LoginCoordinator.swift
//  LoginKit
//
//  Created by Daniel Lozano Valdés on 3/26/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import ILLoginKit
import ZAlertView
import JGProgressHUD

class LoginCoordinator: ILLoginKit.LoginCoordinator {

    // MARK: - LoginCoordinator

    override func start() {
        super.start()
        configureAppearance()
    }

    override func finish() {
        super.finish()
    }

    // MARK: - Setup

    func configureAppearance() {
        // Customize LoginKit. All properties have defaults, only set the ones you want.

        // Customize the look with background & logo images
        backgroundImage = UIImage()
        // mainLogoImage =
        // secondaryLogoImage =

        // Change colors
        tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)

        // Change placeholder & button texts, useful for different marketing style or language.
        loginButtonText = "Sign In"
        signupButtonText = "Create Account"
        facebookButtonText = "Login with Facebook"
        forgotPasswordButtonText = "Forgot password?"
        recoverPasswordButtonText = "Recover"
        namePlaceholder = "Name"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Password"
        repeatPasswordPlaceholder = "Confirm password"
    }
    
    override func login(email: String, password: String) {
        let hud = JGProgressHUD(style: .dark)
        let viewController = self.visibleViewController()
        hud.textLabel.text = "Logging in.."
        hud.show(in:viewController!.view)
        
        SessionManager.logIn(email: email, password: password, completion: {(success) in
            hud.dismiss()
            if success {
                let alert = UIAlertController(title: "Success",
                                              message: "Welcome to LoveSick!",
                                              preferredStyle: .alert)
                let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    alert.dismiss(animated: true, completion: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let view = storyboard.instantiateViewController(withIdentifier: "tabbar")
                    viewController?.present(view, animated: true, completion: nil)
                })
                alert.addAction(submitAction)
                viewController?.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Error",
                                              message: "Cannot log in, please try again",
                                              preferredStyle: .alert)
                let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(submitAction)
                viewController?.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func signup(name: String, email: String, password: String) {
        let hud = JGProgressHUD(style: .dark)
        let viewController = self.visibleViewController()
        hud.textLabel.text = "Signing up.."
        hud.show(in:viewController!.view)
        SessionManager.register(email: email, password: password, displayName: name, completion: {(success) in
            hud.dismiss()
            if success {
                let alert = UIAlertController(title: "Success",
                                              message: "Welcome to LoveSick!",
                                              preferredStyle: .alert)
                let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    alert.dismiss(animated: true, completion: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let view = storyboard.instantiateViewController(withIdentifier: "tabbar")
                    viewController?.present(view, animated: true, completion: nil)
                })
                alert.addAction(submitAction)
                viewController?.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Error",
                                              message: "Cannot sign up, please try again",
                                              preferredStyle: .alert)
                let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(submitAction)
                viewController?.present(alert, animated: true, completion: nil)
            }
        })
    }

    // Handle Facebook login/signup via your API
    override func enterWithFacebook(profile: FacebookProfile) {
        print("Login/Signup via Facebook with: FB profile =\(profile)")
    }
    
    // Handle password recovery via your API
    override func recoverPassword(email: String) {
        print("Recover password with: email =\(email)")
    }

}
