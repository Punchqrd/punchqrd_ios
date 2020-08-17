//
//  AppDelegate.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/24/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleMaps
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    
 
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyCka8C86IBLVINIhjshaRHzKOLLbnNXmAY")
        GMSPlacesClient.provideAPIKey("AIzaSyCka8C86IBLVINIhjshaRHzKOLLbnNXmAY")
        
        
        
      
        
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
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    

    
          func application(
            _ application: UIApplication,
            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
          ) {
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            let token = tokenParts.joined()
            print("Device Token: \(token)")
            //set this token to a global variable
            
            GlobalVariables.deviceToken.token = token
            
            let db = Firestore.firestore()
            let collection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!)
                collection.getDocument { (doc, error) in
                       if let doc = doc, doc.exists {
                        collection.updateData([GlobalVariables.deviceToken.tokenCollectionTitle : GlobalVariables.deviceToken.token!])
                        
                    }
                    
            }
            
          }

          func application(
            _ application: UIApplication,
            didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("Failed to register: \(error)")
          }
    
    
    

}

