//
//  ViewController.swift
//  TwitterFeedDemo
//
//  Created by apple on 10/10/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import TwitterKit
import FBSDKLoginKit

@objc protocol LoginViewControllerDelegate {
    func loginViewController(viewController: LoginViewController, didAuthWith session: TWTRSession)
    func loginViewControllerDidClearAccounts(viewController: LoginViewController)
}


class LoginViewController: UIViewController {
    weak var delegate: LoginViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @IBAction func instaLogin(_ sender: Any) {
        
    }
    @IBAction func facebookLogin(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email","user_posts"], from: self) { (result, error) in
            if let _ = result?.grantedPermissions{
                self.getFacebookData()
                
            }
        }
    }
    
    
    
    func getFacebookData() {
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email,picture.type(large)"]).start(completionHandler: { (connection, graphResult, error) in
            if error == nil {
                if let data = graphResult as? [String: Any] {
                    let pic = data["picture"] as! [String : AnyObject]
                    let dataAll = pic["data"] as! [String : AnyObject]
                    UserDefaults.standard.set(true, forKey: UserDefaultKey.facebookLoginExist.rawValue)
                    if ((self.navigationController?.viewControllers.first as? HomeVC) == nil){
                        let homeVC = HomeVC.instantiateFromStoryBoard() as! HomeVC
                        self.navigationController?.setViewControllers([homeVC], animated: false)
                    }else{
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }                    
                    //                    let user = User()
                    //                    user.name = data["name"] as! String
                    //                    user.userName = user.name
                    //                    user.image = dataAll["url"] as! String
                    //                    user.email = data["email"] as! String
                    //                    user.loginId = data["id"] as! String
                    //                    user.loginType = Constants.KeyIdentifiers.FACEBOOK
                    //                    user.accessToken = FBSDKAccessToken.current().tokenString
                }
            }
        })
    }
    
    @IBAction func twitterLogin(_ sender: Any) {
        TWTRTwitter.sharedInstance().logIn(with: self) { (session, error) in
            if let _ = session {
                UserDefaults.standard.set(true, forKey: UserDefaultKey.twitterLoginExist.rawValue)
                if ((self.navigationController?.viewControllers.first as? HomeVC) == nil){
                    let homeVC = HomeVC.instantiateFromStoryBoard() as! HomeVC
                    self.navigationController?.setViewControllers([homeVC], animated: false)
                }else{
                    self.dismiss(animated: true, completion: {
                        
                    })
                }
                
            } else if let error = error {
                UIAlertController.showAlert(with: error, on: self)
            }
        }
    }
    
    
}

