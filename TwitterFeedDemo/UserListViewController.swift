//
//  UserListViewController.swift
//  DemoApp
//
//  Created by apple on 10/9/18.
//  Copyright © 2018 Twitter. All rights reserved.
//

import UIKit
import TwitterKit

class UserListViewController: UITableViewController, TwitterFollowerDelegate {
    
    var serviceWrapper: TwitterServiceWrapper = TwitterServiceWrapper()
    var followers = [TwitterFollower]()
    var userType:String
    
     init(userType:String) {
        self.userType = userType
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        followers = []
        serviceWrapper.delegate = self
        if let screenName = AppDelegate.shared.twitterUser?.screenName{
            serviceWrapper.getResponseForRequest(url: "https://api.twitter.com/1.1/\(userType)/list.json", method: "GET",params:["screen_name":screenName,"skip_status":"true","include_user_entities":"false","cursor":"-1"])
        }
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = followers.count
        return numberOfRows
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let follower = followers[indexPath.row]
        cell.imageView!.downloaded(from: follower.profileURL)
        cell.textLabel?.text = follower.name
        return cell
    }
    // MARK: - TwitterFollowerDelegate methods
    
    func finishedDownloading(follower: TwitterFollower) {
        DispatchQueue.main.async{
            self.followers.append(follower)
            self.tableView.reloadData()
        }        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let follower = followers[indexPath.row]
        let userTimelineViewController = UserTimelineViewController()
        userTimelineViewController.screenName = follower.screenName
        self.navigationController?.pushViewController(userTimelineViewController, animated: true)
//                follower.screen_name
    }
    
}

class TableViewCell:UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let link = link, let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
