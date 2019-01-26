//
//  AppDelegate.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//

import UIKit
import CoreData
import Seam3
import GoogleMobileAds
import Flurry_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
//    lazy var coreDataStack = CoreDataStack.shared(modelName: ModelName.ToDoFinalApp)


    var window: UIWindow?
var smStore: SMStore!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize the Google Mobile Ads SDK.
        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
//        GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544~1458002511")
        
        //my ad using to do final app
         GADMobileAds.configure(withApplicationID: "ca-app-pub-5462116334906512~1231030276")
        
        
        //analytics
//        guard let gai = GAI.sharedInstance() else {
//            assert(false, "Google Analytics not configured correctly")
//        }
//        gai.tracker(withTrackingId: "YOUR_TRACKING_ID")
//        // Optional: automatically report uncaught exceptions.
//        gai.trackUncaughtExceptions = true
//        
//        // Optional: set Logger to VERBOSE for debug information.
//        // Remove before app release.
//        gai.logger.logLevel = .verbose;
        
        //Flurry anyalitics
        Flurry.startSession("V7K6HQZ9WBN8ZZX8T2ZD", with: FlurrySessionBuilder
            .init()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))

        
        setUpSplitViewController()
        
        self.smStore = persistentContainer.persistentStoreCoordinator.persistentStores.first as? SMStore
        
        CoreDataManager.shared.managedContext = self.persistentContainer.viewContext
        //CoreDataManager.shared.smStore = self.smStore
        CloudKitManager.shared.smStore = self.smStore
        
        application.registerForRemoteNotifications()
        
        return true
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        self.smStore?.handlePush(userInfo: userInfo, fetchCompletionHandler: { result in
            print("result \(result)")
        })
    }
    
    func setUpSplitViewController() {
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        navigationController.topViewController?.navigationItem.rightBarButtonItem?.isEnabled = false
        splitViewController.delegate = self
    
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else {  return false  }
        guard let secondaryAsTaskViewController = secondaryAsNavController.topViewController as? TaskListViewController else { return false }
        if secondaryAsTaskViewController.selectedGoal?.tasks == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
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
        self.saveContext()
    }

//    // MARK: - Core Data stack
//
    //This CoreData stack is moved to a new file called CoreDataStack, to help with the widget. BUt I can't get it to work correclty so it stays here for now. And Target Membership will include TodayWidget
    
    lazy var persistentContainer: NSPersistentContainer = {

        SMStore.registerStoreClass()

        let container = NSPersistentContainer(name: "ToDoFinalApp")

//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        
    //Need both of these for app groups to work correctly with core data and have everything display on the simulator. It's all showing up in CloudKit, but not simulator..
        
         let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.las.ToDoFinalApp.TodayWidget")
        
        
         if let applicationDocumentsDirectory = directory {



//        if let applicationDocumentsDirectory = urls.last {


            
            let url = applicationDocumentsDirectory.appendingPathComponent("ToDoFinalApp.sqlite")
            
            
            //Need to add this for CoreData to work with Widget?
//            let sharedDefaults = NSUserDefaults(suiteName: "group.com.las.FinalAppToDo")
//            sharedDefaults?.setObject(anObject, forKey: "anObjectKey")
            
            

            let storeDescription = NSPersistentStoreDescription(url: url)

            storeDescription.type = SMStore.type

            container.persistentStoreDescriptions=[storeDescription]

            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {



                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }
        
        

        fatalError("Unable to access documents directory")

    }()



    // MARK: - Core Data Saving support
//This also has to be put into the new COreDataStakc file
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}



