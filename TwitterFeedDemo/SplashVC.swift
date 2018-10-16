//
//  SplashVC.swift
//  TwitterFeedDemo
//
//  Created by apple on 10/10/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import TwitterKit

protocol SplashDelegate {
    func twitterLoginExist(user:TWTRUser)
}
class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: UserDefaultKey.twitterLoginExist.rawValue) || UserDefaults.standard.bool(forKey: UserDefaultKey.facebookLoginExist.rawValue) || UserDefaults.standard.bool(forKey: UserDefaultKey.instaLoginExist.rawValue)  {
            let homeVC = HomeVC.instantiateFromStoryBoard()!
            self.navigationController?.setViewControllers([homeVC], animated: false)
        }else{
            let loginVC = LoginViewController.instantiateFromStoryBoard()!
            self.navigationController?.setViewControllers([loginVC], animated: false)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SplashVC:SplashDelegate{
    func twitterLoginExist(user: TWTRUser) {
        
    }
}
