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
var countCheckVersionFirst = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var timeCount = 0
    var timer = Timer()
    
    var backgroundTimer : Timer!
    var isShowLogin = false
    
    func createTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        guard self.timeCount <= 59 else {
            self.timer.invalidate()
            return
        }
        self.timeCount += 1
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        
        #else
            Fabric.with([Crashlytics.self])
        #endif
        
        UINavigationBar.appearance().backgroundColor = NAVIGATION_BAR_COLOR
        
        if #available(iOS 10, *) {
            UITabBarItem.appearance().badgeColor = UIColor(hexString: "#DA3535")
        }
        //        UINavigationBar.appearance().tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.85)
        
        // Override point for customization after application launch.
        //Get loan Data from json
        //DataManager.shared.getDataLoanFromJSON()
        
        if userDefault.value(forKey: Notification_Have_New) == nil {
            userDefault.set(false, forKey: Notification_Have_New)
        }
        
        clearValueInValidUserDefaultData()
        
        //Setup start View Controller
        self.setupStartVC()
        
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Register Notifications
        self.registerForRemoteNotifications(application)
        
        //Facebook init
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Init FireBase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if FinPlusHelper.isConnectedToNetwork() {
            self.getLoanCategories()
//            self.getVersion()
        }
        
        //CHECK VERSION ON STORE
        DispatchQueue.global().async {
            do {
                let _ = try self.updateVersionAppCurrent()
            } catch {
                print(error)
            }
        }
        getLoanBorrowerFee()
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
                completionHandler: {(granted, error) in
                    print("Permission granted: \(granted)")
                    
//                    let viewAction = UNNotificationAction(identifier: viewActionIdentifier,
//                                                          title: "View",
//                                                          options: [.foreground])
//
//                    let newsCategory = UNNotificationCategory(identifier: newsCategoryIdentifier,
//                                                              actions: [viewAction],
//                                                              intentIdentifiers: [],
//                                                              options: [])
//
//                    UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
                    
                    self.getNotificationSettings()
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                
                switch settings.authorizationStatus {
                case .authorized:
                    print("Notification authorized")
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                case .denied:
                    print("Notification denied")
                case .notDetermined:
                    print("Notification not Determined")
                case .provisional:
                    break
                }
            }
        } else {
            // Fallback on earlier versions
        }
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
        
        userDefault.set(true, forKey: Notification_Have_New)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowNotificationIdentifier), object: nil)
        
        guard let aps = userInfo["aps"] as? NSDictionary, let alert = aps["alert"] as? NSDictionary else {
            return
        }
        
        if let body = alert["body"] as? String {
            var title = "Thông báo"
            if let tit = alert["title"] as? String {
                title = tit
            }
            
            guard let topVC = UIApplication.shared.topViewController() else { return }
            
            if let _ = topVC as? LoginViewController {
                DataManager.shared.notificationData = alert
                return
            }
            guard !self.isShowLogin else { return }
            
            if let tabbar = topVC as? BorrowerTabBarController, let currentNavi = tabbar.selectedViewController as? UINavigationController, let currentVC = currentNavi.topViewController as? LoanStateViewController  {
                
                currentVC.showAlertView(title: title, message: body, okTitle: "Đồng ý", cancelTitle: nil) { (status) in
                    currentVC.reLoadStatusLoanVC()
                }
                return
            } else {
                DataManager.shared.isNeedReloadLoanStatusVC = true
            }
            
            topVC.showAlertView(title: title, message: body, okTitle: "Đồng ý", cancelTitle: nil)
        }
    }
    
    //    func loadConfigFromFireBase() {
    //
    //        let fetchDuration: TimeInterval = 0
    //        // WARNING: Don't actually do this in production!
    //        //self.activeDebugMode()
    //
    //        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { (status, error) in
    //            if let error = error {
    //                print("Fetch firebase config fail \(error.localizedDescription)")
    //                return
    //            }
    //
    //            RemoteConfig.remoteConfig().activateFetched()
    //            FinPlusHelper.checkVersionWithFireBaseConfigAndShowAlert {
    //                print("Need update App")
    //            }
    //
    //        }
    //
    //    }
    //
    //    func activeDebugMode() {
    //        let debugSetting = RemoteConfigSettings(developerModeEnabled: true)
    //        RemoteConfig.remoteConfig().configSettings = debugSetting
    //    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
        backgroundTimer = Timer.scheduledTimer(timeInterval: BACKGROUND_TIME, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimedCode() {
        self.isShowLogin = true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        self.backgroundTimer.invalidate()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if self.isShowLogin {
            if let wd = UIApplication.shared.delegate?.window, let _wd = wd {
                var vc = _wd.rootViewController
                if vc is UINavigationController {
                    vc = (vc as! UINavigationController).visibleViewController
                }
                
                self.isShowLogin = false
                
                if vc is LoginViewController || vc is EnterPhoneNumberAuthenVC || vc is SetPassAuthenVC {
                    //do something if it's an instance of that class
                } else {
                    let loginVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    let navi = UINavigationController(rootViewController: loginVC)
                    navi.isNavigationBarHidden = true
                    
                    UIView.transition(with: _wd, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                        self.window?.rootViewController = navi
                    }, completion: { (status) in
                        
                    })
                }
            }
        }
        
        guard countCheckVersionFirst > 0 else {
            if countCheckVersionFirst == 0 {
                countCheckVersionFirst = 1
            }
            return
        }
        
        guard DataManager.shared.isCanShowPopupNeedUpdate else { return }
        //With get file config from Server
        self.checkVersion()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        print("applicationWillTerminate")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }
    
    //MARK: Setup Start View Controller
    private func setupStartVC() {
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
                DataManager.shared.config = model
                FinPlusHelper.checkVersionWithConfigAndShowAlert {
                    
                }
                
                guard let version = userDefault.value(forKey: fVERSION_CONFIG) as? String else {
                    userDefault.set(model.version, forKey: fVERSION_CONFIG)
                    userDefault.synchronize()
                    return
                }
                
                if version == model.version {
                    //Không cần thay đổi dữ liệu local
                    DataManager.shared.isUpdateFromConfig = false
                } else {
                    userDefault.set(model.version, forKey: fVERSION_CONFIG)
                    userDefault.synchronize()
                }
            }
            .catch { error in
                print("error API getConfigs")
        }
    }
    
    private func getLoanCategories() {
        APIClient.shared.getLoanCategories()
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanCategories.removeAll()
                DataManager.shared.loanCategories.append(contentsOf: model)
            }
            .catch { error in
                print("error API getLoanCategories")
        }
    }
    
    private func getLoanBorrowerFee() {
        APIClient.shared.getLoanBorrowerFee()
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanBorrowerFee.removeAll()
                DataManager.shared.loanBorrowerFee.append(contentsOf: model)
            }
            .catch { error in
                print("error API getLoanBorrowerFee")
        }
    }
    
    //Check version From server config
    private func checkVersion() {
        APIClient.shared.getConfigs()
            .done(on: DispatchQueue.global()) { model in
                DispatchQueue.main.async {
                    FinPlusHelper.checkVersionWithConfigAndShowAlert {
                        
                    }
                }
            }
            .catch { error in
                print("error API checkVersion")
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
    
    private func updateVersionAppCurrent() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
//            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            print("version : \(version)")
            DataManager.shared.versionOnStore = version
        }
        throw VersionError.invalidResponse
    }
    
}

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
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

