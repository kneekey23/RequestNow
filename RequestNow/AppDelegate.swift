//
//  AppDelegate.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit
import UserNotifications

enum Identifiers {
    static let viewAction = "VIEW_IDENTIFIER"
    static let requestCategory = "REQUEST_CATEGORY"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LiveChatDelegate {

    var window: UIWindow?
    private var requestService: RequestServiceProtocol = RequestService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LiveChat.licenseId = "11538363"
        LiveChat.delegate = self // Set self as delegate
        UITableView.appearance().backgroundColor = ColorCodes.darkGrey.uicolor()
        registerForPushNotifications()
        
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]
        
        // 1
        if let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
          
            // refresh notifications
            Request.makeRequestGroup(aps)
            
            // 3
           (window?.rootViewController as? UITabBarController)?.selectedIndex = 0
        }
       // UINavigationBar.appearance().tintColor = .white
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                
                // 1
                
                let viewAction = UNNotificationAction(identifier: Identifiers.viewAction, title: "View", options: [.foreground])
                
                // 2
                let requestCategory = UNNotificationCategory(
                    identifier: Identifiers.requestCategory, actions: [viewAction],
                    intentIdentifiers: [], options: [])
                
                // 3
                UNUserNotificationCenter.current().setNotificationCategories([requestCategory])
                self?.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceToken")
        let eventId = UserDefaults.standard.string(forKey: "eventId")
        if let eventId = eventId, !eventId.isEmpty {
            DispatchQueue.once(executionToken: "registerDeviceToken") {
                requestService.registerDeviceToken(eventId: eventId, deviceToken: token)
            }
           
        }
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void
        ) {
        dump(userInfo)
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        print(aps)
        Request.makeRequestGroup(aps)

    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 1
        let userInfo = response.notification.request.content.userInfo
        
        // 2
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            print(aps)
            Request.makeRequestGroup(aps)
        }
        
        // 4
        completionHandler()
    }
}

