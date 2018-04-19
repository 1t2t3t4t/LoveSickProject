//
//  AppDelegate.swift
//  LoveSick2
//
//  Created by marky RE on 20/1/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
//        do {
//            try! Auth.auth().signOut()
//        }
//        catch {}
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        SessionManager.checkSignIn(withCompletion: {(success) in
            if success {
                UserManager.queryUser(withUID: (Auth.auth().currentUser?.uid)!) { (user) in
                    if user != nil {
                        User.currentUser = user
                        let notificationName = NSNotification.Name("removeIgnoreTouch")
                        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
                        if User.currentUser.gender == "" || User.currentUser.birthday == "" || User.currentUser.currentStatus == "" {
                            print("did approve")
                            let view = EditProfileViewController.newInstanceFromStoryboard() as! EditProfileViewController
                            view.isSetting = true
                            let nav = UINavigationController(rootViewController: view)
                           self.window?.rootViewController = nav
                            return
                        }
                        return
                    }
                    else {
                        SessionManager.logOut({(success) in
                            let view = LoginViewController.newInstanceFromStoryboard() as! LoginViewController
                            let window = UIWindow(frame: UIScreen.main.bounds)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                            window.rootViewController = initialViewController
                            window.makeKeyAndVisible()
                            //self.dismiss(animated: true, completion: nil)
                        })
                    }
                    return
                }
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "tabbar")
                self.window?.rootViewController = initialViewController
            }
            else{
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                self.window?.rootViewController = initialViewController
                
            }
        })
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
