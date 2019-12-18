//
//  AppDelegate.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit
import UserNotifications

enum Identifiers {
    static let viewAction = "VIEW_IDENTIFIER"
    static let requestCategory = "REQUEST_CATEGORY"
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var requestService: RequestServiceProtocol = RequestService()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // LoginVC, if neither trainer or client is logged in
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController: UIViewController = loginStoryboard.instantiateViewController(withIdentifier: "EventLoginView") 
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let requestViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "RequestsViewController")
        
        if UserDefaults.standard.string(forKey: "eventId") != nil {
            self.window?.rootViewController = requestViewController
        }
        else {
        self.window?.rootViewController = loginViewController
        }
        
        registerForPushNotifications()
        
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]
        
        // 1
        if let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
          
            // refresh notifications
           
            let newRequestData = aps["songRequest"]
            let newRequest = try! JSONDecoder().decode(Request.self, from: newRequestData as! Data)
            NotificationCenter.default.post(name: UPDATE_REQUESTS, object:newRequest)
            
            // 3
           (window?.rootViewController as? UITabBarController)?.selectedIndex = 0
        }
        
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
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
            requestService.registerDeviceToken(eventId: eventId, deviceToken: token)
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
        //add notificaiton to request list
        let newRequestData = aps["songRequest"]
        let newRequest = try! JSONDecoder().decode(Request.self, from: newRequestData as! Data)
        NotificationCenter.default.post(name: UPDATE_REQUESTS, object:newRequest)
      //  print(aps)
    
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
            let newRequestData = aps["songRequest"]
            let newRequest = try! JSONDecoder().decode(Request.self, from: newRequestData as! Data)
            NotificationCenter.default.post(name: UPDATE_REQUESTS, object:newRequest)
        }
        
        // 4
        completionHandler()
    }
}
