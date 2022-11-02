//
//  AppDelegate.swift
//  DreamPlay
//
//  Created by MAC on 10/06/21.
//

import UIKit
import Alamofire
import FirebaseCore

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
let kScreenHeight = UIScreen.main.bounds.height
let kScreenWidth = UIScreen.main.bounds.width
let kUserDefaults = UserDefaults.standard

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupTabBarAppearance()
      //  registerForPushNotifications()
      //  FirebaseApp.configure()
        if(isLogin()){
            moveToHomeTab()
        }
        return true
    }
    
    class func getAppDelegate()->AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
}
