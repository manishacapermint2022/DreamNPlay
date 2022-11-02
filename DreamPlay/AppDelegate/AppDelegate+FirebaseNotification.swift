//
//  AppDelegate+FirebaseNotification.swift
//  DreamPlay
//
//  Created by sismac20 on 26/05/22.
//

import Foundation
import FirebaseCore
import FirebaseMessaging
import FirebaseAnalytics
import SwiftyJSON

extension AppDelegate: UNUserNotificationCenterDelegate {
    //MARK:- Register For Push Notifications
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device token for push notification - \(deviceTokenString)")
        Messaging.messaging().apnsToken = deviceToken
        print("deviceToken-\(deviceToken)")
        kUserDefaults.set(deviceTokenString, forKey: "DeviceTokenString")
        kUserDefaults.set(deviceToken, forKey: "DeviceTokenPushNotification")
        kUserDefaults.synchronize()
        self.updateDeviceToken { (result) in
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device Token Not Found \(error)")
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.userInfo)
        let payloadJSON = JSON(notification.request.content.userInfo)
        print(payloadJSON)
        completionHandler([.alert, .badge, .sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let payloadJSON = JSON(response.notification.request.content.userInfo)
        print("payloadJSON----\(payloadJSON)")
        completionHandler()
    }
    
    //MARK:- Open Notification Controller
    func openNotificationController() {
        
    }
    
    func updateDeviceToken(completion: @escaping(_ result: Bool) -> Void) {
        Console.log(completion)
    }
}



extension AppDelegate : MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        kUserDefaults.set("\(String(describing: fcmToken!))", forKey: "DEVICE_TOKEN_PUSH_NOTIFICATIONFORFCM")
        kUserDefaults.synchronize()
        // apis implementation
    }
    
}
