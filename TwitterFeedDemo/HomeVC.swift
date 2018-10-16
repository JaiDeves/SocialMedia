//
//  HomeVC.swift
//  TwitterFeedDemo
//
//  Created by apple on 10/10/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import TwitterKit

protocol HomeDelegate {
    func twitterLoginExist(user:TWTRUser)
}
class HomeVC: UIViewController {
    
    let normalButtonColor = UIColor.black
    let selectedButtonColor = UIColor.white
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var facebook_btn: UIButton!
    @IBOutlet weak var insta_btn: UIButton!
    
    @IBOutlet weak var twitter_btn: UIButton!
    
    @IBOutlet weak var all_btn: UIButton!
    @IBOutlet weak var all_lbl: UILabel!
    @IBOutlet weak var facebook_lbl: UILabel!
    @IBOutlet weak var twitter_lbl: UILabel!
    
    @IBOutlet weak var insta_lbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var twitterUser:TWTRUser?
    private var currentChildVC:UIViewController?
    
    private lazy var userListVC: UserListViewController = {
        let vc = UserListViewController(userType: "friends")
        return vc
    }()
    
    private lazy var timeLineVC: HomeTimeLineViewController = {
        let vc = HomeTimeLineViewController()
        return vc
    }()
    private lazy var facebookFeedVC: FacebookFeedVC = {
        let vc = FacebookFeedVC()
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        add(asChildViewController: facebookFeedVC)
        
        all_btn.tag = 101
        twitter_btn.tag = 102
        facebook_btn.tag = 103
        insta_btn.tag = 104
        
        all_btn.addTarget(self, action: #selector(self.buttonSelected(_:)), for: .touchUpInside)
        twitter_btn.addTarget(self, action: #selector(self.buttonSelected(_:)), for: .touchUpInside)
        facebook_btn.addTarget(self, action: #selector(self.buttonSelected(_:)), for: .touchUpInside)
        insta_btn.addTarget(self, action: #selector(self.buttonSelected(_:)), for: .touchUpInside)
        buttonSelected(all_btn)
        self.navigationController?.isNavigationBarHidden = true
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?.first
        
    }
    
    
    @IBAction func addAccount(_ sender: Any) {
        let loginVC = LoginViewController.instantiateFromStoryBoard()!
        self.present(loginVC, animated: true) {
            
        }
    }
    @objc fileprivate func buttonSelected(_ button:UIButton){
        all_lbl.textColor = normalButtonColor
        facebook_lbl.textColor = normalButtonColor
        twitter_lbl.textColor = normalButtonColor
        insta_lbl.textColor = normalButtonColor
        
        switch button.tag {
        case 101:
            all_lbl.textColor = selectedButtonColor
            facebookFeedVC.isShowAll = true
            add(asChildViewController: facebookFeedVC)
            break
        case 102:
            twitter_lbl.textColor = selectedButtonColor
            add(asChildViewController: timeLineVC)
            break
        case 103:
            facebookFeedVC.isShowAll = false
            add(asChildViewController: facebookFeedVC)            
            facebook_lbl.textColor = selectedButtonColor
            break
        case 104:
            insta_lbl.textColor = selectedButtonColor
            break
        default:
            break
        }
    }
    
    fileprivate func add(asChildViewController viewController: UIViewController) {
        // Add Child View as Subview
        if let vc = currentChildVC{
            remove(asChildViewController: vc)
        }
        currentChildVC = viewController
        
        // Configure Child View        
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
    }

    fileprivate func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
        currentChildVC = nil
    }
}
extension HomeVC:HomeDelegate{
    func twitterLoginExist(user: TWTRUser) {
        
    }
    
}

extension HomeVC:UITabBarDelegate{
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title?.lowercased() == "home"{
            if currentChildVC != timeLineVC{
                add(asChildViewController: timeLineVC)
            }
        }else{
            if currentChildVC != userListVC{
                add(asChildViewController: userListVC)
            }
        }
    }
}
