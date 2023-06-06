//
//  AppDelegate.swift
//  MyNotes
//
//  Created by swostik gautam on 06/06/2023.
//

import Foundation
import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {



   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       FirebaseApp.configure()
       return true
   }

   // MARK: UISceneSession Lifecycle

   func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       let sceneConfig:UISceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
       sceneConfig.delegateClass = SceneDelegate.self
       return sceneConfig
   }

   func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       // Called when the user discards a scene session.
       // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
       // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
   }


}


