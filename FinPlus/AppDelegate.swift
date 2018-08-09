//
//  AppDelegate.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import UserNotifications
import CoreData
import Fabric
import Crashlytics

//Cho optionalText trong tạo loan
var optionalTextCount = 10

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        // Override point for customization after application launch.
        // Get Loan Data from Json
        DataManager.shared.getDataLoanFromJSON()
        
        //Setup start View Controller
        self.setupStartVC()
        
        // Register Notifications
        self.registerForRemoteNotifications(application)
        
        //Facebook init
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        // Get Version
        self.getVersion()
        
        // Init FireBase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // Register For Remote Notifications
    func registerForRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
    }
    
    // Get Token for remote Notification (sử dụng fireBase thì k chạy vào đây, lấy token ở fireBase)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        var token = ""
        let tokenParts = deviceToken.map{ data in
            return String(format: "%02.2hhx", data)
        }
        
        token = tokenParts.joined()
        
        print("deviceToken \(token)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("userInfo \(userInfo)")
        self.handleNotificationFireBase(userInfo: userInfo)
        
    }
    
    
    func handleNotificationFireBase(userInfo: [AnyHashable : Any]) {
        guard let aps = userInfo["aps"] as? NSDictionary, let alert = aps["alert"] as? NSDictionary else {
            return
        }
        
        if let body = alert["body"] as? String {
            
            var title = "Thông báo"
            if let t = alert["title"] as? String {
                title = t
            }
            
            guard let topVC = UIApplication.shared.topViewController() else { return }
            
            if let _ = topVC as? LoginViewController {
                DataManager.shared.notificationData = alert
                return
            }
            
            if let tabbar = topVC as? BorrowerTabBarController, let currentNavi = tabbar.selectedViewController as? UINavigationController, let currentVC = currentNavi.topViewController as? LoanStateViewController  {
                
                currentVC.showAlertView(title: title, message: body, okTitle: "OK", cancelTitle: nil) { (status) in
                    currentVC.reLoadStatusLoanVC()
                }
                
                return
            }
            
            topVC.showAlertView(title: title, message: body, okTitle: "OK", cancelTitle: nil)
            
        }
        
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
        // Saves changes in the application's managed object context before the application terminates.
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }
    
    //MARK: Setup Start View Controller
    
    private func setupStartVC() {

        // lionel fix to test
//        let payVC = TestBorrowingPayViewController(nibName: "TestBorrowingPayViewController", bundle: nil)
//        let navi = UINavigationController(rootViewController: payVC)
//        self.window?.rootViewController = navi
//        return
        // end
        
        let isFirstLaunch = UserDefaults.isFirstLaunch()
        if isFirstLaunch == true {
            let enterPhoneVC = UIStoryboard(name: "OnBoard", bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = enterPhoneVC

            return
        } else {
            guard let _ = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String else {
                // chưa có account Login
                let enterPhoneVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "EnterPhoneNumberAuthenNavi") as! UINavigationController

                self.window?.rootViewController = enterPhoneVC

                return
            }
            //Đã có account Login
            let loginVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "LoginViewControllerNavi") as! UINavigationController

            self.window?.rootViewController = loginVC
        }
        
    }
    
    //MARK: GetVersion
    // Get version phải get ở ngoài Appdelegate
    private func getVersion() {
        APIClient.shared.getConfigs()
            .done(on: DispatchQueue.main) { model in
                print("Version\(model)")
                DataManager.shared.config = model
                
                guard let version = userDefault.value(forKey: fVERSION_CONFIG) as? String else {
                    userDefault.set(model.version!, forKey: fVERSION_CONFIG)
                    userDefault.synchronize()
                    return
                }
                
                if version == model.version! {
                    //Không cần thay đổi dữ liệu local
                    DataManager.shared.isUpdateFromConfig = false
                } else {
                    userDefault.set(model.version!, forKey: fVERSION_CONFIG)
                    userDefault.synchronize()
                }
                
            }
            .catch { error in
            }
    }
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "caohai.PresentationSkill" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "FinPlus", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."

        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }


}



//MARK: UNUser Notification Center Delegate
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        // Print full message.
        //Khi dang mở app
        print(userInfo)
        self.handleNotificationFireBase(userInfo: userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        // Print full message.
        //Khi app đang dứoi background
        print(userInfo)
        self.handleNotificationFireBase(userInfo: userInfo)
        
        completionHandler()
    }
    
    

    
    
    
}





// MARK: Messaging Delegate
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Messaging \(remoteMessage.appData)")
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        DataManager.shared.pushNotificationToken = fcmToken
        
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        
    }
    
    
    
}

