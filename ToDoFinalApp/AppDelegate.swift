//
//  AppDelegate.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Flurry_iOS_SDK

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    //delete both entry and data set, delete row on table, and on cloudkit.
/*
 
     class func deleteRecordsFromCloud( list : [CKRecord], completion: @escaping (Bool) -> Void ) {
     
     if list.count == 0 {
     DispatchQueue.main.async {
     completion(true)
     }
     return;
     }
     
     DispatchQueue.global(qos: .background).async {
     
     let count = min(400, list.count)
     
     var newList = list
     var records : [CKRecordID] = []
     
     for _ in 0..<count {
     let object = newList[0]
     let objectId = object.recordID
     records.append(objectId)
     newList.remove(at: 0)
     }
     
     let deleteRecords = CKModifyRecordsOperation.init(recordsToSave: nil, recordIDsToDelete: records)
     deleteRecords.modifyRecordsCompletionBlock = ({(savedRecords, deletedRecords, operationError) -> Void in
     if let error = operationError {
     print("deleteRecordsFromCloud, deleteRecords error:",error)
     } else {
     Cloud.deleteRecordsFromCloud(list: newList, completion: completion)
     }
     })
     
     privateDb.add(deleteRecords)
     }
     }
     
     class func deleteItemFromCloud( _ item: NSManagedObject ) {
     
     let recordId = Cloud.recordIdForItem(item)
     
     privateDb.fetch(withRecordID: recordId) { record, error in
     if let record = record {
     Cloud.deleteRecordsFromCloud(list: [record] ) { completion in
     print("Deleted item from Cloud", item.description)
     }
     } else {
     print("Item not found on Cloud", item.description)
     }
     }
     }
     

     
     
 */

    var window: UIWindow?
    //var smStore: SMStore!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize the Google Mobile Ads SDK.
        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544~1458002511")
        
        //my ad using to dofinalapp
//         GADMobileAds.configure(withApplicationID: "ca-app-pub-5462116334906512~1231030276")
        
        
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
        
        application.registerForRemoteNotifications()
        
        return true
        
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        self.smStore?.handlePush(userInfo: userInfo, fetchCompletionHandler: { result in
//            print("result \(result)")
//        })
//    }
//
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
    }
}



