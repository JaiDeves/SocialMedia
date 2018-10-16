//
//  UIViewControllerExtensions.swift
//  DemoApp
//
//  Created by Rajul Arora on 10/30/17.
//  Copyright © 2017 Twitter. All rights reserved.
//

import UIKit

// This is a common extension to find the top-most view
// controller that several of our customers use.
extension UIViewController {

    class var topMostViewController: UIViewController? {
        let root = UIApplication.shared.keyWindow?.rootViewController
        return self.topMostViewControllerWithRootViewController(root: root)
    }

    class func topMostViewControllerWithRootViewController(root: UIViewController?) -> UIViewController? {
        if let tab = root as? UITabBarController {
            return self.topMostViewControllerWithRootViewController(root: tab.selectedViewController)
        }

        if let nav = root as? UINavigationController {
            return self.topMostViewControllerWithRootViewController(root: nav.visibleViewController)
        }

        if let presented = root?.presentedViewController {
            return self.topMostViewControllerWithRootViewController(root: presented)
        }

        // We are at the root
        return root
    }
}


extension UINavigationController
{   /**
     - usage: self.navigationController(LoginVC.self)
     */
    
    func popToViewController<T: UIViewController>(controller type: T.Type,animated:Bool) {
        for viewController in self.viewControllers {
            if viewController is T {
                self.popToViewController(viewController, animated: animated)
                return
            }
        }
    }
}

/**
 Insantiate ViewController with name
 */
extension UIViewController{
    class func instantiateFromStoryBoard() -> UIViewController?{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vcName = String(describing: self)
        let vc = storyBoard.instantiateViewController(withIdentifier: vcName)
        return vc
    }
}


extension UIWindow{
    static var mainWindow:UIWindow?{
        if let appDelegate  = UIApplication.shared.delegate as? AppDelegate{
            return appDelegate.window
        }
        return nil
    }
    
    static var topWindow:UIWindow?{
        return UIApplication.shared.windows.sorted(by: { (win1, win2) -> Bool in
            return win1.windowLevel < win2.windowLevel
        }).last
        //        UIWindow *topWindow = [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
        //            return win1.windowLevel - win2.windowLevel;
        //            }] lastObject];
    }
}
