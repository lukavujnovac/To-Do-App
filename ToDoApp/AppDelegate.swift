//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Luka Vujnovac on 09.07.2021..
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        do {
            _ = try Realm()
        } catch {
            print("error kod inicijalizacije novog realma \(error)")
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

    // MARK: - Core Data stack

    
    // MARK: - Core Data Saving support

   
}


