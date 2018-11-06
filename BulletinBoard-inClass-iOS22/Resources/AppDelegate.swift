//
//  AppDelegate.swift
//  BulletinBoard-inClass-iOS22
//
//  Created by Ivan Ramirez on 11/5/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // NOTE: - This should be in an enum or something to protect against Magic string, dont this way for simplicity
    static let remoteNotificationRecieved = Notification.Name(rawValue: "SchoolAlarmBell")
    
    //1️⃣
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    /*
         //Test
        MessageController.shared.saveNewMessage(with: "🧀 Test From app delgate") { (_) in
        }
         
        */
         // MARK: - Notification Permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { (didAuthorize, error) in
            if let error = error {
                print("\n\n🚀 There was an error with requesting user notifications in: \(#file) \n\n \(#function); \n\n\(error); \n\n\(error.localizedDescription) 🚀\n\n")
                    return
            }
            if didAuthorize == true {
                // NOTE: - Permision granted
                DispatchQueue.main.async {
                    
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                // NOTE: - Take another path
            }
        }
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // NOTE: - to subscribe to notification we need to create something on the cloudkit database to save that selection
        // NOTE: - were not using icloud manager, to keep this class project simple. we would not write this code in here, due to vialation of seperation of concenrs
        //**********
        
        
        // NOTE: - CKquery is what watches for changes
        let ckQuerySubscript = CKQuerySubscription(recordType: Message.messageTypeKey, predicate: NSPredicate(value: true), subscriptionID: UUID().uuidString, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        
        // NOTE: - This is what weill appear
        notificationInfo.title = "New Message!"
        notificationInfo.alertBody = "There was a message added to the bullein Board"
        
        ckQuerySubscript.notificationInfo = notificationInfo
        
        MessageController.shared.publicDatabase.save(ckQuerySubscript) { (_, error) in
            if let error = error {
                print("\n\n🚀 There was an error with saving CKSubscription in: \(#file) \n\n \(#function); \n\n\(error); \n\n\(error.localizedDescription) 👾\n\n")
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // NOTE: - 📡 Radio Tower sending an INTERNAL SIGNAL
        NotificationCenter.default.post(name: AppDelegate.remoteNotificationRecieved, object: nil)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
          NotificationCenter.default.post(name: AppDelegate.remoteNotificationRecieved, object: nil)
    }
    
}

