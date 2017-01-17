//
//  AppDelegate.swift
//  Chefty
//
//  Created by Arvin San Miguel on 11/16/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let store = DataStore.sharedInstance
    var queue = OperationQueue()
    var initialViewController = UIViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // if no recipes selected in CoreData, fetch from DataBase
        store.getRecipesFromCoreData()
        store.updateSelectedRecipes()
        store.populateHomeArrays()
        
        // set nav bar color: background: red, foreground: title green
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor(named: .titleGreen)
        navigationBarAppearace.barTintColor = UIColor(named: .headingbackground)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(named: .titleGreen)]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = self.window {
            window.backgroundColor = UIColor.white
        
            if self.store.recipesSelected.count == 0 {
            
                self.initialViewController = FinalMainViewController()
            
                let destVC = initialViewController as? FinalMainViewController
            
                    if self.store.recipes.count < 5 {
                        store.getRecipesFromDB {
                            OperationQueue.main.addOperation {
                                self.initialViewController.reloadInputViews()
                                destVC?.mainDishVC.collectionView.reloadData()
                            }
                        }
                    }
            } else {
                store.showNotification = true
                self.initialViewController = MyMenuViewController()
            }
    
            let navigationController = UINavigationController(rootViewController: self.initialViewController)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
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
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        for (n, recipe) in self.store.recipes.enumerated() {
            if recipe.selected == false {
                self.store.recipes.remove(at: n)
            }
        }
        self.store.saveRecipesContext()
    }
}

