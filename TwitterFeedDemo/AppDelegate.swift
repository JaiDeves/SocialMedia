//
//  AppDelegate.swift
//  TwitterFeedDemo
//
//  Created by apple on 10/10/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import TwitterKit


import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var twitterUser:TWTRUser?
    var delegate:HomeDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let consumerKey = Bundle.main.infoDictionary!["TwitterConsumerKey"] as! String
        let consumerSecret = Bundle.main.infoDictionary!["TwitterConsumerSecret"] as! String
        TWTRTwitter.sharedInstance().start(withConsumerKey:consumerKey, consumerSecret:consumerSecret)
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if let session = TWTRTwitter.sharedInstance().sessionStore.session() {
            let client = TWTRAPIClient()
            client.loadUser(withID: session.userID) { (user, error) -> Void in
                if let user = user {
                    UserDefaults.standard.set(true, forKey: UserDefaultKey.twitterLoginExist.rawValue)
                    self.twitterUser = user
                    self.delegate?.twitterLoginExist(user: user)
                    print("@\(user.screenName)")
                }
            }
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
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let facebookHandled = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options) ?? false
        let twitterHandled = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        return facebookHandled || twitterHandled
    }
}

extension AppDelegate{
    static var shared:AppDelegate  {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

