//
//  ViewController.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/20/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TwitterKit


class FacebookFeedVC: UITableViewController {
    
    var allData : [Any] = []
    let facebookCellId = "FacebookFeedCell"
    let twitterCellId = "TwitterCell"
    var screenName:String?
    var tweets:[TWTRTweet] = []
    var feeds:[FacebookFeed] = []
    var isShowAll = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.alwaysBounceVertical = true
        
        tableView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        let nib = UINib(nibName: facebookCellId, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: facebookCellId)
        tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier: twitterCellId)
        
        print("FacebookToken",FBSDKAccessToken.current()?.tokenString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFacebookFeed()
        if isShowAll{
            getHomeTimeLine()
        }
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    func mergeAllData(){
        if !isShowAll{
            tweets = []
        }
        self.allData = []
        var i = 0,j = 0
        while i<feeds.count && j<tweets.count {
            allData.append(feeds[i])
            allData.append(tweets[j])
            i += 1
            j += 1
        }
        
        while i<feeds.count{
            allData.append(feeds[i])
            i += 1
        }
        while j<tweets.count {
            allData.append(tweets[j])
            j += 1
        }
        self.tableView.reloadData()
    }
    
    func fetchFacebookFeed(){
        self.feeds = []
let tokenString = FBSDKAccessToken.current()?.tokenString
        let params = ["fields":"id,from,message,picture,link,source,name,properties,icon,actions,type,object_id,application,created_time,updated_time,shares,likes,comments,place,description,full_picture"]
//        from,properties,source,message,id,link,picture,created_time,place,privacy
        let request = FBSDKGraphRequest(graphPath: "/me/feed", parameters: params, tokenString: tokenString, version: nil, httpMethod: "GET")
        request?.start(completionHandler: { (connection, result, error) in
            if let responseData = result as? NSDictionary{
                print(self.json(from: responseData))
                self.feeds = FacebookFeed.responseMapping(dict: responseData)!
                self.mergeAllData()
            }
        })
    }
    func getHomeTimeLine(){
        self.tweets = []
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["include_user_entities":"false"]
        let client = TWTRAPIClient.withCurrentUser()
        
        let clientRequest = client.urlRequest(withMethod: "GET", urlString: url, parameters:params , error: NSErrorPointer.none)
        client.sendTwitterRequest(clientRequest) { (response, data, error) in
            if let data = data{
                print(String.init(data: data, encoding: String.Encoding.utf8))
                do{
                    if let jsonArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [NSDictionary]{
                        self.tweets = TWTRTweet.tweets(withJSONArray: jsonArray) as! [TWTRTweet]
                        self.mergeAllData()
                    }
                }catch{}
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let post = allData[indexPath.row] as? FacebookFeed{
            let feedCell = tableView.dequeueReusableCell(withIdentifier: facebookCellId, for: indexPath) as! FacebookFeedCell
            feedCell.set(post: post)
            //        feedCell.feedController = self
            return feedCell
        }else if let tweet = allData[indexPath.row] as? TWTRTweet{
            let tweetCell = tableView.dequeueReusableCell(withIdentifier: twitterCellId, for: indexPath) as! TWTRTweetTableViewCell
            tweetCell.configure(with: tweet)
            return tweetCell
        }
     return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return size(for: indexPath).height
        return UITableView.automaticDimension
    }
    
    
    private func size(for indexPath: IndexPath) -> CGSize {
        if let post = allData[indexPath.row] as? FacebookFeed{
            let cell = Bundle.main.loadNibNamed(facebookCellId, owner: self, options: nil)?.first as! FacebookFeedCell
            
            // configure cell with data in it
            cell.set(post: post)
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            // width that you want
            let width = tableView.frame.width
            let height: CGFloat = 0
            
            let targetSize = CGSize(width: width, height: height)
            
            // get size with width that you want and automatic height
            var size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
            // if you want height and width both to be dynamic use below
            // let size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            size.width = width
            print(size)
            return size
        }else if let tweet = allData[indexPath.row] as? TWTRTweet{
            let cell = TWTRTweetTableViewCell()
            // configure cell with data in it
            cell.configure(with: tweet)
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            // width that you want
            let width = tableView.frame.width
            let height: CGFloat = 0
            let targetSize = CGSize(width: width, height: height)
            // get size with width that you want and automatic height
            var size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
            // if you want height and width both to be dynamic use below
            // let size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            size.width = width
            print(size)
            return size
            
        }
        return CGSize.zero
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
    }
    
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    
    var statusImageView: UIImageView?
    
    func animateImageView(_ statusImageView: UIImageView) {
        self.statusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            statusImageView.alpha = 0
            
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            

            
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomImageView.backgroundColor = UIColor.red
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FacebookFeedVC.zoomOut)))
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
                
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                
                let y = self.view.frame.height / 2 - height / 2
                
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                
                self.blackBackgroundView.alpha = 1
                
                self.navBarCoverView.alpha = 1
                
                self.tabBarCoverView.alpha = 1
                
                }, completion: nil)
            
        }
    }
    
    @objc func zoomOut() {
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                self.zoomImageView.frame = startingFrame
                
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
                
                }, completion: { (didComplete) -> Void in
                    self.zoomImageView.removeFromSuperview()
                    self.blackBackgroundView.removeFromSuperview()
                    self.navBarCoverView.removeFromSuperview()
                    self.tabBarCoverView.removeFromSuperview()
                    self.statusImageView?.alpha = 1
            })
            
        }
    }
    
}

class FeedCell: UICollectionViewCell {
    
    var feedController: FacebookFeedVC?
    
    @objc func animate() {
        feedController?.animateImageView(statusImageView)
    }
    var post: FacebookFeed?
    
    func setPost(post:FacebookFeed?){
        self.post = post
        
        if let name = post?.name {
            
            let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            if let city = post?.place?.location?.city, let state = post?.place?.location?.country {
                attributedText.append(NSAttributedString(string: "\n\(city), \(state)  •  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor:
                    UIColor.rgb(155, green: 161, blue: 161)]))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_small")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributedText.append(NSAttributedString(attachment: attachment))
            }
            nameLabel.attributedText = attributedText
        }
        
        
        if let imageUrl = post?.full_picture{
            statusImageView.downloaded(from: imageUrl)
        }
          statusTextView.text = post?.message
        likesCommentsLabel.text = post?.link ?? post?.message
        
        //            if let profileImagename = post?.profileImageName {
        //                profileImageView.image = UIImage(named: profileImagename)
        //            }
        
        //            if let statusImageName = post?.statusImageName {
        //                statusImageView.image = UIImage(named: statusImageName)
        //            }
        //
        //            if let numLikes = post?.lik, let numComments = post?.numComments {
        //                likesCommentsLabel.text = "\(numLikes) Likes  \(numComments) Comments"
        //            }
        
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        profileImageView.image = nil
        statusTextView.text = nil
        statusImageView.image = nil
        likesCommentsLabel.text = nil
        post = nil
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        
        
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likesCommentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(155, green: 161, blue: 171)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton = FeedCell.buttonForTitle("Like", imageName: "like")
    let commentButton: UIButton = FeedCell.buttonForTitle("Comment", imageName: "comment")
    let shareButton: UIButton = FeedCell.buttonForTitle("Share", imageName: "share")
    
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControl.State())
        
        button.setImage(UIImage(named: imageName), for: UIControl.State())
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerLineView)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedCell.animate as (FeedCell) -> () -> ())))
        
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: statusTextView)
        
        addConstraintsWithFormat("H:|[v0]|", views: statusImageView)
        
        addConstraintsWithFormat("H:|-12-[v0]|", views: likesCommentsLabel)
        
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: dividerLineView)

        //button constraints
        addConstraintsWithFormat("H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        
        addConstraintsWithFormat("V:|-12-[v0]", views: nameLabel)
        
        
        
        addConstraintsWithFormat("V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommentsLabel, dividerLineView, likeButton)
        
        addConstraintsWithFormat("V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat("V:[v0(44)]|", views: shareButton)
    }
    
}
