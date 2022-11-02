//
//  AppDelegate+Helper.swift
//  DreamPlay
//
//  Created by sismac020 on 18/04/22.
//

import UIKit


extension AppDelegate {
    func setupTabBarAppearance() {
        UINavigationBar.appearance().barTintColor = .init(red: 0.0/255, green: 11.0/255, blue: 67.0/255, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(red: 0.0/255.0, green: 8.0/255.0, blue: 70.0/255.0, alpha: 1.0)], for: .selected)
        UINavigationBar.appearance().tintColor = .white
        // To apply textAttributes to title i.e. colour, font etc.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white, .font : UIFont.init(name: "AvenirNext-DemiBold", size: 22.0)!]
        // To control navigation bar's translucency.
        UINavigationBar.appearance().isTranslucent = false
    }
    
    func isLogin()->Bool{
        if let userLoginStatus = UserDefaults.standard.bool(forKey: "isUserLoggedIn") as? Bool, userLoginStatus == true{
            return true
        }
        return false
    }
    
    func moveToHomeTab(){
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC = mainStoryBoard.instantiateViewController(withIdentifier:"UITabBarController") as! TabBarController//UITabBarController
        setRoot(centerVC)
    }
    func setRoot(_ vc:AnyObject){
//        self.window?.rootViewController = vc
//        self.window?.makeKeyAndVisible()
//        if (vc is UINavigationController){
//            self.window?.rootViewController = vc
//            self.window?.makeKeyAndVisible()
//        }
        if (vc is UIViewController){
//            let nav = UINavigationController.init(rootViewController: vc)
            self.window?.rootViewController = (vc as! UIViewController)
            self.window?.makeKeyAndVisible()
        }
        
        if (vc is UITabBarController){
//            let nav = UINavigationController.init(rootViewController: vc)
            self.window?.rootViewController = (vc as! UITabBarController)
            self.window?.makeKeyAndVisible()
        }

    }
}
